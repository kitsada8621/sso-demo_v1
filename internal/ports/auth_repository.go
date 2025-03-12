package ports

type AuthRepository interface {
	GetProfile(id string) (interface{}, error)
}
