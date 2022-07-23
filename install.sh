#!/usr/bin/env arch -x86_64 bash

WINESKIN_TARGET_NAME="Origin.app"

function wineskinlauncher() {
    ${PWD}/${WINESKIN_TARGET_NAME}/Contents/MacOS/wineskinlauncher "${@}"
}

# Generate Wineskins prefix
function wineprefixcreate() {
    wineskinlauncher WSS-wineprefixcreate
}

# Run winetricks
function winetricks() {
    wineskinlauncher WSS-winetricks "${@}"
}

# Tell wineserver to kill all processes
function wineserverkill() {
    wineskinlauncher WSS-wineserverkill
}

# Wrap wine
function wine() {
    export WINEDEBUG="-all"
    export WINETRICKS_FALLBACK_LIBRARY_PATH="${PWD}/${WINESKIN_TARGET_NAME}/Contents/Frameworks"
    export WINEPREFIX="${PWD}/${WINESKIN_TARGET_NAME}/Contents/SharedSupport/prefix"
    ${PWD}/${WINESKIN_TARGET_NAME}/Wineskin.app/Contents/Resources/wine "${@}"
}

# Set dll to native,builtin
function override_dll() {
    wine reg add 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' /v "${$1}" /d native,builtin /f >/dev/null 2>&1
}

echo "==> Removing Gatekeeper quarantine from downloaded wrapper. You may need to enter your password."
sudo xattr -drs com.apple.quarantine "${PWD}/${WINESKIN_TARGET_NAME}" &>/dev/null

echo "==> Verifying winetricks is installed within wrapper."
${PWD}/${WINESKIN_TARGET_NAME}/Wineskin.app/Contents/Resources/winetricks list-installed &>/dev/null
isWorkingEnv=$?

if [ "$isWorkingEnv" != "0" ]; then
    echo "==> Could not find winetricks, downloading."
    curl -o ${PWD}/${WINESKIN_TARGET_NAME}/Wineskin.app/Contents/Resources/winetricks https://raw.githubusercontent.com/The-Wineskin-Project/winetricks/macOS/src/winetricks
 &>/dev/null
    chmod +x ${PWD}/${WINESKIN_TARGET_NAME}/Wineskin.app/Contents/Resources/winetricks &>/dev/null
fi

echo "===> - Installing Origin"
winetricks -q -f origin

# The origin verb already installs this
#override_dll d3dcompiler_47

echo "==> Launching explorer"
wine explorer
