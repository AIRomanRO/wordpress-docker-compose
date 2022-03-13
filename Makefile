mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
COMPOSE_PROJECT_NAME := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
export COMPOSE_PROJECT_NAME

CURRENT_UID := $(shell id -u)
CURRENT_GID := $(shell id -g)

export CURRENT_UID
export CURRENT_GID

start:
	docker network create -d bridge wordpress-default --subnet=101.101.0.0/16  --ip-range=101.101.5.0/24 --gateway=101.101.5.1 || true
	docker-compose up -d --build

up: start configure

stop:
	docker-compose stop

healthcheck:
	docker-compose run --rm healthcheck

down:
	docker-compose down

updatesiteurlvar:
	$(eval WORDPRESS_WEBSITE_URL_WITHOUT_HTTP := $(shell sh -c "docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(COMPOSE_PROJECT_NAME)_webserver"))		
	$(eval export WORDPRESS_WEBSITE_URL_WITHOUT_HTTP)
	@echo "Get current websever ip < $(WORDPRESS_WEBSITE_URL_WITHOUT_HTTP) >"
	$(eval WORDPRESS_WEBSITE_URL := "http://$(WORDPRESS_WEBSITE_URL_WITHOUT_HTTP)")
	$(eval export WORDPRESS_WEBSITE_URL)
	@echo "Update current website url var < $(WORDPRESS_WEBSITE_URL) >"

configure: updatesiteurlvar
	docker-compose \
		-f docker-compose.yml \
		-f wp-auto-config.yml \
		run --rm wp-auto-config

autoinstall: start updatesiteurlvar
	docker-compose \
		-f docker-compose.yml \
		-f wp-auto-config.yml \
		run --rm wp-auto-install

install: start healthcheck

clean: down
	@echo "Removing related folders/files..."
	@rm -rf  mysql/* wordpress/* logs/*.log

reset: down
	@echo "Removing related folders/files..."
	@rm -rf  mysql/* wordpress/*.* wordpress/wp-admin/* wordpress/wp-includes/* logs/*.log

