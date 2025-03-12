FROM ruby:3.4.2 AS base

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./

FROM base AS dependencies

RUN bundle install --without test

FROM dependencies AS test

RUN bundle install --with test

COPY . .

FROM dependencies AS production

COPY . .

ENTRYPOINT [ "ruby", "main.rb" ]