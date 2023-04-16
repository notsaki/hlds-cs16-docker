FROM debian:stable

ARG LOGIN=anonymous
ARG ADMIN_STEAM_ID

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
RUN echo "linux addons/amxmodx/dlls/amxmodx_mm_i386.so" > plugins.ini \
    && echo "linux addons/reunion/reunion_mm_i386.so" >> plugins.ini \
    && echo "linux addons/VoiceTranscoder/VoiceTranscoder.so" >> plugins.ini \
    && echo "linux addons/reauthcheck/reauthcheck_mm_i386.so" >> plugins.ini \
    && echo "linux addons/rechecker/rechecker_mm_i386.so" >> plugins.ini \
    && echo "linux addons/whblocker/whblocker_mm_i386.so" >> plugins.ini

# AMX Mod X
WORKDIR /opt/hlds/cstrike
RUN curl -sqL https://www.amxmodx.org/amxxdrop/1.10/amxmodx-1.10.0-git5467-base-linux.tar.gz | tar -zxvf - \
    && curl -sqL https://www.amxmodx.org/amxxdrop/1.10/amxmodx-1.10.0-git5467-cstrike-linux.tar.gz | tar -zxvf -

# ReHLDS
WORKDIR /opt/hlds
RUN wget https://github.com/dreamstalker/rehlds/releases/download/3.12.0.780/rehlds-bin-3.12.0.780.zip \
    && unzip rehlds-bin-3.12.0.780.zip -d ./rehlds \
    && cp -r rehlds/bin/linux32 . \
    && rm -r rehlds \
    && rm rehlds-bin-3.12.0.780.zip

# ReAPI
WORKDIR /opt/hlds/cstrike
RUN wget https://github.com/s1lentq/reapi/releases/download/5.22.0.254/reapi-bin-5.22.0.254.zip \
    && unzip reapi-bin-5.22.0.254.zip -d . \
    && rm reapi-bin-5.22.0.254.zip

# Reunion
WORKDIR /opt/hlds/cstrike/addons
RUN mkdir reunion

WORKDIR /opt/hlds/cstrike/addons/reunion
ADD files/reunion_mm_i386.so reunion_mm_i386.so

# ReGame DLL
WORKDIR /opt/hlds/cstrike/dlls
RUN wget https://github.com/s1lentq/ReGameDLL_CS/releases/download/5.21.0.576/regamedll-bin-5.21.0.576.zip \
    && unzip regamedll-bin-5.21.0.576.zip -d regamedll \
    && mv -f regamedll/bin/linux32/cstrike/dlls/cs.so cs.so \
    && rm -r regamedll \
    && rm regamedll-bin-5.21.0.576.zip

# Voice Transcoder
# || true is a fix for the ZIP using backslash separators.
WORKDIR /opt/hlds/cstrike/addons
RUN wget https://github.com/WPMGPRoSToTeMa/VoiceTranscoder/releases/download/v2017rc5/VoiceTranscoder_2017RC5.zip \
    && mkdir VoiceTranscoder \
    && unzip -j VoiceTranscoder_2017RC5.zip -d VoiceTranscoder || true \
    && rm VoiceTranscoder_2017RC5.zip

# ReAuthCheck
WORKDIR /opt/hlds/cstrike
RUN curl -O -J -L https://dev-cs.ru/resources/63/download \
    && unrar reauthcheck_0.1.6.rar \
    && cp -r linux/addons . \
    && rm -r linux \
    && rm -r windows \
    && rm reauthcheck_0.1.6.rar

# ReChecker
WORKDIR /opt/hlds/cstrike/addons
RUN curl -O -J -L https://dev-cs.ru/resources/72/download \
    && unzip rechecker_2_7.zip -d rechecker_data \
    && mv rechecker_data/bin/addons/rechecker . \
    && rm -r rechecker_data \
    && rm rechecker_2_7.zip

# WHBlocker
WORKDIR /opt/hlds/cstrike/addons
RUN curl -O -J -L https://dev-cs.ru/resources/76/download \
    && unzip whblocker_1_5_697.zip -d whblocker_data \
    && mv whblocker_data/whblocker_1_5_697/bin/linux whblocker \
    && rm -r whblocker_data \
    && rm whblocker_1_5_697.zip

# Add admin user
WORKDIR /opt/hlds/cstrike/addons/amxmodx/configs
RUN echo "$ADMIN_STEAM_ID \"abcdefghijklmnopqrstu\" \"ce\"" >> users.ini

RUN apt-get remove -y git unzip curl wget unrar-free

WORKDIR /opt/hlds

EXPOSE 27015
EXPOSE 27015/udp
VOLUME /opt/hlds

ENTRYPOINT ["./hlds_run", "-game", "cstrike", "-ip", "0.0.0.0", "-port", "27015", "+hostname", "-steam", "disabled"]