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

unit uGUI;

interface

uses
  System.SysUtils,
  GameVision.Color,
  GameVision.Starfield,
  GameVision.Audio,
  GameVision.GUI,
  GameVision.Core,
  GameVision.Game,
  uCommon;

const
  cGuiWindowFlags: array[0..4] of Cardinal = (GUI_WINDOW_BORDER, GUI_WINDOW_MOVABLE, GUI_WINDOW_SCALABLE, GUI_WINDOW_CLOSABLE, GUI_WINDOW_TITLE);
  cGuiThemes: array[0..4] of string = ('Default', 'White', 'Red', 'Blue', 'Dark');

type
  { TGUI }
  TGUI = class(TBaseExample)
  protected
    MusicVolume: Single;
    Difficulty: Integer;
    Chk1: Boolean;
    Chk2: Boolean;
    Theme: Integer;
    ThemeChanged: Boolean;
    FMusic: Integer;
    FSfx: Integer;
    FStarfield: TGVStarfield;
  public
    procedure OnSetSettings(var aSettings: TGVGameSettings); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdateFrame(aDeltaTime: Double); override;
    procedure OnRenderFrame; override;
    procedure OnRenderHUD; override;
    procedure OnProcessIMGUI; override;
  end;

implementation

{ TGUI }
procedure TGUI.OnSetSettings(var aSettings: TGVGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'GameVision - GUI';
  aSettings.WindowClearColor := BLACK;
end;

procedure TGUI.OnStartup;
begin
  inherited;

  MusicVolume := 0.3;
  Difficulty := 0;
  Chk1 := False;
  Chk2 := False;
  Theme := 0;
  ThemeChanged := False;


  FStarfield := TGVStarfield.Create;
  FSfx := GV.Audio.LoadSound(Archive, 'arc/sfx/digthis.ogg');

  FMusic := GV.Audio.LoadMusic(Archive, 'arc/music/song07.ogg');
  GV.Audio.PlayMusic(FMusic, MusicVolume, True);


end;

procedure TGUI.OnShutdown;
begin
  GV.Audio.UnloadMusic(FMusic);
  GV.Audio.UnloadSound(FSfx);
  FreeAndNil(FStarfield);
  inherited;
end;

procedure TGUI.OnUpdateFrame(aDeltaTime: Double);
begin
  inherited;
  FStarfield.Update(aDeltaTime);
end;

procedure TGUI.OnRenderFrame;
begin
  inherited;
  FStarfield.Render;
  GV.Primitive.FilledRectangle((GV.Window.Width/2)-50, (GV.Window.Height/2)-50, 100, 100, DARKGREEN);
end;

procedure TGUI.OnRenderHUD;
begin
  inherited;
end;

procedure TGUI.OnProcessIMGUI;
begin
  inherited;

  if GV.GUI.WindowBegin('Window 1', 'Window 1', 50, 50, 270, 220, cGuiWindowFlags) then
  begin
    GV.GUI.LayoutRowStatic(30, 80, 2);
    GV.GUI.Button('One');
    GV.GUI.Button('Two');

    GV.GUI.LayoutRowDynamic(30, 2);
    if GV.GUI.Option('easy', Boolean(Difficulty = 0)) then
      Difficulty := 0;

    if GV.GUI.Option('hard', Boolean(Difficulty = 1)) then
      Difficulty := 1;

    GV.GUI.LayoutRowBegin(GUI_STATIC, 30, 2);
    GV.GUI.LayoutRowPush(50);
    GV.GUI.&Label('Volume:', GUI_TEXT_LEFT);
    GV.GUI.LayoutRowPush(110);
    if GV.GUI.Slider(0, 1, 0.01, MusicVolume) then
      GV.Audio.SetMusicVolume(FMusic, MusicVolume);
    GV.GUI.LayoutRowPush(120);
    if GV.GUI.Checkbox('Dig this', chk1) then
    begin
      if chk1 then
      begin
        GV.Audio.PlaySound(AUDIO_DYNAMIC_CHANNEL, FSfx, 0.5, False);
      end;
    end;
    GV.GUI.Checkbox('Change theme', chk2);
    GV.GUI.LayoutRowEnd;
  end;
  GV.GUI.WindowEnd;

  if chk2 then
  begin
    if GV.GUI.WindowBegin('Window 2', 'Window 2', 350, 150, 320, 220, cGuiWindowFlags) then
      begin
       GV.GUI.LayoutRowStatic(25, 190, 1);
       Theme := GV.GUI.Combobox(cGuiThemes, Theme, 25, 200, 200, ThemeChanged);
      end
    else
      begin
       chk2 := False;
      end;
    GV.GUI.WindowEnd;

    if ThemeChanged then
      GV.GUI.SetStyle(Theme);
  end;
end;


end.
