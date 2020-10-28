# Setting up Merritt Docker on a DEV server

## Pre-requisites

- Install github_rsa and github_rsa.pub for the role account.
- Install public keys for the team in ~/.ssh/authorized_keys.
- Clone the merritt-docker repo into the role account directory
```
git clone git@github.com:CDLUC3/merritt-docker.git
```
- Ensure that the environment variables are set
```
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export PATH=$JAVA_HOME/bin:$HOME/bin:$PATH
```

## VSCode Setup
- Connect to the remote host as the role account
- Open the folder ~/merritt-docker to create the workspace.
  - This will load the settings in .~/merritt-docker/vscode directory.

## Using VSCode with your own git credentials

## Start Services

- Navigate to mrt-services/docker-compose.yml
- Right click, select Compose Up
- Choose your configuration to start

## Start Java Debug Session

- Start a compose configuration including a debug container
- From the Debug tag, start "Debug Attach Remote"
- Add a breakpoint in the appropriate code base
- Navigate to the proper endpoint to trigger the debug

## Start Ruby Debug Session

- Start a compose configuration including a Ruby container (UI)
- From the Debug tag, start "Listen for rdebug-ide"
  - Note that the service will not start until the debugger is active
- Add a breakpoint in the appropriate code base
- Navigate to the proper endpoint to trigger the debug