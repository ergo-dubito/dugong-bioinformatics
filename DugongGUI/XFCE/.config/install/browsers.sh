#!/usr/bin/env bash
### every exit != 0 fails the script
set -e
echo "Install Chromium Browser" && \
apt-get update && \
apt-get install -y --allow-unauthenticated chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg firefox=45* && \
apt-mark hold firefox && \
apt-get clean -y && \
ln -s /usr/bin/chromium-browser /usr/bin/google-chrome && \
echo "CHROMIUM_FLAGS='--no-sandbox --start-maximized --user-data-dir'" > $HOME/.chromium-browser.init
