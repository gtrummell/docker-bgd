# Makefile for Docker-BGD

.DEFAULT_GOAL := help
.PHONY: help

HOST_IP := $(shell /sbin/ip route | /bin/grep "scope\s*link\s*src.*metric" | /usr/bin/sort -nk 11 | /usr/bin/cut -d' ' -f 12 | /usr/bin/head -n 1)


# Self-documenting makefile: https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Show this help.
	@echo "Makefile for Docker-BGD.  Usage: make COMMAND"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

ip: # Export the host's IP address to a shell variable.
	@export HOST_IP=${HOST_IP}
	@echo "Detected Host IP ${HOST_IP}"

build-blue: # Build Sample-App version blue
	@echo "Building Sample-App version blue"
	@cd ./sample-app-blue; \
	 docker build -t sample-app:blue -t sample-app:latest .; \
	 cd ..

build-green: # Build Sample-App version green
	@echo "Building Sample-App version green"
	@cd ./sample-app-green; \
	 docker build -t sample-app:green -t sample-app:latest .; \
	 cd ..

build-lb: ip # Build Load-Balancer
	@echo "Building Load-Balancer"
	@export HOST_IP=${HOST_IP}; \
     cd ./load-balancer; \
	 docker build -t load-balancer:latest .; \
	 cd ..

build-stack: ip build-lb build-green build-blue ## Docker-compose a stack running the latest (blue) version of Sample-App
	@echo "Raising a stack with latest version of Sample-App"
	@export HOST_IP=${HOST_IP}; \
     docker-compose up -d; \
     docker-compose stop sample-app-green

deploy-green: ## Deploy Sample-App version green
	@echo "Deploying Sample-App version green"
	@export HOST_IP=${HOST_IP}; \
     docker-compose start sample-app-green

teardown-blue: ## Tear-down Sample-App version blue
	@echo "Tearing down Sample-App version blue"
	@export HOST_IP=${HOST_IP}; \
     docker-compose stop sample-app-blue

deploy-blue: ## Deploy Sample-App version blue
	@echo "Deploying Sample-App version blue"
	@export HOST_IP=${HOST_IP}; \
     docker-compose start sample-app-blue

teardown-green: ## Tear-down Sample-App version green
	@echo "Tearing down Sample-App version green"
	@export HOST_IP=${HOST_IP}; \
     docker-compose stop sample-app-green

cleanup: ip ## Clean up all resources from the demo
	@echo "Cleaning up Demo resources"
	-export HOST_IP=${HOST_IP}; \
	 docker-compose down; \
	 docker rmi -f sample-app:green sample-app:blue sample-app:latest load-balancer:latest
