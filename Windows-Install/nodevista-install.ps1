#
#   Check to see if Docker is installed. If not, download and install Docker Desktop for Windows. Then pull and run VistA EHR image in container
#
param ([String] $action="install", [switch]$help = $false )
function vdm() {
    try {
        & 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe' -address 'http://127.0.0.1:9100'
    }
    catch {
        Write-Host -ForegroundColor red "There was an issue running the VDM browser"
    }
}
If ($help) {
    Write-Host ""
    Write-Host "This script runs a nodeVistA EHR server in a Docker Container after first installing the Docker Desktop dependancy if required"
    Write-Host "https://github.com/RamSailopal/nodeVistA"
    Write-Host ""
    Write-Host "Additional flags:"
    Write-Host ""
    Write-Host -ForegroundColor "yellow" "-help" 
    Write-Host -ForegroundColor "green" "Print help"
    Write-Host ""
    Write-Host -ForegroundColor "yellow" "-action install" 
    Write-Host -ForegroundColor "green" "Install the nodeVistA EHR container plus dependancies if necessary (default)"
    Write-Host ""
    Write-Host -ForegroundColor "yellow" "-action noint-install"
    Write-Host -ForegroundColor "green" "Install the nodeVistA EHR container plus dependancies if necessary in none interactive mode"
    Write-Host ""
    Write-Host -ForegroundColor "yellow" "-action status"
    Write-Host -ForegroundColor "green" "Print the status of the World VistA EHR container"
    Write-Host ""
    Write-Host -ForegroundColor "yellow" "-action start"
    Write-Host -ForegroundColor "green" "Start the nodeVistA EHR container"
    Write-Host ""
    Write-Host -ForegroundColor "yellow" "-action stop"
    Write-Host -ForegroundColor "green" "Stop the nodeVistA EHR container"
    Write-Host ""
    Write-Host -ForegroundColor "yellow" "-action restart"
    Write-Host -ForegroundColor "green" "Restart the nodeVistA EHR container"
    Write-Host ""
    exit
}
if ($action.ToUpper() -eq "RESTART") {
    try {
        $contid=""
        $fnd=0
        Get-Process | ForEach-Object { 
            if ( $_.Name  -eq "Docker Desktop" ) { 
                $fnd=1 
            } 
        }
        if ($fnd -eq 0 ) {
            Write-Host -ForegroundColor Red "Docker Desktop is not running. Starting now ..."
            & '~\Desktop\Docker Desktop.lnk'
            Start-Sleep 60
        }
        if (docker ps -a --format "{{.Names}}" | Select-String "nodevista999") { 
            docker ps -a | Select-String "nodevista999" | ForEach-Object { 
                $bits=$_.toString().split(" ")
                if ($bits[0] -notmatch "CONTAINER") { 
                    $contid = $bits[0] 
                } 
                docker rm -f $contid | Out-Null
                docker run -p 9330:9430 -p 32:22 -p 9100:9000 -p 9331:8001 -d -P --name nodevista999 vistadataproject/nodevista999:latest | Out-Null
                Write-Host -ForegroundColor green "VistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
            }
        }
        if ($contid -eq "") {
            $ans3 = Read-Host -Prompt "There was an error recreating the VistA EHR container. Do you wish to create one now? (Y/N)"
            if ($ans3.ToUpper() -eq "Y") {
                docker run -p 9330:9430 -p 32:22 -p 9100:9000 -p 9331:8001 -d -P --name nodevista999 vistadataproject/nodevista999:latest | Out-Null
                Write-Host -ForegroundColor green "VistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
                exit
            }
        }
        $ans4 = Read-Host -Prompt "Would you like to run the VDM  browser? (Y/N)"
        if ($ans4.ToUpper() -eq "Y") {
                vdm
                exit
        }
    }
    catch {
        Write-Host -ForegroundColor Red "There was an error recreating the VistA EHR container"
    }
    exit
}
elseif ($action.ToUpper() -eq "STOP") {
    try {
        $contid=""
        if (docker ps -a --format "{{.Names}}" | Select-String "nodevista999") { 
            docker ps -a | Select-String "nodevista999" | ForEach-Object { 
                $bits=$_.toString().split(" ")
                if ($bits[0] -notmatch "CONTAINER") { 
                    $contid = $bits[0] 
                } 
                docker rm -f $contid | Out-Null
                Write-Host -ForegroundColor green "VistA EHR is stopped and container removed"
                exit
            }
        }
        if ($contid -eq "") {
            Write-Host -ForegroundColor Green "The VistA EHR container is not running"
        }
    }
    catch {
        Write-Host -ForegroundColor Red "There was an error recreating the VistA EHR container"
    }
    exit
}
elseif ($action.ToUpper() -eq "START") {
    try {
        $contid=""
        $fnd=0
        Get-Process | ForEach-Object { 
            if ( $_.Name  -eq "Docker Desktop" ) { 
                $fnd=1 
            } 
        }
        if ($fnd -eq 0 ) {
            Write-Host -ForegroundColor Red "Docker Desktop is not running. Starting now ..."
            & '~\Desktop\Docker Desktop.lnk'
            Start-Sleep 60
        }
        if (docker ps -a --format "{{.Names}}" | Select-String "nodevista999" ) { 
            docker ps -a | Select-String "nodevista999" | ForEach-Object { 
                $bits=$_.toString().split(" ")
                if ($bits[0] -notmatch "CONTAINER") { 
                    $contid = $bits[0] 
                } 
            }
        }
        if ($fnd -eq 0 ) {
            docker rm -f $contid | Out-Null
            docker run -p 9330:9430 -p 32:22 -p 9100:9000 -p 9331:8001 -d -P --name nodevista999 vistadataproject/nodevista999:latest | Out-Null
            Write-Host -ForegroundColor green "nodeVistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
        }
        elseif ($contid -eq "") {
            docker run -p 9330:9430 -p 32:22 -p 9100:9000 -p 9331:8001 -d -P --name nodevista999 vistadataproject/nodevista999:latest | Out-Null
            Write-Host -ForegroundColor green "nodeVistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
            exit
        }
        else {
            Write-Host -ForegroundColor Green "The nodeVistA EHR container is already running"
        }
    }
    catch {
        Write-Host -ForegroundColor Red "There was an error recreating the VistA EHR container"
    }
    $ans4 = Read-Host -Prompt "Would you like to run the VDM  browser? (Y/N)"
        if ($ans4.ToUpper() -eq "Y") {
                vdm
                exit
        }
    exit
}
elseif ($action.ToUpper() -eq "STATUS") {
    try {
        $contid=""
        if (docker ps -a --format "{{.Names}}" | Select-String "nodevista999") { 
            docker ps -a | Select-String "nodevista999" | ForEach-Object { 
                $bits=$_.toString().split(" ")
                if ($bits[0] -notmatch "CONTAINER") { 
                    $contid = $bits[0] 
                } 
            }
        }
        if ($contid -eq "") {
            Write-Host -ForegroundColor Green "The nodeVistA EHR container is not running"
            exit
        }
        else {
            $contdet = docker ps -a --format "{{.ID}}:{{.RunningFor}}" | ForEach-Object {
                $contdetsp = $_.split(":")
                $runfor = $contdetsp[1]
            }
            Write-Host -ForegroundColor Green "The nodeVistA EHR container has been running since $runfor"
            exit
        }
    }
    catch {
        Write-Host -ForegroundColor Red "There was an error recreating the nodeVistA EHR container"
    }
    exit
}
elseif ($action.ToUpper() -eq "NOINT-INSTALL") {
    try {
        docker version | Out-Null
        Write-Host -ForegroundColor green "Docker Desktop already installed"
        if (docker ps -a --format "{{.Names}}" | Select-String "nodevista999") {
                docker ps -a | Select-String "nodevista999" | ForEach-Object { 
                    $bits=$_.toString().split(" ")
                    if ($bits[0] -notmatch "CONTAINER") { 
                        $contid = $bits[0] 
                    } 
                }
                docker rm -f $contid | Out-Null
                docker run -p 9330:9430 -p 32:22 -p 9100:9000 -p 9331:8001 -d -P --name nodevista999 vistadataproject/nodevista999:latest | Out-Null
                Write-Host -ForegroundColor green "nodeVistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
                exit
        }
        docker run -p 9330:9430 -p 32:22 -p 9100:9000 -p 9331:8001 -d -P --name nodevista999 vistadataproject/nodevista999:latest | Out-Null
        Write-Host -ForegroundColor green "nodeVistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
        exit
    }
    catch {
        Write-Host -ForegroundColor green "Downloading ..."
        try {
            Invoke-WebRequest 'https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe' -OutFile ~/Downloads/DockerInstall.exe
        }
        catch {
            Write-Host -ForegroundColor red "Issue downloading Docker Desktop for Windows"
        }
        try {
            & ~\Downloads\DockerInstall.exe
            Write-Host -ForegroundColor green "Please follow screen option to continue"
            Write-Host -ForegroundColor green "Running Docker Desktop"
            & '~\Docker Desktop.lnk'
            Start-Sleep 60
            Write-Host -ForegroundColor green "Running nodeVistA EHR in Docker"
            docker run -p 9330:9430 -p 32:22 -p 9100:9000 -p 9331:8001 -d -P --name nodevista999 vistadataproject/nodevista999:latest | Out-Null
            Write-Host -ForegroundColor green "nodeVistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
        }
        catch {
            Write-Host -ForegroundColor red "Issue running Docker Desktop Install"
        }
    }
}
elseif( $action.ToUpper() -eq "RUN-VDM" ) {
    vdm
    exit
}
try {
    docker version | Out-Null
    Write-Host -ForegroundColor green "Docker Desktop already installed"
    $ans=Read-Host -Prompt "Would you like to run nodeVistA EHR in Docker? (Y/N)"
    if ($ans.ToUpper() -eq "Y") {
        if (docker ps -a --format "{{.Names}}" | Select-String "nodevista999") {
            $ans2=Read-Host -Prompt "Would you like to remove the existing and recreate a container running nodeVistA EHR? (Y/N)"
            if ( $ans2.ToUpper() -eq "Y") {
                docker ps -a | Select-String "nodevista999" | ForEach-Object { 
                    $bits=$_.toString().split(" ")
                    if ($bits[0] -notmatch "CONTAINER") { 
                        $contid = $bits[0] 
                    } 
                }
                docker rm -f $contid | Out-Null
                docker run -p 9330:9430 -p 32:22 -p 9100:9000 -p 9331:8001 -d -P --name nodevista999 vistadataproject/nodevista999:latest | Out-Null
                Write-Host -ForegroundColor green "nodeVistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
                exit
            }
        }
        docker run -p 9330:9430 -p 32:22 -p 9100:9000 -p 9331:8001 -d -P --name nodevista999 vistadataproject/nodevista999:latest | Out-Null
        Write-Host -ForegroundColor green "nodeVistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
        exit
    }
}
catch {
    $resp = Read-Host "Docker Desktop is not installed. Initiate download and install now? (Y/N)"
    If ( $resp.ToUpper() -eq "Y") {
        Write-Host -ForegroundColor green "Downloading ..."
        try {
            Invoke-WebRequest 'https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe' -OutFile ~/Downloads/DockerInstall.exe
        }
        catch {
            Write-Host -ForegroundColor red "Issue downloading Docker Desktop for Windows"
        }
        try {
            & ~\Downloads\DockerInstall.exe
            Write-Host -ForegroundColor green "Please follow screen option to continue"
            Write-Host -ForegroundColor green "Running Docker Desktop"
            & '~\Docker Desktop.lnk'
            Start-Sleep 60
            Write-Host -ForegroundColor green "Running VistA EHR in Docker"
            docker run -p 9330:9430 -p 32:22 -p 9100:9000 -p 9331:8001 -d -P --name nodevista999 vistadataproject/nodevista999:latest | Out-Null
            Write-Host -ForegroundColor green "VistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
        }
        catch {
            Write-Host -ForegroundColor red "Issue running Docker Desktop Install"
        }
    }
}
