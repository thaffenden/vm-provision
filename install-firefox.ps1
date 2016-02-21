#Requires -RunAsAdministrator

function Download-FireFox ([string]$version) {
    $exename = "Firefox Setup $version.exe"
    $urlformat = $exename -replace " ", "%20"
    $url = "http://ftp.mozilla.org/pub/firefox/releases/$version/win32/en-GB/$urlformat"
    $destination = "c:\tmp\$exename"

    if (!(Test-Path $destination)) {
        Write-Host "Downloading Firefox" -ForegroundColor Yellow
        Invoke-WebRequest $url -OutFile $destination

        # double check that is was written to disk
        if(!(Test-Path $destination)){
            throw 'Unable to download firefox'
        }
    }
    return $destination
}

function Install-Firefox([string]$path) {
    Start-Process -FilePath $path -ArgumentList "/silent"
    Write-Host "Firefox installed" -ForegroundColor Green
}

function Install-Requirements {

    $firefox = Download-FireFox "34.0b5"
    Install-Firefox $firefox
}

Install-Requirements
