#! /bin/bash
source ./ecs-helpers.sh

export label="Nuxeo Init"
export statfile="/tmp/nuxeo-init-log.txt"

task_init

NUXEO_DIR="/merritt-filesys/nuxeo/mrt-atom"

if [[ -d "${NUXEO_DIR}" ]]
then
  cd ${NUXEO_DIR}
  git fetch
  git pull
else
  mkdir -p /merritt-filesys/nuxeo
  cd /merritt-filesys/nuxeo
  git clone https://github.com/CDLUC3/mrt-atom.git
  cd ${NUXEO_DIR}
fi

bundle install
mkdir -p LockFile LastUpdate logs

${NUXEO_DIR}/bin/nuxeoInit.sh || task_fail

task_complete
