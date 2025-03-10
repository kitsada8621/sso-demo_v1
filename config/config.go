package config

import "os"

type Config struct{}

func NewConfig() *Config {
	return &Config{}
}

func (c *Config) GetPort() string {
	if os.Getenv("PORT") != "" {
		return os.Getenv("PORT")
	}
	return ":5356"
}

func (c *Config) GetDBHost() string {
	if os.Getenv("DB_HOST") != "" {
		return os.Getenv("DB_HOST")
	}
	return "localhost"
}

func (c *Config) GetDBPort() string {
	if os.Getenv("DB_PORT") != "" {
		return os.Getenv("DB_PORT")
	}
	return "5432"
}

func (c *Config) GetDBUser() string {
	if os.Getenv("DB_USER") != "" {
		return os.Getenv("DB_USER")
	}
	return "postgres"
}

func (c *Config) GetDBPassword() string {
	if os.Getenv("DB_PASSWORD") != "" {
		return os.Getenv("DB_PASSWORD")
	}
	return "password"
}

func (c *Config) GetDBName() string {
	if os.Getenv("DB_NAME") != "" {
		return os.Getenv("DB_NAME")
	}
	return "postgres"
}
