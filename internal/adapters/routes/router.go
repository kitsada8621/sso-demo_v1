package routes

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

func NewRouter(api *echo.Group) {
	api.GET("", func(c echo.Context) error {
		return c.String(http.StatusOK, "Welcome to the API")
	})
}
