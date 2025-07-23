# Makefile for API IA Invoices Docker Management

# Variables
COMPOSE_FILE = docker-compose.yml
PROJECT_NAME = api_ia_invoices
RAILS_SERVICE = api
DB_SERVICE = db

# Colors for output
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

.PHONY: help build up down restart logs shell db-shell clean test setup

# Default target
help: ## Show this help message
	@echo "$(GREEN)API IA Invoices - Docker Management$(NC)"
	@echo "Available commands:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup: ## Initial setup - copy .env.example to .env
	@echo "$(GREEN)Setting up environment...$(NC)"
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "$(YELLOW)Created .env file from .env.example$(NC)"; \
		echo "$(RED)Please edit .env file with your configuration$(NC)"; \
	else \
		echo "$(YELLOW).env file already exists$(NC)"; \
	fi

build: ## Build all Docker images
	@echo "$(GREEN)Building Docker images...$(NC)"
	docker-compose -f $(COMPOSE_FILE) build

up: ## Start all services
	@echo "$(GREEN)Starting all services...$(NC)"
	docker-compose -f $(COMPOSE_FILE) up -d

up-build: ## Build and start all services
	@echo "$(GREEN)Building and starting all services...$(NC)"
	docker-compose -f $(COMPOSE_FILE) up -d --build

down: ## Stop all services
	@echo "$(GREEN)Stopping all services...$(NC)"
	docker-compose -f $(COMPOSE_FILE) down

restart: ## Restart all services
	@echo "$(GREEN)Restarting all services...$(NC)"
	docker-compose -f $(COMPOSE_FILE) restart

logs: ## Show logs for all services
	docker-compose -f $(COMPOSE_FILE) logs -f

logs-api: ## Show logs for API service only
	docker-compose -f $(COMPOSE_FILE) logs -f $(RAILS_SERVICE)

logs-db: ## Show logs for database service only
	docker-compose -f $(COMPOSE_FILE) logs -f $(DB_SERVICE)

shell: ## Access Rails application shell
	@echo "$(GREEN)Accessing Rails shell...$(NC)"
	docker-compose -f $(COMPOSE_FILE) exec $(RAILS_SERVICE) bash

rails-console: ## Access Rails console
	@echo "$(GREEN)Accessing Rails console...$(NC)"
	docker-compose -f $(COMPOSE_FILE) exec $(RAILS_SERVICE) rails console

db-shell: ## Access PostgreSQL shell
	@echo "$(GREEN)Accessing PostgreSQL shell...$(NC)"
	docker-compose -f $(COMPOSE_FILE) exec $(DB_SERVICE) psql -U postgres -d api_ia_invoices_development

db-reset: ## Reset database (drop, create, migrate, seed)
	@echo "$(GREEN)Resetting database...$(NC)"
	docker-compose -f $(COMPOSE_FILE) exec $(RAILS_SERVICE) rails db:drop db:create db:migrate db:seed

db-migrate: ## Run database migrations
	@echo "$(GREEN)Running database migrations...$(NC)"
	docker-compose -f $(COMPOSE_FILE) exec $(RAILS_SERVICE) rails db:migrate

db-seed: ## Seed database
	@echo "$(GREEN)Seeding database...$(NC)"
	docker-compose -f $(COMPOSE_FILE) exec $(RAILS_SERVICE) rails db:seed

test: ## Run tests
	@echo "$(GREEN)Running tests...$(NC)"
	docker-compose -f $(COMPOSE_FILE) exec $(RAILS_SERVICE) rails test

clean: ## Clean up Docker resources
	@echo "$(GREEN)Cleaning up Docker resources...$(NC)"
	docker-compose -f $(COMPOSE_FILE) down -v --remove-orphans
	docker system prune -f

clean-all: ## Clean up all Docker resources (including images)
	@echo "$(RED)Cleaning up ALL Docker resources...$(NC)"
	docker-compose -f $(COMPOSE_FILE) down -v --remove-orphans
	docker system prune -af

status: ## Show status of all services
	@echo "$(GREEN)Service status:$(NC)"
	docker-compose -f $(COMPOSE_FILE) ps

# Production targets
prod-up: ## Start services with production profile
	@echo "$(GREEN)Starting production services...$(NC)"
	docker-compose -f $(COMPOSE_FILE) --profile production up -d

prod-build: ## Build production images
	@echo "$(GREEN)Building production images...$(NC)"
	docker-compose -f $(COMPOSE_FILE) build --target production

# Tools targets
tools-up: ## Start with tools profile (includes Adminer)
	@echo "$(GREEN)Starting services with tools...$(NC)"
	docker-compose -f $(COMPOSE_FILE) --profile tools up -d

# Health checks
health: ## Check health of all services
	@echo "$(GREEN)Checking service health...$(NC)"
	@docker-compose -f $(COMPOSE_FILE) ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"

# Quick development commands
dev: setup up-build ## Quick development setup (setup + build + up)
	@echo "$(GREEN)Development environment ready!$(NC)"
	@echo "$(YELLOW)API available at: http://localhost:3000$(NC)"
	@echo "$(YELLOW)Database available at: localhost:5432$(NC)"
	@echo "$(YELLOW)Redis available at: localhost:6379$(NC)"