#!/bin/sh

# Downloads stuff from wget, and parses it to obtain an output useful for Zenity.
download_wget () {
  wget "$1" 2>&1 | sed -u "s/.* \([0-9]\+\)%\ \+\([0-9,.]\+.\) \(.*\)/\1\n# Downloading $2\\\\nDownload speed: \2\/s, ETA \3/"
  ret_wget="${PIPESTATUS[0]}"    # get return code of wget
  if [[ "$ret_wget" = 0 ]]; then # check return code for errors
    echo "${2}100%"
    echo "$2# Download completed."
  else
    echo "$2# Download error."
  fi
}

# Gives a Zenity prompt for a wget download, with optional title as a second argument.
# Function forked from https://askubuntu.com/a/464122.
wzen () {
  download_wget "$1" "$2" | zenity --progress --width=500 --title="Downloading $2" --auto-close
}

# Install Cubism SDK Native if not there
cache_dir="${XDG_CACHE_HOME-$HOME/.cache}/vignette"
cubism=CubismSdkForNative-4-r.3
libcubism=libLive2DCubismCore.so

vignette_state="${XDG_STATE_HOME-$HOME/.local/state}/vignette"

if [ ! -f "/usr/lib/vignette/$libcubism" ] && [ ! -f "$vignette_state/$libcubism" ]; then
  zenity --question --text="It seems like you don't have the Cubism SDK installed on your system, or locally for Vignette.\\nDo you accept the <a href=\"https://www.live2d.com/en/download/cubism-sdk/download-native/\">Live2D Proprietary Software License Agreement</a>?" --width=480 || exit 1
  
  mkdir -p "$cache_dir"
  cd "$cache_dir"

  wzen "https://cubism.live2d.com/sdk-native/bin/$cubism.zip" "Cubism SDK for Native (v4-r3)"
  unzip "$cubism.zip"
  mkdir -p "$vignette_state"
  cp "$cubism/Core/dll/linux/x86_64/$libcubism" "$vignette_state/$libcubism"
  rm -rf "$libcubism"
fi

# Run Vignette (with runtime if present)
if which dotnet > /dev/null; then
  env DOTNET_CLI_TELEMETRY_OPTOUT="${DOTNET_CLI_TELEMETRY_OPTOUT-1}" \
    SDL_VIDEO_X11_NET_WM_BYPASS_COMPOSITOR=0 \
    dotnet /usr/lib/vignette/Vignette.dll
else
  env DOTNET_CLI_TELEMETRY_OPTOUT="${DOTNET_CLI_TELEMETRY_OPTOUT-1}" \
    SDL_VIDEO_X11_NET_WM_BYPASS_COMPOSITOR=0 \
    Vignette
fi
