package handlers

import (
	"net/http"

	"github.com/eec/sso/internal/core/domain/outbound"
	ports "github.com/eec/sso/internal/ports"
	"github.com/labstack/echo/v4"
)

type AuthHandler struct {
	authService *ports.AuthService
}

func NewAuthHandler(authService *ports.AuthService) *AuthHandler {
	return &AuthHandler{
		authService: authService,
	}
}

func (r *AuthHandler) GetProfile(c echo.Context) error {
	return c.JSON(http.StatusOK, outbound.ResponseWithJSON{
		Status:  "OK",
		Success: true,
		Message: "Profile retrieved successfully",
		Data:    nil,
	})
}
