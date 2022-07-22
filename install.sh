#!/usr/bin/env arch -x86_64 bash

WINESKIN_TARGET_NAME="Origin.app"

# Launch with unix path to open said file
# Launch without command to load the default bat/cmd/exe
# Launch WSS- commands, all wrapped below
function wineskinlauncher() {
    ${PWD}/${WINESKIN_TARGET_NAME}/Contents/MacOS/wineskinlauncher "${@}"
}

#### start of Wineskin functions ####

# Run an installer
function installer() {
    wineskinlauncher WSS-installer "${@}"
}

# Launch winecfg
function winecfg() {
    wineskinlauncher WSS-winecfg
}

# Launch windows cmd
function cmd() {
    wineskinlauncher WSS-cmd
}

## TODO: Check if this command accepts flags
# Run regedit app
#function regedit() {
#    wineskinlauncher WSS-regedit
#}

# Launch windows task manager
function taskmgr() {
    wineskinlauncher WSS-taskmgr
}

# Launch windows uninstaller
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

# Launch windows explorer (not a browser)
function explorer() {
    wineskinlauncher WSS-explorer
}

#### End of Wineskin functions ####


# add wine/wineprefix to ENV
export wineWrappers="${PWD}/${WINESKIN_TARGET_NAME}/Wineskin.app/Contents/Resources"
export WINEDEBUG="-all"
export WINETRICKS_FALLBACK_LIBRARY_PATH="${PWD}/${WINESKIN_TARGET_NAME}/Contents/Frameworks"
export WINEPREFIX="${PWD}/${WINESKIN_TARGET_NAME}/Contents/SharedSupport/prefix"
export wine="${wineWrappers}/wine"


function install_deps() {
    echo "===> - Installing Origin"
    winetricks -q -f origin
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

echo "==> Installing proprietary dependencies..."
install_deps
echo "==> Finished installing dependencies."

# The origin verb already installs this
#override_dll d3dcompiler_47

echo "==> Launching explorer"
explorer
