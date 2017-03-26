#!/bin/sh
#
# /etc/init.d/kibana4_init -- startup script for kibana4
# 2015-02-20; used elasticsearch init script as template
# https://github.com/akabdog/scripts/edit/master/kibana4_init
#
### BEGIN INIT INFO
# Provides:          kibana4_init
# Required-Start:    $network $remote_fs $named
# Required-Stop:     $network $remote_fs $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Starts kibana4_init
# Description:       Starts kibana4_init using start-stop-daemon
### END INIT INFO

#configure this with wherever you unpacked kibana:
KIBANA_BIN={{kibana_home}}/bin

NAME=kibana4
PID_FILE={{kibana_pid_file}}
CONFIG_PATH={{kibana_config_file}}
PATH=/bin:/usr/bin:/sbin:/usr/sbin:$KIBANA_BIN
DAEMON=$KIBANA_BIN/kibana
DESC="Kibana"
USER=nobody
ES_HOST="{{elasticsearch_host_url}}"



case "$1" in
  start)
        echo "Starting $DESC"

        pid=`pidofproc -p $PID_FILE kibana`
        if [ -n "$pid" ] ; then
                echo "Already running."
                echo 0
                exit 0
        fi

        # Check if elasticsearch is up:
        elasticsearchDOWN=true
        timer=1
        # Attempt to start, wait for elasticsearch, if it doesn't complete in 300 seconds (30*10), exit
        while [ "$elasticsearchDOWN" = true ] && [ $timer -lt 10 ]; do
                response=$(curl -sLI "$ES_HOST")

                if [ -z "$response" ]; then
                        echo "Elasticsearch not running, waiting 10 seconds..."
                        sleep 10
		else
                # Start Daemon
                        elasticsearchDOWN=false
                        start-stop-daemon --start --user "$USER" -c "$USER" --pidfile "$PID_FILE" --make-pidfile --background
                        --exec $DAEMON
                        --config {{kibana_config_file}}

                fi
                timer=$((timer+1))
        done
        echo $?
        ;;
  stop)
	echo "Stopping $DESC"

	if [ -f "$PID_FILE" ]; then
		start-stop-daemon --stop --user "$USER" -c "$USER" --pidfile "$PID_FILE" \
			--retry=TERM/20/KILL/5 >/dev/null
		if [ $? -eq 1 ]; then
			echo "$DESC is not running but pid file exists, cleaning up"
		elif [ $? -eq 3 ]; then
			PID="`cat $PID_FILE`"
			log_failure_msg "Failed to stop $DESC (pid $PID)"
			exit 1
		fi
		rm -f "$PID_FILE"
	else
		echo "(not running)"
	fi
	echo 0
	;;
  status)
	status_of_proc -p $PID_FILE kibana kibana && exit 0 || exit $?
    ;;
  restart|force-reload)
	if [ -f "$PID_FILE" ]; then
		$0 stop
		sleep 1
	fi
	$0 start
	;;
  *)
	echo "Usage: $0 {start|stop|restart|force-reload|status}"
	exit 1
	;;
esac

exit 0
