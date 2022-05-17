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
  end;

implementation

uses
  System.IOUtils,
  VCL.Graphics,
  WinApi.Messages,
  WinApi.ShellAPI;

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

end.
