init:
	bundle install
	cp .env.dist .env

run:
	ruby main.rb

IMAGE_NAME=summarizarr

build:
	docker build -t ${IMAGE_NAME} .

COMMON=--env-file=.env \
	-v ${PWD}/cache:/app/cache \
	-v ${PWD}/main.rb:/app/main.rb

run-image:
	@docker run -it --rm \
	${COMMON} \
	${IMAGE_NAME} 
