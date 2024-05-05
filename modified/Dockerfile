FROM tsaki/hlds-cs16-amxmodx
LABEL authors=tsaki

# Currently not working.

RUN apt-get install unzip unrar-free curl wget -y

# Metamod-r
RUN cd /opt/hlds/cstrike \
    && rm -r ./addons/metamod  \
    && mkdir -p ./addons/metamod

RUN cd /opt/hlds/cstrike \
    && wget https://github.com/theAsmodai/metamod-r/releases/download/1.3.0.149/metamod-bin-1.3.0.149.zip \
    && unzip metamod-bin-1.3.0.149.zip \
    && rm -r example_plugin \
    && rm -r sdk \
    && rm metamod-bin-1.3.0.149.zip

RUN cd /opt/hlds/cstrike \
    && cp liblist.gam.bak liblist.gam \
    && sed -i -E "s/gamedll_linux/\/\/gamedll_linux/g" liblist.gam \
    && echo "gamedll_linux \"addons/metamod/metamod_i386.so\"" >> liblist.gam

# ReHLDS
RUN cd /opt/hlds \
    && wget https://github.com/dreamstalker/rehlds/releases/download/3.13.0.788/rehlds-bin-3.13.0.788.zip \
    && unzip rehlds-bin-3.13.0.788.zip -d ./rehlds \
    && cp -r rehlds/bin/linux32/* . \
    && rm -r rehlds \
    && rm rehlds-bin-3.13.0.788.zip

# ReAPI
RUN cd /opt/hlds/cstrike \
    && wget https://github.com/s1lentq/reapi/releases/download/5.24.0.300/reapi-bin-5.24.0.300.zip \
    && unzip reapi-bin-5.24.0.300.zip -d . \
    && rm reapi-bin-5.24.0.300.zip

# Reunion
RUN mkdir /opt/hlds/cstrike/addons/reunion
ADD reunion_mm_i386.so /opt/hlds/cstrike/addons/reunion/reunion_mm_i386.so

# ReGame DLL
RUN cd /opt/hlds/cstrike/dlls \
    && wget https://github.com/s1lentq/ReGameDLL_CS/releases/download/5.26.0.668/regamedll-bin-5.26.0.668.zip \
    && unzip regamedll-bin-5.26.0.668.zip -d regamedll \
    && mv -f regamedll/bin/linux32/cstrike/dlls/cs.so cs.so \
    && rm -r regamedll \
    && rm regamedll-bin-5.26.0.668.zip

# ReVoice
RUN cd /opt/hlds/cstrike \
    && wget https://github.com/Garey27/revoice-plus/releases/download/v2.1.0/revoice_plus-bin-v2.1.0.zip \
    && unzip revoice_plus-bin-v2.1.0.zip \
    && rm revoice_plus-bin-v2.1.0.zip

# ReAuthCheck
RUN cd /opt/hlds/cstrike \
    && curl -O -J -L https://dev-cs.ru/resources/63/download \
    && unrar reauthcheck_0.1.6.rar \
    && cp -r linux/addons . \
    && rm -r linux \
    && rm -r windows \
    && rm reauthcheck_0.1.6.rar

# ReSemiClip
RUN cd /opt/hlds/cstrike \
    && curl -O -J -L https://dev-cs.ru/resources/71/download \
    && unzip resemiclip-2.4.3.zip \
    && rm resemiclip-2.4.3.zip

# Add Hitbox Fixer
RUN cd /opt/hlds/cstrike \
    && wget https://github.com/Garey27/hitbox_fixer/releases/download/1.1.4/hitbox_fix-bin-1.1.4.zip \
    && unzip hitbox_fix-bin-1.1.4.zip \
    && rm hitbox_fix-bin-1.1.4.zip

# ReChecker
RUN cd /opt/hlds/cstrike/addons \
    && curl -O -J -L https://dev-cs.ru/resources/72/download \
    && unzip rechecker_2_7.zip -d rechecker_data \
    && mv rechecker_data/bin/addons/rechecker . \
    && rm -r rechecker_data \
    && rm rechecker_2_7.zip

# WHBlocker
RUN cd /opt/hlds/cstrike/addons \
    && curl -O -J -L https://dev-cs.ru/resources/76/download \
    && unzip whblocker_1_5_697.zip -d whblocker_data \
    && mv whblocker_data/whblocker_1_5_697/bin/linux whblocker \
    && rm -r whblocker_data \
    && rm whblocker_1_5_697.zip

ADD plugins.ini /opt/hlds/cstrike/addons/metamod/plugins.ini

RUN apt-get remove unzip unrar-free curl wget -y

EXPOSE 27015
EXPOSE 27015/udp
VOLUME /opt/hlds

WORKDIR /opt/hlds

ENTRYPOINT ./hlds_run -game cstrike -strictportbind -ip 0.0.0.0 -port 27015 $LAUNCH_OPTIONS