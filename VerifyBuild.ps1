﻿#*******************************************************************************
#     Author: Mick Pletcher
#     Date: 25 November 2013
#
#     Program: Check Build
#*******************************************************************************

Clear-Host

#Declare Global Memory
$app = ,@()
Set-Variable -Name Count -Scope Global -Value 1 -Force
Set-Variable -Name OS -Scope Global -Force
Set-Variable -Name RelativePath -Scope Global -Force

Function RenameWindow ($Title) {

	#Declare Local Memory
	Set-Variable -Name a -Scope Local -Force
	
	$a = (Get-Host).UI.RawUI
	$a.WindowTitle = $Title
	
	#Cleanup Local Memory
	Remove-Variable -Name a -Scope Local -Force
}

Function AppInstalled($Description) {

	#Declare Local Memory
	Set-Variable -Name AppName -Scope Local -Force
	Set-Variable -Name AppLocal -Scope Local -Force
	Set-Variable -Name Desc -Scope Local -Force
	Set-Variable -Name Output -Scope Local -Force
	
	$object = New-Object -TypeName PSObject
	#Change '%application%' to whatever app you are calling
	$Desc = [char]34+"description like"+[char]32+[char]39+[char]37+$Description+[char]37+[char]39+[char]34
	$Output = wmic product where $Desc get Description
	$Output | ForEach-Object {
		$_ = $_.Trim()
    		if(($_ -ne "Description")-and($_ -ne "")){
     	   	$AppName = $_
    		}
	}
	$AppLocal = New-Object System.Object
	$AppLocal | Add-Member -type NoteProperty -name Application -value $Description
	If ($AppName -ne $null) {
		#$Global:app+=,@($Description,"Installed")
		$AppLocal | Add-Member -type NoteProperty -name Status -value "Installed"
		
	} else {
		#$Global:app+=,@($Description,"Not Installed")
		$AppLocal | Add-Member -type NoteProperty -name Status -value "Not Installed"
	}
	$Global:app += $AppLocal
	$AppLocal | Select Application
	$Global:Count++

	#Cleanup Local Memory
	Remove-Variable -Name AppName -Scope Local -Force
	Remove-Variable -Name AppLocal -Scope Local -Force
	Remove-Variable -Name Desc -Scope Local -Force
	Remove-Variable -Name Output -Scope Local -Force
	
}

cls
Write-Host "Processing Applications"
Write-Host
RenameWindow "Check Build Installs"
AppInstalled "Dell Client System Update"
AppInstalled "Adobe Reader"
AppInstalled "Microsoft Lync"
AppInstalled "Remote Desktop"
AppInstalled "Interactive Admin"
AppInstalled "RunAs Admin"
AppInstalled "Windows Backup"
cls
Write-Host "Installation Report"
Write-Host
$app | Format-Table

#Cleanup Global Memory
$app.Clear()
Remove-Variable -Name Count -Scope Global -Force
Remove-Variable -Name OS -Scope Global -Force
Remove-Variable -Name RelativePath -Scope Global -Force
