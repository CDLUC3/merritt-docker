#! /bin/bash

if [[ -z $BUCKET8888 ]]; then
  echo "Environment variable BUCKET8888 only defined for DEV environments"
  exit 1
fi

arkp1=ark:/99999/
arkp2=$(/merritt-s3.sh ls s3://$BUCKET8888/$arkp1 | cut -c32- | grep system | tail -1)

/merritt-s3.sh cp s3://$BUCKET8888/${arkp1}${arkp2}mrt-mom.txt /tmp/mrt-mom.txt
echo 'error' >> /tmp/mrt-mom.txt
/merritt-s3.sh cp /tmp/mrt-mom.txt s3://$BUCKET8888/${arkp1}${arkp2}

/merritt-s3.sh cp s3://$BUCKET8888/${arkp1}${arkp2}mrt-ingest.txt /tmp/mrt-ingest.txt
sed -i -e 's/e/a/g' /tmp/mrt-ingest.txt
/merritt-s3.sh cp /tmp/mrt-ingest.txt s3://$BUCKET8888/${arkp1}${arkp2}