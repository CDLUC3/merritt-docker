# Using ZooKeeper in Amazon ECS

## Docker Compose: Standalone ZooKeeper

```yaml
services:
  zoo:
    container_name: zoo
    image: public.ecr.aws/docker/library/zookeeper:3.9.3
    restart: unless-stopped
  my_client:
    container_name: my_client
    image: ${MY_ECR}/my_client
    environment:
      ZKCONN: zoo:2181      
```

## ECS / ServiceConnect Configuration: Standalone ZooKeeper

This configuration will allow the client container to access ZooKeeper using `zoo:2181`

```yaml
Resources:
  ServiceZoo:
    Type: AWS::ECS::Service
    Properties:
      ServiceName: zoo
      Cluster: my_cluster
      DesiredCount: 1
      TaskDefinition: !Ref TaskDefinitionZoo
      EnableExecuteCommand: true
      ServiceConnectConfiguration:
        Enabled: true
        Namespace: my_namespace
        Services:
        - PortName: zoo2181_port
          DiscoveryName: zoo2181
          ClientAliases:
          - DnsName: zoo
            Port: 2181
        # Make Admin Port Available
        - PortName: zoo8080_port
          DiscoveryName: zoo8080
          ClientAliases:
          - DnsName: zoo
            Port: 8080
      DeploymentConfiguration:
        # In a clustered mode, this will be important when redeploying nodes in the cluster
        MaximumPercent: 100
        MinimumHealthyPercent: 0
        DeploymentCircuitBreaker:
          Enable: true
          Rollback: true
      CapacityProviderStrategy:
        - CapacityProvider: 'FARGATE'
          Weight: 1
      NetworkConfiguration:
        AwsvpcConfiguration:
          AssignPublicIp: 'ENABLED'
          Subnets:
            - {{sceptre_user_data.public_subnet_a}}
            - {{sceptre_user_data.public_subnet_b}}
            - {{sceptre_user_data.public_subnet_c}}
          SecurityGroups:
            - !Ref my_sg

  TaskDefinitionzoo:
    Type: AWS::ECS::TaskDefinition
    Properties:
      NetworkMode: awsvpc
      ContainerDefinitions:
      - Image: public.ecr.aws/docker/library/zookeeper:3.9.3
        Name: zoo
        PortMappings:
        - ContainerPort: 2181
          # the following is needed in clustered mode
          # HostPort: 2181
          Protocol: 'tcp'
          Name: zoo2181_port
        - ContainerPort: 8080
          # enables client apps to talk to the admin port (snapshot, restore)
          HostPort: 8080
          Protocol: 'tcp'
          Name: zoo8080_port
        StartTimeout: 30
        StopTimeout: 30

        Environment:
        - Name: ZOO_MAX_CLIENT_CNXNS
          Value: 500
      Cpu: ...
      Memory: ..
      RequiresCompatibilities:
        - FARGATE
      TaskRoleArn: ...
      ExecutionRoleArn: ...
```

## Docker Compose: 3 Node ZooKeeper Cluster

```yaml
services:
  zoo1:
    container_name: zoo1
    image: public.ecr.aws/docker/library/zookeeper:3.9.3
    environment:
      ZOO_MY_ID: 1
      ZOO_SERVERS: 'server.1=zoo1:2888:3888;2181 server.2=zoo2:2888:3888;2181 server.3=zoo3:2888:3888;2181'
    restart: unless-stopped
  zoo2:
    container_name: zoo2
    image: public.ecr.aws/docker/library/zookeeper:3.9.3
    environment:
      ZOO_MY_ID: 2
      ZOO_SERVERS: 'server.1=zoo1:2888:3888;2181 server.2=zoo2:2888:3888;2181 server.3=zoo3:2888:3888;2181'
    restart: unless-stopped
  zoo3:
    container_name: zoo3
    image: public.ecr.aws/docker/library/zookeeper:3.9.3
    environment:
      ZOO_MY_ID: 3
      ZOO_SERVERS: 'server.1=zoo1:2888:3888;2181 server.2=zoo2:2888:3888;2181 server.3=zoo3:2888:3888;2181'
    restart: unless-stopped
  my_client:
    container_name: my_client
    image: ${MY_ECR}/my_client
    environment:
      ZKCONN: zoo1:2181,zoo2:2181,zoo3:2181
```

## ECS / ServiceConnect Configuration: 3 Node ZooKeeper Cluster

This configuration will allow the client container to access ZooKeeper using `zoo1:2181,zoo2:2181,zoo3:2181`

