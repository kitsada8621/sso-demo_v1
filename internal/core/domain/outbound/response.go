package outbound

type ResponseWithJSON struct {
	Status  string       `json:"status"`
	Success bool         `json:"success"`
	Message string       `json:"message"`
	Data    *interface{} `json:"data,omitempty"`
	Total   *int         `json:"total,omitempty"`
}
