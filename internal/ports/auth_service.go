package ports

type AuthService interface {
	GetProfile(id string) (interface{}, error)
}
