
#$varCheminRepertoireScript = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition) #On récupère le chemin du répertoire contenant ce script
Write-host $varCheminRepertoireScript

$LogPath = Read-Host "Entrer le chemin de stockage des logs"


$ChoosenDate = Read-Host "Entrer la date a laquelle recuperer les logs"
$ChoosenDate= Get-Date $ChoosenDate
$date = Get-Date -format "dd-MM-yyyy"
Write-Host = "Date du jour :" $date
Write-Host = "Date choisie :" $ChoosenDate "`n"

$ChoosenPath = Read-Host "Entrer le chemin à lequel copier les fichier"

if((Test-Path "$ChoosenPath\LogCopied_$date") -ne $true )
{
    New-Item -Path $ChoosenPath -Name "LogCopied_$date" -ItemType "directory"
}


Write-Host "`nSuppressions des fichiers suivant deja present:"
$MonDossier_Clear = Get-ChildItem -Path $ChoosenPath\LogCopied_$date -Recurse -file | Where{$_.LastWriteTime.day -eq $ChoosenDate.day -and $_.LastWriteTime.month -eq $ChoosenDate.month -and $_.LastWriteTime.year -eq $ChoosenDate.year} #On récupère la liste des fichiers de ce répertoire
foreach ($MonFichier_Clear in $MonDossier_Clear)
{
    Write-Host $MonFichier_Clear.FullName
    Remove-Item -Path $ChoosenPath\LogCopied_$date\$($MonFichier_Clear.Name)
	Write-Host "A ete Suprimmed $($MonFichier_Clear.Name) / $($MonFichier_Clear.LastWriteTime) `n" #On affiche le nom du fichier ainsi que son chemin d'accès complet
}


Write-Host "`nCopie des fichiers suivant :"
$MonFolder = Get-ChildItem -Path $LogPath -Recurse -file | Where{$_.LastWriteTime.day -eq $ChoosenDate.day -and $_.LastWriteTime.month -eq $ChoosenDate.month -and $_.LastWriteTime.year -eq $ChoosenDate.year} #On récupère la liste des fichiers de ce répertoire
foreach ($MyFile in $MonFolder)
{
    #Copy-item $MonFolder.FullName -Destination $ChoosenPath\LogCopied_$date -filter{PSIsContainer} -Force
    #Write-Host $MonFolder"`n"

    #Write-Host $MyFile.FullName
    Copy-item $Myfile.FullName -Destination $ChoosenPath\LogCopied_$date -Force
    Write-Host "A ete Copied $($MyFile.Name) / $($MyFile.LastWriteTime)`n" 

}

 

