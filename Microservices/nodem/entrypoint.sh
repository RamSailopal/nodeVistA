#!/bin/bash
source /home/nodevista/etc/env
$ydb_dist/mumps -run GDE <<< change -segment DEFAULT -file=NODEM:/home/nodevista/g/nodevista.dat
cp /home/nodem/fmqlServer.js /home/vdp/FMQL/webservice/fmqlServer.js
su vdp -c "source /home/nodevista/etc/env && pm2 start /home/vdp/FMQL/webservice/fmqlServer.js"
tail -f /dev/null
