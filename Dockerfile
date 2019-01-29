FROM ruby:2.5.3

RUN gem install mysql2

WORKDIR /app

EXPOSE 8080

CMD ruby /app/simple_server.rb

COPY . /app

# Build command:
# docker image build -t docker_hands_on .
#
# Run command:
# docker run -p 80:8080 --rm -t --name simple_server docker_hands_on
