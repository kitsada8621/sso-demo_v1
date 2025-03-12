package main

import (
	"fmt"
	"log"
	"os"

	"github.com/eec/sso/internal/infrastructure/server"
	"github.com/joho/godotenv"
)

func main() {
	// Load the configuration based on environment
	env := getEnv("ENV", "development")

	// Load environment variables from the appropriate .env file
	if err := loadEnvFile(env); err != nil {
		log.Fatalf("Error loading .env file: %v", err)
	}

	// Create and start the server
	e := server.CreateServer()
	e.Logger.Fatal(e.Start(getPort()))
}

// getEnv returns the value of an environment variable or a default value
func getEnv(key, defaultValue string) string {
	if value, exists := os.LookupEnv(key); exists {
		return value
	}
	return defaultValue
}

// loadEnvFile loads the appropriate .env file based on the environment
func loadEnvFile(env string) error {
	var envFile string
	if env == "development" {
		envFile = ".env.development"
	} else {
		envFile = ".env"
	}
	return godotenv.Load(envFile)
}

// getPort returns the port to start the server on, defaulting to ":1323"
func getPort() string {
	if port, exists := os.LookupEnv("PORT"); exists {
		return fmt.Sprintf(":%s", port)
	}
	return ":1323"
}
