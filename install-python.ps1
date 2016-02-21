#Requires -RunAsAdministrator

function Download-Python {
    $version = "3.5.1"
    $exename = "python-$version-amd64-webinstall.exe"
    $url = "https://www.python.org/ftp/python/$version/$exename"
    $destination = "c:\tmp\$exename"

    if (!(Test-Path $destination)) {
        Write-Host "Downloading Python" -ForegroundColor Yellow
        Invoke-WebRequest $url -OutFile $destination

        # double check that is was written to disk
        if(!(Test-Path $destination)){
            throw 'Unable to download python'
        }
    
    }
    return $destination
}

function Install-Python([string]$path) {
    Start-Process -FilePath $path -ArgumentList "/quiet", "PrependPath=1"
    Write-Host "Python installed" -ForegroundColor Green
    Write-Host "Validating path variable..."

    Start-Sleep -s 5

    $installdir = "$env:userprofile\AppData\Local\Programs\Python\"

    if (!(Test-Path $installdir))
    {
        Start-Sleep -s 10
    }
    $pythonversion = Get-ChildItem $installdir

    Write-Host "Python Folder: $pythonversion"

    $env:Path += ";$installdir$pythonversion"
    $env:Path += ";$installdir$pythonversion\Scripts"

    Write-Host ([Environment]::GetEnvironmentVariable("PATH")) -ForegroundColor Yellow
    Write-Host "Verified Python path" -ForegroundColor Green
}

function UpgradePip($localversion)
{
    $currentversion = CheckPipVersion

    if($currentversion -ne $localversionpip)
    {
        Write-Host "Pip version out of date, upgrading." -ForegroundColor Yello
        Invoke-Expression "python -m pip install --upgrade pip" 
        Start-Sleep -s 2

        $newversion = CheckPipVersion
        if ($newversion -eq $currentversion)
        {
            Start-Sleep -s 5
        }
    }  
}

function CheckPipVersion()
{
    try
    {
        $pipcurrent = Invoke-Expression "pip --version"
    }
    catch
    {
        Write-Host "Pausing for pip to initialise"
        Start-Sleep -s 30
        $pipcurrent = Invoke-Expression "pip --version"
    }
    
    $versionnumber = $pipcurrent.Split(" ")[1]

    Write-Host "pip version: $versionnumber" -ForegroundColor Magenta
    return $versionnumber 

}

function InstallVirtualenv()
{
    Invoke-Expression "pip install virtualenv"
}


function Install-Requirements {
    $python = Download-Python
    Install-Python $python

    $pipversion = CheckPipVersion
    UpgradePip $pipversion

    InstallVirtualenv

}

Install-Requirements
