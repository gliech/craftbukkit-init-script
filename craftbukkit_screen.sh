#!/bin/bash -

### BEGIN INIT INFO
# Provides:          craftbukkit
# Required-Start:    $remote_fs $syslog $local_fs $network $time
# Required-Stop:     $remote_fs $syslog $local_fs $network $time
# Should-Start:      $named
# Should-Stop:       $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Manages Craftbukkit
# Description:       Launches and Controls Craftbukkit in the background with the help of GNU screen.
### END INIT INFO

### BEGIN SCRIPT HEADER
# title:             craftbukkit_screen.sh
# description:       Launches and Controls Craftbukkit in the background with the help of GNU screen.
# author:            gliech
# date:              20151008
# notes:             This script has been released to the public domain under http://pastebin.com/tQBm2xWv I only take credit for the changes I made myself.
# bash_version:      4.2.25(1)-release
### END SCRIPT HEADER


### START CONFIGURATION

# Replace the location path with the folder containing your CraftBukkit.jar
# or minecraft_server.jar file
LOCATION="/path/to/server/files"

# Replace CraftBukkit with the name of the .jar file you use
MINECRAFT="CraftBukkit.jar"

MINECRAFTOPTS=""

# Path to your java executable (or just "java" if it's already in your $PATH)
JAVA="java"

# Java Options - Replace with options that are sane and stable for your server
JAVAOPTS="-server -Xms1024M -Xmx1024M"

SCREENNAME="craftbukkit"

SCREENOPTS="-dmS"

USER=""

### END CONFIGURATION


#check for GNU screen installation
if !( hash screen 2>/dev/null )
then
	echo "It seems GNU screen is not installed on the machine. Please install it, if you want to use this script."
	exit 1
fi

#Determine whether or not Minecraft is already running
RUNNING=`screen -ls | grep minecraft`

case "$1" in
	start)
		cd $LOCATION
		if [ "$RUNNING" == "" ]
		then
			$USER screen $SCREENOPTS $SCREENNAME $JAVA $JAVAOPTS -jar $MINECRAFT $MINECRAFTOPTS
		fi
		;;

	stop)
		$USER screen -S $SCREENNAME -p 0 -X stuff `printf "stop\r"`
		;;

	restart)
		$USER screen -S $SCREENNAME -p 0 -X stuff `printf "stop\r"`
		cd $LOCATION
		until [ "$RUNNING" == "" ]
		do
			RUNNING=`screen -ls | grep $SCREENNAME`
		done
		$USER screen $SCREENOPTS $SCREENNAME $JAVA $JAVAOPTS -jar $MINECRAFT $MINECRAFTOPS
		;;

	view)
		$USER screen -x $SCREENNAME
		;;

	sv)
		cd $LOCATION
		if [ "$RUNNING" == "" ]
		then
			$USER screen $SCREENOPTS $SCREENNAME $JAVA $JAVAOPTS -jar $MINECRAFT $MINECRAFTOPS
		fi
		sleep 1
		$USER screen -x $SCREENNAME
		;;		

	*)
		echo "Usage: $0 { start | stop | restart | view | sv (start & view) }"
		;;
esac
exit 0