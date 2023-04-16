FROM debian:stable

ARG LOGIN=anonymous
ARG ADMIN_STEAM_ID

ENV OPT=/opt

ENV STEAM_DIR=$OPT/steam
ENV HLDS_DIR=$OPT/hlds
ENV CSTRIKE_DIR=$HLDS_DIR/cstrike
ENV ADDONS_DIR=$CSTRIKE_DIR/addons
ENV AMXMODX_DIR=$ADDONS_DIR/amxmodx
ENV METAMOD_DIR=$ADDONS_DIR/metamod
ENV DPROTO_DIR=$ADDONS_DIR/dproto
ENV HOME_SDK_DIR=/root/.steam/sdk32

ENV STEAMCMD=$STEAM_DIR/steamcmd.sh

RUN apt-get update && apt-get install -y git unzip curl lib32gcc-s1

# HLDS
RUN mkdir -p $STEAM_DIR \
    && cd $STEAM_DIR \
    && curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

RUN mkdir -p $HLDS_DIR

RUN $STEAMCMD +force_install_dir $HLDS_DIR +login $LOGIN +app_update 90 validate +quit || :
RUN $STEAMCMD +force_install_dir $HLDS_DIR +login $LOGIN +app_update 70 validate +quit || :
RUN $STEAMCMD +force_install_dir $HLDS_DIR +login $LOGIN +app_update 10 validate +quit || :
RUN $STEAMCMD +force_install_dir $HLDS_DIR +login $LOGIN +app_update 90 validate +quit || :

RUN echo "10" > $HLDS_DIR/steam_appid.txt

# dlopen failed trying to load: steamclient.so
RUN mkdir -p $HOME_SDK_DIR \
    && cp $STEAM_DIR/linux32/steamclient.so $HOME_SDK_DIR/steamclient.so

# Metamod
RUN mkdir -p $METAMOD_DIR/dlls
RUN curl -o metamod.zip https://www.amxmodx.org/release/metamod-1.21.1-am.zip \
    && unzip metamod.zip -d $CSTRIKE_DIR \
    && rm metamod.zip

RUN sed -i -E "s/gamedll_linux \"dlls\/cs.so\"/gamedll_linux \"addons\/metamod\/dlls\/metamod_i386.so\"/g" $CSTRIKE_DIR/liblist.gam

RUN echo "linux addons/amxmodx/dlls/amxmodx_mm_i386.so" > $METAMOD_DIR/plugins.ini
RUN echo "linux addons/dproto/dproto_i386.so" >> $METAMOD_DIR/plugins.ini

# Dproto
RUN git clone https://github.com/BloodSharp/dproto-0.4.8p.git \
    && mkdir -p $DPROTO_DIR \
    && cp dproto-0.4.8p/bin/Linux/dproto_i386.so $DPROTO_DIR/dproto_i386.so \
    && cp dproto-0.4.8p/dproto.cfg $CSTRIKE_DIR/dproto.cfg \
    && rm -r dproto-0.4.8p

# AMX Mod X
RUN cd $CSTRIKE_DIR \
    && curl -sqL https://www.amxmodx.org/release/amxmodx-1.8.2-base-linux.tar.gz | tar -zxvf - \
    && curl -sqL https://www.amxmodx.org/release/amxmodx-1.8.2-cstrike-linux.tar.gz | tar -zxvf -

# Add admin user
RUN echo "$ADMIN_STEAM_ID \"abcdefghijklmnopqrstu\" \"ce\"" >> $AMXMODX_DIR/configs/users.ini

RUN apt remove -y unzip curl

VOLUME $HLDS_DIR
WORKDIR $HLDS_DIR
EXPOSE 27015

ENTRYPOINT ["./hlds_run", "-game", "cstrike", "-port", "27015", "-map", "de_dust2", "+hostname", "-steam", "disabled"]
