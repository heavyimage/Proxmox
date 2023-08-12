#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/heavyimage/Proxmox/main/misc/build.func)
# Copyright (c) 2023 heavyimage
# Author: heavyimage
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
                                                 
     ______  _______        _____        _____   
    |      \/       \   ___|\    \   ___|\    \  
   /          /\     \ |    |\    \ |    |\    \ 
  /     /\   / /\     ||    | |    ||    | |    |
 /     /\ \_/ / /    /||    |/____/||    | |    |
|     |  \|_|/ /    / ||    ||    |||    | |    |
|     |       |    |  ||    ||____|/|    | |    |
|\____\       |____|  /|____|       |____|/____/|
| |    |      |    | / |    |       |    /    | |
 \|____|      |____|/  |____|       |____|____|/ 
    \(          )/       \(           \(    )/   
     '          '         '            '    '    
                                                 
EOF
}
header_info
echo -e "Loading..."
APP="Mpd"
var_disk="16"
var_cpu="1"
var_ram="512"
var_os="debian"
var_version="11"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="0"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="yes"
  echo_default
}

function update_script() {
header_info
if [[ ! -d /usr/bin/mpd ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
msg_info "Stopping mpd"
systemctl stop mpd.service
msg_ok "Stopped mpd"

msg_info "Updating mpd"
apt upgrade mpd mpc nfs-common
msg_ok "Updated mpd"

msg_info "Starting mpd"
systemctl start mpd.service
msg_ok "Started mpd"

msg_ok "Updated Successfully"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
