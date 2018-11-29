#!/usr/bin/env bash
#######################################################################
#author nikai
#######################################################################
APP_NAME=ui.jar
APP_URL=http://192.168.1.119:8911/view/cloud/job/cloud-user/ws/target/cloud-user.jar
SERVER_PORT=18000
RUN_ENV=dev

#使用说明，用来提示输入参数
usage() {
    echo "Usage: sh run.sh [start|stop|restart|status|update] [dev|prd|test .... dev]"
    exit 1
}

#检查程序是否在运行
is_exist(){
  pid=`ps -ef|grep $APP_NAME|grep -v grep|awk '{print $2}' `
  #如果不存在返回1，存在返回0
  if [ -z "${pid}" ]; then
    echo "未检测到${APP_NAME}运行"
    return 1
  else
    echo "检测到${APP_NAME}已运行，进程号为$pid"
    return 0
  fi
}

is_restart(){
  newpid=`ps -ef|grep $APP_NAME|grep -v grep|awk '{print $2}' `
  #如果不存在返回1，存在返回0
  if [ -z "${newpid}" ]; then
    echo "未检测到${APP_NAME}运行"
    return 1
  else
    echo "检测到${APP_NAME}已运行，进程号为$newpid"
    return 0
  fi
}

#检查应用是否存在
is_exist_app(){
   if [ -e ${APP_NAME} ]; then
       return 0
   else
       return 1
   fi
}

#启动方法
start() {
  is_exist
  if [ $? -eq "0" ]; then
    echo "${APP_NAME} is already running. pid=${pid} ."
  else
#    is_exist_app
    if [ -e ${APP_NAME} ]; then
       echo "${APP_NAME}已经存在"
     else
       echo "${APP_NAME}不存在，现在开始下载....."
       wget -O ${APP_NAME} $APP_URL
    fi
    chmod a+x $APP_NAME
    nohup java -jar $APP_NAME --spring.profiles.active=${RUN_ENV} --server.port=${SERVER_PORT} >log.txt 2>&1 &
    echo "${APP_NAME}启动中.............."
    sleep 10
    is_restart
    if [ $? -eq "0" ]; then
        echo "${APP_NAME} 已经启动.环境为${RUN_ENV},进程号${newpid} ."
    else
        echo "${APP_NAME}启动失败"
    fi
  fi
}

#停止方法
stop(){
  is_exist
  if [ $? -eq "0" ]; then
   echo "${APP_NAME} is running,stop it now."
    kill -9 $pid
  else
    echo "${APP_NAME} is not running"
  fi
}

#输出运行状态
status(){
  is_exist
  if [ $? -eq "0" ]; then
    echo "${APP_NAME} is running. Pid is ${pid}"
  else
    echo "${APP_NAME} is NOT running."
  fi
}

#重启
restart(){
  stop
  sleep 3
  start
}

#更新应用
update(){
   is_exist_app
   if [ $? -eq "0" ]; then
       echo "Old ${APP_NAME} exists, delete it now."
       rm -rf $APP_NAME
   fi
   restart
}

if [ $# -ge 2 ]; then
    echo "the target env is $2"
    RUN_ENV=$2
  else
    echo "use default env:${RUN_ENV}"
fi

#根据输入参数，选择执行对应方法，不输入则执行使用说明
case "$1" in
  "start")
    start
    ;;
  "stop")
    stop
    ;;
  "status")
    status
    ;;
  "restart")
    restart
    ;;
  "update")
    update
    ;;
  *)
    usage
    ;;
esac
