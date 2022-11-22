#!/bin/bash
/opt/lsb-gtm/V6.2-000_x86_64/gtcm_gnp_server -log=/var/log/gtcm.log -service=6789
cd /opt/vista
rm -Rf /home/vdp
/home/nodevista/bin/start.sh
