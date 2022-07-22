#!/usr/bin/env arch -x86_64 bash

WINESKIN_TARGET_NAME="template_xiv_working.app"

export wineWrappers="${PWD}/${WINESKIN_TARGET_NAME}/Wineskin.app/Contents/Resources"
export PATH="${wineWrappers}:${PATH}"
export WINEDEBUG="-esync,-plugplay"

# Workaround SIP DYLD_stripping
# See https://support.apple.com/en-us/HT204899
# See https://github.com/Winetricks/winetricks/pull/1820
export WINETRICKS_FALLBACK_LIBRARY_PATH="${PWD}/${WINESKIN_TARGET_NAME}/Contents/Frameworks"

export WINEPREFIX="${PWD}/${WINESKIN_TARGET_NAME}/Contents/SharedSupport/prefix"

function install_deps() {
    echo "===> Installing dotnet48"
	winetricks -q -f dotnet48 &>/dev/null
    echo "===> Installing vcrun2015"
	winetricks -q vcrun2015 &>/dev/null
    echo "===> Installing vcrun2012"
	winetricks -q vcrun2012 &>/dev/null
    echo "===> Installing vcrun2010"
	winetricks -q vcrun2010 &>/dev/null
}

echo "==> Removing Gatekeeper quarantine from downloaded wrapper. You may need to enter your password."
sudo xattr -drs com.apple.quarantine "${PWD}/${WINESKIN_TARGET_NAME}" &>/dev/null

echo "==> Verifying winetricks is installed within wrapper."
${PWD}/${WINESKIN_TARGET_NAME}/Wineskin.app/Contents/Resources/winetricks list-installed &>/dev/null
isWorkingEnv=$?

if [ "$isWorkingEnv" != "0" ]; then
    echo "==> Could not find winetricks, downloading."
    curl -o ${PWD}/${WINESKIN_TARGET_NAME}/Wineskin.app/Contents/Resources/winetricks https://raw.githubusercontent.com/The-Wineskin-Project/winetricks/macOS/src/winetricks &>/dev/null
    chmod +x ${PWD}/${WINESKIN_TARGET_NAME}/Wineskin.app/Contents/Resources/winetricks &>/dev/null
fi

echo "==> Installing proprietary dependencies..."
install_deps
echo "==> Finished installing dependencies."

echo "==> Launching explorer"
wine explorer
