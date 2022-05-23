{==============================================================================
   ___              __   ___    _
  / __|__ _ _ __  __\ \ / (_)__(_)___ _ _
 | (_ / _` | '  \/ -_) V /| (_-< / _ \ ' \
  \___\__,_|_|_|_\___|\_/ |_/__/_\___/_||_|
                  Toolkit™

 Copyright © 2022 tinyBigGAMES™ LLC
 All Rights Reserved.

 Website: https://tinybiggames.com
 Email  : support@tinybiggames.com

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software in
   a product, an acknowledgment in the product documentation would be
   appreciated but is not required.

2. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

3. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in
   the documentation and/or other materials provided with the
   distribution.

4. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived
   from this software without specific prior written permission.

5. All video, audio, graphics and other content accessed through the
   software in this distro is the property of the applicable content owner
   and may be protected by applicable copyright law. This License gives
   Customer no rights to such content, and Company disclaims any liability
   for misuse of content.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
============================================================================= }

unit GameVision.Util;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  WinApi.Windows;

type
  { TGVEaseType }
  TGVEaseType = (etLinearTween, etInQuad, etOutQuad, etInOutQuad, etInCubic,
    etOutCubic, etInOutCubic, etInQuart, etOutQuart, etInOutQuart, etInQuint,
    etOutQuint, etInOutQuint, etInSine, etOutSine, etInOutSine, etInExpo,
    etOutExpo, etInOutExpo, etInCircle, etOutCircle, etInOutCircle);

  { TGVUtil }
  TGVUtil = record
  private
  public
    class function  GetLastOSError: string; static;
    class function  RemoveQuotes(const aText: string): string; static;
    class procedure GotoURL(const aURL: string); static;
    class procedure ShellRun(const aFilename: string; const aParams: string; const aDir: string; aHide: Boolean); static;
    class function  CreateDirsInPath(const aPath: string): Boolean; static;
    class procedure DeferDelFile(const aFilename: string); static;
    class procedure LoadDefaultIcon(aWnd: HWND); static;
    class function  ResourceExists(aInstance: THandle; const aResName: string): Boolean; static;
    class procedure LoadStringListFromResource(const aResName: string; aList: TStringList); static;
    class function  LoadStringFromResource(const aResName: string): string; static;
    class procedure ClearKeyboardBuffer; static;
    class procedure ClearMouseClickBuffer; static;
    class procedure CryptBuffer(const aBuffer: PByte; aLength: Cardinal; const aPassword: string; aToCrypt: Boolean); static;
    class function  GetPackedVersion(aVersion: UInt32): string; static;
    class procedure ProcessMessages; static;
    class function  MicrosecondsToSeconds(aTime: Double): Double; static;
    class function  MillisecondsToSeconds(aTime: Double): Double; static;
    class function  BeatsPerSecondToSeconds(aTime: Double): Double; static;
    class function  BeatsPerMinutoToSeconds(aTime: Double): Double; static;
    class procedure WriteStringToStream(const aStream: TStream; const aStr: string); static;
    class function  ReadStringFromStream(const aStream: TStream): string; static;
    class function  FileCount(const aPath: string; const aSearchMask: string): Int64; static;
    class function  FindLastWrittenFile(const aDir: string; const aSearch: string): string; static;
    class function  IsSingleInstance(aMutexName: string; aKeepMutex: Boolean=True): Boolean; static;
    class function  GetEnvVarValue(const aVarName: string): string; static;
    class function  SetEnvVarValue(const aVarName, aVarValue: string): Integer; static;
    class function  GetModuleVersionFullStr: string; overload; static;
    class function  GetModuleVersionFullStr(const aFilename: string): string; overload; static;
    class function  GetAppVersionStr: string; static;
    class function  GetAppVersionFullStr: string; static;
    class function  GetAppName: string; static;
    class function  GetAppPath: string; static;
    class function  GetCPUCount: Integer; static;
    class procedure GetDiskFreeSpace(const aPath: string; var aFreeSpace: Int64; var aTotalSpace: Int64); static;
    class function  GetOSVersion: string; static;
    class procedure GetMemoryFree(var aAvailMem: UInt64; var aTotalMem: UInt64); static;
    class function  GetVideoCardName: string; static;
    class function  EncryptString(const aValue: string; const aPassword: string; aEncryp: Boolean): string; static;
    class function  StringMacro(const aString: string; const aMacro: string; const aValue: string; const aPrefix: string='&'; const aPostfix: string=''): string; overload; static;
    class function  StringMacro(const aString: string; const aMacro: string; const aValue: Int64; const aPrefix: string='&'; const aPostfix: string=''): string; overload; static;
    class function  StringMacro(const aString: string; const aMacro: string; const aValue: UInt64; const aPrefix: string='&'; const aPostfix: string=''): string; overload; static;
    class function  StringMacro(const aString: string; const aMacro: string; const aValue: Double; const aPrefix: string='&'; const aPostfix: string=''): string; overload; static;
    class function  EaseValue(aCurrentTime: Double; aStartValue: Double; aChangeInValue: Double; aDuration: Double; aEaseType: TGVEaseType): Double; static;
    class function  EasePosition(aStartPos: Double; aEndPos: Double; aCurrentPos: Double; aEaseType: TGVEaseType): Double; static;
    class function URLEncode(const Url: string): string; static;
    class function URLEncodeTilde(const Url: string): string; static;
    class function HTTPEncode(const AStr: ansistring): AnsiString; static;
    class function URLEncodeRFC3986(URL: string): string; static;
    class function EncodeParams(Params: TStringList; splitter: string; quot: Boolean; encodeHttp: Boolean = false): string; static;

  end;

implementation

uses
  System.IOUtils,
  System.Win.ComObj,
  System.Variants,
  System.Math,
  VCL.Graphics,
  WinApi.Messages,
  WinApi.ShellAPI,
  WinApi.ActiveX;

class function  TGVUtil.GetLastOSError: string;
begin
  Result := SysErrorMessage(WinAPI.Windows.GetLastError);
end;

class function TGVUtil.RemoveQuotes(const aText: string): string;
var
  LText: string;
begin
  LText := AnsiDequotedStr(aText, '"');
  Result := AnsiDequotedStr(LText, '''');
end;

class procedure TGVUtil.GotoURL(const aURL: string);
begin
  if aURL.IsEmpty then Exit;
  ShellExecute(0, 'OPEN', PChar(aURL), '', '', SW_SHOWNORMAL);
end;

class procedure TGVUtil.ShellRun(const aFilename: string; const aParams: string; const aDir: string; aHide: Boolean);
var
  LShowCmd: Integer;
  LFilename: string;
begin
  LFilename := RemoveQuotes(aFilename);
  if LFilename.IsEmpty then Exit;
  if aHide then
    LShowCmd := SW_HIDE
  else
    LShowCmd := SW_SHOWNORMAL;
  ShellExecute(0, 'OPEN', PChar(aFilename), PChar(aParams), PChar(aDir), LShowCmd);
end;

class function TGVUtil.CreateDirsInPath(const aPath: string): Boolean;
var
  LPath: string;
begin
  Result := False;

  if aPath = '' then Exit;

  LPath := TPath.GetDirectoryName(aPath);
  if LPath = '' then Exit;

  TDirectory.CreateDirectory(LPath);

  Result := TDirectory.Exists(LPath);
end;

class procedure TGVUtil.DeferDelFile(const aFilename: string);
var
  LCode: TStringList;
  LFilename: string;

  procedure C(const aMsg: string; const aArgs: array of const);
  var
    LLine: string;
  begin
    LLine := Format(aMsg, aArgs);
    LCode.Add(LLine);
  end;

begin
  if aFilename.IsEmpty then Exit;
  LFilename := ChangeFileExt(aFilename, '');
  LFilename := LFilename + '_DeferDelFile.bat';

  LCode := TStringList.Create;
  try
    C('@echo off', []);
    C(':Repeat', []);
    C('del "%s"', [aFilename]);
    C('if exist "%s" goto Repeat', [aFilename]);
    C('del "%s"', [LFilename]);
    LCode.SaveToFile(LFilename);
  finally
    FreeAndNil(LCode);
  end;

  if FileExists(LFilename) then
  begin
    ShellExecute(0, 'open', PChar(LFilename), nil, nil, SW_HIDE);
  end;
end;


class procedure TGVUtil.LoadDefaultIcon(aWnd: HWND);
var
  LHnd: THandle;
  LIco: TIcon;
begin
  LHnd := GetModuleHandle(nil);
  if LHnd <> 0 then
  begin
    if FindResource(LHnd, 'MAINICON', RT_GROUP_ICON) <> 0 then
    begin
      LIco := TIcon.Create;
      LIco.LoadFromResourceName(LHnd, 'MAINICON');
      SendMessage(aWnd, WM_SETICON, ICON_BIG, LIco.Handle);
      FreeAndNil(LIco);
      //Application.ProcessMessages;
    end;
  end;
end;

class function TGVUtil.ResourceExists(aInstance: THandle; const aResName: string): Boolean;
begin
  Result := Boolean((FindResource(aInstance, PChar(aResName), RT_RCDATA) <> 0));
end;

class procedure TGVUtil.LoadStringListFromResource(const aResName: string; aList: TStringList);
var
  LStream: TResourceStream;
begin
  if not ResourceExists(HInstance, aResName) then Exit;
  LStream := TResourceStream.Create(HInstance, aResName, RT_RCDATA);
  try
    aList.LoadFromStream(LStream);
  finally
    FreeAndNil(LStream);
  end;
end;

class function TGVUtil.LoadStringFromResource(const aResName: string): string;
var
  LStream: TResourceStream;
  LStrList: TStringLIst;
begin
  Result := '';
  if not ResourceExists(HInstance, aResName) then Exit;
  LStream := TResourceStream.Create(HInstance, aResName, RT_RCDATA);
  try
    LStrList := TStringList.Create;
    try
      LStrList.LoadFromStream(LStream);
      Result := LStrList.Text;
    finally
      FreeAndNil(LStrList);
    end;
  finally
    FreeAndNil(LStream);
  end;
end;

class procedure TGVUtil.ClearKeyboardBuffer;
var
  LMsg: TMsg;
begin
  while PeekMessage(LMsg, 0, WM_KEYFIRST, WM_KEYLAST, PM_REMOVE or PM_NOYIELD) do;
end;

class procedure TGVUtil.ClearMouseClickBuffer;
var
  LMsg: TMsg;
begin
  while PeekMessage(LMsg, 0, WM_MOUSEFIRST, WM_MOUSELAST, PM_REMOVE or PM_NOYIELD) do;
end;

const
  ADVAPI32 = 'advapi32.dll';
type
  HCRYPTPROV  = NativeUInt;
  PHCRYPTPROV = ^HCRYPTPROV;
  HCRYPTHASH  = NativeUInt;
  PHCRYPTHASH = ^HCRYPTHASH;
  HCRYPTKEY   = NativeUInt;
  PHCRYPTKEY  = ^HCRYPTKEY;
  ALG_ID      = NativeUInt;
  LPAWSTR     = PWideChar;

function CryptAcquireContext(phProv: PHCRYPTPROV; pszContainer: LPAWSTR; pszProvider: LPAWSTR; dwProvType: DWORD; dwFlags: DWORD): BOOL; stdcall; external ADVAPI32 name 'CryptAcquireContextW';
function CryptCreateHash(hProv: HCRYPTPROV; Algid: ALG_ID; hKey: HCRYPTKEY; dwFlags: DWORD; phHash: PHCRYPTHASH): BOOL; stdcall; external ADVAPI32 name 'CryptCreateHash';
function CryptHashData(hHash: HCRYPTHASH; const pbData: PBYTE; dwDataLen: DWORD; dwFlags: DWORD): BOOL; stdcall; external ADVAPI32 name 'CryptHashData';
function CryptDeriveKey(hProv: HCRYPTPROV; Algid: ALG_ID; hBaseData: HCRYPTHASH; dwFlags: DWORD; phKey: PHCRYPTKEY): BOOL; stdcall; external ADVAPI32 name 'CryptDeriveKey';
function CryptDestroyHash(hHash: HCRYPTHASH): BOOL; stdcall; external ADVAPI32 name 'CryptDestroyHash';
function CryptReleaseContext(hProv: HCRYPTPROV; dwFlags: DWORD): BOOL; stdcall; external ADVAPI32 name 'CryptReleaseContext';
function CryptEncrypt(hKey: HCRYPTKEY; hHash: HCRYPTHASH; Final_: BOOL; dwFlags: DWORD; pbData: PBYTE; pdwDataLen: PDWORD; dwBufLen: DWORD): BOOL; stdcall; external ADVAPI32 name 'CryptEncrypt';
function CryptDecrypt(hKey: HCRYPTKEY; hHash: HCRYPTHASH; Final_: BOOL; dwFlags: DWORD; pbData: PBYTE; pdwDataLen: PDWORD): BOOL; stdcall; external ADVAPI32 name 'CryptDecrypt';

class procedure TGVUtil.CryptBuffer(const aBuffer: PByte; aLength: Cardinal; const aPassword: string; aToCrypt: Boolean);
const
  PROV_RSA_FULL          = 1;
  CRYPT_VERIFYCONTEXT    = $F0000000;
  ALG_CLASS_HASH         = (4 shl 13);
  ALG_TYPE_ANY           = 0;
  ALG_SID_SHA            = 4;
  CALG_SHA               = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_SHA);
  ALG_CLASS_DATA_ENCRYPT = (3 shl 13);
  ALG_TYPE_STREAM        = (4 shl 9);
  ALG_SID_RC4            = 1;
  CALG_RC4               = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_STREAM or ALG_SID_RC4);
var
  LProv: HCRYPTPROV;
  LHash: HCRYPTHASH;
  LKey: HCRYPTKEY;
begin
  //get context for crypt default provider
  CryptAcquireContext(@LProv, nil, nil, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT);

  //create hash-object (SHA algorithm)
  CryptCreateHash(LProv, CALG_SHA, 0, 0, @LHash);

  //get hash from password
  CryptHashData(LHash, @aPassword[1], Length(aPassword), 0);

  //create key from hash by RC4 algorithm
  CryptDeriveKey(LProv, CALG_RC4, LHash, 0, @LKey);

  //destroy hash-object
  CryptDestroyHash(LHash);

  if aToCrypt then
    //crypt buffer
    CryptEncrypt(LKey, 0, True, 0, aBuffer, @aLength, aLength)
  else
    //decrypt buffer
    CryptDecrypt(LKey, 0, True, 0, aBuffer, @aLength);

  //release the context for crypt default provider
  CryptReleaseContext(LProv, 0);
end;

(*
uint32_t version = al_get_allegro_version();
int major = version >> 24;
int minor = (version >> 16) & 255;
int revision = (version >> 8) & 255;
int release = version & 255;
*)
class function TGVUtil.GetPackedVersion(aVersion: UInt32): string;
var
  LMajor: Integer;
  LMinor: Integer;
  LRevision: Integer;
  LRelease: Integer;
begin
  LMajor := aVersion shr 24;
  LMinor := (aVersion shr 16) and 255;
  LRevision := (aVersion shr 8) and 255;
  LRelease := aVersion and 255;
  Result := LMajor.ToString + '.' + LMinor.ToString + '.' + LRevision.ToString + '.' + LRelease.ToString;
end;

class procedure TGVUtil.ProcessMessages;
var
  LMsg: TMsg;
begin
  while Integer(PeekMessage(LMsg, 0, 0, 0, PM_REMOVE)) <> 0 do
  begin
    TranslateMessage(LMsg);
    DispatchMessage(LMsg);
  end;
end;

class function  TGVUtil.MicrosecondsToSeconds(aTime: Double): Double;
begin
  Result := aTime / 1000000.0;
end;

class function  TGVUtil.MillisecondsToSeconds(aTime: Double): Double;
begin
  Result := aTime / 1000.0;
end;

class function  TGVUtil.BeatsPerSecondToSeconds(aTime: Double): Double;
begin
  Result := 1.0 / aTime;
end;

class function  TGVUtil.BeatsPerMinutoToSeconds(aTime: Double): Double;
begin
  Result := 60.0 / aTime;
end;

class procedure TGVUtil.WriteStringToStream(const aStream: TStream; const aStr: string);
var
  LLength: LongInt;
begin
  LLength := Length(aStr);
  aStream.Write(LLength, SizeOf(LLength));
  if LLength > 0 then aStream.Write(aStr[1], LLength * SizeOf(Char));
end;

class function  TGVUtil.ReadStringFromStream(const aStream: TStream): string;
var
  LLength: LongInt;
begin
  aStream.Read(LLength, SizeOf(LLength));
  SetLength(Result, LLength);
  if LLength > 0 then aStream.Read(Result[1], LLength * SizeOf(Char));
end;

(*
class function  TGVUtil.ReadStringFromBuffer(const aBuffer: TGVBuffer): string;
var
  LLength: LongInt;
begin
  aBuffer.Read(@LLength, SizeOf(LLength));
  SetLength(Result, LLength);
  if LLength > 0 then aBuffer.Read(@Result[1], LLength * SizeOf(Char));
end;
*)

class function TGVUtil.FileCount(const aPath: string; const aSearchMask: string): Int64;
var
  LSearchRec: TSearchRec;
  LPath: string;
begin
  Result := 0;
  LPath := aPath;
  LPath := System.IOUtils.TPath.Combine(aPath, aSearchMask);
  if FindFirst(LPath, faAnyFile, LSearchRec) = 0 then
    repeat
      if LSearchRec.Attr <> faDirectory then
        Inc(Result);
    until FindNext(LSearchRec) <> 0;
end;

class function TGVUtil.FindLastWrittenFile(const aDir: string; const aSearch: string): string;
Var
 LSearchRec :TSearchRec;
 LLastWrite: TDateTime;
 LLastWriteAllFiles: TDateTime;
 LDir: string;
begin
 LDir := IncludeTrailingBackslash(aDir);
 LLastWriteAllFiles := 0;
 Result := '';
 if System.SysUtils.FindFirst(LDir+aSearch,faAnyFile-faDirectory,LSearchRec)=0 then
  repeat
   LLastWrite  := LSearchRec.TimeStamp;
   if LLastWrite > LLastWriteAllFiles Then
    begin
     LLastWriteAllFiles := LLastWrite;
     Result := TPath.Combine(LDir, LSearchRec.Name);
    end;
  until System.SysUtils.FindNext(LSearchRec)<>0;
 System.SysUtils.FindClose(LSearchRec);
end;

//Creates a mutex to see if the program is already running.
class function  TGVUtil.IsSingleInstance(aMutexName: string; aKeepMutex: Boolean=True): Boolean;
const
  MUTEX_GLOBAL = 'Global\'; // Prefix to explicitly create the object in the
                            // global or session namespace. I.e. both client
                            // app (local user) and service (system account)
var
  LMutexHandel : THandle;
  LSecurityDesc: TSecurityDescriptor;
  LSecurityAttr: TSecurityAttributes;
  LErrCode : integer;
begin
  //  By default (lpMutexAttributes =nil) created mutexes are accessible only by
  //  the user running the process. We need our mutexes to be accessible to all
  //  users, so that the mutex detection can work across user sessions.
  //  I.e. both the current user account and the System (Service) account.
  //  To do this we use a security descriptor with a null DACL.
  InitializeSecurityDescriptor(@LSecurityDesc, SECURITY_DESCRIPTOR_REVISION);
  SetSecurityDescriptorDacl(@LSecurityDesc, True, nil, False);
  LSecurityAttr.nLength:=SizeOf(LSecurityAttr);
  LSecurityAttr.lpSecurityDescriptor := @LSecurityDesc;
  LSecurityAttr.bInheritHandle:=False;

  //  The mutex is created in the global name space which makes it possible to
  //  access across user sessions.
  LMutexHandel := CreateMutex(@LSecurityAttr, True, PChar(MUTEX_GLOBAL + aMutexName));
  LErrCode := GetLastError;

  //  If the function fails, the return value is 0
  //  If the mutex is a named mutex and the object existed before this function
  //  call, the return value is a handle to the existing object, GetLastError
  //  returns ERROR_ALREADY_EXISTS.
  if {(MutexHandel = 0) or }(LErrCode = ERROR_ALREADY_EXISTS) then
  begin
    Result := false;
    CloseHandle(LMutexHandel);
  end
  else
  begin
    //  Mutex object has not yet been created, meaning that no previous
    //  instance has been created.
    Result := true;

    if not aKeepMutex then
       CloseHandle(LMutexHandel);
  end;

  // The Mutexhandle is not closed because we want it to exist during the
  // lifetime of the application. The system closes the handle automatically
  //when the process terminates.
end;

class function TGVUtil.GetEnvVarValue(const aVarName: string): string;
var
  LBufSize: Integer;  // buffer size required for value
begin
  // Get required buffer size (inc. terminal #0)
  LBufSize := GetEnvironmentVariable(PChar(aVarName), nil, 0);
  if LBufSize > 0 then
  begin
    // Read env var value into result string
    SetLength(Result, LBufSize - 1);
    GetEnvironmentVariable(PChar(aVarName), PChar(Result), LBufSize);
  end
  else
    // No such environment variable
    Result := '';
end;

class function TGVUtil.SetEnvVarValue(const aVarName, aVarValue: string): Integer;
begin
  if SetEnvironmentVariable(PChar(aVarName), PChar(aVarValue)) then
    Result := 0
  else
    Result := GetLastError;
end;

class function TGVUtil.GetModuleVersionFullStr: string;
begin
  Result := GetModuleVersionFullStr(GetModuleName(HInstance));
end;

class function TGVUtil.GetModuleVersionFullStr(const aFilename: string): string;
var
  LExe: string;
  LSize, LHandle: DWORD;
  LBuffer: TBytes;
  LFixedPtr: PVSFixedFileInfo;
begin
  Result := '';
  if not TFile.Exists(aFilename) then Exit;
  LExe := aFilename;
  LSize := GetFileVersionInfoSize(PChar(LExe), LHandle);
  if LSize = 0 then
  begin
    //RaiseLastOSError;
    //no version info in file
    Exit;
  end;
  SetLength(LBuffer, LSize);
  if not GetFileVersionInfo(PChar(LExe), LHandle, LSize, LBuffer) then
    RaiseLastOSError;
  if not VerQueryValue(LBuffer, '\', Pointer(LFixedPtr), LSize) then
    RaiseLastOSError;
  if (LongRec(LFixedPtr.dwFileVersionLS).Hi = 0) and (LongRec(LFixedPtr.dwFileVersionLS).Lo = 0) then
  begin
    Result := Format('%d.%d',
    [LongRec(LFixedPtr.dwFileVersionMS).Hi,   //major
     LongRec(LFixedPtr.dwFileVersionMS).Lo]); //minor
  end
  else if (LongRec(LFixedPtr.dwFileVersionLS).Lo = 0) then
  begin
    Result := Format('%d.%d.%d',
    [LongRec(LFixedPtr.dwFileVersionMS).Hi,   //major
     LongRec(LFixedPtr.dwFileVersionMS).Lo,   //minor
     LongRec(LFixedPtr.dwFileVersionLS).Hi]); //release
  end
  else
  begin
    Result := Format('%d.%d.%d.%d',
    [LongRec(LFixedPtr.dwFileVersionMS).Hi,   //major
     LongRec(LFixedPtr.dwFileVersionMS).Lo,   //minor
     LongRec(LFixedPtr.dwFileVersionLS).Hi,   //release
     LongRec(LFixedPtr.dwFileVersionLS).Lo]); //build
  end;
end;

class function TGVUtil.GetAppVersionStr: string;
var
  LRec: LongRec;
  LVer : Cardinal;
begin
  LVer := System.SysUtils.GetFileVersion(ParamStr(0));
  if LVer <> Cardinal(-1) then
  begin
    LRec := LongRec(LVer);
    Result := Format('%d.%d', [LRec.Hi, LRec.Lo]);
  end
  else Result := '';
end;

class function  TGVUtil.GetAppVersionFullStr: string;
begin
  GetModuleVersionFullStr(ParamStr(0));
end;

class function  TGVUtil.GetAppName: string;
begin
  Result := Format('%s %s',[TPath.GetFileNameWithoutExtension(ParamStr(0)),GetAppVersionFullStr]);
end;

class function  TGVUtil.GetAppPath: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

class function  TGVUtil.GetCPUCount: Integer;
begin
  Result := CPUCount;
end;

class procedure TGVUtil.GetDiskFreeSpace(const aPath: string; var aFreeSpace: Int64; var aTotalSpace: Int64);
begin
  GetDiskFreeSpaceEx(PChar(aPath), aFreeSpace, aTotalSpace, nil);
end;

class function  TGVUtil.GetOSVersion: string;
begin
  Result := TOSVersion.ToString;
end;

class procedure TGVUtil.GetMemoryFree(var aAvailMem: UInt64; var aTotalMem: UInt64);
var
  LMemStatus: MemoryStatusEx;
begin
 FillChar (LMemStatus, SizeOf(MemoryStatusEx), #0);
 LMemStatus.dwLength := SizeOf(MemoryStatusEx);
 GlobalMemoryStatusEx (LMemStatus);
 aAvailMem := LMemStatus.ullAvailPhys;
 aTotalMem := LMemStatus.ullTotalPhys;
end;

class function  TGVUtil.GetVideoCardName: string;
const
  WbemUser = '';
  WbemPassword = '';
  WbemComputer = 'localhost';
  wbemFlagForwardOnly = $00000020;
var
  LFSWbemLocator: OLEVariant;
  LFWMIService: OLEVariant;
  LFWbemObjectSet: OLEVariant;
  LFWbemObject: OLEVariant;
  LEnum: IEnumvariant;
  LValue: LongWord;
begin;
  try
    LFSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    LFWMIService := LFSWbemLocator.ConnectServer(WbemComputer, 'root\CIMV2',
      WbemUser, WbemPassword);
    LFWbemObjectSet := LFWMIService.ExecQuery
      ('SELECT Name,PNPDeviceID  FROM Win32_VideoController', 'WQL',
      wbemFlagForwardOnly);
    LEnum := IUnknown(LFWbemObjectSet._NewEnum) as IEnumvariant;
    while LEnum.Next(1, LFWbemObject, LValue) = 0 do
    begin
      result := String(LFWbemObject.Name);
      LFWbemObject := Unassigned;
    end;
  except
  end;
end;

class function  TGVUtil.EncryptString(const aValue: string; const aPassword: string; aEncryp: Boolean): string;
var
  LStream: TStringStream;
begin
  LStream := TStringStream.Create(aValue);
  CryptBuffer(LStream.Memory, LStream.Size, aPassword, aEncryp);
  Result := LStream.DataString;
  FreeAndNil(LStream);
end;

class function TGVUtil.StringMacro(const aString: string; const aMacro: string; const aValue: string; const aPrefix: string; const aPostfix: string): string;
var
  LMacro: string;
begin
  LMacro := aPrefix + aMacro + aPostfix;
  Result := aString.Replace(LMacro, aValue);
end;

class function TGVUtil.StringMacro(const aString: string; const aMacro: string; const aValue: Int64; const aPrefix: string; const aPostfix: string): string;
var
  LMacro: string;
begin
  LMacro := aPrefix + aMacro + aPostfix;
  Result := aString.Replace(LMacro, aValue.ToString);
end;

class function TGVUtil.StringMacro(const aString: string; const aMacro: string; const aValue: UInt64; const aPrefix: string; const aPostfix: string): string;
var
  LMacro: string;
begin
  LMacro := aPrefix + aMacro + aPostfix;
  Result := aString.Replace(LMacro, aValue.ToString);
end;

class function TGVUtil.StringMacro(const aString: string; const aMacro: string; const aValue: Double; const aPrefix: string; const aPostfix: string): string;
var
  LMacro: string;
begin
  LMacro := aPrefix + aMacro + aPostfix;
  Result := aString.Replace(LMacro, aValue.ToString);
end;

class function TGVUtil.EaseValue(aCurrentTime: Double; aStartValue: Double; aChangeInValue: Double; aDuration: Double; aEaseType: TGVEaseType): Double;
begin
  Result := 0;
  case aEaseType of
    etLinearTween:
      begin
        Result := aChangeInValue * aCurrentTime / aDuration + aStartValue;
      end;

    etInQuad:
      begin
        aCurrentTime := aCurrentTime / aDuration;
        Result := aChangeInValue * aCurrentTime * aCurrentTime + aStartValue;
      end;

    etOutQuad:
      begin
        aCurrentTime := aCurrentTime / aDuration;
        Result := -aChangeInValue * aCurrentTime * (aCurrentTime-2) + aStartValue;
      end;

    etInOutQuad:
      begin
        aCurrentTime := aCurrentTime / (aDuration / 2);
        if aCurrentTime < 1 then
          Result := aChangeInValue / 2 * aCurrentTime * aCurrentTime + aStartValue
        else
        begin
          aCurrentTime := aCurrentTime - 1;
          Result := -aChangeInValue / 2 * (aCurrentTime * (aCurrentTime - 2) - 1) + aStartValue;
        end;
      end;

    etInCubic:
      begin
        aCurrentTime := aCurrentTime / aDuration;
        Result := aChangeInValue * aCurrentTime * aCurrentTime * aCurrentTime + aStartValue;
      end;

    etOutCubic:
      begin
        aCurrentTime := (aCurrentTime / aDuration) - 1;
        Result := aChangeInValue * ( aCurrentTime * aCurrentTime * aCurrentTime + 1) + aStartValue;
      end;

    etInOutCubic:
      begin
        aCurrentTime := aCurrentTime / (aDuration/2);
        if aCurrentTime < 1 then
          Result := aChangeInValue / 2 * aCurrentTime * aCurrentTime * aCurrentTime + aStartValue
        else
        begin
          aCurrentTime := aCurrentTime - 2;
          Result := aChangeInValue / 2 * (aCurrentTime * aCurrentTime * aCurrentTime + 2) + aStartValue;
        end;
      end;

    etInQuart:
      begin
        aCurrentTime := aCurrentTime / aDuration;
        Result := aChangeInValue * aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime + aStartValue;
      end;

    etOutQuart:
      begin
        aCurrentTime := (aCurrentTime / aDuration) - 1;
        Result := -aChangeInValue * (aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime - 1) + aStartValue;
      end;

    etInOutQuart:
      begin
        aCurrentTime := aCurrentTime / (aDuration / 2);
        if aCurrentTime < 1 then
          Result := aChangeInValue / 2 * aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime + aStartValue
        else
        begin
          aCurrentTime := aCurrentTime - 2;
          Result := -aChangeInValue / 2 * (aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime - 2) + aStartValue;
        end;
      end;

    etInQuint:
      begin
        aCurrentTime := aCurrentTime / aDuration;
        Result := aChangeInValue * aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime + aStartValue;
      end;

    etOutQuint:
      begin
        aCurrentTime := (aCurrentTime / aDuration) - 1;
        Result := aChangeInValue * (aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime + 1) + aStartValue;
      end;

    etInOutQuint:
      begin
        aCurrentTime := aCurrentTime / (aDuration / 2);
        if aCurrentTime < 1 then
          Result := aChangeInValue / 2 * aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime + aStartValue
        else
        begin
          aCurrentTime := aCurrentTime - 2;
          Result := aChangeInValue / 2 * (aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime * aCurrentTime + 2) + aStartValue;
        end;
      end;

    etInSine:
      begin
        Result := -aChangeInValue * Cos(aCurrentTime / aDuration * (PI / 2)) + aChangeInValue + aStartValue;
      end;

    etOutSine:
      begin
        Result := aChangeInValue * Sin(aCurrentTime / aDuration * (PI / 2)) + aStartValue;
      end;

    etInOutSine:
      begin
        Result := -aChangeInValue / 2 * (Cos(PI * aCurrentTime / aDuration) - 1) + aStartValue;
      end;

    etInExpo:
      begin
        Result := aChangeInValue * Power(2, 10 * (aCurrentTime/aDuration - 1) ) + aStartValue;
      end;

    etOutExpo:
      begin
        Result := aChangeInValue * (-Power(2, -10 * aCurrentTime / aDuration ) + 1 ) + aStartValue;
      end;

    etInOutExpo:
      begin
        aCurrentTime := aCurrentTime / (aDuration/2);
        if aCurrentTime < 1 then
          Result := aChangeInValue / 2 * Power(2, 10 * (aCurrentTime - 1) ) + aStartValue
        else
         begin
           aCurrentTime := aCurrentTime - 1;
           Result := aChangeInValue / 2 * (-Power(2, -10 * aCurrentTime) + 2 ) + aStartValue;
         end;
      end;

    etInCircle:
      begin
        aCurrentTime := aCurrentTime / aDuration;
        Result := -aChangeInValue * (Sqrt(1 - aCurrentTime * aCurrentTime) - 1) + aStartValue;
      end;

    etOutCircle:
      begin
        aCurrentTime := (aCurrentTime / aDuration) - 1;
        Result := aChangeInValue * Sqrt(1 - aCurrentTime * aCurrentTime) + aStartValue;
      end;

    etInOutCircle:
      begin
        aCurrentTime := aCurrentTime / (aDuration / 2);
        if aCurrentTime < 1 then
          Result := -aChangeInValue / 2 * (Sqrt(1 - aCurrentTime * aCurrentTime) - 1) + aStartValue
        else
        begin
          aCurrentTime := aCurrentTime - 2;
          Result := aChangeInValue / 2 * (Sqrt(1 - aCurrentTime * aCurrentTime) + 1) + aStartValue;
        end;
      end;
  end;
end;

class function TGVUtil.EasePosition(aStartPos: Double; aEndPos: Double; aCurrentPos: Double; aEaseType: TGVEaseType): Double;
var
  LT, LB, LC, LD: Double;
begin
  LC := aEndPos - aStartPos;
  LD := 100;
  LT := aCurrentPos;
  LT := EnsureRange(LT, 0, 100);
  LB := aStartPos;
  Result := EaseValue(LT, LB, LC, LD, aEaseType);
  //if Result > 100 then
  //  Result := 100;
end;

class function TGVUtil.URLEncode(const Url: string): string;
var
  i: Integer;
  UrlA: ansistring;
  res: ansistring;
begin
  res := '';
  UrlA := ansistring(UTF8Encode(Url));

  for i := 1 to Length(UrlA) do
  begin
    case UrlA[i] of
      'A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.':
        res := res + UrlA[i];
    else
        res := res + '%' + ansistring(IntToHex(Ord(UrlA[i]), 2));
    end;
  end;

  Result := string(res);
end;

class function TGVUtil.URLEncodeTilde(const Url: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(Url) do
  begin
    case Url[i] of
      'A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.','~':
        Result := Result + Url[i];
    else
        Result := Result + '%' + IntToHex(Ord(Url[i]), 2);
    end;
  end;
end;

class function TGVUtil.HTTPEncode(const AStr: ansistring): AnsiString;
// The NoConversion set contains characters as specificed in RFC 1738 and
// should not be modified unless the standard changes.
const
  NoConversion = ['A'..'Z','a'..'z','*','@','.','_','-',
                  '0'..'9','$','!','''','(',')'];
var
  Sp, Rp: PAnsiChar;
begin
  SetLength(Result, Length(AStr) * 3);
  Sp := PAnsiChar(AStr);
  Rp := PAnsiChar(Result);
  while Sp^ <> #0 do
  begin
    if Sp^ in NoConversion then
      Rp^ := Sp^
    else
      if Sp^ = ' ' then
        Rp^ := '+'
      else
      begin
        {$IFDEF DELPHIXE4_LVL}
        AnsiStrings.FormatBuf(Rp^, 3, AnsiString('%%%.2x'), 6, [Ord(Sp^)]);
        {$ENDIF}
        {$IFNDEF DELPHIXE4_LVL}
        FormatBuf(Rp^, 3, AnsiString('%%%.2x'), 6, [Ord(Sp^)]);
        {$ENDIF}
        Inc(Rp,2);
      end;
    Inc(Rp);
    Inc(Sp);
  end;
  SetLength(Result, Rp - PAnsiChar(Result));
end;

class function TGVUtil.URLEncodeRFC3986(URL: string): string;
var
  URL1: string;
begin
  URL1 := UrlEncode(URL);
  URL1 := StringReplace(URL1, '+', ' ', [rfReplaceAll, rfIgnoreCase]);
  Result := URL1;
end;

class function TGVUtil.EncodeParams(Params: TStringList; splitter: string; quot: Boolean; encodeHttp: Boolean = false): string;
var
  arr: TStringList;
  buf: string;
  I: Integer;

begin
  arr := TStringList.Create;
  arr.Clear;

  for I := 0 to Params.Count - 1 do
  begin
    begin
      if quot then
        buf := Params.Names[I] + '="' + Params.ValueFromIndex[I] + '"'
      else
      begin
        if encodeHttp then
          buf := Params.Names[I] + '=' +
            String(HTTPEncode(UTF8Encode(Params.ValueFromIndex[I]))) + ''
        else
          buf := Params.Names[I] + '=' + UrlEncode
            (String(UTF8Encode(Params.ValueFromIndex[I]))) + '';

      end;
      arr.Add(buf);
    end;
  end;

  if not quot then
    arr.Sort;

  buf := '';

  for I := 0 to arr.Count - 1 do
  begin
    if (buf <> '') then
      buf := buf + splitter;
    buf := buf + arr.Strings[I];
  end;
  arr.Free;
  Result := buf;
end;


end.
