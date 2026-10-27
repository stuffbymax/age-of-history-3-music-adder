param (
    [string]$Path = "."
)

Get-ChildItem -Path $Path -Recurse -Force |
    Sort-Object { $_.FullName.Length } -Descending |
    ForEach-Object {
        $newName = $_.Name -replace '[ -]', '_'

        if ($newName -ne $_.Name) {
            Rename-Item -LiteralPath $_.FullName -NewName $newName
            Write-Host "Renamed: $($_.Name) -> $newName"
        }
    }