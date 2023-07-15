#!/bin/bash

# Update the server
steamcmd +force_install_dir /home/steam/stationeers +login anonymous +app_update 600760 validate +quit

# Needed to solve ArgumentOutOfRangeException in System.TermInfoDriver.SetCursorPosition
stty cols 80
stty rows 24

# Run the server
/home/steam/stationeers/rocketstation_DedicatedServer.x86_64 -settings \
	LocalIpAddress "$SERVER_IP" \
	GamePort "$SERVER_PORT" \
	ServerName "$SERVER_NAME" \
	ServerPassword "$SERVER_PASSWORD" \
	ServerMaxPlayers "$SERVER_MAXPLAYERS" \
	UPNPEnabled "$SERVER_UPNP" \
	ServerAuthSecret "$SERVER_ADMINPASSWORD" \
	-load "$SERVER_SAVENAME" "$SERVER_MAP";

