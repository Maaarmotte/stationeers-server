# Stationeers dedicated server docker image
My attempt at a docker image running Stationeers dedicated server.

## Configuration
Open `docker-compose.yml` and edit the `environment` section. Check the [Environment variable](#environment-variables) section below.

## Starting the server
Navigate to root folder and run `docker-compose up -d`.

## Watching the logs
Run `docker logs -f stationeers_server_1`. The container name might be different, it should have been printed when starting the container.

## Opening the console
There are two ways to access the console.

### Attaching to the container
Run `docker attach stationeers_server_1` to attach to the container's stdin. The console itself is very glitchy and cannot print correctly. To detach from the container, press `CTRL+P` followed by `CTRL+Q`.

### Using the ingame console
First, you need to configure your client by adding the `SERVER_ADMINPASSWORD` value you set up in `docker-compose.yml`. Open the file `C:/Users/<username>/Documents/My Games/Stationeers/setting.xml` and add `<ServerAuthSecret>your_admin_password</ServerAuthSecret>` after the `<SettingsVersion>` tag.

Then, start the game and join the server. Open the console by pressing `F3`. You can now send commands to the server by running `serverrun <your_command>`.

## Saving and quitting
The game is saved automatically every 5 minutes. To save manually, run the `save` command if attached to the container or `serverrun save` if using the ingame console.

To stop the server, navigate to the root folder and run `docker-compose stop`. If you want to remove the container and network that were created, run `docker-compose down` (this won't erase save files).

**WARNING**: the game is not saved automatically when the server is stopped! Do not forget to save!

## Data storage
The saves are stored in `data/saves` folder. The setting are stored in `data/setting.xml` file. Make sure that data folder is readable and writable by user with uid 1000. If you are having permissions issue, you can update the permissions by running `chmod -R 777 data` to make the folder readable and writable by all users in the system.

## Networking
By default you need to forward port `27016` for `UDP` protocol. Don't forget to update the port mapping in `docker-compose.yml` if you update `SERVER_PORT`!

## Environment variables

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

## Resources
Game wiki: https://stationeers-wiki.com/Dedicated_Server_Guide
