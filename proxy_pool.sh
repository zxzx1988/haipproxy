#!/bin/bash
CMD=$1
ProxyPoolCollectors='_booter.py --usage'

function startup()
{

	PID_COUNT=`ps -ef|grep "${ProxyPoolCollectors}"|grep -v "grep"|wc -l`
	if [ $PID_COUNT -gt 0 ]; then
		echo "Get Web is running already. Nothing to be done."
		exit 0
	fi
	echo "In startup"

	nohup python3 crawler_booter.py --usage crawler common > crawler.log 2>&1 &
	nohup python3 scheduler_booter.py --usage crawler common > crawler_scheduler.log 2>&1 &
	nohup python3 crawler_booter.py --usage validator init > init_validator.log 2>&1 &
	nohup python3 crawler_booter.py --usage validator https > https_validator.log 2>&1&
	nohup python3 scheduler_booter.py --usage validator https > validator_scheduler.log 2>&1 &
}


function stop()
{
	PY_PID=`ps -ef|grep "${ProxyPoolCollectors}"|grep -v "grep"|awk '{print $2}'`
	echo "PY_PID="`echo ${PY_PID}`
	if [ -z "$PY_PID" ]; then
		echo "No need to kill Python script."
	else
		kill -9 `echo ${PY_PID}`
	fi
}



if [ "start" = "${CMD}" ]; then
	echo "Command: "${CMD}
	startup
fi

if [ "stop" = "${CMD}" ]; then
	echo "Command: "${CMD}
	stop
fi

if [ "restart" = "${CMD}" ]; then
	echo "Command: "${CMD}
	stop
	startup
fi


echo "Done."
exit 0