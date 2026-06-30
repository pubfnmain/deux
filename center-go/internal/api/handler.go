package api

import (
	"context"

	deuxv1 "github.com/pubfnmain/deux/sdk-go/gen/deux/v1"
	"github.com/pubfnmain/deux/sdk-go/gen/deux/v1/deuxv1connect"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/metric"
)

// meterName is the instrumentation scope for CenterService metrics.
const meterName = "github.com/pubfnmain/deux/center-go/internal/api"

var _ deuxv1connect.CenterServiceHandler = (*Handler)(nil)

type Handler struct {
	requests metric.Int64Counter
}

func (h *Handler) Authorize(ctx context.Context, r *deuxv1.AuthorizeRequest) (*deuxv1.AcknowledgementResponse, error) {
	h.requests.Add(ctx, 1, metric.WithAttributes(attribute.String("method", "authorize")))
	return &deuxv1.AcknowledgementResponse{Status: deuxv1.Acknowledgement_ACKNOWLEDGEMENT_ACK}, nil
}

func (h *Handler) Finalize(ctx context.Context, r *deuxv1.FinalizeRequest) (*deuxv1.AcknowledgementResponse, error) {
	h.requests.Add(ctx, 1, metric.WithAttributes(attribute.String("method", "finalize")))
	return &deuxv1.AcknowledgementResponse{Status: deuxv1.Acknowledgement_ACKNOWLEDGEMENT_ACK}, nil
}

// NewHandler constructs a Handler with a per-method request counter registered
// on the global meter provider. Compute RPS as the rate of this counter, e.g.
// rate(center_service_requests_total{method="authorize"}).
func NewHandler() (*Handler, error) {
	meter := otel.Meter(meterName)
	requests, err := meter.Int64Counter(
		"center.service.requests",
		metric.WithDescription("Number of CenterService RPCs handled, by method"),
		metric.WithUnit("{request}"),
	)
	if err != nil {
		return nil, err
	}
	return &Handler{requests: requests}, nil
}
