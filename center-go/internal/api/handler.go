package api

import (
	"context"

	deuxv1 "github.com/pubfnmain/deux/sdk-go/gen/deux/v1"
	"github.com/pubfnmain/deux/sdk-go/gen/deux/v1/deuxv1connect"
)

var _ deuxv1connect.CenterServiceHandler = (*Handler)(nil)

type Handler struct {
}

func (*Handler) Authorize(context.Context, *deuxv1.AuthorizeRequest) (*deuxv1.AuthorizeResponse, error) {
	return &deuxv1.AuthorizeResponse{}, nil
}

func (*Handler) Finalize(context.Context, *deuxv1.FinalizeRequest) (*deuxv1.FinalizeResponse, error) {
	return &deuxv1.FinalizeResponse{}, nil
}

func NewHandler() *Handler {
	return &Handler{}
}
