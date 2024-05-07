FROM debian:stable
LABEL authors=tsaki

ARG LOGIN=anonymous
ARG LAUNCH_OPTIONS="+sv_lan 0 +map de_dust2 -maxplayers 32"

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y git curl lib32stdc++6

# HLDS
RUN mkdir -p /opt/steam \
    && cd /opt/steam \
    && curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

RUN mkdir -p /opt/hlds

# Trick to correctly get all the files.
RUN /opt/steam/steamcmd.sh +force_install_dir /opt/hlds +login $LOGIN +app_update 90 validate +quit || true \
    ; /opt/steam/steamcmd.sh +force_install_dir /opt/hlds +login $LOGIN +app_update 70 validate +quit || true \
    ; /opt/steam/steamcmd.sh +force_install_dir /opt/hlds +login $LOGIN +app_update 10 validate +quit || true \
    ; /opt/steam/steamcmd.sh +force_install_dir /opt/hlds +login $LOGIN +app_update 90 validate +quit || true

RUN cd /opt/hlds  \
    && echo "10" > steam_appid.txt

# dlopen failed trying to load: steamclient.so
RUN mkdir -p /root/.steam \
    && ln -s /opt/steam/linux32 /root/.steam/sdk32

# Add all maps to the map cycle.
ADD mapcycle.txt /opt/hlds/cstrike/mapcycle.txt

RUN apt-get remove -y git curl

EXPOSE 27015
EXPOSE 27015/udp
VOLUME /opt/hlds

WORKDIR /opt/hlds

ENTRYPOINT ./hlds_run -game cstrike -strictportbind -ip 0.0.0.0 -port 27015 $LAUNCH_OPTIONS
