## Updates User Profile Pictures
## -----------------------------
## After backup-restore process the images still contain link to the original location
## this script replaces that links to point to the current location
## .\UpdateUserProfilePictures.ps1 "<CurrentSiteUrl>"
## Remember to update the $prodUrlWildcard variable

param([string]$mySiteUrl)

$prodUrlWildcard = "https://yourProductionMySiteUrl*"
$mySiteHostSite = Get-SPSite $MySiteUrl
$mySiteHostWeb = $mySiteHostSite.OpenWeb()
$context = Get-SPServiceContext $mySiteHostSite

$profileManager = New-Object Microsoft.Office.Server.UserProfiles.UserProfileManager($context)

$userProfiles = $profileManager.GetEnumerator();
Write-Host "Start processing profiles"
foreach($profile in $userProfiles)
{
   Write-Host "Start processing " $profile.DisplayName    
   if($profile["PictureURL"].Value -ne $null -and $profile["PictureURL"].Value -ne "" )
   {
        Write-Host "Start processing " $profile.DisplayName 
        $picture = $profile["PictureURL"].Value
        if ($picture -like $prodUrlWildcard)
        {
            $profile["PictureURL"].Value = $picture -replace $prodUrlWildcard, $mySiteUrl
            $profile.Commit()
            Write-Host "Modified " $profile.DisplayName -Foregroundcolor green
        }
   }
}