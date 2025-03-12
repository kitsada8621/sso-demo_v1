package services

import "github.com/eec/sso/internal/ports"

type authServiceImpl struct {
	authRepository ports.AuthRepository
}

func NewAuthService(authRepository ports.AuthRepository) ports.AuthService {
	return &authServiceImpl{
		authRepository: authRepository,
	}
}

func (s *authServiceImpl) GetProfile(id string) (interface{}, error) {
	return nil, nil
}
