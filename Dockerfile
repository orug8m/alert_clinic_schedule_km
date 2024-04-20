# Multi Stage Build 1st for build (bundler and headless-chromedriver)
FROM ruby:3.3-slim-bookworm as builder

WORKDIR /var/task

ADD Gemfile /var/task/Gemfile
ADD Gemfile.lock /var/task/Gemfile.lock

RUN bundle install

# Multi Stage Build 2nd for executional container
FROM ruby:3.3-slim-bookworm

WORKDIR /var/task

# pkg-config libxml2-dev libxslt-dev: for nokogiri
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    pkg-config libxml2-dev libxslt-dev \
    tzdata

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY . .

ENTRYPOINT [ "ruby" ]
CMD [ "/var/task/app.rb" ]
