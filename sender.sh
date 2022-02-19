#!/bin/bash

COUNT=0
TIME=0
for i in $(seq 1 10)
do
	echo "============="
	echo "STAGE $i OF 10"
	echo "============="
	./kasrapars.sh > tmp.txt
	grep '1 passing' tmp.txt
	if [ $? -eq 0 ]
	then
	  TIME=$(grep '1 passing' tmp.txt | awk '{print $7}' | tr -d '()s' | sed 's/[^0-9.]//g' | sed 's/..$//')
		COUNT=$((COUNT + 1))
	fi
	# grep '1 passing' tmp.txt
	# if [ $? -eq 0 ]
	# then
	# 	COUNT=$((COUNT + 1))
	# fi
	sync
done
if [ $COUNT -gt 0 ]
then
	zabbix_sender -z 127.0.0.1 -p 10051 -s "kasrapars" -k time -o $TIME
	zabbix_sender -z 127.0.0.1 -p 10051 -s "kasrapars" -k log -o 'login successful'
else
	zabbix_sender -z 127.0.0.1 -p 10051 -s "kasrapars" -k time -o 0
	zabbix_sender -z 127.0.0.1 -p 10051 -s "kasrapars" -k log -o 'login unsuccessful'
fi
rm tmp.txt
# ./kasrapars.sh > tmp.txt
# TIME=$(grep '1 passing' tmp.txt | awk '{print $7}' | tr -d '()s' | sed 's/[^0-9.]//g' | sed 's/..$//')
# grep '1 passing' tmp.txt
# if [ $? -eq 0 ]
# then
# 	zabbix_sender -z 127.0.0.1 -p 10051 -s "kasrapars" -k time -o $TIME
# 	zabbix_sender -z 127.0.0.1 -p 10051 -s "kasrapars" -k log -o 'login successful'
# else
# 	zabbix_sender -z 127.0.0.1 -p 10051 -s "kasrapars" -k time -o 0
# 	zabbix_sender -z 127.0.0.1 -p 10051 -s "kasrapars" -k log -o 'login unsuccessful'
# fi
# rm tmp.txt
