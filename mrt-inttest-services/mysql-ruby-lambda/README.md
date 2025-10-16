## Publish as ${ECR_REGISTRY}/mysql-ruby-lambda
This image used to be published as [cdluc3/mysql-ruby-lambda](https://hub.docker.com/r/cdluc3/mysql-ruby-lambda)

This Docker image is used to facilitate building Ruby Lambda dependencies.

MySql binaries need to be built for the Lambda environment.

```
docker build --pull -t ${ECR_REGISTRY}/mysql-ruby-lambda .
docker push ${ECR_REGISTRY}/mysql-ruby-lambda
```
