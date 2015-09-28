FROM ruby:2.1-onbuild
EXPOSE 8000
ENTRYPOINT bundle exec unicorn -c config/unicorn.rb
