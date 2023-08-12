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
$STD apt-get install -y mpd mpc nfs-common
msg_ok "Installed mpd"

msg_info "disabling system service for installation"
systemctl disable mpd
msg_info "disabled system service for installation"

msg_info "Creating config file"
cat <<EOF >/etc/mpd.conf
music_directory    "/mnt/media/music/music"
bind_to_address    "0.0.0.0"

database {
    plugin           "simple"
    path             "/var/lib/mpd/mpd.db"
    cache_directory  "/var/lib/mpd/cache"
}
EOF
msg_info "Created config file"


msg_info "Adding mountpoint"
cat <<EOF >>/etc/fstab
192.168.0.44:/volume1/media      /mnt/media      nfs  vers=4  0  0
EOF
msg_info "Added mountpoint"

msg_info "Mounting media"
mount -a
msg_info "Mounted media"

msg_info "enabling system service"
systemctl enable mpd
msg_info "enabled system service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
