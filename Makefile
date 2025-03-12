init:
	bundle install
	cp .env.dist .env

run:
	ruby main.rb

IMAGE_NAME=summarizarr

build:
	docker build --target production -t ${IMAGE_NAME}:production .

build-test:
	docker build --target test -t ${IMAGE_NAME}:test .

COMMON=--env-file=.env \
	-v ${PWD}/cache:/app/cache \
	-v ${PWD}/main.rb:/app/main.rb

run-image:
	@docker run -it --rm \
	${COMMON} \
	${IMAGE_NAME}:production 

run-image-test:
	@docker run -it --rm \
	${COMMON} \
	${IMAGE_NAME}:test \
	bundle exec rspec
