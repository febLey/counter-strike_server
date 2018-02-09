FROM debian:9

# labels
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/febLey/counter-strike_server"

# define default env variables
ENV PORT 27015
ENV MAP de_dust2
ENV MAXPLAYERS 16
ENV SV_LAN 0

# install dependencies
RUN dpkg --add-architecture i386
RUN apt-get update && \
    apt-get -qqy install lib32gcc1 curl

# create directories
WORKDIR /root
RUN mkdir Steam .steam

# download steamcmd
WORKDIR /root/Steam
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# install CS 1.6 via steamcmd
RUN ./steamcmd.sh +login anonymous +force_install_dir /hlds +app_update 90 validate +quit || true
RUN ./steamcmd.sh +login anonymous +app_update 70 validate +quit || true
RUN ./steamcmd.sh +login anonymous +app_update 10 validate +quit || true
RUN ./steamcmd.sh +login anonymous +force_install_dir /hlds +app_update 90 validate +quit

# link sdk
WORKDIR /root/.steam
RUN ln -s ../Steam/linux32 sdk32

# start server
WORKDIR /hlds
ENTRYPOINT ./hlds_run -game cstrike -strictportbind -ip 0.0.0.0 -port $PORT +sv_lan $SV_LAN +map $MAP -maxplayers $MAXPLAYERS
