FROM tsaki/hlds-cs16
LABEL authors="tsaki"

RUN apt-get update && apt-get install -y wget unzip p7zip-full

# Get auto-mix plugin.
WORKDIR /opt/hlds
RUN wget https://forums.alliedmods.net/attachment.php?attachmentid=119170 -O automix.zip \
    && unzip automix.zip -d automix \
    && cp -r automix/Auto-Mix/cstrike . \
    && rm -r automix \
    && rm automix.zip

WORKDIR /opt/hlds/cstrike/addons/amxmodx/scripting
# Replace less with cat to prevent the script from getting stuck.
RUN sed -i "s/less temp.txt/cat temp.txt/g" compile.sh \
    && ./compile.sh stats_pug.sma pimpspug.sma \

WORKDIR /opt/hlds/cstrike/addons/amxmodx/scripting/compiled
RUN mv /stats_pug.amxx ../../plugins/stats_pug.amxx \
    && mv /pimpspug.amxx ../../plugins/pimpspug.amxx

WORKDIR /opt/hlds/cstrike/addons/amxmodx/configs
RUN echo "stats_pug.amxx \
    pimpspug.amxx" >> plugins.ini

# Add more maps.

# de_cpl_mill
WORKDIR /opt/hlds
RUN wget https://gamebanana.com/dl/317605  \
    && unzip 317605  \
    && rm 317605

# de_russka
WORKDIR /opt/hlds
RUN wget https://gamebanana.com/dl/316613  \
    && unzip 316613  \
    && rm brutesmaps_readme.txt \
    && rm 316613

# de_lite
WORKDIR /opt/hlds/cstrike
RUN wget https://gamebanana.com/dl/298586  \
    && 7za x 298586  \
    && rm 298586

# de_cpl_strike
WORKDIR /opt/hlds
RUN wget https://gamebanana.com/dl/318354  \
    && unzip 320703  \
    && rm 320703

# de_tuscan
WORKDIR /opt/hlds
RUN wget https://gamebanana.com/dl/320703  \
    && unzip 320703  \
    && rm 320703

# Update mapcycle.
WORKDIR /opt/hlds/cstrike
RUN echo -e "de_aztec\n\
de_cpl_mill\n\
de_dust\n\
de_dust2\n\
de_inferno\n\
de_lite\n\
de_nuke\n\
de_piranesi\n\
de_russka\n\
de_torn\n\
de_train\n\
de_tuscan\n\
de_vertigo" > mapcycle.txt

# Add all maps to the map pool of the plugin.
WORKDIR /opt/hlds/cstrike
RUN cp mapcycle.txt addons/amxmodx/configs/maps.ini

RUN apt-get remove wget unzip p7zip-full

WORKDIR /opt/hlds
