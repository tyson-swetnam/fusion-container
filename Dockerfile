FROM ubuntu:16.04
LABEL maintainer="Stefan Kombrink <stefan.kombrink@uni-ulm.de>"
LABEL version="1.0"

ENTRYPOINT [ "/singularity" ]

RUN mkdir -p /APPS /PROFILES
RUN chmod 0777 /APPS /PROFILES
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get -y install wget less vim software-properties-common python3-software-properties apt-transport-https winbind
RUN wget https://dl.winehq.org/wine-builds/Release.key
RUN apt-key add Release.key
RUN apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/
RUN apt-get update && apt-get install -y winehq-stable winetricks # this installs Wine2
RUN apt-get clean

RUN wine 
COPY singularity /
RUN chmod 0755 /singularity
