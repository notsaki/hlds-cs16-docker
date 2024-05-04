FROM tsaki/hlds-cs16
LABEL authors=tsaki

ARG LOGIN=anonymous
ARG LAUNCH_OPTIONS="+sv_lan 0 +map de_dust2 -maxplayers 32"

# Metamod-r
WORKDIR /opt/hlds/cstrike
RUN mkdir -p addons/metamod
RUN wget https://github.com/theAsmodai/metamod-r/releases/download/1.3.0.131/metamod-bin-1.3.0.131.zip \
    && unzip metamod-bin-1.3.0.131.zip -d . \
    && rm -r example_plugin \
    && rm -r sdk \
    && rm metamod-bin-1.3.0.131.zip

RUN sed -i -E "s/gamedll_linux \"dlls\/cs.so\"/\/\/gamedll_linux \"dlls\/cs.so\"/g" liblist.gam
RUN echo "\ngamedll_linux \"addons\/metamod\/metamod_i386.so\"" > liblist.gam

WORKDIR /opt/hlds/cstrike/addons/metamod
ADD plugins.ini .

# AMX Mod X
WORKDIR /opt/hlds/cstrike
RUN curl -sqL https://www.amxmodx.org/amxxdrop/1.10/amxmodx-1.10.0-git5467-base-linux.tar.gz | tar -zxvf - \
    && curl -sqL https://www.amxmodx.org/amxxdrop/1.10/amxmodx-1.10.0-git5467-cstrike-linux.tar.gz | tar -zxvf -

EXPOSE 27015
EXPOSE 27015/udp
VOLUME /opt/hlds

WORKDIR /opt/hlds

ENTRYPOINT ./hlds_run -game cstrike -strictportbind -ip 0.0.0.0 -port 27015 $LAUNCH_OPTIONS
