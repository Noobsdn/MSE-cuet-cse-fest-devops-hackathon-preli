# Docker Services:
#   up - Start services (use: make up MODE=dev|prod ARGS="--build")
#   down - Stop services (use: make down MODE=dev|prod ARGS="--volumes")
#   build - Build containers (use: make build MODE=dev|prod)
#   logs - View logs (use: make logs MODE=dev|prod SERVICE=gateway)
#   restart - Restart services (use: make restart MODE=dev|prod SERVICE=backend)
#   shell - Open shell in container (use: make shell SERVICE=backend MODE=dev, default SERVICE=backend)
#   ps - Show running containers (use MODE=prod for production)
#
# Convenience Aliases (Development):
#   dev-up - Start development environment
#   dev-down - Stop development environment
#   dev-build - Build development containers
#   dev-logs - View development logs
#   dev-restart - Restart development services
#   dev-shell - Open shell in backend container (dev)
#
# Convenience Aliases (Production):
#   prod-up - Start production environment
#   prod-down - Stop production environment
#   prod-build - Build production containers
#   prod-logs - View production logs
#   prod-restart - Restart production services
#   prod-shell - Open shell in backend container (prod)
#
# Database:
#   db-migrate - Run database migrations (placeholder)
#   db-reset - Reset MongoDB database (WARNING: deletes all data)
#   db-backup - Backup MongoDB database into ./mongo-backups/
#
# Cleanup:
#   clean - Remove containers and networks (both dev and prod)
#   clean-all - Remove containers, networks, volumes, and images
#   clean-volumes - Remove all named volumes used by this project
#
# Utilities:
#   status - Alias for ps
#   health - Check service health (gateway + backend via gateway)
#
# Help:
#   help - Display this help message

MODE ?= dev
ARGS ?=
SERVICE ?= backend

# Determine compose file based on MODE
ifeq ($(MODE),prod)
COMPOSE_FILE := docker/compose.production.yaml
else
COMPOSE_FILE := docker/compose.development.yaml
endif

DC := docker compose --env-file .env -f $(COMPOSE_FILE)

.PHONY: up down build logs restart shell ps \
        dev-up dev-down dev-build dev-logs dev-restart dev-shell \
        prod-up prod-down prod-build prod-logs prod-restart prod-shell \
        db-migrate db-reset db-backup \
        clean clean-all clean-volumes status health help

up:
	$(DC) up $(ARGS) -d

down:
	$(DC) down $(ARGS)

build:
	$(DC) build $(ARGS)

logs:
	$(DC) logs -f $(SERVICE)

restart:
	$(DC) restart $(SERVICE)

shell:
	$(DC) exec $(SERVICE) sh

ps:
	$(DC) ps

# Development aliases
dev-up:
	$(MAKE) MODE=dev up

dev-down:
	$(MAKE) MODE=dev down

dev-build:
	$(MAKE) MODE=dev build

dev-logs:
	$(MAKE) MODE=dev logs SERVICE=$(SERVICE)

dev-restart:
	$(MAKE) MODE=dev restart SERVICE=$(SERVICE)

dev-shell:
	$(MAKE) MODE=dev shell SERVICE=$(SERVICE)

# Production aliases
prod-up:
	$(MAKE) MODE=prod up

prod-down:
	$(MAKE) MODE=prod down

prod-build:
	$(MAKE) MODE=prod build

prod-logs:
	$(MAKE) MODE=prod logs SERVICE=$(SERVICE)

prod-restart:
	$(MAKE) MODE=prod restart SERVICE=$(SERVICE)

prod-shell:
	$(MAKE) MODE=prod shell SERVICE=$(SERVICE)

# DB operations (simple but functional)
db-migrate:
	@echo "No DB migrations defined. Add your migration commands here if needed."

db-reset:
	@echo "WARNING: this will remove Mongo volumes for both dev and prod!"
	$(DC) down --volumes

db-backup:
	@mkdir -p mongo-backups
	@echo "Creating MongoDB backup into mounted /data/backup directory (check volume)..."
	$(DC) exec mongo sh -c 'mongodump --db $$MONGO_DATABASE --out /data/backup/backup-`date +%Y%m%d-%H%M%S`'

# Cleanup
clean:
	@echo "Stopping dev and prod environments..."
	- docker compose -f docker/compose.development.yaml down
	- docker compose -f docker/compose.production.yaml down

clean-all:
	@echo "Stopping and removing dev+prod including volumes..."
	- docker compose -f docker/compose.development.yaml down --volumes --remove-orphans
	- docker compose -f docker/compose.production.yaml down --volumes --remove-orphans

clean-volumes:
	@echo "Removing named volumes for dev and prod..."
	- docker volume rm $$(docker volume ls -q | grep 'mongo_data') 2>/dev/null || true
	- docker volume rm $$(docker volume ls -q | grep 'mongo_backup') 2>/dev/null || true

status: ps

health:
	@echo "Gateway health:"
	- curl -sS http://localhost:5921/health || echo " (unreachable)"
	@echo
	@echo "Backend health via gateway:"
	- curl -sS http://localhost:5921/api/health || echo " (unreachable)"

help:
	@grep -E '^#' $(lastword $(MAKEFILE_LIST)) | sed 's/^#//'
