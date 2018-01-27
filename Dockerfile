FROM debian

# define default env variables
ENV PORT 27015
ENV CLIENTPORT 27005
ENV MAP de_dust2
ENV MAXPLAYERS 16
ENV SV_LAN 0

# install dependencies
RUN dpkg --add-architecture i386
RUN apt-get update && \
    apt-get -qqy install lib32gcc1 curl

# create configs directory
RUN mkdir configs

# create user
RUN useradd -m server
RUN chown server /configs
USER server

# create directories
WORKDIR /home/server
RUN mkdir Steam .steam

# download steamcmd
WORKDIR /home/server/Steam
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# install CS 1.6 via steamcmd
RUN ./steamcmd.sh +login anonymous +app_update 90 validate +quit || true
RUN ./steamcmd.sh +login anonymous +app_update 70 validate +quit || true
RUN ./steamcmd.sh +login anonymous +app_update 10 validate +quit || true
RUN ./steamcmd.sh +login anonymous +app_update 90 validate +quit || true

# link sdk
WORKDIR /home/server/.steam
RUN ln -s ../Steam/linux32 sdk32

# link configs
WORKDIR /home/server/Steam/steamapps/common/Half-Life/cstrike
RUN mv server.cfg /configs/ && \
    touch /configs/listip.cfg && \
    touch /configs/banned.cfg && \
    touch /configs/mapcycle.txt &&\
    ln -s /configs/server.cfg && \
    ln -s /configs/listip.cfg && \
    ln -s /configs/banned.cfg && \
    ln -s /configs/mapcycle.txt

# expose ports
EXPOSE $PORT/udp
EXPOSE $CLIENTPORT/udp
EXPOSE 1200/udp
EXPOSE $PORT
EXPOSE $CLIENTPORT

# start server
WORKDIR /home/server/Steam/steamapps/common/Half-Life
ENTRYPOINT ./hlds_run -game cstrike -strictportbind -ip 0.0.0.0 -port $PORT +clientport $CLIENTPORT +sv_lan $SV_LAN +map $MAP -maxplayers $MAXPLAYERS
