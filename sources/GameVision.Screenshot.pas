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

unit GameVision.Screenshot;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Base;

type
  { TGVScreenshot }
  TGVScreenshot = class(TGVObject)
  protected
    FFlag: Boolean;
    FDir: string;
    FBaseFilename: string;
    FFilename: string;
  public
    property Dir: string read FDir;
    constructor Create; override;
    destructor Destroy; override;
    procedure Process;
    procedure Init(const aDir: WideString; const aBaseFilename: WideString);
    procedure Take;
  end;


implementation

uses
  System.IOUtils,
  GameVision.Core;

{ TGVScreenshot }
procedure TGVScreenshot.Process;
var
  LC: Integer;
  LF, LD, LB: string;
begin
  if GV.Screenshake.Active then Exit;
  if not FFlag then Exit;

  FFlag := False;

  // directory
  LD := ExpandFilename(FDir);
  ForceDirectories(LD);

  // base name
  LB := FBaseFilename;

  // search file maks
  LF := LB + '*.png';

  // file count
  LC := GV.Util.FileCount(LD, LF);

  // screenshot file mask
  LF := Format('%s\%s (%.6d).png', [LD, LB, LC]);
  FFilename := LF;

  // save screenshot
  GV.Window.Save(LF);

  // call event handler
  if TFile.Exists(LF) then
    GV.Game.OnScreenshot(LF);
end;

constructor TGVScreenshot.Create;
begin
  inherited;
  FFlag := False;
  FFilename := '';
  FDir := 'Screenshots';
  FBaseFilename := 'Screen';
  Init('', '');
end;

destructor TGVScreenshot.Destroy;
begin
  inherited;
end;

procedure TGVScreenshot.Init(const aDir: WideString; const aBaseFilename: WideString);
var
  LDir: string;
  LBaseFilename: string;
begin
  FFilename := '';
  FFlag := False;

  LDir := aDir;
  LBaseFilename := aBaseFilename;

  if LDir.IsEmpty then
    LDir := 'Screenshots';
  FDir := LDir;

  if LBaseFilename.IsEmpty then
    LBaseFilename := 'Screen';
  FBaseFilename := LBaseFilename;

  ChangeFileExt(FBaseFilename, '');
end;

procedure TGVScreenshot.Take;
begin
  FFlag := True;
end;

end.
