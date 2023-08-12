#!/usr/bin/env bash

# Copyright (c) 2023 heavyimage
# Author: heavyimage
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os


msg_info "Installing mpd"
$STD apt-get install -y mpd mpc
msg_ok "Installed mpd"

#msg_info "Disabling user service"
#systemctl --user disable mpd
#msg_info "Disabled user service"

msg_info "disabling system service for installation"
systemctl disable mpd
msg_info "disabled system service for installation"


msg_info "Creating config file"
cat <<EOF >/etc/mpd.conf
music_directory    "/mnt/music/""
bind_to_address    "0.0.0.0"

database {
    plugin           "simple"
    path             "/var/lib/mpd/mpd.db"
    cache_directory  "/var/lib/mpd/cache"
}

EOF

msg_info "enabling system service"
systemctl enable mpd
msg_info "enabled system service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
