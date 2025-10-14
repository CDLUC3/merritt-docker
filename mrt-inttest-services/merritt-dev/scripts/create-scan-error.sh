#! /bin/bash

if [[ -z $BUCKET7777 ]]; then
  echo "Environment variable BUCKET7777 only defined for DEV environments"
  exit 1
fi

echo 'hello' > /tmp/test.txt

/merritt-s3.sh cp /tmp/test.txt s3://$BUCKET7777/scan-error.txt
/merritt-s3.sh cp /tmp/test.txt s3://$BUCKET7777/ark:/00000/fk00000000/scan-error.txt

arkp1=ark:/99999/
arkp2=$(/merritt-s3.sh ls s3://$BUCKET7777/$arkp1 | cut -c32- | grep producer | tail -1)
/merritt-s3.sh cp /tmp/test.txt s3://$BUCKET7777/${arkp1}${arkp2}scan-error.txt
