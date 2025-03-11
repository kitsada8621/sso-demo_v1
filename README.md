## Installation
1. Clone the repository to your local machine: 
```sh
    git clone https://github.com/kitsada8621/sso-demo_v1.git
    cd sso-demo_v1
```
2. Install the required dependencies:
```sh
go mod tidy
```

## Configuration
#### Set up the API configuration in the `.env` file ⚙️✅
```sh
# API Port
PORT=3089 
# DB Config
DB_HOST=localhost
DB_PORT=5432
DB_USER=<your_db_user>
DB_PASSWORD=<your_db_password>
DB_NAME=<your_db_name>
```

#### Specify basic details in the `docker-compose.keycloak.yml` file 📝✅
```sh
services:
  keycloak:
    image: quay.io/keycloak/keycloak:26.1.3
    container_name: keycloak
    environment:
      KC_DB: postgres
      KC_DB_URL: jdbc:postgresql://<host>:<port>/<db_name>
      KC_DB_USERNAME: your_username
      KC_DB_PASSWORD: your_password
      KEYCLOAK_ADMIN: keycloak_username
      KEYCLOAK_ADMIN_PASSWORD: keycloak_password
      KC_HOSTNAME: localhost
    ports:
      - "8080:8080"
      - "8443:8443"
    networks:
      - default
    command: start-dev
networks:
  default:
    external: true
    name: <your_network>
```

## Run the project 🚀✅
1. Start keycloak
```sh
make docker-up  # Choose option 1 to start Keycloak
```
2. Start API
```sh
make run # Choose option 1 to start Service
```