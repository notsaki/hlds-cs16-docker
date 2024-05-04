FROM tsaki/hlds-cs16
LABEL authors=tsaki

ARG LAUNCH_OPTIONS="+sv_lan 0 +map de_dust2 -maxplayers 32"

RUN apt-get install unzip curl wget -y

# Metamod
WORKDIR /opt/hlds/cstrike
RUN mkdir -p addons/metamod
RUN wget https://www.amxmodx.org/release/metamod-1.21.1-am.zip \
    && unzip metamod-bin-1.3.0.131.zip -d . \
    && rm -r example_plugin \
    && rm -r sdk \
    && rm metamod-bin-1.3.0.131.zip

# Backup liblist to make it overridable.
RUN cp liblist.gam liblist.gam.bak
RUN sed -i -E "s/gamedll_linux/\/\/gamedll_linux/g" liblist.gam
RUN echo "\ngamedll_linux \"addons\/metamod\/metamod.so\"" >> liblist.gam

WORKDIR /opt/hlds/cstrike/addons/metamod
ADD plugins.ini .

# AMX Mod X
WORKDIR /opt/hlds/cstrike
RUN curl -sqL https://www.amxmodx.org/amxxdrop/1.10/amxmodx-1.10.0-git5467-base-linux.tar.gz | tar -zxvf - \
    && curl -sqL https://www.amxmodx.org/amxxdrop/1.10/amxmodx-1.10.0-git5467-cstrike-linux.tar.gz | tar -zxvf -

RUN apt-get remove unzip curl wget -y

EXPOSE 27015
EXPOSE 27015/udp
VOLUME /opt/hlds

WORKDIR /opt/hlds

ENTRYPOINT ./hlds_run -game cstrike -strictportbind -ip 0.0.0.0 -port 27015 $LAUNCH_OPTIONS
