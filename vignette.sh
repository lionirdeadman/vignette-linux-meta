#!/bin/sh

if [[ ! -f '/var/data/vignette/libLive2DCubismCore.so' ]]; then
  zenity --question --text='Do you accept the <a href="https://www.live2d.com/en/download/cubism-sdk/download-native/">Live2D Proprietary Software License Agreement</a>?' --width=500 || exit 1
  cd "${CUBISM_LOCATION}"
  wget https://cubism.live2d.com/sdk-native/bin/CubismSdkForNative-4-r.3.zip
  unzip CubismSdkForNative-4-r.3.zip
  cp /var/data/vignette/CubismSdkForNative-4-r.3/Core/dll/linux/x86_64/libLive2DCubismCore.so /var/data/vignette/libLive2DCubismCore.so
  rm -rf /var/data/vignette/CubismSdkForNative-4-r.3*
fi
if which dotnet; then
  env DOTNET_CLI_TELEMETRY_OPTOUT="${DOTNET_CLI_TELEMETRY_OPTOUT-1}" \
    SDL_VIDEO_X11_NET_WM_BYPASS_COMPOSITOR=0 \
    dotnet /usr/lib/vignette/Vignette.dll
else
  env DOTNET_CLI_TELEMETRY_OPTOUT="${DOTNET_CLI_TELEMETRY_OPTOUT-1}" \
    SDL_VIDEO_X11_NET_WM_BYPASS_COMPOSITOR=0 \
    Vignette
fi
