FROM debian:stable
LABEL authors=tsaki

ARG LOGIN=anonymous
ARG LAUNCH_OPTIONS="+sv_lan 0 +map de_dust2 -maxplayers 32"

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y git unzip unrar-free curl wget lib32gcc-s1

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

# Metamod-r
WORKDIR /opt/hlds/cstrike
RUN mkdir -p addons/metamod
RUN wget https://github.com/theAsmodai/metamod-r/releases/download/1.3.0.131/metamod-bin-1.3.0.131.zip \
    && unzip metamod-bin-1.3.0.131.zip -d . \
    && rm -r example_plugin \
    && rm -r sdk \
    && rm metamod-bin-1.3.0.131.zip

RUN sed -i -E "s/gamedll_linux \"dlls\/cs.so\"/gamedll_linux \"addons\/metamod\/metamod_i386.so\"/g" liblist.gam

WORKDIR /opt/hlds/cstrike/addons/metamod
ADD plugins.ini .

# AMX Mod X
WORKDIR /opt/hlds/cstrike
RUN curl -sqL https://www.amxmodx.org/amxxdrop/1.10/amxmodx-1.10.0-git5467-base-linux.tar.gz | tar -zxvf - \
    && curl -sqL https://www.amxmodx.org/amxxdrop/1.10/amxmodx-1.10.0-git5467-cstrike-linux.tar.gz | tar -zxvf -

# Add user permissions.
ADD files/users.ini /opt/hlds/cstrike/addons/amxmodx/configs

# Add all maps to the map cycle.
WORKDIR /opt/hlds/cstrike
ADD files/mapcycle.txt mapcycle.txt

RUN apt-get remove -y git unzip curl wget unrar-free

EXPOSE 27015
EXPOSE 27015/udp
VOLUME /opt/hlds

WORKDIR /opt/hlds

ENTRYPOINT ./hlds_run -game cstrike -strictportbind -ip 0.0.0.0 -port 27015 $LAUNCH_OPTIONS
