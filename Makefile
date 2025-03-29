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
	-v ${PWD}/app:/app/app \
	-v ${PWD}/cache:/app/cache \
	-v ${PWD}/main.rb:/app/main.rb \
	-v ${PWD}/Gemfile:/app/Gemfile \
	-v ${PWD}/Gemfile.lock:/app/Gemfile.lock \
	-e RAILS_ENV=development

run-image:
	@docker run -it --rm \
	${COMMON} \
	${IMAGE_NAME}:production 

TEST_COMMON=-v ${PWD}/app:/app/app \
	-v ${PWD}/cache:/app/cache \
	-v ${PWD}/main.rb:/app/main.rb \
	-v ${PWD}/spec:/app/spec  \
	-v ${PWD}/Gemfile:/app/Gemfile \
	-v ${PWD}/Gemfile.lock:/app/Gemfile.lock \
	-e RAILS_ENV=test

run-image-test:
	@docker run -it --rm \
	${TEST_COMMON} \
	${IMAGE_NAME}:test \
	bundle exec rspec -fd ${TARGET}

lint:
	bundle exec rake lint_fix

update-mocks:
	bash update_mocks.sh