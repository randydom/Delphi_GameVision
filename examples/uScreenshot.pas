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

(*
  This is a game template you can use in your projects as a starting point.

  1. Add GameVision.GameTemplate unit to your project
  2. Save-as a new unit name
  3. Place cursor on TGVGameTemplate and press Shft+Ctrl+E to rename
  4. Update { TGVGameTemplate } throughout to your liking
  5. Enjoy
  --------------------------------------------------------------------------
  In GameVision you have a these OnXXX callback methods that you can
  override to add functionaliy to your game. The minimum methods that you
  must override include:
    OnSetSettings - set game settings
    OnStartup     - run game startup code
    OnShutdown    - run game shutdown code
    OnUpdateFrame - run game update code
    OnRenderFrame - run game rendering code
    OnRenderHUD   - run game hud rendering code
*)

unit uScreenshot;

interface

uses
  System.SysUtils,
  System.IOUtils,
  GameVision.Common,
  GameVision.Color,
  GameVision.Math,
  GameVision.Texture,
  GameVision.Input,
  GameVision.Game,
  GameVision.Core,
  uCommon;

type
  { TScreenshot }
  TScreenshot = class(TBaseExample)
  protected
    FTexture: TGVTexture;
    FScreenshotImage: TGVTexture;
    FPos: TGVVector;
    FFilename: string;
  public
    procedure OnSetSettings(var aSettings: TGVGameSettings); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdateFrame(aDeltaTime: Double); override;
    procedure OnRenderFrame; override;
    procedure OnRenderHUD; override;
    procedure OnShowFrame; override;
    procedure OnScreenshot(const aFilename: string); override;
  end;

implementation

{ TScreenshot }
procedure TScreenshot.OnSetSettings(var aSettings: TGVGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'GameVision - Screenshot';
end;

procedure TScreenshot.OnStartup;
begin
  inherited;
  FScreenshotImage := TGVTexture.Create;

  FTexture := TGVTexture.Create;
  FTexture.Load(Archive, 'arc/images/bluestone.png', nil);
  FPos.Assign(0, 0, 30, 30);
end;

procedure TScreenshot.OnShutdown;
begin
  FreeAndNil(FTexture);
  FreeAndNil(FScreenshotImage);
  inherited;
end;

procedure TScreenshot.OnUpdateFrame(aDeltaTime: Double);
begin
  inherited;

  // update postion
  FPos.X := FPos.X + (FPos.Z * aDeltaTime);
  FPos.Y := FPos.Y + (FPos.W * aDeltaTime);

  // take a screenshot
  if GV.Input.KeyPressed(KEY_S) then
    GV.Screenshot.Take;
end;

procedure TScreenshot.OnRenderFrame;
begin
  inherited;

  FTexture.DrawTiled(FPos.X, FPos.Y)
end;

procedure TScreenshot.OnRenderHUD;
begin
  inherited;
  HudText(Font, GREEN, haLeft, HudTextItem('S', 'Screenshot'), []);
  HudText(Font, YELLOW, haLeft, HudTextItem('File', '%s'), [TPath.GetFileName(FFilename)]);
end;

procedure TScreenshot.OnShowFrame;
begin
  // display scaled down version of last screen image
  FScreenshotImage.Draw(GV.Window.Width/2, GV.Window.Height/2, 0.5, 0, WHITE, haCenter, vaCenter);

  inherited;
end;

procedure TScreenshot.OnScreenshot(const aFilename: string);
begin
  // get the filename of last screenshot image
  //FFilename := GV.Util.FindLastWrittenFile(GV.Screenshot.Dir, '*.png');
  FFilename := aFilename;

  // load in this image
  FScreenshotImage.Load(nil, FFilename, nil);
end;

end.
