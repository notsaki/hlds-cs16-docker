FROM debian:stable

ARG LOGIN=anonymous

ENV OPT=/opt

ENV STEAM_DIR=$OPT/steam
ENV HLDS_DIR=$OPT/hlds
ENV CSTRIKE_DIR=$HLDS_DIR/cstrike
ENV ADDONS_DIR=$CSTRIKE_DIR/addons
ENV AMXMODX_DIR=$ADDONS_DIR/amxmodx
ENV METAMOD_DIR=$CSTRIKE_DIR/addons/metamod
ENV STEAM_HOME=~/.steam

ENV STEAMCMD=$STEAM_DIR/steamcmd.sh

RUN apt-get update && apt-get install -y unzip curl lib32gcc-s1

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

# Metamod
RUN mkdir -p $METAMOD_DIR/dlls
RUN curl -o metamod.zip https://www.amxmodx.org/release/metamod-1.21.1-am.zip \
    && unzip metamod.zip -d $CSTRIKE_DIR \
    && rm metamod.zip

RUN sed -i -E "s/gamedll_linux \"dlls\/cs.so\"/gamedll_linux \"addons\/metamod\/dlls\/metamod_i386.so\"/g" $CSTRIKE_DIR/liblist.gam

RUN echo "linux addons/amxmodx/dlls/amxmodx_mm_i386.so" > $METAMOD_DIR/plugins.ini
RUN echo "linux addons/dproto/dproto_i386.so" >> $METAMOD_DIR/plugins.ini

# Dproto
RUN curl -o dproto.zip https://www.amxmod.net/forum/attachment.php?aid=1452 \
    && unzip dproto.zip -d $CSTRIKE_DIR \
    && rm dproto.zip
#    && rm 'IMPORTANT - Please install & use AMX Mod from amxmod.net!.txt' \
#    && rm 'dproto - Readme.txt'

# AMX Mod X
RUN cd $CSTRIKE_DIR \
    && curl -sqL https://www.amxmodx.org/release/amxmodx-1.8.2-base-linux.tar.gz | tar -zxvf - \
    && curl -sqL https://www.amxmodx.org/release/amxmodx-1.8.2-cstrike-linux.tar.gz | tar -zxvf -

RUN apt remove -y unzip curl

VOLUME $HLDS_DIR
WORKDIR $HLDS_DIR
EXPOSE 27015

ENTRYPOINT ["./hlds_run"]