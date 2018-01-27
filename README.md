# Counter-Strike 1.6 Dedicated Server Docker Image

## About

This image is based on `debian` and the game server is set up via steamcmd.

## Quick start

``` bash
docker run --name counter-strike_server -p 27015:27015/udp -p 27005:27005/udp -p 27015:27015 -p 27005:27005 -p 1200:1200/udp counter-strike_server
```

## Availibe env

```
PORT 27015
CLIENTPORT 27005
MAP de_dust2
MAXPLAYERS 16
SV_LAN 0
```

## custom config files

You can add you own `server.cfg`, `banned.cfg` and `listip.cfg` by mounting the config directory to your host machine. You can do this by adding a volumes parameter to your docker run command.

``` bash
-v /path/to/your/configs:/configs
```

``` bash
docker run --name counter-strike_server -p 27015:27015/udp -p 27005:27005/udp -p 27015:27015 -p 27005:27005 -p 1200:1200/udp -v /path/to/your/configs:/configs counter-strike_server
```

Keep in mind the server.cfg file can override the settings from your environment variables:
`HOMENAME`, `MAP`, `MAXPLAYERS` and `SV_LAN`

### Example server.cfg

```
// Use this file to configure your DEDICATED server.
// This config file is executed on server start.

// disable autoaim
sv_aim 0

// disable clients' ability to pause the server
pausable 0

// default server name. Change to "Bob's Server", etc.
hostname "Counter-Strike 1.6 Server"

// RCON password
rcon_password "password"

// default map
map de_dust2

// maximum client movement speed
sv_maxspeed 320

// 20 minute timelimit
mp_timelimit 20

// disable cheats
sv_cheats 0

// load ban files
exec listip.cfg
exec banned.cfg
```

## Docker Compose

``` yml
version: '3'

services:

  csserver:
    container_name: counter-strike_server
    image: febley/counter-strike_server:latest
    restart: always
    ports:
      - 27015:27015/udp
      - 27005:27005/udp
      - 27015:27015
      - 27005:27005
      - 1200:1200/udp 
    volumes:
      - /path/to/your/configs:/configs
    environment:
      - PORT=27015
      - CLIENTPORT=27005
      - MAP=de_dust2
      - MAXPLAYERS=16
      - SV_LAN=0
```
