# Stationeers dedicated server docker image
My attempt at a docker image running Stationeers dedicated server.

⚠️ The game is still in early access and this page might be outdated when you read it. If something doesn't work, check the game wiki (link at the bottom).

## Configuration
If you are pulling the image from dockerhub, do the optional step below. If you are cloning the repository from GitHub, you can skip it.

### (Optional) Pulling from dockerhub
Create a new folder named `stationeers-server`. Move inside and:
- create the folders structure: `mkdir -p data/saves data/mods`
- create the empty `setting` file: `touch data/setting.xml`
- create and edit `docker-compose.yml` and put this content inside:

```yml
version: "3"
services:
  server:
    image: maaarmotte/stationeers-server:latest
    volumes:
      - ./data/saves/:/home/steam/stationeers/saves/
      - ./data/mods/:/home/steam/stationeers/rocketstation_DedicatedServer_Data/StreamingAssets/Data/Mods/
      - ./data/setting.xml:/home/steam/stationeers/setting.xml
    environment:
      - SERVER_IP=0.0.0.0
      - SERVER_PORT=27016
      - SERVER_NAME=Stationeers
      - SERVER_PASSWORD=
      - SERVER_MAXPLAYERS=10
      - SERVER_UPNP=false
      - SERVER_ADMINPASSWORD=asuperstrongpassword
      - SERVER_SAVENAME=default # Load a save or create a new one
      - SERVER_MAP=mars # Map to create if no save exists
    ports:
      - 27016:27016/udp
    stdin_open: true
    tty: true
```

### Editing the config
Open `docker-compose.yml` and edit the `environment` section.

| Variable | Default value | Description |
|----------|---------------|-------------|
| SERVER_IP | 0.0.0.0 | The IP to bind to. Default value should be fine unless there are multiple networking interfaces. |
| SERVER_PORT | 27016 | The port used by the clients to join the server. Do not forget to update the docker mapping if you change it. |
| SERVER_NAME | Stationeers | The display name of the server. |
| SERVER_PASSWORD |  | The password required to join the server. Set to blank to disable password protection. |
| SERVER_MAXPLAYERS | 10 | Maximum number of concurrent players on the server. |
| SERVER_UPNP | false | Enable/disable UPnP, not sure how it is used in this context. Probably not needed for a dedicated server. |
| SERVER_ADMINPASSWORD | asuperstrongpassword | Admin password required to run console commands from the ingame console. |
| SERVER_SAVENAME | default | Name of the save and of the directory that will be created under `saves/`. |
| SERVER_MAP | mars | Map to create if the save doesn't exist yet and a new one is going to be created. |

## Operating the server
### Starting the server
Navigate to root folder and run `docker-compose up -d`.

### Watching the logs
Run `docker logs -f stationeers-server_server_1`. The container name might be different, it should have been printed when starting the container.

### Opening the console
There are two ways to access the console.

#### Attaching to the container
Run `docker attach stationeers-server_server_1` to attach to the container's stdin. The console itself is very glitchy and cannot print correctly. To detach from the container, press `CTRL+P` followed by `CTRL+Q`.

#### Using the ingame console
First, you need to configure your client by adding the `SERVER_ADMINPASSWORD` value you set up in `docker-compose.yml`. Open the file `C:/Users/<username>/Documents/My Games/Stationeers/setting.xml` and add `<ServerAuthSecret>your_admin_password</ServerAuthSecret>` after the `<SettingsVersion>` tag.

Then, start the game and join the server. Open the console by pressing `F3`. You can now send commands to the server by running `serverrun <your_command>`.

### Saving and quitting
The game is saved automatically every 5 minutes. To save manually, run the `save` command if attached to the container or `serverrun save` if using the ingame console.

To stop the server, navigate to the root folder and run `docker-compose stop`. If you want to remove the container and network that were created, run `docker-compose down` (this won't erase save files).

You can also stop it by running `serverrun quit` directly in the ingame console.

**WARNING**: the game is not saved automatically when the server is stopped! Do not forget to save!

### Data storage
The saves are stored in `data/saves` folder. The settings are stored in `data/setting.xml` file. Make sure that the `data` folder is readable and writable by user with uid 1000. If you are having permissions issue, you can update the permissions by running `chmod -R 777 data` to make the folder readable and writable by all users in the system.

### Networking
By default you need to forward port `27016` for `UDP` protocol. Don't forget to update the port mapping in `docker-compose.yml` if you update `SERVER_PORT`!

### Game difficulty
To change game difficulty, you need to:
 - start the server
 - wait for the save to be created in `data/saves`
 - stop the server
 - edit the `<DifficultySetting>` tag in `data/saves/<save_name>/worldsettings.xml`
 - start the server

Here's an example to set the difficulty to `Easy`:
```xml
<DifficultySetting>
    <Name>Easy</Name>
    <Description>A more relaxed game, with lower oxygen, food and water usage. You will survive longer in toxic environments. Respawning is no issue.</Description>
    <HungerRate>0.5</HungerRate>
    <HydrationRate>0.5</HydrationRate>
    <OxygenRate>1</OxygenRate>
    <LungDamageRate>0.02</LungDamageRate>
    <LifeFunctionLoggedOut>0</LifeFunctionLoggedOut>
    <EatWhileHelmetClosed>true</EatWhileHelmetClosed>
    <DrinkWhileHelmetClosed>true</DrinkWhileHelmetClosed>
    <StartingCondition>Default</StartingCondition>
    <RespawnCondition>Easy</RespawnCondition>
  </DifficultySetting>
```
Tip: to find the values for the different difficulty settings, create a singleplayer game and check the values in the `worldsettings.xml` for that game.

## Resources
Game wiki: https://stationeers-wiki.com/Dedicated_Server_Guide
