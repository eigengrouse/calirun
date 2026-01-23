param(
    # One or more .hex files. Supports wildcards like .\build\*.hex
    [Parameter(Mandatory=$true, Position=0, ValueFromRemainingArguments=$true)]
    [string[]]$hexFiles
)

# Storage for all bytes across all files
$bytes = @()

# Optional: track where each file starts within the combined blob (for later use)
$routineIndex = @()  # array of PSCustomObjects: File, StartOffset, ByteCount

foreach ($hexFile in $hexFiles) {
    if (-not (Test-Path -LiteralPath $hexFile)) {
        throw "File not found: $hexFile"
    }

    $startOffset = $bytes.Count

    # Read all lines
    $lines = Get-Content -LiteralPath $hexFile

    foreach ($line in $lines) {
        # Only process Intel HEX records
        if ($line.StartsWith(":")) {
            $recordType = $line.Substring(7,2)
            if ($recordType -eq "00") {
                # Extract the data portion
                $byteCount = [Convert]::ToInt32($line.Substring(1,2),16)
                $dataField = $line.Substring(9, $byteCount * 2)

                for ($i = 0; $i -lt $dataField.Length; $i += 2) {
                    $byteHex = $dataField.Substring($i,2)
                    $bytes += [int]("0x$byteHex")
                }
            }
        }
    }

    $routineIndex += [pscustomobject]@{
        File       = $hexFile
        StartOffset= $startOffset
        ByteCount  = ($bytes.Count - $startOffset)
    }
}

# Build output lines (so we can either Write-Output or write to a file)
$out = New-Object System.Collections.Generic.List[string]

$out.Add("") # newline
$out.Add("# machine code routines")
$out.Add("@loadroutines:")
$out.Add("RESTORE @routines")
$out.Add("FOR x = 1 TO $($bytes.Count) : READ y : POKE x+61439, y : NEXT x")
# use routine index and offset to store addresses
$i = 0
foreach ($r in $routineIndex) {
    $out.Add("LET r" + ++$i + " = " + (61440 + $r.StartOffset) + " : REM " + $r.File)
}
$out.Add("RETURN") # TODO: GO SUB and RETURN causing error, why?
$out.Add("@routines:")

# split data statements by routines
$groupSize = 16
foreach ($r in $routineIndex) {
    $out.Add("# " + $r.File)
    for ($i = $r.StartOffset; $i -lt ($r.StartOffset + $r.ByteCount); $i += $groupSize) {
        $end = [Math]::Min($i + $groupSize - 1,($r.StartOffset + $r.ByteCount) - 1)
        $group = $bytes[$i..$end]
        $out.Add("DATA " + ($group -join ","))
    }
}

# Emit
$out
