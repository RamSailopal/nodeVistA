## nodeVistA

This is a VISTA system driven by Node.js ("_nodeVISTA_"), which allows coding all functionality in Javascript for both server and clients.


* [nodeVISTA Docker](https://github.com/CloudVistA/nodevista/tree/main/setupDocker#docker-for-nodevista)
* [nodeVISTA Clinical Services](https://github.com/cloudvista/nodevista/tree/master/clinicalService#clinical-rest-service)
* [nodeVISTA RPC Services](https://github.com/cloudvista/nodevista/tree/master/rpcServer#rpc-server)

# Additions to this particular fork

This particular fork splits the fmql nodem component from the main VistA YottaDB stack by running separate micro services for both.

Details are in the **Microservices** folder.

The key stages for remote connection of a nodem client to the YottaDB database is as follws:

**Server (VistA micro service)** - 

Execute:
   
    /opt/lsb-gtm/V6.2-000_x86_64/gtcm_gnp_server -log=/var/log/gtcm.log -service=6789
    
Allow remote connections on port 6789

**Client (fmql micro service)** -

Execute:

    $ydb_dist/mumps -run GDE <<< change -segment DEFAULT -file=NODEM:/home/nodevista/g/nodevista.dat
    
Change the data file on the client to reference that on the server **/home/nodevista/g/nodevista.dat**
**

Then when opening a YottaDB nodem connection on the client, in file **fmqlServer.js**

change:

    var ok = db.open();
    
to:

    var ok = db.open({ipAddress: 'nodevista', tcpPort: 6789});
    
Where nodevista is the hostname of the VistA container and 6789 the port we allowed remote connection on in the previous step

The main entry point/daemon process for each container can then be split out from the original **/home/nodevista/entryCombo.sh** entrypoint

The original entryCombo.sh file for Docker image **docker.io/vistadataproject/nodevista999** contains the following lines:

    #!/bin/bash
    su vdp -c "source /home/nodevista/etc/env && pm2 start /home/vdp/FMQL/webservice/fmqlServer.js"
    /home/nodevista/bin/start.sh

These can execution stages can then be split:

**fmql container**

    su vdp -c "source /home/nodevista/etc/env && pm2 start /home/vdp/FMQL/webservice/fmqlServer.js"
    tail -f /dev/null # Hang indefinitely
    
**VistA container**

    /home/nodevista/bin/start.sh
    
# Windows Installer

Powershell scripts have been added to run nodevista container after installing Docker Desktop for WIndows (if required). Script also for installing CPRS client. All scripts are held in **Windows-install** directory.
 

