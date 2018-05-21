BootStrap: docker
From: ubuntu:latest

%runscript
TEMPDIR="$(mktemp -d)"
echo "Creating and changing into temporary directory $TEMPDIR..."
cd "$TEMPDIR"

APPDIR="/APPS"
PROFILEDIR="/PROFILES/${USER}@${HOSTNAME}"

echo "Setting up wine prefix..."
export WINEPREFIX="$TEMPDIR/wineprefix"
export WINEARCH="win32"

if [ -f "$APPDIR/wineprefix.tgz" ]; then
    echo "Found existing wineprefix - restoring it..."
    mkdir -p "$WINEPREFIX"
    cd "$WINEPREFIX"
    tar xzf "$APPDIR/wineprefix.tgz"
else
  wineboot --init

  echo "Installing DirectX9..."
  winetricks dlls directx9
fi

echo "Containerizing gaming directory..."
if [ -L "$WINEPREFIX/drive_c/Apps" ]; then
    echo "Links exist already"
else
    ln -sf "$APPDIR" "$WINEPREFIX/drive_c/Apps"
    ln -sf "$APPDIR" "$WINEPREFIX/drive_c/GOG Games"
    ln -sf "$APPDIR" "$WINEPREFIX/drive_c/Games"
fi

echo "Containerizing user profile..."
if [ -d "$PROFILEDIR" ]; then
    rm -rf "$WINEPREFIX/drive_c/users/$USER"
else
    echo "This user profile is newly generated..."
    mv "$WINEPREFIX/drive_c/users/$USER" "$PROFILEDIR"
fi
ln -s "$PROFILEDIR" "$WINEPREFIX/drive_c/users/$USER"

echo "Please install your GOG windows game now or play it"
echo "To install Broken Sword 2.5 (download size ~700MB):"
echo " wget http://server.c-otto.de/baphometsfluch/bs25setup.zip"
echo " unzip bs25setup.zip"
echo " wine ./bs25-setup.exe"
env WINEPREFIX="$WINEPREFIX" WINEARCH="$WINEARCH" /bin/bash

wineboot --end-session

echo "Saving last wineprefix..."
cd $WINEPREFIX && tar czf "$APPDIR/wineprefix.tgz" . && sync

rm -rf "$TEMPDIR" 

%files
README.md /README.md

%post
    dpkg --add-architecture i386 
    apt-get update
    apt-get -y install wget less vim software-properties-common python3-software-properties apt-transport-https winbind
    wget https://dl.winehq.org/wine-builds/Release.key
    apt-key add Release.key
    apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/
    apt-get update
    apt-get install -y winehq-stable winetricks # this installs Wine2
    wget http://forsys.cfr.washington.edu/fusion/FUSION_Install.exe
    mkdir /APPS /PROFILES
    chmod 0777 /APPS /PROFILES
