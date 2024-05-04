FROM debian:stable
LABEL authors=tsaki

ARG LOGIN=anonymous
ARG LAUNCH_OPTIONS="+sv_lan 0 +map de_dust2 -maxplayers 32"

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y git lib32stdc++6

# HLDS
RUN mkdir -p /opt/steam

WORKDIR /opt/steam
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

RUN mkdir -p /opt/hlds

WORKDIR /opt/steam
# Trick to correctly get all the files.
RUN ./steamcmd.sh +force_install_dir /opt/hlds +login $LOGIN +app_update 90 validate +quit || true; \
    ./steamcmd.sh +force_install_dir /opt/hlds +login $LOGIN +app_update 70 validate +quit || true; \
    ./steamcmd.sh +force_install_dir /opt/hlds +login $LOGIN +app_update 10 validate +quit || true; \
    ./steamcmd.sh +force_install_dir /opt/hlds +login $LOGIN +app_update 90 validate +quit || true

WORKDIR /opt/hlds
RUN echo "10" > steam_appid.txt

# dlopen failed trying to load: steamclient.so
RUN mkdir -p /root/.steam
RUN ln -s /opt/steam/linux32 /root/.steam/sdk32

# Add user permissions.
ADD files/users.ini /opt/hlds/cstrike/addons/amxmodx/configs

# Add all maps to the map cycle.
WORKDIR /opt/hlds/cstrike
ADD files/mapcycle.txt mapcycle.txt

RUN apt-get remove -y git

EXPOSE 27015
EXPOSE 27015/udp
VOLUME /opt/hlds

WORKDIR /opt/hlds

ENTRYPOINT ./hlds_run -game cstrike -strictportbind -ip 0.0.0.0 -port 27015 $LAUNCH_OPTIONS
