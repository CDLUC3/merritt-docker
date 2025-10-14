#! /bin/bash

echo 'hello' > /tmp/test.txt

/merritt-s3.sh cp /tmp/test.txt s3://my-bucket/scan-error.txt
/merritt-s3.sh cp /tmp/test.txt s3://my-bucket/ark:/00000/fk00000000/scan-error.txt

arkp1=ark:/99999/
arkp2=$(/merritt-s3.sh ls s3://my-bucket/$arkp1 | cut -c32- | grep producer | tail -1)
/merritt-s3.sh cp /tmp/test.txt s3://my-bucket/${arkp1}${arkp2}scan-error.txt
