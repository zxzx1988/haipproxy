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

	#启动 'common' 和 'ajax'这两种爬虫，以及他它们的定时任务调度器
	nohup python3 crawler_booter.py --usage crawler common ajax > crawler.log 2>&1 &
	nohup python3 scheduler_booter.py --usage crawler  ommon ajax > crawler_scheduler.log 2>&1 &
	#启动三个'init'校验器(特殊校验器，至少存在一个，用于初级校验，过滤掉那些直接从站点爬来的低质量代理IP)的实例
	nohup python3 crawler_booter.py --usage validator init > init_validator1.log 2>&1 &
	nohup python3 crawler_booter.py --usage validator init > init_validator2.log 2>&1 &
	nohup python3 crawler_booter.py --usage validator init > init_validator3.log 2>&1 &
	#启动普通校验器(http校验器和https校验器以http(s)://httpbin.org/ip为校验对象，也可以在这里指定自定义的校验器)，以及其定时任务调度器
	nohup python3 crawler_booter.py --usage validator https > https_validator.log 2>&1&
	nohup python3 crawler_booter.py --usage validator http > http_validator.log 2>&1&
	nohup python3 scheduler_booter.py --usage validator https > validator_https_scheduler.log 2>&1 &
	nohup python3 scheduler_booter.py --usage validator http > validator_http_scheduler.log 2>&1 &
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