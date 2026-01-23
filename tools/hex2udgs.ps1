# Hex file passed in as parameter
param (
    [string]$hexFile
)

# Read all lines
$lines = Get-Content $hexFile

# Storage for bytes
$bytes = @()

foreach ($line in $lines) {
    # Only process data records (start with ":")
    if ($line.StartsWith(":")) {
        $recordType = $line.Substring(7,2)
        if ($recordType -eq "00") {
            # Extract the data portion
            $byteCount = [Convert]::ToInt32($line.Substring(1,2),16)
            $dataField = $line.Substring(9, $byteCount * 2)
            for ($i=0; $i -lt $dataField.Length; $i+=2) {
                $byteHex = $dataField.Substring($i,2)
                $bytes += [int]("0x$byteHex")
            }
        }
    }
}

# Output BASIC DATA statements
Write-Output ("") #newline
Write-Output ("# load user defined graphics")
Write-Output ("@loadudgs:")
Write-Output ("RESTORE @udgs")
Write-Output ("LET i=USR ""a"":LET z=i+8*" + ($bytes.Count/8) + "-1:FOR x=i TO z:READ y:POKE x,y:NEXT x")
Write-Output ("RETURN")
Write-Output ("@udgs:")
$groupSize = 8
for ($i = 0; $i -lt $bytes.Count; $i += $groupSize) {
    $group = $bytes[$i..([Math]::Min($i+$groupSize-1, $bytes.Count-1))]
    Write-Output ("DATA " + ($group -join ","))
}