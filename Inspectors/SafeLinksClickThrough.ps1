﻿$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-SafeLinksClickThrough {
Try {

	Try {
		$click_through_policies = Get-SafeLinksPolicy
		$flag = $false

		If ($click_through_policies.AllowClickThrough -eq $false) {
			return $null
		}
		Else {
			$flag = $true
		}
	} Catch [System.Management.Automation.CommandNotFoundException] {
		return $null
	}
	
	If ($flag -eq $true) {
		return "$($click_through_policies.Name): $($click_through_policies.AllowClickThrough)" 
	}
	return $null

}
Catch {
Write-Warning "Error message: $_"
$message = $_.ToString()
$exception = $_.Exception
$strace = $_.ScriptStackTrace
$failingline = $_.InvocationInfo.Line
$positionmsg = $_.InvocationInfo.PositionMessage
$pscommandpath = $_.InvocationInfo.PSCommandPath
$failinglinenumber = $_.InvocationInfo.ScriptLineNumber
$scriptname = $_.InvocationInfo.ScriptName
Write-Verbose "Write to log"
Write-ErrorLog -message $message -exception $exception -scriptname $scriptname
Write-Verbose "Errors written to log"
}

}

return Inspect-SafeLinksClickThrough


