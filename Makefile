#make_args := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
#container := $(word 1, $(make_args))
#cmd       := $(wordlist 2, $(words $(make_args)), $(make_args))

ifneq ($(origin NAME),command line)
NAME := app
endif
CMD  ?= date

.PHONY: env-info
env-info:
	@echo "_WSL_SLINK_DIR  : $(_WSL_SLINK_DIR)"
	@echo "_WSL_DOCKER_DIR : $(_WSL_DOCKER_DIR)"

.PHONY: dc-login
dc-login:
	@cd $(_WSL_DOCKER_DIR) && docker-compose exec $(NAME) bash --login

.PHONY: dc-make
dc-make:
	@cd $(_WSL_DOCKER_DIR) && docker-compose exec -u 1000:1000 -it $(NAME) make -- $(CMD)

.PHONY: restart
restart:
	docker compose restart

.PHONY: up
up:
	docker compose -f ./docker/docker-compose.yml up -d

.PHONY: down
down:
	docker compose -f ./docker/docker-compose.yml down

.PHONY: clean
clean:
	docker compose -f ./docker/docker-compose.yml down -v

SERVICES ?= mysql_master mysql_slave

.PHONY: db-reset
db-reset:
	docker compose -f ./docker/docker-compose.yml down -v $(SERVICES)
	docker compose -f ./docker/docker-compose.yml up -d --build $(SERVICES)

# 必須のおまじない
#%:
#	@:
.DEFAULT:
	@echo "--- [WARN] target '$@' unknown ---"
