#! /bin/bash

make_status() {
  datetime=$(TZ="America/Los_Angeles" date "+%Y-%m-%d %H:%M:%S")
  status=$1
  duration=$2

  echo $(jq -n \
    --arg task_datetime "$datetime" \
    --arg task_environment "$MERRITT_ECS" \
    --arg task_status "$status" \
    --arg task_label "$label" \
    --arg task_duration "${duration}" \
    '$ARGS.named')
}

task_init() {
  TZ="America/Los_Angeles" date "+ ==> %Y-%m-%d %H:%M:%S: START: $label for $MERRITT_ECS" | tee $statfile
  echo $(make_status "STARTED" "")
  export STARTTIME=$(date +%s)
}

task_complete() {
  local send_sms=${1:-N}

  TZ="America/Los_Angeles" date "+ ==> %Y-%m-%d %H:%M:%S: COMPLETE: $label for $MERRITT_ECS $(duration)" | tee -a $statfile
  echo $(make_status "COMPLETE" "$(duration)")

  if [[ "$send_sms" == "Y" ]]
  then
    subject="Merritt ECS $label for $MERRITT_ECS $(duration)"
    aws sns publish --topic-arn "$SNS_ARN" --subject "$subject" \
      --message "$(cat $statfile)"
  fi
}

task_fail() {
  TZ="America/Los_Angeles" date "+ ==> %Y-%m-%d %H:%M:%S: FAIL: $label for $MERRITT_ECS $(duration)" | tee -a $statfile
  echo $(make_status "FAIL" "$(duration)")
  subject="FAIL: Merritt ECS $label for $MERRITT_ECS $(duration)"
  aws sns publish --topic-arn "$SNS_ARN" --subject "$subject" \
    --message "$(cat $statfile)"
  exit 1
}

duration() {
  duration=$(( $(date +%s) - $STARTTIME ))
  min=$(( $duration / 60 ))
  sec=$(( $duration % 60 ))
  # Pad seconds with a leading zero when < 10
  if [ "$sec" -lt 10 ]; then sec="0$sec"; fi
  echo "($min:$sec sec)"
}