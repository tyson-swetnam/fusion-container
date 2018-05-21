FROM ubuntu:16.04
LABEL maintainer="Tyson Lee Swetnam <tswetnam@cyverse.org>"
LABEL version="0.1"

ENTRYPOINT [ "/singularity" ]

RUN mkdir -p /APPS /PROFILES
RUN chmod 0777 /APPS /PROFILES
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get -y install wget \
  less \
  nano \
  vim \
  software-properties-common \
  python3-software-properties \
  apt-transport-https \
  winbind
  
RUN wget https://dl.winehq.org/wine-builds/Release.key
RUN apt-key add Release.key
RUN apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/
RUN apt-get update && apt-get install -y winehq-stable \
  winetricks # this installs Wine2
  
RUN apt-get clean

# Wine really doesn't like to be run as root, so let's use a non-root user
USER xclient
ENV HOME /home/xclient
ENV WINEPREFIX /home/xclient/.wine
ENV WINEARCH win32

# Use xclient's home dir as working dir
WORKDIR /home/xclient

RUN echo "alias winegui='wine explorer /desktop=DockerDesktop,1920x1080'" > ~/.bash_aliases 

RUN wine 
COPY singularity /
RUN chmod 0755 /singularity
