FROM febley/counter-strike_server:latest

ARG ADMIN_STEAM_ID

ENV HLDS_DIR=/hlds
ENV CSTRIKE_DIR=$HLDS_DIR/cstrike
ENV ADDONS_DIR=$CSTRIKE_DIR/addons
ENV AMXMODX_DIR=$ADDONS_DIR/amxmodx
ENV METAMOD_DIR=$ADDONS_DIR/metamod
ENV DPROTO_DIR=$ADDONS_DIR/dproto
ENV HOME_SDK_DIR=/root/.steam/sdk32

ENV STEAMCMD=$STEAM_DIR/steamcmd.sh

RUN apt-get update && apt-get install -y git unzip curl

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

RUN apt-get remove -y git unzip curl