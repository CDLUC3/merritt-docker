# Mock ezid and storage service for ingest integration testing
#
# docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/pm-server:dev .
# aws ecr create-repository --repository-name pm-server
# docker push ${ECR_REGISTRY}/pm-server:dev

FROM ruby:3
RUN apt-get update -y -qq && apt-get install -y build-essential libpq-dev nodejs

# Adding gems
COPY Gemfile Gemfile

RUN gem install bundler
RUN bundle install --jobs 20 --retry 5
# Adding project files

COPY *.rb .
COPY *.html .

EXPOSE 4567
CMD ["ruby", "app.rb"]
