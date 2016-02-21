param(
    [string]$timezone=$null
)

function ConfigTimeSync($tzname)
{
    $formattedtimezone = FormatTimeZone $tzname
 	Invoke-Expression "TZUTIL /s '$formattedtimezone'"
    Write-Host "Timezone set to $formattedtimezone"
}
 
function FormatTimeZone($timezonetext)
{
     Write-Host "Timezone given: $timezonetext"
 
     # Need to convert timezone from ruby generated value (in vagrant file) to powershell compatible value
     # Powershell in Vagrant box has Belarus Standard Time as Kaliningrad Standard Time
     $timezonestable = @{"GMT" = "GMT Standard Time"; 
                         "E." = "E. Europe Standard Time"; 
                         "Belarus" = "Kaliningrad Standard Time";
                         "South" = "South Africa Standard Time"}
 
     if ($timezonestable.ContainsKey($timezonetext))
     {
         return $timezonestable.Get_Item($timezonetext)
     }
     else
     {
         Write-Host "Timezone not found in table please updates values in set-timezone.ps1 to add your timezone."
     }
}

ConfigTimeSync $timezone
