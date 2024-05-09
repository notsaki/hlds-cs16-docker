FROM tsaki/hlds-cs16-amxmodx
LABEL authors=tsaki

RUN apt-get update && apt-get install -y wget unzip p7zip-full

# Get auto-mix plugin.
RUN cd /opt/hlds \
    && wget https://forums.alliedmods.net/attachment.php?attachmentid=119170 -O automix.zip \
    && unzip automix.zip -d automix \
    && cp -r automix/Auto-Mix/cstrike . \
    && rm -r automix \
    && rm automix.zip

# Compile the plugins.
# Replace less with cat to prevent the script from getting stuck.
RUN cd /opt/hlds/cstrike/addons/amxmodx/scripting \
    && sed -i "s/less temp.txt/cat temp.txt/g" compile.sh \
    && ./compile.sh stats_pug.sma pimpspug.sma \
    && mv ./compiled/stats_pug.amxx ../plugins/stats_pug.amxx \
    && mv ./compiled/pimpspug.amxx ../plugins/pimpspug.amxx

ADD plugins.ini /opt/hlds/cstrike/addons/amxmodx/configs/plugins.ini

# Add more maps.

# de_cpl_mill
RUN cd /opt/hlds \
    && wget https://gamebanana.com/dl/317605 \
    && unzip 317605 \
    && rm 317605

# de_russka
RUN cd /opt/hlds \
    && wget https://gamebanana.com/dl/316613 \
    && unzip 316613 \
    && rm brutesmaps_readme.txt \
    && rm 316613

# de_lite
RUN cd /opt/hlds/cstrike \
    && wget https://gamebanana.com/dl/298586 \
    && 7za x 298586 \
    && rm 298586

# de_cpl_strike
RUN cd /opt/hlds \
    && wget https://gamebanana.com/dl/318354 \
    && unzip 318354  \
    && rm 318354

# de_tuscan
RUN cd /opt/hlds \
    && wget https://gamebanana.com/dl/320703 \
    && unzip 320703 \
    && rm 320703

# Update mapcycle.
ADD mapcycle.txt /opt/hlds/cstrike/mapcycle.txt

# Create a map pool over mapcycle.
RUN cp /opt/hlds/cstrike/mapcycle.txt /opt/hlds/addons/amxmodx/configs/maps.ini

RUN apt-get remove wget unzip p7zip-full