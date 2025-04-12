# Zenoh Docker configuration
ZENOH_IMAGE := eclipse/zenoh:latest
ZENOH_CONTAINER_NAME := zenoh-router
ZENOH_PORT := 7447
ZENOH_REST_PORT := 8000

# Default configuration - can be overridden via environment variables
DOCKER_NETWORK := zenoh-net

#.PHONY: help network start stop restart status logs clean

help:
	@echo "Available commands:"
	@echo "  make network     - Create Docker network for Zenoh"
	@echo "  make start      - Start Zenoh router container"
	@echo "  make stop       - Stop Zenoh router container"
	@echo "  make restart    - Restart Zenoh router container"
	@echo "  make status     - Check status of Zenoh router container"
	@echo "  make logs       - View Zenoh router logs"
	@echo "  make clean      - Remove Zenoh router container and network"

network:
	@docker network inspect $(DOCKER_NETWORK) >/dev/null 2>&1 || \
		docker network create $(DOCKER_NETWORK)

start: network
	@if [ "$$(docker ps -q -f name=$(ZENOH_CONTAINER_NAME))" ]; then \
		echo "Zenoh router is already running."; \
	else \
		if [ "$$(docker ps -aq -f status=exited -f name=$(ZENOH_CONTAINER_NAME))" ]; then \
			docker start $(ZENOH_CONTAINER_NAME); \
		else \
			docker run -d \
				--name $(ZENOH_CONTAINER_NAME) \
				--network $(DOCKER_NETWORK) \
				-p $(ZENOH_PORT):$(ZENOH_PORT) \
				-p $(ZENOH_REST_PORT):$(ZENOH_REST_PORT) \
				$(ZENOH_IMAGE); \
		fi; \
		echo "Zenoh router started."; \
	fi

stop:
	@if [ "$$(docker ps -q -f name=$(ZENOH_CONTAINER_NAME))" ]; then \
		docker stop $(ZENOH_CONTAINER_NAME); \
		echo "Zenoh router stopped."; \
	else \
		echo "Zenoh router is not running."; \
	fi

restart: stop start

status:
	@if [ "$$(docker ps -q -f name=$(ZENOH_CONTAINER_NAME))" ]; then \
		echo "Zenoh router is running."; \
		docker ps -f name=$(ZENOH_CONTAINER_NAME); \
	else \
		echo "Zenoh router is not running."; \
	fi

logs:
	@docker logs -f $(ZENOH_CONTAINER_NAME)

clean: stop
	@docker rm -f $(ZENOH_CONTAINER_NAME) 2>/dev/null || true
	@docker network rm $(DOCKER_NETWORK) 2>/dev/null || true
	@echo "Cleaned up Zenoh router container and network."