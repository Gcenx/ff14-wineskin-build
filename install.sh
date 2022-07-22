#!/usr/bin/env arch -x86_64 bash

WINESKIN_TARGET_NAME="Origin.app"

# Launch with unix path to open said file
# Launch without command to load the default bat/cmd/exe
function wineskinlauncher() {
    ${PWD}/${WINESKIN_TARGET_NAME}/Contents/MacOS/wineskinlauncher "${@}"
}


#### start of wineskin functions ####

# Installer is calling the program
function installer() {
    wineskinlauncher WSS-installer "${@}"
}

# Run winecfg
function winecfg() {
    wineskinlauncher WSS-winecfg
}

# Run windows cmd
function cmd() {
    wineskinlauncher WSS-cmd
}

# Run regedit app
function regedit() {
    wineskinlauncher WSS-regedit
}

# Run task manager
function taskmgr() {
    wineskinlauncher WSS-taskmgr
}

# Run windows uninstaller
function uninstaller() {
    wineskinlauncher WSS-uninstaller
}

# Generate Wineskins prefix
function wineprefixcreate() {
    wineskinlauncher WSS-wineprefixcreate
}

# Generate Wineskins prefix without settings
function wineprefixcreatenoregs() {
    wineskinlauncher WSS-wineprefixcreatenoregs
}

# Run wineboot
function wineboot() {
    wineskinlauncher WSS-wineboot
}

# Run winetricks
function winetricks() {
    wineskinlauncher WSS-winetricks "${@}"
}

# Tell wineserver to kill all processes
function wineserverkill() {
    wineskinlauncher WSS-wineserverkill
}

# Open windows explorer menu (not a browser)
function explorer() {
    wineskinlauncher WSS-explorer
}

#### End of wineakin functions ####


function install_deps() {
    echo "===> - Installing Origin"
    winetricks -q -f origin
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

echo "==> Installing proprietary dependencies..."
install_deps
echo "==> Finished installing dependencies."

echo "==> Launching explorer"
explorer
