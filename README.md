# Stationeers dedicated server
My attempt at a docker image running Stationeers dedicated server

## Configuration
Open `docker-compose.yml` and edit the `environment` section.

## Starting the server
Navigate to root folder and run `docker-compose up -d`.

## Watching the logs
Run `docker logs -f stationeers_server_1`. The container name might be different, it should have been printed when starting the container.

## Opening the console
There are two ways to access the console.

### Attaching to the container
Run `docker attach stationeers_server_1` to attach to the container's stdin. The console itself is very glitchy and cannot print correctly. To detach from the container, press `CTRL+P` followed by `CTRL+Q`.

### Using the ingame console
First, you need to configure your client by adding the `SERVER_ADMINPASSWORD` value you set up in `docker-compose.yml`. Open the file `C:/Users/<username>/Documents/My Games/Stationeers/setting.xml` and add `<ServerAuthSecret>your_admin_password</ServerAuthSecret>` below the `<SettingsVersion>` tag.

Then, start the game and join the server. Open the console by pressing `F3`. You can now send commands to the server by running `serverrun <your_command>`.

## Saving and quitting
The game is saved automatically every 5 minutes. To save manually, run the command `save` if attached to the container or `serverrun save` if using the ingame console.

To stop the server, navigate to the root folder and run `docker-compose stop`. If you want to remove the container and network that were created, run `docker-compose down` (this won't erase save files).

**WARNING**: the game is not saved automatically when stopping the server! Do not forget to save manually!

## Data storage
The saves are stored in `data/saves` folder. The setting are stored in `data/setting.xml` file. Make sure that data folder is readble and writable by user with uid 1000. If you are having permissions issue, you can update the permissions by running `chmod -R 777 data` to make the folder readble and writable by all users on the system.

## Networking
By default you need to forward port `27016` for `UDP` protocol. Don't forget to update the port mapping in `docker-compose.yml` if you update `SERVER_PORT`!

## Resources
Game wiki: https://stationeers-wiki.com/Dedicated_Server_Guide
