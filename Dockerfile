FROM microsoft/windowsservercore
LABEL maintainer="fellipef"

SHELL ["powershell"]

RUN Invoke-WebRequest "https://download.microsoft.com/download/E/E/D/EEDF18A8-4AED-4CE0-BEBE-70A83094FC5A/BuildTools_Full.exe" -OutFile "$env:TEMP\BuildTools_Full.exe" -UseBasicParsing
RUN &  "$env:TEMP\BuildTools_Full.exe" /Silent /Full

# Note:.NET + ASP.NET
RUN Install-WindowsFeature NET-Framework-45-ASPNET ; \
    Install-WindowsFeature Web-Asp-Net45

#NuGet
RUN Invoke-WebRequest "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" -OutFile "C:\windows\nuget.exe" -UseBasicParsing
WORKDIR "C:\Program Files (x86)\MSBuild\Microsoft\VisualStudio\v12.0"

#Install Web Targets
RUN &  "C:\windows\nuget.exe" Install MSBuild.Microsoft.VisualStudio.Web.targets -Version 12.0.4
RUN mv "C:\Program Files (x86)\MSBuild\Microsoft\VisualStudio\v12.0\MSBuild.Microsoft.VisualStudio.Web.targets.12.0.4\tools\VSToolsPath\*" "C:\Program Files (x86)\MSBuild\Microsoft\VisualStudio\v12.0"

#Msbuild to path
RUN setx PATH '%PATH%;C:\\Program Files (x86)\\MSBuild\\12.0\\Bin\\msbuild.exe'
CMD ["C:\\Program Files (x86)\\MSBuild\\12.0\\Bin\\msbuild.exe"]