!include "common.nsh"
!include "MUI2.nsh"
!include "multiUser.nsh"
!include "allowOnlyOneInstallerInstace.nsh"

!ifdef ONE_CLICK
  !include "oneClick.nsh"
!else
  !include "boringInstaller.nsh"
!endif

!ifmacrodef customHeader
  !insertmacro customHeader
!endif

Var startMenuLink
Var desktopLink

!ifdef BUILD_UNINSTALLER
  SilentInstall silent
!endif

Function .onInit
  !ifdef BUILD_UNINSTALLER
    WriteUninstaller "${UNINSTALLER_OUT_FILE}"
    # avoid exit code 2
    SetErrorLevel 0
    Quit
  !else
    !insertmacro check64BitAndSetRegView
    !insertmacro initMultiUser

    !ifdef ONE_CLICK
      !insertmacro ALLOW_ONLY_ONE_INSTALLER_INSTACE
    !else
      ${IfNot} ${UAC_IsInnerInstance}
        !insertmacro ALLOW_ONLY_ONE_INSTALLER_INSTACE
      ${EndIf}
    !endif

    InitPluginsDir

    SetCompress off
    !ifdef APP_32
      File /oname=$PLUGINSDIR\app-32.7z "${APP_32}"
    !endif
    !ifdef APP_64
      File /oname=$PLUGINSDIR\app-64.7z "${APP_64}"
    !endif
    SetCompress "${COMPRESS}"

    !ifdef HEADER_ICO
      File /oname=$PLUGINSDIR\installerHeaderico.ico "${HEADER_ICO}"
    !endif

    !ifmacrodef customInit
      !insertmacro customInit
    !endif
  !endif
FunctionEnd

Section "install"
  !ifndef BUILD_UNINSTALLER
    !include "install.nsh"
  !endif
SectionEnd

!ifdef BUILD_UNINSTALLER
  !include "uninstaller.nsh"
!endif