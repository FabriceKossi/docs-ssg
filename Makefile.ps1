# Déclaration des variables d'installation
$nodeUrl = "https://nodejs.org/dist/v20.11.1/node-v20.11.1-x64.msi"
$installerPath = "$env:TEMP\node-lts.msi"

function Install-NodeJS {
    param (
        [string]$url,
        [string]$outputPath
    )
    # Vérification de la validité de l'URL
    if (-not $url) {
        Write-Host "❌ L'URL de téléchargement de Node.js est invalide."
        exit 1
    }
    # Téléchargement de l'installateur
    Write-Host "Téléchargement de Node.js LTS depuis $nodeUrl..."
    Invoke-WebRequest -Uri $nodeUrl -OutFile $outputPath
    if (-not (Test-Path $outputPath)) {
        Write-Host "❌ L'installateur de Node.js n'a pas été téléchargé correctement."
        exit 1
    }
    # Installation de Node.js
    Write-Host "Installation de Node.js..."
    Start-Process msiexec.exe -Wait -ArgumentList @("/i", $outputPath, "/qn", "/norestart")
    # Nettoyage de l'installateur
    Write-Host "Nettoyage de l'installateur..."
    Remove-Item $outputPath -Force
    # Vérification de l'installation
    $nodeVersion = node -v
    $npmVersion = npm -v
    if ($nodeVersion -eq $null -or $npmVersion -eq $null) {
        Write-Host "❌ L'installation de Node.js a échoué."
        exit 1
    } else {
        Write-Host "✅ Node.js $nodeVersion a été installé avec succès."
    }
    if ($npmVersion -eq $null -or $npmVersion -eq $null) {
        Write-Host "❌ L'installation de npm a échoué."
        exit 1
    } else {
        Write-Host "✅ Npm $npmVersion a été installé avec succès."
    }
}

# Vérification de l'existence de Node.js
if (Get-Command node -ErrorAction SilentlyContinue) {
    Write-Host "Node.js est déjà installé."
} else {
    Write-Host "Node.js n'est pas installé. Début de l'installation..."
    Install-NodeJS -url $nodeUrl -outputPath $installerPath
}

# Vérification de l'existence de yarn...