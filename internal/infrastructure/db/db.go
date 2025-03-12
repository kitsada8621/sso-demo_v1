package db

import (
	"fmt"
	"time"

	"github.com/eec/sso/config"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

// NewPostgresDB initializes a new PostgreSQL database connection using GORM.
// It returns a pointer to the DB instance and an error if any.
func NewPostgresDB() (*gorm.DB, error) {
	// Load configuration
	env := config.NewConfig()

	// Construct the connection string
	connectionString := fmt.Sprintf(
		"host=%s user=%s password=%s dbname=%s port=%s sslmode=disable TimeZone=Asia/Bangkok",
		env.GetDBHost(), env.GetDBUser(), env.GetDBPassword(), env.GetDBName(), env.GetDBPort(),
	)

	// Configure GORM with custom settings for better performance and security
	gormConfig := &gorm.Config{
		Logger: logger.Default.LogMode(logger.Silent), // Disable GORM logging for production
	}

	// Open a connection to the PostgreSQL database
	db, err := gorm.Open(postgres.Open(connectionString), gormConfig)
	if err != nil {
		return nil, fmt.Errorf("failed to connect to database: %w", err)
	}

	// Set database connection pool settings for better performance
	sqlDB, err := db.DB()
	if err != nil {
		return nil, fmt.Errorf("failed to get database instance: %w", err)
	}

	// Set maximum number of open connections to the database
	sqlDB.SetMaxOpenConns(25)
	// Set maximum number of idle connections to the database
	sqlDB.SetMaxIdleConns(25)
	// Set the maximum lifetime of a connection
	sqlDB.SetConnMaxLifetime(5 * time.Minute)

	return db, nil
}
