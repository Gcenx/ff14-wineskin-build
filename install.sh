#!/usr/bin/env arch -x86_64 bash

WINESKIN_TARGET_NAME="template_xiv_working.app"

function wineskinlauncher() {
    ${PWD}/${WINESKIN_TARGET_NAME}/Contents/MacOS/wineskinlauncher "${@}"
}

function explorer() {
    wineskinlauncher WSS-explorer
}

function winetricks() {
    wineskinlauncher WSS-winetricks "${@}"
}

function install_deps() {
    echo "===> - Installing dotnet48"
    winetricks -q -f dotnet48
    echo "===> - Installing vcrun2015"
    winetricks -q vcrun2015
    echo "===> - Installing vcrun2012"
    winetricks -q vcrun2012
    echo "===> - Installing vcrun2010"
    winetricks -q vcrun2010
    echo "===> - Installing dxvk_macos"
    winetricks dxvk_macos.verb
    #winetricks corefonts
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
