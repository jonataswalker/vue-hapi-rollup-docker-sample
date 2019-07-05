define GetFromPkg
$(shell node -p "require('./package.json').$(1)")
endef

PROJECT					:= $(call GetFromPkg,name)
VERSION					:= $(subst .,-,$(call GetFromPkg,version))
CONTAINER_NAME	:= $(subst .,-,$(call GetFromPkg,name))

.PHONY: default
default: help

.PHONY: __header
__header:
	@echo
	@echo "  |- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -|"
	@echo "  |- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -|"
	@echo "  |                                     __                   __                 |"
	@echo "  |        \  /    _    |__| _  _ .    |__)_ ||    _   ()/  |  \ _  _|  _ _     |"
	@echo "  |         \/ |_|(-,   |  |(_||_)|,   | \(_)|||_||_)  (X   |__/(_)(_|((-|      |"
	@echo "  |                            |                  |                             |"
	@echo "  |                                                                             |"
	@echo "  |- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -|"
	@echo "  |- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -|"

## This help message
.PHONY: help
help: __header
	@printf "Usage: make [target]\n";

	@awk '{ \
			if ($$0 ~ /^.PHONY: [a-zA-Z\-\_0-9]+$$/) { \
				helpCommand = substr($$0, index($$0, ":") + 2); \
				if (helpMessage) { \
					printf "\033[36m%-20s\033[0m %s\n", \
						helpCommand, helpMessage; \
					helpMessage = ""; \
				} \
			} else if ($$0 ~ /^[a-zA-Z\-\_0-9.]+:/) { \
				helpCommand = substr($$0, 0, index($$0, ":")); \
				if (helpMessage) { \
					printf "\033[36m%-20s\033[0m %s\n", \
						helpCommand, helpMessage; \
					helpMessage = ""; \
				} \
			} else if ($$0 ~ /^##/) { \
				if (helpMessage) { \
					helpMessage = helpMessage"\n                     "substr($$0, 3); \
				} else { \
					helpMessage = substr($$0, 3); \
				} \
			} else { \
				if (helpMessage) { \
					print "\n                     "helpMessage"\n" \
				} \
				helpMessage = ""; \
			} \
		}' \
		$(MAKEFILE_LIST)

## -- The most common targets are: --

## Builds, (re)creates, starts, and attaches to containers for a service
.PHONY: start
start: __header stop
	@docker container rm $(CONTAINER_NAME) || true
	@docker-compose up --build --detach

## Stop and removes containers, networks, volumes, and images created by up
.PHONY: stop
stop: __header
	@docker-compose down

## Guess what! :-)
.PHONY: restart
restart: stop start

## Show container logs
.PHONY: logs
logs:
	@docker container logs $(CONTAINER_NAME) --follow

## Interact within the container
.PHONY: interact
interact:
	@docker container exec -it $(CONTAINER_NAME) sh

## Inspect the container
.PHONY: inspect
inspect:
	@docker container inspect $(CONTAINER_NAME)

.DEFAULT_GOAL := default
