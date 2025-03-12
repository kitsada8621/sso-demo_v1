package routes

import (
	"github.com/eec/sso/internal/adapters/handlers"
	"github.com/labstack/echo/v4"
)

func NewAuthRouter(api *echo.Group, handler *handlers.AuthHandler) {
	api.GET("/profile", handler.GetProfile)
}
