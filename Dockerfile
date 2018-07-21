FROM ruby:2.4.4-onbuild

RUN apt-get update && apt-get -y install node-less
RUN mkdir -pv /usr/src/app/tmp && bundle exec rake assets:compile --trace

EXPOSE 8000
ENTRYPOINT bundle exec unicorn -c config/unicorn.rb

HEALTHCHECK CMD curl http://localhost:8000/status || exit 1
