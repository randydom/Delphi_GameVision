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

unit GameVision.Logger;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Base;

type
  { TGVLogger }
  TGVLogger = class(TGVObject)
  protected
    FFormatSettings : TFormatSettings;
    FFilename: string;
    FText: Text;
    FBuffer: array[Word] of Byte;
    FOpen: Boolean;
  public
    property Filename: string read FFilename;
    constructor Create; override;
    destructor Destroy; override;
    procedure Open(const aFilename: string=''; aOverwrite: Boolean=True);
    procedure Close;
    procedure Log(const aMsg: string; const aArgs: array of const; aWriteToConsole: Boolean=False);
    procedure Exception(const aMsg: string; const aArgs: array of const; aWriteToConsole: Boolean=False);
    class procedure Fatal(const aMsg: string; const aArgs: array of const; aWriteToConsole: Boolean=False);
  end;

implementation

uses
  System.IOUtils,
  System.Classes,
  WinApi.Windows,
  WinApi.ShellAPI,
  GameVision.Common,
  GameVision.Console;

{ TGVLogger }
constructor TGVLogger.Create;
begin
  inherited;
  FFilename := '';
  FillChar(FBuffer, SizeOf(FBuffer), 0);
  FOpen := False;
  Open;
end;

destructor TGVLogger.Destroy;
begin
  Close;
  inherited;
end;

procedure TGVLogger.Open(const aFilename: string; aOverwrite: Boolean);
var
  LFilename: string;
begin
  Close;

  FFormatSettings.DateSeparator := '/';
  FFormatSettings.TimeSeparator := ':';
  FFormatSettings.ShortDateFormat := 'DD-MM-YYY HH:NN:SS';
  FFormatSettings.ShortTimeFormat := 'HH:NN:SS';

  LFilename := aFilename;

  if LFilename.IsEmpty then LFilename := ParamStr(0);
  LFilename := TPath.ChangeExtension(LFilename, GV_FILEEXT_LOG);

  AssignFile(FText, LFilename);
  if aOverwrite then
    ReWrite(FText)
  else
    begin
      if TFile.Exists(LFilename) then
        Reset(FText)
      else
        ReWrite(FText);
    end;
  SetTextBuf(FText, FBuffer);
  FOpen := True;
  FFilename := LFilename;
end;

procedure TGVLogger.Close;
begin
  if not FOpen then Exit;
  CloseFile(FText);
  FOpen := False;
end;

procedure TGVLogger.Log(const aMsg: string; const aArgs: array of const; aWriteToConsole: Boolean=False);
var
  LLine: string;
begin
  if not FOpen then Exit;

  // get line
  LLine := Format(aMsg, aArgs);

  // write to console
  if aWriteToConsole then
  begin
    if TGVConsole.IsPresent then
      WriteLn(LLine);
  end;

  // write to logfile
  {$I-}
  LLine := Format('%s %s', [DateTimeToStr(Now, FFormatSettings), LLine]);
  Writeln(FText, LLine);
  Flush(FText);
  {$I+}
end;

procedure TGVLogger.Exception(const aMsg: string; const aArgs: array of const; aWriteToConsole: Boolean=False);
var
  LMsg: string;
begin
  LMsg := Format(aMsg, aArgs);
  Log(LMsg, [], aWriteToConsole);
  raise System.SysUtils.Exception.Create(LMsg);
end;

class procedure TGVLogger.Fatal(const aMsg: string; const aArgs: array of const; aWriteToConsole: Boolean=False);
var
  LLog: TStringList;
  LLine: string;
  FFormatSettings : TFormatSettings;
  LFilename: string;
begin
  FFormatSettings.DateSeparator := '/';
  FFormatSettings.TimeSeparator := ':';
  FFormatSettings.ShortDateFormat := 'DD-MM-YYY HH:NN:SS';
  FFormatSettings.ShortTimeFormat := 'HH:NN:SS';

  LLine := Format(aMsg, aArgs);
  LLine := Format('%s %s', [DateTimeToStr(Now, FFormatSettings), LLine]);

  LLog := TStringList.Create;
  try
    LFilename := TPath.ChangeExtension(ParamStr(0), GV_FILEEXT_LOG);
    if TFile.Exists(LFilename) then
      LLog.LoadFromFile(LFilename);
    LLog.Add(LLine);
    LLog.SaveToFile(LFilename);
  finally
    FreeAndNil(LLog);
  end;
  if TFile.Exists(LFilename) then
    ShellExecute(0, 'OPEN', PChar(LFilename), '', '', SW_SHOWNORMAL);
end;

end.
