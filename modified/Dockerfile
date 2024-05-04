FROM tsaki/hlds-cs16-amxmodx
LABEL authors=tsaki

# ReHLDS
WORKDIR /opt/hlds
RUN wget https://github.com/dreamstalker/rehlds/releases/download/3.12.0.780/rehlds-bin-3.12.0.780.zip \
    && unzip rehlds-bin-3.12.0.780.zip -d ./rehlds \
    && cp -r rehlds/bin/linux32/* . \
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
# || true is a fix for the ZIP using backslash separators causing a non-zero exit code.
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

EXPOSE 27015
EXPOSE 27015/udp
VOLUME /opt/hlds

WORKDIR /opt/hlds

ENTRYPOINT ./hlds_run -game cstrike -strictportbind -ip 0.0.0.0 -port 27015 $LAUNCH_OPTIONS