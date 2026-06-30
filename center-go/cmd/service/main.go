package main

import (
	"context"
	"errors"
	"flag"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"runtime/debug"
	"strconv"
	"syscall"
	"time"

	"connectrpc.com/connect"
	"connectrpc.com/otelconnect"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/pubfnmain/deux/center-go/internal/api"
	"github.com/pubfnmain/deux/center-go/internal/config"
	"github.com/pubfnmain/deux/center-go/internal/observability"
	"github.com/pubfnmain/deux/sdk-go/gen/deux/v1/deuxv1connect"
	tigerbeetle "github.com/tigerbeetle/tigerbeetle-go"
	"github.com/valkey-io/valkey-go"
	runtimemetrics "go.opentelemetry.io/contrib/instrumentation/runtime"
)

// version reports the build version embedded by the Go toolchain, falling back
// to "dev" for local builds.
func version() string {
	if info, ok := debug.ReadBuildInfo(); ok && info.Main.Version != "" {
		return info.Main.Version
	}
	return "dev"
}

func Logging(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		next.ServeHTTP(w, r)
		slog.Info(r.Method + " " + r.URL.Path)
	})
}

func run() error {
	port := flag.Int64("port", 7890, "Port to listen on")
	flag.Parse()

	cfgPath := os.Getenv("CONFIG")
	if cfgPath == "" {
		cfgPath = config.DefaultPath
	}

	cfg, err := config.New(cfgPath)
	if err != nil {
		return err
	}

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	shutdown, err := observability.Setup(ctx, version())
	if err != nil {
		return err
	}
	defer func() {
		err = errors.Join(err, shutdown(context.Background()))
	}()

	if err := runtimemetrics.Start(); err != nil {
		return err
	}

	otelInterceptor, err := otelconnect.NewInterceptor()
	if err != nil {
		return err
	}
	svc, err := api.NewHandler()
	if err != nil {
		return err
	}

	path, h := deuxv1connect.NewCenterServiceHandler(
		svc,
		connect.WithInterceptors(otelInterceptor),
	)

	mux := http.NewServeMux()

	mux.Handle(path, h)
	mux.HandleFunc("/health", api.Health)

	pool, err := pgxpool.New(ctx, cfg.Postgres.Conn())
	if err != nil {
		return err
	}
	defer pool.Close()
	slog.Info("connected to postgres")

	if err := pool.Ping(ctx); err != nil {
		return err
	}
	slog.Info("pinged postgres")

	tbClient, err := tigerbeetle.NewClient(tigerbeetle.ToUint128(cfg.TigerBeetle.ClusterID), []string{strconv.FormatUint(cfg.TigerBeetle.Address, 10)})
	if err != nil {
		return err
	}
	defer tbClient.Close()
	slog.Info("created tigerbeetle client")

	vkClient, err := valkey.NewClient(valkey.ClientOption{InitAddress: []string{cfg.Valkey.URL}})
	if err != nil {
		return err
	}
	defer vkClient.Close()
	slog.Info("connected to valkey")

	handler := Logging(mux)
	p := &http.Protocols{}
	p.SetHTTP1(true)
	p.SetUnencryptedHTTP2(true)

	server := &http.Server{
		Handler:   handler,
		Addr:      ":" + strconv.FormatInt(*port, 10),
		Protocols: p,
	}

	go func() {
		if err := server.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
			slog.Error("failed to serve", "err", err)
		}
	}()

	slog.Info("run server", "port", *port)

	<-ctx.Done()

	shutdownCtx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if err := server.Shutdown(shutdownCtx); err != nil {
		slog.Error("failed to shutdown server", "err", err)
	} else {
		slog.Info("graceful shutdown")
	}

	return nil
}

func main() {
	if err := run(); err != nil {
		slog.Error("failed to run", "err", err)
	}
}
