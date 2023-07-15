FROM steamcmd/steamcmd:latest

# Create a new user
RUN useradd -ms /bin/bash steam
WORKDIR /home/steam
USER steam

# Server setup
RUN mkdir -p ./stationeers/rocketstation_DedicatedServer_Data/StreamingAssets/Data/Mods/
ADD --chown=steam:steam scripts/entrypoint.sh entrypoint.sh

# Server configuration
ENV SERVER_IP="0.0.0.0" \
    SERVER_PORT="27016" \
    SERVER_NAME="Stationeers" \
    SERVER_PASSWORD="astrongpassword" \
    SERVER_MAXPLAYERS="10" \
    SERVER_UPNP="false" \
    SERVER_ADMINPASSWORD="asuperstrongpassword" \
    SERVER_SAVENAME="default" \
    SERVER_MAP="mars"

# We need to start as root or some scripts from steamcmd image will fail
USER root
ENTRYPOINT ["su", "steam", "-", "/home/steam/entrypoint.sh"]
