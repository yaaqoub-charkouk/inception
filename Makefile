DATA_DIR = ~/data
COMPOSE = docker compose -f srcs/docker-compose.yml

all: setup build up

setup:
	@mkdir -p $(DATA_DIR)/mariadb
	@mkdir -p $(DATA_DIR)/wordpress

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

stop:
	$(COMPOSE) stop

start:
	$(COMPOSE) start

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

clean: down
	docker system prune -af

fclean: down
	docker system prune -af --volumes
	@sudo rm -rf $(DATA_DIR)

re: fclean all

.PHONY: all setup build up down stop start logs ps clean fclean re
