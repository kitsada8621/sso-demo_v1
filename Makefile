# Default environment is development
ENV ?= development

# Declare phony targets to avoid conflicts with files of the same name
.PHONY: docker-start run run-direct build clean help default

# Colors for help menu
GREEN  := $(shell tput -T xterm setaf 2)
YELLOW := $(shell tput -T xterm setaf 3)
WHITE  := $(shell tput -T xterm setaf 7)
RESET  := $(shell tput -T xterm sgr0)

# Default target
default: help

# Help target to display usage information
help:
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@echo '  ${GREEN}docker-start${RESET}  - Start Docker containers'
	@echo '  ${GREEN}run${RESET}           - Run the Go application with interactive environment selection'
	@echo '  ${GREEN}run-direct${RESET}    - Run directly with ENV variable'
	@echo '  ${GREEN}build${RESET}         - Build the Go application'
	@echo '  ${GREEN}clean${RESET}         - Remove binary files'
	@echo '  ${GREEN}help${RESET}          - Show this help message'
	@echo ''

# Target to start Docker containers
docker-start: 
	@echo "Starting Docker containers..."
	docker-compose down --remove-orphans
	docker-compose up -d --build

# Interactive run
run:
	@echo "${YELLOW}Please select environment:${RESET}"
	@echo "1) Development"
	@echo "2) Production"
	@read -p "Enter choice [1-2]: " choice; \
	case "$$choice" in \
		1) ENV=development $(MAKE) run-direct ;; \
		2) ENV=production $(MAKE) run-direct ;; \
		*) echo "${YELLOW}Invalid choice. Using default (development)${RESET}" ; ENV=development $(MAKE) run-direct ;; \
	esac

# Direct run with ENV variable
run-direct:
	@echo "${GREEN}Running application in ${ENV} environment...${RESET}"
	go run ./cmd/api/main.go

# Target to build the Go application
build:
	@echo "Building application..."
	go build -o bin/app ./cmd/api/main.go

# Target to clean build files
clean:
	@echo "Cleaning build files..."
	rm -rf bin/
	go clean
