# Fluent Bit Configuration Files for Merritt ECS

## Resources
- [Fluent Bit](https://docs.fluentbit.io/manual/about/what-is-fluent-bit)
  - [Filters](https://docs.fluentbit.io/manual/data-pipeline/filters)
- [AWS Firelens](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/using_firelens.html)
- [Merritt Sceptre (private)](https://github.com/CDLUC3/mrt-sceptre/blob/main/mrt-ecs/templates/service-env-ref.yaml.j2)
- [Merritt Fluent Bit Config files](https://github.com/CDLUC3/merritt-docker/tree/main/mrt-inttest-services/mrt-fluent-bit)

### Force all service output to STDOUT
- [Merritt Java Logger Customizations](https://github.com/CDLUC3/merritt-docker/blob/main/mrt-inttest-services/merritt-tomcat/Dockerfile)
- [Merritt Rails Logger Customizations](https://github.com/CDLUC3/mrt-dashboard/blob/main/config/initializers/lograge.rb)

### Service Log Configuration
```
        LogConfiguration:
          LogDriver: awsfirelens
          Options:
            Name: opensearch
            Host: {{uc3_domain_data.opensearch}}
            Port: 443
            Index: my_index_{{svcname}}
            Aws_Auth: 'On'
            Aws_Region: !Sub '${AWS::Region}'
            Aws_Service_Name: aoss
            Trace_Error: 'On'
            Trace_Output: 'On'
            Suppress_Type_Name: 'On'
            tls: 'On'
            retry_limit: 2
```

### Logger Sidecar Image
```
      - Name: log_router
        Image: "....dkr.ecr.us-west-2.amazonaws.com/mrt-fluent-bit:latest"
```

### Logger Sidecar Configuration
```
        FirelensConfiguration:
          Type: fluentbit
          Options:
            config-file-type: file
            config-file-value: {{fluentbit_file}}
```

## mrt-fluent-bit image

- [Dockerfile](Dockerfile)

## Generated fluent-bit configuration

```
bash-4.2# cat /fluent-bit/etc/fluent-bit.conf 

[INPUT]
    Name tcp
    Listen 127.0.0.1
    Port 8877
    Tag firelens-healthcheck

[INPUT]
    Name forward
    Mem_Buf_Limit 25MB
    unix_path /var/run/fluent.sock

[INPUT]
    Name forward
    Listen 127.0.0.1
    Port 24224

[FILTER]
    Name record_modifier
    Match *
    Record ecs_cluster mrt-ecs-dev-stack
    Record ecs_task_arn ...
    Record ecs_task_definition ...

@INCLUDE /fluent-bit/etc/FLUENTBIT_FILE-customizations.conf

[OUTPUT]
    Name null
    Match firelens-healthcheck

[OUTPUT]
    Name opensearch
    Match merrittdev-firelens*
    Aws_Auth On
    Aws_Region us-west-2
    Aws_Service_Name aoss
    Host ....us-west-2.aoss.amazonaws.com
    Index my_index_merrittdev
    Port 443
    Suppress_Type_Name On
    Trace_Error On
    Trace_Output On
    retry_limit 2
    tls On
```

## Sample Transformations

Fluent Bit documentation recommends [Rubular](https://rubular.com/) for regex testing.

Scenario, we have a service named app that logs in the following format
```
127.0.0.1 /foo/bar 200
127.0.0.1 /foo/bar?hi=x 200
127.0.0.1 /bar/foo 404
```

After firelens processing, the following will be generated
```

{
  "ecs_cluster": "...",
  "ecs_task_arn": "...",
  "ecs_task_definition": "...",
  "log": "127.0.0.1 /foo/bar 200"
}
{
  "ecs_cluster": "...",
  "ecs_task_arn": "...",
  "ecs_task_definition": "...",
  "log": "127.0.0.1 /foo/bar?hi=x 200"
}
{
  "ecs_cluster": "...",
  "ecs_task_arn": "...",
  "ecs_task_definition": "...",
  "log": "127.0.0.1 /bar/foo 404"
}

```

Add a custom parser for app `parser-customizations.conf`
```
[PARSER]
    Name app
    Format regex
    Regex ^(?<host>[^ ]*) (?<path>[^\"]*?) (?<code>[^ ]*)$
```

Add a custom rule to `app-customizations.conf`
```
[SERVICE]
    Parsers_file /fluent-bit/etc/parsers-merged.conf

[FILTER]
    Name Parser
    Match *
    Parser app
    Key_Name log
    Reserve_Data On
```

After running this customization, the following is generated
```
{
  "ecs_cluster": "...",
  "ecs_task_arn": "...",
  "ecs_task_definition": "...",
  "host": "127.0.0.1",
  "path":	"/foo/bar",
  "code":	200
}
{
  "ecs_cluster": "...",
  "ecs_task_arn": "...",
  "ecs_task_definition": "...",
  "host": "127.0.0.1",
  "path":	"/foo/bar?hi=x",
  "code":	200
}
{
  "ecs_cluster": "...",
  "ecs_task_arn": "...",
  "ecs_task_definition": "...",
  "host": "127.0.0.1",
  "path":	"/bar/foo",
  "code":	404
}
```

This data will be sent to the Merritt OpenSearch collection.

### Other notes
- Fluent bit provides a json parser named `docker` that will preserve json input.
- Custom filters can be applied based on the presence/abscense of json properties.
- Regex tests will return false if a property contains a json object
- Open search will reject records if type conflicts are introduced
  - `{"foo": "bar"}`
  - `{"foo": {"cat": "meow"}}`

## Command Line Testsing

Move to source directory
```
cd .../mrt-fluent-bit
```

- Authenticate to AWS and login to ECR
- Set the customization file in `test-driver-stdin.conf`

Build docker image 
```
docker compose build
```

Run stdin driver
```
docker run -it --rm -v ./test-driver-stdin.conf:/fluent-bit/etc/fluent-bit.conf ${ECR_REGISTRY}/mrt-fluent-bit
```

Run Dummy data driver
```
docker run -it --rm -v ./test-driver.conf:/fluent-bit/etc/fluent-bit.conf ${ECR_REGISTRY}/mrt-fluent-bit
```
