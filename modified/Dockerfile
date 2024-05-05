FROM tsaki/hlds-cs16-amxmodx
LABEL authors=tsaki

# Currently not working.

RUN apt-get install unzip unrar-free curl wget -y

# Metamod-r
RUN cd /opt/hlds/cstrike \
    && rm -r ./addons/metamod  \
    && mkdir -p ./addons/metamod

RUN cd /opt/hlds/cstrike \
    && wget https://github.com/theAsmodai/metamod-r/releases/download/1.3.0.131/metamod-bin-1.3.0.131.zip \
    && unzip metamod-bin-1.3.0.131.zip \
    && rm -r example_plugin \
    && rm -r sdk \
    && rm metamod-bin-1.3.0.131.zip

RUN cd /opt/hlds/cstrike \
    && cp liblist.gam.bak liblist.gam \
    && sed -i -E "s/gamedll_linux/\/\/gamedll_linux/g" liblist.gam \
    && echo "gamedll_linux \"addons/metamod/metamod_i386.so\"" >> liblist.gam

# ReHLDS
RUN cd /opt/hlds \
    && wget https://github.com/dreamstalker/rehlds/releases/download/3.12.0.780/rehlds-bin-3.12.0.780.zip \
    && unzip rehlds-bin-3.12.0.780.zip -d ./rehlds \
    && cp -r rehlds/bin/linux32/* . \
    && rm -r rehlds \
    && rm rehlds-bin-3.12.0.780.zip

# ReAPI
RUN cd /opt/hlds/cstrike \
    && wget https://github.com/s1lentq/reapi/releases/download/5.22.0.254/reapi-bin-5.22.0.254.zip \
    && unzip reapi-bin-5.22.0.254.zip -d . \
    && rm reapi-bin-5.22.0.254.zip

# Reunion
RUN mkdir /opt/hlds/cstrike/addons/reunion
ADD reunion_mm_i386.so /opt/hlds/cstrike/addons/reunion/reunion_mm_i386.so

# ReGame DLL
RUN cd /opt/hlds/cstrike/dlls \
    && wget https://github.com/s1lentq/ReGameDLL_CS/releases/download/5.21.0.576/regamedll-bin-5.21.0.576.zip \
    && unzip regamedll-bin-5.21.0.576.zip -d regamedll \
    && mv -f regamedll/bin/linux32/cstrike/dlls/cs.so cs.so \
    && rm -r regamedll \
    && rm regamedll-bin-5.21.0.576.zip

# Voice Transcoder
# || true is a fix for the ZIP using backslash separators causing a non-zero exit code.
RUN cd /opt/hlds/cstrike/addons \
    && wget https://github.com/WPMGPRoSToTeMa/VoiceTranscoder/releases/download/v2017rc5/VoiceTranscoder_2017RC5.zip \
    && mkdir VoiceTranscoder \
    && unzip -j VoiceTranscoder_2017RC5.zip -d VoiceTranscoder || true \
    && rm VoiceTranscoder_2017RC5.zip

# ReAuthCheck
RUN cd /opt/hlds/cstrike \
    && curl -O -J -L https://dev-cs.ru/resources/63/download \
    && unrar reauthcheck_0.1.6.rar \
    && cp -r linux/addons . \
    && rm -r linux \
    && rm -r windows \
    && rm reauthcheck_0.1.6.rar

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