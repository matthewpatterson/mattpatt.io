DOCKER=sudo docker
COMPOSE=sudo docker-compose

compose_build:
	$(COMPOSE) build

run: compose_build
	$(COMPOSE) up

build:
	$(DOCKER) build -t profile .
	$(DOCKER) build -t nginx .

save: build
	$(DOCKER) run -d profile:latest
	$(DOCKER) commit `$(DOCKER) ps | grep 'profile:latest' | awk '{ print $$1 }'` profile_img
	$(DOCKER) save profile_img > tmp/profile_img.tar
	$(DOCKER) stop `$(DOCKER) ps | grep 'profile:latest' | awk '{ print $$1 }'`
	$(DOCKER) run -d nginx:latest
	$(DOCKER) commit `$(DOCKER) ps | grep 'nginx:latest' | awk '{ print $$1 }'` nginx_img
	$(DOCKER) save nginx_img > tmp/nginx_img.tar
	$(DOCKER) stop `$(DOCKER) ps | grep 'nginx:latest' | awk '{ print $$1 }'`
