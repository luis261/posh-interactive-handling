function Handle-Interactively {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline=$true)]
        $ExecutionTarget,
        [bool]
        $Bypass=$false
    )

    if ($Bypass) {
        Invoke-Command $ExecutionTarget
        return
    }

    ([string]$ExecutionTarget).Split([Environment]::NewLine, [System.StringSplitOptions]::RemoveEmptyEntries) | ForEach-Object {
        try {
            $LineToInvoke = $_.Trim()
            # add line to history (before even executing it) to provide a shortcut for the user when amending failed commands (instead of having to search for and paste the previous command)
            [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($LineToInvoke)
            Invoke-Expression $LineToInvoke
        } catch {
            Write-Host -Object 'An error occurred, prompting user for interactive handling' -ForeGroundColor 'red'
            Write-Warning $_.Exception.Message
            Write-Warning "This was the offending line: $LineToInvoke"

            if(-Not $PSCmdlet.ShouldContinue('Do you want the script to proceed? : [Y] yes, continue directly without handling; [N] no, terminate script; [S] suspend script and gain prompt for adhoc handling (you can resume the script and return to this prompt via typing "exit" later)', 'Prompt for interactive error handling')) {
                throw 'Stopping the script as requested by the user'
            }
        }
    }
}
