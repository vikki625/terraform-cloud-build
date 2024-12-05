# Function to check if a command exists
function Command-Exists {
    param (
        [string]$command
    )
    $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
}

# Function to install Google Cloud SDK
function Install-GCloud {
    Write-Output "Installing Google Cloud SDK..."
    if (Command-Exists gcloud) {
        Write-Output "Google Cloud SDK is already installed."
    } else {
        Invoke-WebRequest -Uri "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-$(Invoke-RestMethod -Uri https://dl.google.com/dl/cloudsdk/channels/rapid/components-2.json | Select-String -Pattern '(?<=version": ")[^"]*').Matches.Value).zip" -OutFile "google-cloud-sdk.zip"
        Expand-Archive -Path "google-cloud-sdk.zip" -DestinationPath "."
        Start-Process -FilePath ".\google-cloud-sdk\install.bat" -ArgumentList "--quiet" -NoNewWindow -Wait
        $env:Path += ";$PWD\google-cloud-sdk\bin"
        if (Command-Exists gcloud) {
            Write-Output "Google Cloud SDK installed successfully."
        } else {
            Write-Error "Failed to install Google Cloud SDK."
            exit 1
        }
    }
}

# Function to install Terraform
function Install-Terraform {
    Write-Output "Installing Terraform..."
    if (Command-Exists terraform) {
        Write-Output "Terraform is already installed."
    } else {
        $version = (Invoke-RestMethod -Uri https://releases.hashicorp.com/terraform/ | Select-String -Pattern 'terraform/\K[0-9]+\.[0-9]+\.[0-9]+' -AllMatches).Matches.Value | Select-Object -First 1
        Invoke-WebRequest -Uri "https://releases.hashicorp.com/terraform/$version/terraform_${version}_windows_amd64.zip" -OutFile "terraform.zip"
        Expand-Archive -Path "terraform.zip" -DestinationPath "."
        Move-Item -Path ".\terraform.exe" -Destination "C:\Windows\System32\"
        if (Command-Exists terraform) {
            Write-Output "Terraform installed successfully."
        } else {
            Write-Error "Failed to install Terraform."
            exit 1
        }
    }
}

# Function to install Firebase CLI
function Install-Firebase {
    Write-Output "Installing Firebase CLI..."
    if (Command-Exists firebase) {
        Write-Output "Firebase CLI is already installed."
    } else {
        if (Command-Exists npm) {
            npm install -g firebase-tools --silent
        } else {
            Write-Output "npm is not installed. Installing npm..."
            Invoke-WebRequest -Uri "https://nodejs.org/dist/latest/node-v$(Invoke-RestMethod -Uri https://nodejs.org/dist/latest/ | Select-String -Pattern 'node-v\K[0-9]+\.[0-9]+\.[0-9]+' -AllMatches).Matches.Value-win-x64.msi" -OutFile "nodejs.msi"
            Start-Process -FilePath "msiexec.exe" -ArgumentList "/i nodejs.msi /quiet" -NoNewWindow -Wait
            npm install -g firebase-tools --silent
        }
        if (Command-Exists firebase) {
            Write-Output "Firebase CLI installed successfully."
        } else {
            Write-Error "Failed to install Firebase CLI."
            exit 1
        }
    }
}

# Main script execution
Install-GCloud
Install-Terraform
Install-Firebase

Write-Output "All installations completed successfully."
