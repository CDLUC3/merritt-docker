# Mock ezid and storage service for ingest integration testing
#
# docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mock-merritt-it:dev .
# aws ecr create-repository --repository-name mock-merritt-it
# docker push ${ECR_REGISTRY}/mock-merritt-it:dev

FROM public.ecr.aws/docker/library/ruby:3
RUN apt-get update -y -qq && apt-get install -y build-essential libpq-dev nodejs && apt-get -y upgrade


# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN gem install bundler
RUN bundle install --jobs 20 --retry 5
# Adding project files

COPY *.rb ./
COPY *.sh ./
COPY data /data
COPY *.md /data
COPY static /data/static
COPY --from=public.ecr.aws/docker/library/mysql:8 /usr/bin/mysql /usr/bin/mysql
COPY --from=public.ecr.aws/docker/library/mysql:8 /usr/bin/mysqldump /usr/bin/mysqldump

RUN ruby generate.rb
RUN chmod 744 *.sh
RUN mkdir /audit_replic_data
RUN touch /audit_replic_data/audit_replic_data.sql

EXPOSE 4567
CMD ["ruby", "app.rb"]
