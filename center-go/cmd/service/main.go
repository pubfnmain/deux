package main

import (
	"context"
	"errors"
	"flag"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"strconv"
	"syscall"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/pubfnmain/deux/interop-go/internal/api"
	"github.com/pubfnmain/deux/interop-go/internal/config"
	tigerbeetle "github.com/tigerbeetle/tigerbeetle-go"
	"github.com/valkey-io/valkey-go"
)

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

	mux := http.NewServeMux()

	mux.HandleFunc("/health", api.Health)

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	pool, err := pgxpool.New(ctx, cfg.Postgres.Conn())
	if err != nil {
		return err
	}
	defer pool.Close()
	slog.Info("connected to postgres")

	tbClient, err := tigerbeetle.NewClient(tigerbeetle.ToUint128(cfg.TigerBeetle.ClusterID), []string{strconv.FormatUint(cfg.TigerBeetle.Address, 10)})
	if err != nil {
		return err
	}
	defer tbClient.Close()
	slog.Info("connected to tigerbeetle")

	vkClient, err := valkey.NewClient(valkey.ClientOption{InitAddress: []string{cfg.Valkey.URL}})
	if err != nil {
		return err
	}
	defer vkClient.Close()
	slog.Info("connected to valkey")

	handler := Logging(mux)

	server := &http.Server{Handler: handler, Addr: ":" + strconv.FormatInt(*port, 10)}

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
