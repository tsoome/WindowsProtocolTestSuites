# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

# [MethodHelp(@"This method is used to restore the Netlogon service on the PDC and TDC")]
#        void RestoreNetlogonService(string pdcName, string tdcName);
#
##get service object
Invoke-Command -Computername $pdcName -Scriptblock { $serviceObj = Get-Service Netlogon
	##Judge the status of service.
	if($serviceObj.Status -eq "Paused")
	{
		Resume-Service -inputObject $serviceObj
	}
	if($serviceObj.Status -eq "Stopped")
	{
		Start-Service -inputObject $serviceObj
	}
	Sleep 10
	do
	{
		Sleep 5
		$serviceObj =Invoke-Command -Computername $pdcName -Scriptblock {Get-Service Netlogon} 
	}While($serviceObj.Status -ne "Running")
	Sleep 10
}
[System.GC]::Collect();
[System.GC]::WaitForPendingFinalizers();
[System.GC]::Collect();

if($tdcName)
{
	##get service object
	Invoke-Command -Computername $tdcName -Scriptblock { $serviceObj = Get-Service Netlogon
		##Judge the status of service.
		if($serviceObj.Status -eq "Paused")
		{
			Resume-Service -inputObject $serviceObj
		}
		if($serviceObj.Status -eq "Stopped")
		{
			Start-Service -inputObject $serviceObj
		}	
		sleep 10
		do{
			Sleep 5
			$serviceObj =Invoke-Command -Computername $tdcName -Scriptblock {Get-Service Netlogon} 
		}While($serviceObj.Status -ne "Running")
		Sleep 10
	}

	[System.GC]::Collect();
	[System.GC]::WaitForPendingFinalizers();
	[System.GC]::Collect();
}
New-Item -Force -ItemType directory -Path c:\temp\
$strFileName="c:\temp\changednetlogonservicestatus.txt"
If (Test-Path $strFileName)
{
    Remove-Item $strFileName
}