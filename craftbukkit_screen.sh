#!/bin/sh
# Controls the minecraft server

#####################
#START CONFIGURATION#
#####################

# Replace the location path with the folder containing your CraftBukkit.jar or minecraft_server.jar file
LOCATION="/home/username/minecraft"

#Replace CraftBukkit with the name of the .jar file you use
MINECRAFT="CraftBukkit.jar"

# Path to your java executable (or just "java" if it's already in your $PATH)
JAVA="java"

#Java Options - Replace with options that are sane and stable for your server
JAVAOPTS="-server -jar"

###################
#END CONFIGURATION#
###################

#Determine whether or not Minecraft is already running
RUNNING=`screen -ls | grep minecraft`

case "$1" in
'start')
	cd $LOCATION
	RUNNING=`screen -ls | grep minecraft`
	if [ "$RUNNING" = "" ]
	then
		screen -dmS minecraft $JAVA $JAVAOPTS $MINECRAFT nogui
	fi
	;;
'stop')
	screen -x minecraft -X stuff "`printf "kickall Restarting server!  Try again in 60 seconds!\r"`"
	sleep 2
	screen -x minecraft -X stuff `printf "stop\r"`
	;;

'restart')
	screen -x minecraft -X stuff "`printf "kickall Restarting server!  Try again in 60 seconds!\r"`"
	sleep 2
	screen -x minecraft -X stuff `printf "stop\r"`
	RUNNING=`screen -ls | grep minecraft`
	cd $LOCATION
	until [ "$RUNNING" = "" ]
	do
		RUNNING=`screen -ls | grep minecraft`
	done
	screen -dmS minecraft $JAVA $JAVAOPTS $MINECRAFT nogui
        sleep 1
        screen -x minecraft
	;;

'view')
	screen -x minecraft
	;;

'sv')
	cd $LOCATION
	if [ "$RUNNING" = "" ]
	then
		screen -dmS minecraft $JAVA $JAVAOPTS $MINECRAFT nogui
	fi
	sleep 1
	screen -x minecraft
	;;	

*)
	echo "Usage: $0 { start | stop | restart | view | sv (start & view) }"
	;;
esac
exit 0