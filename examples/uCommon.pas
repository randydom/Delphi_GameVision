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

unit uCommon;

interface

uses
  System.SysUtils,
  GameVision.Common,
  GameVision.Game,
  GameVision.Color;

const
  cArchivePassword = 'ab870994de394389836f316da16add68';
  cArchiveFilename = 'Data.zip';

type
  { TBaseExample }
  TBaseExample = class(TGVGame)
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnPreStartup; override;
    procedure OnPostStartup; override;
    procedure OnLoadConfig; override;
    procedure OnSaveConfig; override;
    procedure OnSetSettings(var aSettings: TGVGameSettings); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnReady(aReady: Boolean); override;
    procedure OnUpdateFrame(aDeltaTime: Double); override;
    procedure OnFixedUpdateFrame; override;
    procedure OnStartFrame; override;
    procedure OnEndFrame; override;
    procedure OnClearFrame; override;
    procedure OnRenderFrame; override;
    procedure OnRenderHUD; override;
    procedure OnShowFrame; override;
    procedure OnLoadVideo(const aFilename: string); override;
    procedure OnUnloadVideo(const aFilename: string); override;
    procedure OnStartVideo(const aFilename: string); override;
    procedure OnFinishedVideo(const aFilename: string); override;
    procedure OnSpeechWord(aFWord: string; aText: string); override;
  end;

implementation

{ TExampleTemplate }
constructor TBaseExample.Create;
begin
  inherited;
end;

destructor TBaseExample.Destroy;
begin
  inherited;
end;

procedure TBaseExample.OnPreStartup;
begin
  inherited;
end;

procedure TBaseExample.OnPostStartup;
begin
  inherited;
end;

procedure TBaseExample.OnLoadConfig;
begin
  inherited;
end;

procedure TBaseExample.OnSaveConfig;
begin
  inherited;
end;

procedure TBaseExample.OnSetSettings(var aSettings: TGVGameSettings);
begin
  inherited;

  // archive
  aSettings.ArchivePassword := cArchivePassword;
  aSettings.ArchiveFilename := cArchiveFilename;

  // window settings
  aSettings.WindowWidth := 960;
  aSettings.WindowHeight := 540;
  aSettings.WindowTitle := 'TBaseExample';
  aSettings.WindowClearColor := DARKSLATEBROWN;

  // font
  aSettings.FontFilename := '';
  aSettings.FontSize := 16;
end;

procedure TBaseExample.OnStartup;
begin
end;

procedure TBaseExample.OnShutdown;
begin
  inherited;
end;

procedure TBaseExample.OnReady(aReady: Boolean);
begin
  inherited;
end;

procedure TBaseExample.OnUpdateFrame(aDeltaTime: Double);
begin
  inherited;
end;

procedure TBaseExample.OnFixedUpdateFrame;
begin
  inherited;
end;

procedure TBaseExample.OnStartFrame;
begin
  inherited;
end;

procedure TBaseExample.OnEndFrame;
begin
  inherited;
end;

procedure TBaseExample.OnClearFrame;
begin
  inherited;
end;

procedure TBaseExample.OnRenderFrame;
begin
  inherited;
end;

procedure TBaseExample.OnRenderHUD;
begin
  HudResetPos;
  HudText(FFont, WHITE, haLeft, 'fps %d', [GetFrameRate]);
  HudText(FFont, GREEN, haLeft, HudTextItem('ESC', 'Quit'), []);
end;

procedure TBaseExample.OnShowFrame;
begin
  inherited;
end;

procedure TBaseExample.OnLoadVideo(const aFilename: string);
begin
  inherited;
end;

procedure TBaseExample.OnUnloadVideo(const aFilename: string);
begin
  inherited;
end;

procedure TBaseExample.OnStartVideo(const aFilename: string);
begin
  inherited;
end;

procedure TBaseExample.OnFinishedVideo(const aFilename: string);
begin
  inherited;
end;

procedure TBaseExample.OnSpeechWord(aFWord: string; aText: string);
begin
  inherited;
end;

end.
