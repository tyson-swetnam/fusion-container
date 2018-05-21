BootStrap: docker
From: ubuntu:xenial

%runscript
TEMPDIR="$(mktemp -d)"
echo "Creating and changing into temporary directory $TEMPDIR..."
cd "$TEMPDIR"

APPDIR="/APPS"
PROFILEDIR="/PROFILES/${USER}@${HOSTNAME}"

echo "Setting up wine prefix..."
export WINEPREFIX="$TEMPDIR/wineprefix"
export WINEARCH="win64"

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

echo "Containerizing FUSION directory..."
if [ -L "$WINEPREFIX/drive_c/Apps" ]; then
    echo "Links exist already"
else
    ln -sf "$APPDIR" "$WINEPREFIX/drive_c/Apps"
    ln -sf "$APPDIR" "$WINEPREFIX/drive_c/FUSION"
fi

echo "Containerizing user profile..."
if [ -d "$PROFILEDIR" ]; then
    rm -rf "$WINEPREFIX/drive_c/users/$USER"
else
    echo "This user profile is newly generated..."
    mv "$WINEPREFIX/drive_c/users/$USER" "$PROFILEDIR"
fi
ln -s "$PROFILEDIR" "$WINEPREFIX/drive_c/users/$USER"

echo " Install FUSION from its URL:"
echo " wget http://forsys.cfr.washington.edu/fusion/FUSION_Install.exe $WINEPREFIX/drive_c/users/$USER/FUSION_Install.exe"

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
    mkdir /APPS /PROFILES
    chmod 0777 /APPS /PROFILES
