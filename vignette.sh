#!/bin/sh

# Downloads stuff from wget, and parses it to obtain an output useful for Zenity.
download-wget () {
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
  download-wget "$1" "$2" | zenity --progress --width=500 --title="Downloading $2" --auto-close
}

# Install Cubism SDK Native if not there
cache_dir=~/.cache/vignette
cubism_dir=/var/data/vignette

if [[ ! -f "$cubism_dir/libLive2DCubismCore.so" ]]; then
  zenity --question --text='Do you accept the <a href="https://www.live2d.com/en/download/cubism-sdk/download-native/">Live2D Proprietary Software License Agreement</a>?' --width=500 || exit 1
  
  mkdir -p "$cache_dir"
  cd "$cache_dir"

  wzen https://cubism.live2d.com/sdk-native/bin/CubismSdkForNative-4-r.3.zip "Cubism SDK for Native (v4-r3)"
  unzip CubismSdkForNative-4-r.3.zip
  cp CubismSdkForNative-4-r.3/Core/dll/linux/x86_64/libLive2DCubismCore.so "$cubism_dir/libLive2DCubismCore.so"
  rm -rf CubismSdkForNative-4-r.3*
fi

# Run Vignette (with runtime if present)
if which dotnet; then
  env DOTNET_CLI_TELEMETRY_OPTOUT="${DOTNET_CLI_TELEMETRY_OPTOUT-1}" \
    SDL_VIDEO_X11_NET_WM_BYPASS_COMPOSITOR=0 \
    dotnet /usr/lib/vignette/Vignette.dll
else
  env DOTNET_CLI_TELEMETRY_OPTOUT="${DOTNET_CLI_TELEMETRY_OPTOUT-1}" \
    SDL_VIDEO_X11_NET_WM_BYPASS_COMPOSITOR=0 \
    Vignette
fi
