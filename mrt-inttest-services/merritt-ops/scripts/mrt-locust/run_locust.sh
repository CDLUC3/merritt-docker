#! /bin/bash
      
pip3 -q install locust
pip3 -q install bs4
source ./config.sh

echo; echo; echo " === Run ${DURATION} locust test"; echo
locust --headless -u ${USERCOUNT} -r 1 -t ${DURATION} -H $MERRITTURL --only-summary -L ERROR --csv out.csv --reset-stats --json > out.json
cut -d, -f2,3,4,10,15 out.csv_stats.csv

echo; echo; echo " === Analyze Failures"; echo
jq ".[] | select(.num_failures>0) | {name: .name, fail: .num_failures}" out.json > fail.json
cat fail.json
      
echo; echo; echo " === Analyze 80th percentile response times"; echo
# See https://github.com/CDLUC3/mrt-locust/blob/main/sample.md for an explanation of this jq command
jq "[.[] | {name: .name, resp_ms_80pct: (.response_times | (. as \$s | [([(keys[] as \$k | (\$k | tonumber))] | sort_by(.)) | .[] as \$v | range(\$s[\$v|tostring]) | \$v]) as \$vals | \$vals[(\$vals | length) * .8])}]" out.json > out80.json
cat out80.json

echo; echo; echo " === Test for failure... fail if file is not empty"; echo
if [ -s fail.json ]; then echo " ** FAILURE found"; false; fi

echo; echo; echo " === Test for login response times greater than #{MS_LOGIN}ms... fail if file is not empty"; echo
jq ".[] | select(.resp_ms_80pct > $MS_LOGIN) | select(.name | test(\"login\$\"))" out80.json > out.test.txt
ls -l out.test.txt
cat out.test.txt
if [ -s out.test.txt ]; then echo " ** FAIL login reposonse time"; false; fi

echo; echo; echo " === Test for response times greater than ${MS_RESP}ms... fail if file is not empty"; echo
jq ".[] | select(.resp_ms_80pct > $MS_RESP) | select(.name | test(\"login\$\") | not)" out80.json > out.test.txt
ls -l out.test.txt
cat out.test.txt
if [ -s out.test.txt ]; then echo " ** FAIL response time"; false; fi
