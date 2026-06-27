package main

import (
	"context"
	"encoding/json"
	"errors"
	"flag"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"strconv"
	"syscall"
	"time"
)

func Logging(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		next.ServeHTTP(w, r)

		slog.Info(r.Method + " " + r.URL.Path)
	})
}

func main() {
	port := flag.Int64("port", 6789, "Port to listen on")
	flag.Parse()

	mux := http.NewServeMux()

	mux.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusAccepted)
		if err := json.NewEncoder(w).Encode(struct {
			Status string `json:"status"`
		}{Status: "ok"}); err != nil {
			slog.Error("failed to encode json response", "err", err)
		}
	})

	handler := Logging(mux)

	server := &http.Server{Handler: handler, Addr: ":" + strconv.FormatInt(*port, 10)}

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

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
}
