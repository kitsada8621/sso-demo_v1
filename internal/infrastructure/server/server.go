package server

import (
	"fmt"
	"net/http"
	"time"

	"github.com/eec/sso/internal/adapters/handlers"
	"github.com/eec/sso/internal/adapters/repositories"
	"github.com/eec/sso/internal/adapters/routes"
	"github.com/eec/sso/internal/core/services"
	postgres "github.com/eec/sso/internal/infrastructure/db"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

// CreateServer initializes and configures the Echo server
func CreateServer() *echo.Echo {
	e := echo.New()

	// Middleware for logging, recovering from panics, and enhanced security
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())
	e.Use(middleware.SecureWithConfig(middleware.SecureConfig{
		XSSProtection:         "1; mode=block",
		ContentTypeNosniff:    "nosniff",
		XFrameOptions:         "SAMEORIGIN",
		HSTSMaxAge:            31536000, // 1 year
		HSTSExcludeSubdomains: false,
		HSTSPreloadEnabled:    true,
		ContentSecurityPolicy: "default-src 'self'",
		ReferrerPolicy:        "strict-origin-when-cross-origin",
	}))

	// CORS middleware with secure defaults
	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins:     []string{"*"},
		AllowMethods:     []string{http.MethodGet, http.MethodPut, http.MethodPost, http.MethodDelete},
		AllowHeaders:     []string{echo.HeaderOrigin, echo.HeaderContentType, echo.HeaderAccept, echo.HeaderAuthorization},
		AllowCredentials: true,
		MaxAge:           int(12 * time.Hour.Seconds()),
	}))

	// Rate limiting middleware to prevent abuse
	e.Use(middleware.RateLimiter(middleware.NewRateLimiterMemoryStore(20))) // 20 requests per second

	// Basic route for health check
	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "Hello, World!")
	})

	// Initialize database connection
	db, err := postgres.NewPostgresDB()
	if err != nil {
		e.Logger.Fatal(err)
		panic(fmt.Errorf("failed to connect to database: %w", err))
	}

	// Initialize repositories
	authRepository := repositories.NewAuthRepository(db)

	// Initialize services
	authService := services.NewAuthService(authRepository)

	// Initialize handlers
	authHandler := handlers.NewAuthHandler(&authService)

	// Initialize and configure routes
	apiV1 := e.Group("/api/v1")
	routes.NewRouter(apiV1)
	routes.NewAuthRouter(apiV1, authHandler)

	return e
}
