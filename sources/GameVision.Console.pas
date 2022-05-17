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

unit GameVision.Console;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Base;

type
  { TGVConsole }
  TGVConsole = class(TGVObject)
  public
    constructor Create; override;
    destructor Destroy; override;
    class function  IsPresent: Boolean;
    class function  AtStartup: Boolean;
    procedure Print(const aMsg: string; const aArgs: array of const);
    procedure PrintLn; overload;
    procedure PrintLn(const aMsg: string; const aArgs: array of const); overload;
    procedure WaitForInput;
    procedure Pause;
  end;

implementation

uses
  WinApi.Windows;

constructor TGVConsole.Create;
begin
  inherited;
end;

destructor TGVConsole.Destroy;
begin
  inherited;
end;

class function  TGVConsole.IsPresent: Boolean;
var
  LStdout: THandle;
begin
  LStdout := GetStdHandle(Std_Output_Handle);
  Win32Check(LStdout <> Invalid_Handle_Value);
  Result := LStdout <> 0;
end;

class function  TGVConsole.AtStartup: Boolean;
var
  LConsoleHWnd: THandle;
  LProcessId: DWORD;
begin
  LConsoleHWnd := GetConsoleWindow;
  if LConsoleHWnd <> 0 then
    begin
      GetWindowThreadProcessId(LConsoleHWnd, LProcessId);
      Result := GetCurrentProcessId <> LProcessId;
    end
  else
    Result := False;
end;

procedure TGVConsole.Print(const aMsg: string; const aArgs: array of const);
begin
  if not IsPresent then Exit;
  Write(Format(aMsg, aArgs));
end;

procedure TGVConsole.PrintLn;
begin
  if not IsPresent then Exit;
  WriteLn;
end;

procedure TGVConsole.PrintLn(const aMsg: string; const aArgs: array of const);
begin
  if not IsPresent then Exit;
  WriteLn(Format(aMsg, aArgs));
end;

procedure TGVConsole.WaitForInput;
var
  LInputRec: TInputRecord;
  LNumRead: Cardinal;
  LOldMode: DWORD;
  LStdIn: THandle;
begin
  LStdIn := GetStdHandle(STD_INPUT_HANDLE);
  GetConsoleMode(LStdIn, LOldMode);
  SetConsoleMode(LStdIn, 0);
  repeat
    ReadConsoleInput(LStdIn, LInputRec, 1, LNumRead);
  until (LInputRec.EventType and KEY_EVENT <> 0) and LInputRec.Event.KeyEvent.bKeyDown;
  SetConsoleMode(LStdIn, LOldMode);
end;

procedure TGVConsole.Pause;
begin
  if IsPresent and (not AtStartup) then
  begin
    WriteLn;
    Write('Press any key... ');
    WaitForInput;
    WriteLn;
  end;
end;

end.
