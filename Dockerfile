FROM ruby:2.5.3

WORKDIR /app

COPY . /app

EXPOSE 8080

CMD ruby /app/simple_server.rb

# Build command:
# docker image build -t docker_hands_on .
#
# Run command:
# docker run -p 80:8080 --rm -t --name simple_server docker_hands_on
