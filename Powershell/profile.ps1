Import-Module -Name Microsoft.WinGet.CommandNotFound

remove-alias ls

$env:EDITOR="vim"

function Get-VisibleLength {
    param (
	[string]$str
    )

    # Return visible length of string (Without escape codes)
    return ($str -replace "`e\[.*?m", "").Length
}

function Convert-FileSize {
    param (
        [Parameter(Mandatory=$true)]
        [int64]$size
    )

    if ($size -ge 107374182) {
        return "{0,-5:N1} GB" -f ($size / 1GB)
    }
    elseif ($size -ge 102400) {
        return "{0,-5:N1} MB" -f ($size / 1MB)
    }
    elseif ($size -ge 102) {
        return "{0,-5:N1} KB" -f ($size / 1KB)
    }
    else {
        return "{0,-5:N1}  B" -f $size
    }
}

function ls {
    param (
	[Parameter(Mandatory=$true)]
	[string]$path,

	[switch]$a  # "a" is short for "all" (similar to 'ls -a' on unix)
    )
    
    # Get a list of files in current directory
    $items = Get-ChildItem -Path $path -Force:$a | Sort-Object LastWriteTime

    if (-not $items) {
        Write-Host "No items found."
        return
    }

    # Manually set column widths
    $widthDate = 19
    $widthMode = 5
    
    # Calculate max width for filenames and sizes dynamically (Ignore ANSI escape codes by using Get-VisibleLength)
    $maxNameLength = ($items.Name | ForEach-Object { Get-VisibleLength $_ }) | Measure-Object -Maximum
    $maxSizeLength = ($items.Size | Where-Object { $_.PSIsContainer -eq $false } | ForEach-Object { (Convert-FileSize $_).Length }) | Measure-Object -Maximum
    $widthName = [Math]::Max($maxNameLength.Maximum, 10) # Ensure name column is at least 10 characters wide
    $widthSize = [Math]::Max($maxSizeLength.Maximum, 8)  # Ensure size column is at least 8 characters wide

    # ANSI Colors
    $colorDefault = "`e[39m"
    $colorReset = "`e[0m"
    $colorSeparator = "`e[32m"
    $colorDir = "`e[44m"

    # Create the header with dynamic spacing
    $format = "{0,-$widthDate} $colorSeparator¦$colorDefault {1,-$widthMode} $colorSeparator¦$colorDefault {2,-$widthName} $colorSeparator¦$colorDefault {3,-$widthSize}"
    $header = $format -f "LastWriteTime", "Mode", "Name", "Size"
    $separator = "-" * (Get-VisibleLength $header)

    # Print header and separator
    Write-Host "`n $header"
    Write-Host " $colorSeparator$separator$colorDefault"

    # Print each item with formatting
    foreach ($item in $items) {
	if ($item.PSIsContainer) {
            $formattedSize = "<DIR>"

	    Write-Host "" $colorDir$($format -f $item.LastWriteTime.ToString("MM/dd/yyyy HH:mm:ss"), $item.Mode, $item.Name, $formattedSize)$colorReset
	} else {
	    $formattedSize = (Convert-FileSize $item.Length)

	    Write-Host "" ($format -f $item.LastWriteTime.ToString("MM/dd/yyyy HH:mm:ss"), $item.Mode, $item.Name, $formattedSize)
	}
	
    }
    Write-Host ""
}

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