Repeat the following 3 times: zoo1, zoo2, zoo3
```yaml
Resources:
  ServiceZoo1:
    Type: AWS::ECS::Service
    Properties:
      ServiceName: zoo1
      Cluster: my_cluster
      DesiredCount: 1
      TaskDefinition: !Ref TaskDefinitionzoo1
      EnableExecuteCommand: true
      ServiceConnectConfiguration:
        Enabled: true
        Namespace: my_namespace
        Services:
        - PortName: zoo1_2181_port
          DiscoveryName: zoo1_2181
          ClientAliases:
          - DnsName: zoo1
            Port: 2181
        - PortName: zoo1_2888_port
          DiscoveryName: zoo1_2888
          ClientAliases:
          - DnsName: zoo1
            Port: 2888
        - PortName: zoo1_3888_port
          DiscoveryName: zoo1_3888
          ClientAliases:
          - DnsName: zoo1
            Port: 23888
        # Make Admin Port Available
        - PortName: zoo1_8080_port
          DiscoveryName: zoo1_8080
          ClientAliases:
          - DnsName: zoo1
            Port: 8080
      DeploymentConfiguration:
        # In a clustered mode, this will be important when redeploying nodes in the cluster
        MaximumPercent: 100
        MinimumHealthyPercent: 0
        DeploymentCircuitBreaker:
          Enable: true
          Rollback: true
      CapacityProviderStrategy:
        - CapacityProvider: 'FARGATE'
          Weight: 1
      NetworkConfiguration:
        AwsvpcConfiguration:
          AssignPublicIp: 'ENABLED'
          Subnets:
            - {{sceptre_user_data.public_subnet_a}}
            - {{sceptre_user_data.public_subnet_b}}
            - {{sceptre_user_data.public_subnet_c}}
          SecurityGroups:
            - !Ref my_sg

  TaskDefinitionzoo1:
    Type: AWS::ECS::TaskDefinition
    Properties:
      NetworkMode: awsvpc
      ContainerDefinitions:
      - Image: public.ecr.aws/docker/library/zookeeper:3.9.3
        Name: zoo1
        PortMappings:
        - ContainerPort: 2181
          # the following is needed in clustered mode to allow the other nodes to find this one
          HostPort: 2181
          Protocol: 'tcp'
          Name: zoo1_2181_port
        - ContainerPort: 2888
          # the following is needed in clustered mode to allow the other nodes to find this one
          HostPort: 2888
          Protocol: 'tcp'
          Name: zoo1_2888_port
        - ContainerPort: 3888
          # the following is needed in clustered mode to allow the other nodes to find this one
          HostPort: 3888
          Protocol: 'tcp'
          Name: zoo1_3888_port
        - ContainerPort: 8080
          # enables client apps to talk to the admin port (snapshot, restore)
          HostPort: 8080
          Protocol: 'tcp'
          Name: zoo1_8080_port
        StartTimeout: 30
        StopTimeout: 30

        Environment:
        - Name: ZOO_MAX_CLIENT_CNXNS
          Value: 500
        - Name: ZOO_MY_ID
          Value: 1
        - Name: ZOO_SERVERS
          Value: 'server.1=zoo1:2888:3888;2181 server.2=zoo2:2888:3888;2181 server.3=zoo3:2888:3888;2181'
      Cpu: ...
      Memory: ..
      RequiresCompatibilities:
        - FARGATE
      TaskRoleArn: ...
      ExecutionRoleArn: ...
```

Change "zoo1" above to "zoo2", Note that ZOO_MY_ID must be set to 2
```yaml
  ServiceZoo2:
  TaskDefinitionzoo2:
    Properties:
      ContainerDefinitions:
        Environment:
        - Name: ZOO_MY_ID
          Value: 2
```

Change "zoo1" above to "zoo3", Note that ZOO_MY_ID must be set to 3
```yaml
  ServiceZoo3:
  TaskDefinitionzoo3:
    Properties:
      ContainerDefinitions:
        Environment:
        - Name: ZOO_MY_ID
          Value: 3
```

## Cycle Through ZK instances for a controlled restart

```bash
      wait_on_svc_running() {
        svc=${1:-na}
        max=${2:-20}
        echo "Wait on running: $svc (max tries: $max)"
        attempts=0
        running=0
        while [[ $running -eq 0 ]]
        do 
          sleep 15
          running=0
          attempts=$(($attempts + 1))
          if [[ $attempts -gt $max ]]
          then
            echo "Giving up waiting for running tasks"
            exit 1
          fi
          ARN=$(aws ecs list-services --cluster my_stack --output text|grep $svc|cut -f2)
          running=$(aws ecs describe-services --cluster my_stack --services $ARN --query services[].[runningCount] --output text --no-cli-pager)
          echo "Attept $attempts: $running running tasks"
        done
      }

      wait_on_svc_not_running() {
        svc=${1:-na}
        max=${2:-20}
        echo "Wait on NOT running: $svc (max tries: $max)"
        attempts=0
        running=-1
        while [[ $running -ne 0 ]]
        do 
          sleep 15
          running=0
          attempts=$(($attempts + 1))
          if [[ $attempts -gt $max ]]
          then
            echo "Giving up waiting for NOT running tasks"
            exit 1
          fi
          ARN=$(aws ecs list-services --cluster my_stack --output text|grep $svc|cut -f2)
          running=$(aws ecs describe-services --cluster my_stack --services $ARN --query services[].[runningCount] --output text --no-cli-pager)
          echo "Attept $attempts: $running running tasks"
        done
      }

      # consider POST http://zoo1:8080/commands/snapshot
      sleep 30

      aws ecs update-service --cluster my_stack --service zoo1 --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
      wait_on_svc_not_running 'zoo1'
      wait_on_svc_running 'zoo1'

      aws ecs update-service --cluster my_stack --service zoo2 --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
      wait_on_svc_not_running 'zoo2'
      wait_on_svc_running 'zoo2'

      aws ecs update-service --cluster my_stack --service zoo3 --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
      wait_on_svc_not_running 'zoo3'
      wait_on_svc_running 'zoo3'

```
