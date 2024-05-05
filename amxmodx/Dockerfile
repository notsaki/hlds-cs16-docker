FROM tsaki/hlds-cs16
LABEL authors=tsaki

RUN apt-get install unzip curl wget -y

# Metamod
RUN cd /opt/hlds/cstrike \
    && wget https://www.amxmodx.org/release/metamod-1.21.1-am.zip \
    && unzip metamod-1.21.1-am.zip \
    && rm metamod-1.21.1-am.zip

# Backup liblist to make it overridable.
RUN cd /opt/hlds/cstrike  \
    && cp liblist.gam liblist.gam.bak \
    && sed -i -E "s/gamedll_linux/\/\/gamedll_linux/g" liblist.gam \
    && echo "gamedll_linux \"addons/metamod/dlls/metamod.so\"" >> liblist.gam

# AMX Mod X
RUN cd /opt/hlds/cstrike \
    && curl -sqL https://www.amxmodx.org/amxxdrop/1.10/amxmodx-1.10.0-git5467-base-linux.tar.gz | tar -zxvf - \
    && curl -sqL https://www.amxmodx.org/amxxdrop/1.10/amxmodx-1.10.0-git5467-cstrike-linux.tar.gz | tar -zxvf - \
    && rm /opt/hlds/cstrike/addons/amxmodx/ACKNOWLEDGEMENTS.txt \
    && rm /opt/hlds/cstrike/addons/amxmodx/GPLv2.txt \
    && rm /opt/hlds/cstrike/addons/amxmodx/GPLv3.txt \
    && rm /opt/hlds/cstrike/addons/amxmodx/LICENSE.txt

ADD plugins.ini /opt/hlds/cstrike/addons/metamod/plugins.ini

# Add user permissions.
ADD users.ini /opt/hlds/cstrike/addons/amxmodx/configs/users.ini

RUN apt-get remove unzip curl wget -y