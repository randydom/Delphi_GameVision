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

unit GameVision.ConfigFile;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  System.IniFiles,
  GameVision.Base;

type
  { TGVConfigFile }
  TGVConfigFile = class(TGVObject)
  protected
    FHandle: TIniFile;
    FFilename: string;
    FSection: TStringList;
    property  Handle: TIniFile read FHandle;
  public
    constructor Create; override;
    destructor Destroy; override;
    function  Open(const aFilename: string=''): Boolean;
    procedure Close;
    function  IsOpen: Boolean;
    procedure Update;
    function  RemoveSection(const aName: string): Boolean;
    procedure SetValue(const aSection: string; const aKey: string; const aValue: string);  overload;
    procedure SetValue(const aSection: string; const aKey: string; aValue: Integer); overload;
    procedure SetValue(const aSection: string; const aKey: string; aValue: Boolean); overload;
    procedure SetValue(const aSection: string; const aKey: string; aValue: Pointer; aValueSize: Cardinal); overload;
    function  GetValue(const aSection: string; const aKey: string; const aDefaultValue: string): string; overload;
    function  GetValue(const aSection: string; const aKey: string; aDefaultValue: Integer): Integer; overload;
    function  GetValue(const aSection: string; const aKey: string; aDefaultValue: Boolean): Boolean; overload;
    procedure GetValue(const aSection: string; const aKey: string; aValue: Pointer; aValueSize: Cardinal); overload;
    function  RemoveKey(const aSection: string; const aKey: string): Boolean;
    function  GetSectionValues(const aSection: string): Integer;
    function  GetSectionValue(aIndex: Integer; aDefaultValue: string): string; overload;
    function  GetSectionValue(aIndex: Integer; aDefaultValue: Integer): Integer; overload;
    function  GetSectionValue(aIndex: Integer; aDefaultValue: Boolean): Boolean; overload;
  end;

implementation

uses
  System.IOUtils,
  GameVision.Common,
  GameVision.Core;

  { TGVConfigFile }
constructor TGVConfigFile.Create;
begin
  inherited;

  FHandle := nil;
  FSection := TStringList.Create;
end;

destructor TGVConfigFile.Destroy;
begin
  Close;
  FreeAndNil(FSection);

  inherited;
end;

function  TGVConfigFile.Open(const aFilename: string=''): Boolean;
var
  LFilename: string;
begin
  Result := False;
  if IsOpen then Exit;
  LFilename := aFilename;
  if LFilename.IsEmpty then LFilename := TPath.ChangeExtension(ParamStr(0), GV_FILEEXT_INI);
  FHandle := TIniFile.Create(LFilename);
  Result := Boolean(FHandle <> nil);
  FFilename := LFilename;
end;

procedure TGVConfigFile.Close;
begin
  if not IsOpen then Exit;
  FHandle.UpdateFile;
  FreeAndNil(FHandle);
end;

function  TGVConfigFile.IsOpen: Boolean;
begin
  Result := Boolean(FHandle <> nil);
end;

procedure TGVConfigFile.Update;
begin
  if not IsOpen then Exit;
  FHandle.UpdateFile;
end;

function  TGVConfigFile.RemoveSection(const aName: string): Boolean;
var
  LName: string;
begin
  Result := False;
  if FHandle = nil then Exit;
  LName := aName;
  if LName.IsEmpty then Exit;
  FHandle.EraseSection(LName);
  Result := True;
end;

procedure TGVConfigFile.SetValue(const aSection: string; const aKey: string; const aValue: string);
begin
  if FHandle = nil then Exit;
  FHandle.WriteString(aSection, aKey, aValue);
end;

procedure TGVConfigFile.SetValue(const aSection: string; const aKey: string; aValue: Integer);
begin
  SetValue(aSection, aKey, aValue.ToString);
end;

procedure TGVConfigFile.SetValue(const aSection: string; const aKey: string; aValue: Boolean);
begin
  SetValue(aSection, aKey, aValue.ToInteger);
end;

procedure TGVConfigFile.SetValue(const aSection: string; const aKey: string; aValue: Pointer; aValueSize: Cardinal);
var
  LValue: TMemoryStream;
begin
  if aValue = nil then Exit;
  LValue := TMemoryStream.Create;
  try
    LValue.Position := 0;
    LValue.Write(aValue^, aValueSize);
    LValue.Position := 0;
    FHandle.WriteBinaryStream(aSection, aKey, LValue);
  finally
    FreeAndNil(LValue);
  end;
end;

function  TGVConfigFile.GetValue(const aSection: string; const aKey: string; const aDefaultValue: string): string;
begin
  Result := '';
  if FHandle = nil then Exit;
  Result := FHandle.ReadString(aSection, aKey, aDefaultValue);
end;

function  TGVConfigFile.GetValue(const aSection: string; const aKey: string; aDefaultValue: Integer): Integer;
var
  LResult: string;
begin
  LResult := GetValue(aSection, aKey, aDefaultValue.ToString);
  Integer.TryParse(LResult, Result);
end;

function  TGVConfigFile.GetValue(const aSection: string; const aKey: string; aDefaultValue: Boolean): Boolean;
begin
  Result := GetValue(aSection, aKey, aDefaultValue.ToInteger).ToBoolean;
end;

procedure TGVConfigFile.GetValue(const aSection: string; const aKey: string; aValue: Pointer; aValueSize: Cardinal);
var
  LValue: TMemoryStream;
  LSize: Cardinal;
begin
  LValue := TMemoryStream.Create;
  try
    LValue.Position := 0;
    FHandle.ReadBinaryStream(aSection, aKey, LValue);
    LSize := aValueSize;
    if aValueSize > LValue.Size then
      LSize := LValue.Size;
    LValue.Position := 0;
    LValue.Write(aValue^, LSize);
  finally
    FreeAndNil(LValue);
  end;

end;

function  TGVConfigFile.RemoveKey(const aSection: string; const aKey: string): Boolean;
var
  LSection: string;
  LKey: string;
begin
  Result := False;
  if FHandle = nil then Exit;
  LSection := aSection;
  LKey := aKey;
  if LSection.IsEmpty then Exit;
  if LKey.IsEmpty then Exit;
  FHandle.DeleteKey(LSection, LKey);
  Result := True;
end;

function  TGVConfigFile.GetSectionValues(const aSection: string): Integer;
var
  LSection: string;
begin
  Result := 0;
  if LSection.IsEmpty then Exit;
  LSection := aSection;
  FSection.Clear;
  FHandle.ReadSectionValues(LSection, FSection);
  Result := FSection.Count;
end;

function  TGVConfigFile.GetSectionValue(aIndex: Integer; aDefaultValue: string): string;
begin
  Result := '';
  if (aIndex < 0) or (aIndex > FSection.Count - 1) then Exit;
  Result := FSection.ValueFromIndex[aIndex];
  if Result = '' then Result := aDefaultValue;
end;

function  TGVConfigFile.GetSectionValue(aIndex: Integer; aDefaultValue: Integer): Integer;
begin
  Result := string(GetSectionValue(aIndex, aDefaultValue.ToString)).ToInteger;
end;

function  TGVConfigFile.GetSectionValue(aIndex: Integer; aDefaultValue: Boolean): Boolean;
begin
  Result := string(GetSectionValue(aIndex, aDefaultValue.ToString)).ToBoolean
end;


end.
