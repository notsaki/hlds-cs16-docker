FROM debian:stable

ARG LOGIN=anonymous
ARG ADMIN_STEAM_ID

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y git unzip curl wget lib32gcc-s1

# HLDS
RUN mkdir -p /opt/steam

WORKDIR /opt/steam
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

RUN mkdir -p /opt/hlds

WORKDIR /opt/steam
# Trick to correctly get all the files.
RUN ./steamcmd.sh +force_install_dir /opt/hlds +login $LOGIN +app_update 90 validate +quit || true
RUN ./steamcmd.sh +force_install_dir /opt/hlds +login $LOGIN +app_update 70 validate +quit || true
RUN ./steamcmd.sh +force_install_dir /opt/hlds +login $LOGIN +app_update 10 validate +quit || true
RUN ./steamcmd.sh +force_install_dir /opt/hlds +login $LOGIN +app_update 90 validate +quit || true

WORKDIR /opt/hlds
RUN echo "10" > steam_appid.txt

# dlopen failed trying to load: steamclient.so
RUN mkdir -p /root/.steam
RUN ln -s /opt/steam/linux32 /root/.steam/sdk32

# Metamod-r
WORKDIR /opt/hlds/cstrike
RUN mkdir -p addons/metamod/dlls
RUN wget https://github.com/theAsmodai/metamod-r/releases/download/1.3.0.131/metamod-bin-1.3.0.131.zip \
    && unzip metamod-1.21.1-am.zip -d . \
    && rm -r example_plugin \
    && rm -r sdk \
    && rm metamod-1.21.1-am.zip

RUN sed -i -E "s/gamedll_linux \"dlls\/cs.so\"/gamedll_linux \"addons\/metamod\/dlls\/metamod_i386.so\"/g" liblist.gam

WORKDIR /opt/hlds/cstrike/addons/metamod
RUN echo "linux addons/amxmodx/dlls/amxmodx_mm_i386.so" > plugins.ini
RUN echo "linux addons/vtc/vtc.so" >> plugins.ini

# AMX Mod X
WORKDIR /opt/hlds/cstrike
RUN curl -sqL https://www.amxmodx.org/release/amxmodx-1.8.2-base-linux.tar.gz | tar -zxvf - \
    && curl -sqL https://www.amxmodx.org/release/amxmodx-1.8.2-cstrike-linux.tar.gz | tar -zxvf -

# ReHLDS
WORKDIR /opt/hlds
RUN wget https://github.com/dreamstalker/rehlds/releases/download/3.12.0.780/rehlds-bin-3.12.0.780.zip \
    && unzip rehlds-bin-3.12.0.780.zip -d ./rehlds \
    && cp -r rehlds/bin/linux32 . \
    && rm -r rehlds \
    && rm rehlds-bin-3.12.0.780.zip

# Add admin user
WORKDIR /opt/hlds/cstrike/addons/amxmodx/configs
RUN echo "$ADMIN_STEAM_ID \"abcdefghijklmnopqrstu\" \"ce\"" >> users.ini

# Voice Transcoder
WORKDIR /opt/hlds/cstrike
RUN wget https://github.com/WPMGPRoSToTeMa/VoiceTranscoder/releases/download/v2017rc5/VoiceTranscoder_2017RC5.zip \
    && unzip VoiceTranscoder_2017RC5.zip -d . \
    && rm VoiceTranscoder_2017RC5.zip

RUN apt-get remove -y git unzip curl wget

WORKDIR /opt/hlds

EXPOSE 27015
EXPOSE 27015/udp
VOLUME /opt/hlds

ENTRYPOINT ["./hlds_run", "-game", "cstrike", "-ip", "0.0.0.0", "-port", "27015", "+hostname", "-steam", "disabled"]