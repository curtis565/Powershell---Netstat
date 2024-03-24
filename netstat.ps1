$computers = Get-Content -Path "C:\path\to\computer_list.txt"

foreach ($computer in $computers) {
    $result = Invoke-Command -ComputerName $computer -ScriptBlock {
        netstat -aon | Select-String '3389' | ForEach-Object {
            $split = $_ -split '\s+'
            New-Object PSObject -Property @{
                'LocalAddress' = $split[2]
                'ForeignAddress' = $split[3]
                'State' = $split[3]
            }
        }
    } -ErrorAction SilentlyContinue

    if ($result) {
        foreach ($item in $result) {
            Write-Host "$computer has port 3389 open with foreign address $($item.ForeignAddress)"
        }
    } else {
        Write-Host "$computer does not have port 3389 open"
    }
}
