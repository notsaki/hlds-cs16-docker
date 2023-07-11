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

# Compile the plugins.
WORKDIR /opt/hlds/cstrike/addons/amxmodx/scripting
# Replace less with cat to prevent the script from getting stuck.
RUN sed -i "s/less temp.txt/cat temp.txt/g" compile.sh \
    && ./compile.sh stats_pug.sma pimpspug.sma \
    && mv ./compiled/stats_pug.amxx ../plugins/stats_pug.amxx \
    && mv ./compiled/pimpspug.amxx ../plugins/pimpspug.amxx

WORKDIR /opt/hlds/cstrike/addons/amxmodx/configs
RUN echo -e "stats_pug.amxx\n\
pimpspug.amxx" >> plugins.ini

# Add more maps.

# de_cpl_mill
WORKDIR /opt/hlds
RUN wget https://gamebanana.com/dl/317605 \
    && unzip 317605 \
    && rm 317605

# de_russka
WORKDIR /opt/hlds
RUN wget https://gamebanana.com/dl/316613 \
    && unzip 316613 \
    && rm brutesmaps_readme.txt \
    && rm 316613

# de_lite
WORKDIR /opt/hlds/cstrike
RUN wget https://gamebanana.com/dl/298586 \
    && 7za x 298586 \
    && rm 298586

# de_cpl_strike
WORKDIR /opt/hlds
RUN wget https://gamebanana.com/dl/318354 \
    && unzip 318354  \
    && rm 318354

# de_tuscan
WORKDIR /opt/hlds
RUN wget https://gamebanana.com/dl/320703 \
    && unzip 320703 \
    && rm 320703

# Update mapcycle.
WORKDIR /opt/hlds/cstrike
ADD mapcycle.txt .

# Create a map pool over mapcycle.
WORKDIR /opt/hlds/cstrike
RUN cp mapcycle.txt addons/amxmodx/configs/maps.ini

# Add user permissions.
WORKDIR /opt/hlds/cstrike/addons/amxmodx/configs
ADD users.ini .

RUN apt-get remove wget unzip p7zip-full

WORKDIR /opt/hlds
