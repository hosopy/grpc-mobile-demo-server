FROM ruby:2.2
MAINTAINER hosopy

ENV GRPC_RUBY_VERSION 1.0.0
RUN gem install grpc -v ${GRPC_RUBY_VERSION}
RUN gem install grpc-tools -v ${GRPC_RUBY_VERSION}

WORKDIR /usr/src/demoapp
ADD *.rb ./
ADD lib ./lib/

CMD ruby server.rb
