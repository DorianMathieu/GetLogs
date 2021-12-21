function Copy-LogInTree{
    param(
        $FChoosenPath,
        $FLogPath
    )
    #Write-Host "Deb FNC :$FLogPath`n"
    $TabFichier = Get-ChildItem -Path $FLogPath #Tableau des fichiers du chemin choisis
    foreach($ElementEnfant in $TabFichier) #Recherche dans le tableau
    {
        #Write-Host "ChoosenPath :$FChoosenPath`n"
        #Write-Host "ChoosenDate :$ChoosenDate`n"
        if(Test-Path -Path $ElementEnfant.FullName -PathType leaf) #Si l'element est un fichier (leaf)
        {

            if($ElementEnfant.LastWriteTime.day -eq $ChoosenDate.day -and $ElementEnfant.LastWriteTime.month -eq $ChoosenDate.month -and $ElementEnfant.LastWriteTime.year -eq $ChoosenDate.year)
            {
                Write-Host "Copie du Fichier :$FLogPath\$($ElementEnfant.Name)`n"
                Copy-Item $ElementEnfant.FullName -Destination $FChoosenPath
                #compteur_copieF++
            }   
        }
        else {
            
            if((Test-Path "$FChoosenPath\$($ElementEnfant.Name)") -ne $true ) #Si l'élement est pas déjà dans le dossier de destination
            {
                Write-Host "Copie du Dossier :$FLogPath\$($ElementEnfant.Name)`n"
                Copy-Item $ElementEnfant.FullName -Destination $FChoosenPath
            }
            Copy-LogInTree -FChoosenPath $FChoosenPath\$($ElementEnfant.Name) -FLogPath $FLogPath\$($ElementEnfant.Name)
            #Return de la valeur de compteur_copieF
            #Si valeur return = 0 on efface le dossier
        }
    }
    
}
 

#$varCheminRepertoireScript = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition) #On récupère le chemin du répertoire contenant ce script
Write-host $varCheminRepertoireScript

$LogPath = Read-Host "Entrer le chemin de stockage des logs `n(Par defaut : D:\Program Files\NICE Systems\Log) "

if($LogPath -eq "") #
{
    $LogPath = "D:\Program Files\Nice System\Log"
    Write-Host ->"Chemin source :" $LogPath
}


$ChoosenDate = Read-Host "Entrer la date a laquelle recuperer les logs"
$ChoosenDate= Get-Date $ChoosenDate -format "dd-MM-yyyy"
$date = Get-Date -format "dd-MM-yyyy"
Write-Host = "Date du jour :" $date
Write-Host = "Date choisie :" $ChoosenDate "`n"

$ChoosenPath = Read-Host "Entrer le chemin destination des fichiers`n->"

Write-Host "`nCopie des elements suivants :`n---------------------------------"

if((Test-Path "$ChoosenPath\LogCopied_$date") -ne $true ) #Verif du chemin de destination sinon création d'un dossier logcopied avec la date d'auj
{
    New-Item -Path $ChoosenPath -Name "LogCopied_$date" -ItemType "directory"
}

Copy-LogInTree -FChoosenPath $ChoosenPath\LogCopied_$date -FLogPath $LogPath

<#
Write-Host "`nSuppressions des fichiers suivant deja present:"
$MonDossier_Clear = Get-ChildItem -Path $ChoosenPath\LogCopied_$date -Recurse -file | Where{$_.LastWriteTime.day -eq $ChoosenDate.day -and $_.LastWriteTime.month -eq $ChoosenDate.month -and $_.LastWriteTime.year -eq $ChoosenDate.year} #On récupère la liste des fichiers de ce répertoire
foreach ($MonFichier_Clear in $MonDossier_Clear)
{
    Write-Host $MonFichier_Clear.FullName
    Remove-Item -Path $ChoosenPath\LogCopied_$date\$($MonFichier_Clear.Name)
	Write-Host "A ete Suprimmed $($MonFichier_Clear.Name) / $($MonFichier_Clear.LastWriteTime) `n" #On affiche le nom du fichier ainsi que son chemin d'accès complet
}
#>

<#
Write-Host "`nCopie des fichiers suivant :"
$MonFolder = Get-ChildItem -Path $LogPath -Recurse -file -Verbose | Where{$_.LastWriteTime.day -eq $ChoosenDate.day -and $_.LastWriteTime.month -eq $ChoosenDate.month -and $_.LastWriteTime.year -eq $ChoosenDate.year} #On récupère la liste des fichiers de ce répertoire
foreach ($MyFile in $MonFolder)
{
    #Copy-item $MonFolder.FullName -Destination $ChoosenPath\LogCopied_$date -filter{PSIsContainer} -Force
    Write-Host $MonFolder"`n"

    Write-Host $MyFile.FullName
    Copy-item $Myfile.FullName -Destination $ChoosenPath\LogCopied_$date -Force
    Write-Host "A ete Copied $($MyFile.Name) / $($MyFile.LastWriteTime)`n" 

}
#>



