# Setting up Merritt Docker on a DEV server

## Pre-requisites

- Clone the init script into the role account directory
```
curl -o ~dpr2/bin/merritt-docker-dev-init.sh https://raw.githubusercontent.com/CDLUC3/merritt-docker/master/workspace-init/merritt-docker-dev-init.sh
chmod 754 ~dpr2/bin/merritt-docker-dev-init.sh
```

- [x] Ensure that the environment variables are set
```
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export PATH=$JAVA_HOME/bin:$HOME/bin:$PATH
```

- Confirm that ssh credentials have been carried into the session
```
ssh-add -l
```

- Run the init script from personal user account using established git credentials
```
~/bin/merritt-docker-dev-init.sh
```

_If this is to be run in VSCode:_ 
- make an ssh connection from user account 
- run this in a terminal 
- THEN add a folder to VSCode project ~dpr2/merritt-workspace/merritt-docker

- Run the build script from user account using established git credentials
```
~dpr2/merritt-workspace/merritt-docker/workspace-init/merritt-docker-dev-build.sh
```


## VSCode Setup
- Connect to the remote host as user account
  - be sure to ssh -A to bring github credentials
- Open the folder ~dpr2/merritt-workspace/merritt-docker to create the workspace.
  - This will load the settings in .~/merritt-docker/vscode directory.
- The project contains extension recommendations.  Accept those recommendations.

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