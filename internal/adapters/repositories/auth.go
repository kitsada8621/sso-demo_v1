package repositories

import (
	ports "github.com/eec/sso/internal/ports"
	"gorm.io/gorm"
)

type authRepositoryImpl struct {
	db *gorm.DB
}

func NewAuthRepository(db *gorm.DB) ports.AuthRepository {
	return &authRepositoryImpl{
		db: db,
	}
}

func (r *authRepositoryImpl) GetProfile(id string) (interface{}, error) {
	return nil, nil
}
