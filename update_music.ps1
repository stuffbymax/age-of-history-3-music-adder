$MusicFolder = $PSScriptRoot

# Back up the existing lists before running this script.
$Extensions = @(".ogg")

# Rename actual music files: spaces -> underscores
Get-ChildItem -LiteralPath $MusicFolder -File |
    Where-Object { $Extensions -contains $_.Extension.ToLower() } |
    ForEach-Object {
        $NewName = $_.Name -replace ' ', '_'

        if ($NewName -ne $_.Name) {
            $Target = Join-Path $MusicFolder $NewName

            if (Test-Path -LiteralPath $Target) {
                Write-Warning "Skipping rename because target exists: $NewName"
            }
            else {
                Rename-Item -LiteralPath $_.FullName -NewName $NewName
            }
        }
    }

# Read the final, actual filenames
$MusicFiles = @(
    Get-ChildItem -LiteralPath $MusicFolder -File |
        Where-Object { $_.Extension.ToLower() -eq ".ogg" } |
        Sort-Object Name
)

# Build semicolon-separated lists
$AllMusic = ($MusicFiles.Name -join ";") + ";"

$WarMusic = @(
    $MusicFiles |
        Where-Object { $_.BaseName -match "war" } |
        ForEach-Object { $_.Name }
)

$WarList = ($WarMusic -join ";") + ";"

# Write without a BOM or newline
$Encoding = [System.Text.Encoding]::ASCII

[System.IO.File]::WriteAllText(
    (Join-Path $MusicFolder "list.txt"),
    $AllMusic,
    $Encoding
)

[System.IO.File]::WriteAllText(
    (Join-Path $MusicFolder "listWar.txt"),
    $WarList,
    $Encoding
)

Write-Host "Normal music tracks: $($MusicFiles.Count)"
Write-Host "War music tracks: $($WarMusic.Count)"
Write-Host "Finished. Restart the game and test the music."