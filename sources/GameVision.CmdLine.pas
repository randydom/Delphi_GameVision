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

unit GameVision.CmdLine;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Base;

type
  { TGVCmdLine }
  TGVCmdLine = class(TGVObject)
  protected
    FCmdLine: string;
    function GetCmdLine: PChar;
    function GetParamStr(aParamStr: PChar; var aParam: string): PChar;
  public
    constructor Create; override;
    destructor Destroy; override;
    function ParamCount: Integer;
    procedure Reset;
    procedure ClearParams;
    procedure AddAParam(const aParam: string);
    procedure AddParams(const aParams: string);
    function ParamStr(aIndex: Integer): string;
    function GetParamValue(const aParamName: string; aSwitchChars: TSysCharSet; aSeperator: Char; var aValue: string): Boolean; overload;
    function GetParamValue(const aParamName: string; var aValue: string): Boolean; overload;
    function ParamExist(const aParamName: string): Boolean;
  end;

implementation

uses
  System.Types,
  WinApi.Windows;

{ TGVCmdLine }
function TGVCmdLine.GetCmdLine: PChar;
begin
  Result := PChar(FCmdLine);
end;

function TGVCmdLine.GetParamStr(aParamStr: PChar; var aParam: string): PChar;
var
  LIndex, LLen: Integer;
  LStart, LStr: PChar;
begin
  // U-OK
  while True do
  begin
    while (aParamStr[0] <> #0) and (aParamStr[0] <= ' ') do
      Inc(aParamStr);
    if (aParamStr[0] = '"') and (aParamStr[1] = '"') then Inc(aParamStr, 2) else Break;
  end;
  LLen := 0;
  LStart := aParamStr;
  while aParamStr[0] > ' ' do
  begin
    if aParamStr[0] = '"' then
    begin
      Inc(aParamStr);
      while (aParamStr[0] <> #0) and (aParamStr[0] <> '"') do
      begin
        Inc(LLen);
        Inc(aParamStr);
      end;
      if aParamStr[0] <> #0 then
        Inc(aParamStr);
    end
    else
    begin
      Inc(LLen);
      Inc(aParamStr);
    end;
  end;

  SetLength(aParam, LLen);

  aParamStr := LStart;
  LStr := Pointer(aParam);
  LIndex := 0;
  while aParamStr[0] > ' ' do
  begin
    if aParamStr[0] = '"' then
    begin
      Inc(aParamStr);
      while (aParamStr[0] <> #0) and (aParamStr[0] <> '"') do
      begin
        LStr[LIndex] := aParamStr^;
        Inc(aParamStr);
        Inc(LIndex);
      end;
      if aParamStr[0] <> #0 then Inc(aParamStr);
    end
    else
    begin
      LStr[LIndex] := aParamStr^;
      Inc(aParamStr);
      Inc(LIndex);
    end;
  end;

  Result := aParamStr;
end;
constructor TGVCmdLine.Create;
begin
  inherited;
  Reset;
end;

destructor TGVCmdLine.Destroy;
begin
  inherited;
end;

function TGVCmdLine.ParamCount: Integer;
var
  LPtr: PChar;
  LStr: string;
begin
  // U-OK
  Result := 0;
  LPtr := Self.GetParamStr(GetCmdLine, LStr);
  while True do
  begin
    LPtr := Self.GetParamStr(LPtr, LStr);
    if LStr = '' then Break;
    Inc(Result);
  end;
end;

procedure TGVCmdLine.Reset;
begin
  // init commandline
  FCmdLine := System.CmdLine + ' ';
end;

procedure TGVCmdLine.ClearParams;
begin
  FCmdLine := '';
end;

procedure TGVCmdLine.AddAParam(const aParam: string);
var
  LParam: string;
begin
  LParam := aParam.Trim;
  if LParam.IsEmpty then Exit;
  FCmdLine := FCmdLine + LParam + ' ';
end;

procedure TGVCmdLine.AddParams(const aParams: string);
var
  LParams: TStringDynArray;
  LIndex: Integer;
begin
  LParams := aParams.Split([' '], TStringSplitOptions.ExcludeEmpty);
  for LIndex := 0 to Length(LParams)-1 do
  begin
    AddAParam(LParams[LIndex]);
  end;
end;

function TGVCmdLine.ParamStr(aIndex: Integer): string;
var
  LPtr: PChar;
  LBuffer: array[0..260] of Char;
begin
  Result := '';
  if aIndex = 0 then
    SetString(Result, LBuffer, GetModuleFileName(0, LBuffer, Length(LBuffer)))
  else
  begin
    LPtr := GetCmdLine;
    while True do
    begin
      LPtr := Self.GetParamStr(LPtr, Result);
      if (aIndex = 0) or (Result = '') then Break;
      Dec(aIndex);
    end;
  end;
end;

function TGVCmdLine.GetParamValue(const aParamName: string; aSwitchChars: TSysCharSet; aSeperator: Char; var aValue: string): Boolean;
var
  LIndex, LSep: Longint;
  LStr: string;
begin

  Result := False;
  aValue := '';

  // check for first non switch param when aParamName = '' and no
  // other params are found
  if (aParamName = '') then
  begin
    for LIndex := 1 to Self.ParamCount do
    begin
      LStr := Self.ParamStr(LIndex);
      if Length(LStr) > 0 then
        // if S[1] in aSwitchChars then
        if not CharInSet(LStr[1], aSwitchChars) then
        begin
          aValue := LStr;
          Result := True;
          Exit;
        end;
    end;
    Exit;
  end;

  // check for switch params
  for LIndex := 1 to Self.ParamCount do
  begin
    LStr := Self.ParamStr(LIndex);
    if Length(LStr) > 0 then
      // if S[1] in aSwitchChars then
      if CharInSet(LStr[1], aSwitchChars) then

      begin
        LSep := Pos(aSeperator, LStr);

        case LSep of
          0:
            begin
              if CompareText(Copy(LStr, 2, Length(LStr) - 1), aParamName) = 0 then
              begin
                Result := True;
                Break;
              end;
            end;
          1 .. MaxInt:
            begin
              if CompareText(Copy(LStr, 2, LSep - 2), aParamName) = 0 then
              // if CompareText(Copy(S, 1, Sep -1), aParamName) = 0 then
              begin
                aValue := Copy(LStr, LSep + 1, Length(LStr));
                Result := True;
                Break;
              end;
            end;
        end; // case
      end
  end;
end;

function TGVCmdLine.GetParamValue(const aParamName: string; var aValue: string): Boolean;
begin
  Result := Self.GetParamValue(aParamName, ['/', '-'], '=', aValue);
end;

function TGVCmdLine.ParamExist(const aParamName: string): Boolean;
var
  LValue: string;
begin
  Result := Self.GetParamValue(aParamName, ['/', '-'], '=', LValue);
  if not Result then
  begin
    Result := SameText(aParamName, Self.ParamStr(1));
  end;
end;

end.
