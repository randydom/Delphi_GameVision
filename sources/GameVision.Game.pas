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

unit GameVision.Game;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Base,
  GameVision.CustomGame,
  GameVision.Math,
  GameVision.ConfigFile,
  GameVision.Archive,
  GameVision.InputMap,
  GameVision.Font,
  GameVision.ActorScene,
  GameVision.Sprite,
  GameVision.Color,
  GameVision.Common;

type
  { TGVGameSettings }
  TGVGameSettings = record
    // archive
    ArchivePassword: string;
    ArchiveFilename: string;

    // window
    WindowWidth: Integer;
    WindowHeight: Integer;
    WindowTitle: string;
    WindowClearColor: TGVColor;

    // font
    FontFilename: string;
    FontSize: Integer;

    // hud
    HudTextItemPadWidth: Integer;
    HudPosX: Integer;
    HudPosY: Integer;
    HudLineSpace: Integer;

    // scene
    SceneCount: Integer;
    SceneRenderAttr: TGVObjectAttributeSet;
    SceneUpdateAttr: TGVObjectAttributeSet;
  end;

  { PGVSettings }
  PGVSettings = ^TGVGameSettings;


  { TGVGame }
  TGVGame = class(TGVCustomGame)
  protected
    FTerminated: Boolean;
    FReady: Boolean;
    FTimer: record
      LNow: Double;
      Passed: Double;
      Last: Double;
      Accumulator: Double;
      FrameAccumulator: Double;
      DeltaTime: Double;
      FrameCount: Cardinal;
      FrameRate: Cardinal;
      UpdateSpeed: Single;
      FixedUpdateSpeed: Single;
      FixedUpdateTimer: Single;
    end;
    FHud: record
      TextItemPadWidth: Integer;
      Pos: TGVVector;
    end;
    FMousePos: TGVVector;
    FMouseDelta: TGVVector;
    FMousePressure: Single;
    FSettings: TGVGameSettings;
    FConfigFile: TGVConfigFile;
    FArchive: TGVArchive;
    FFont: TGVFont;
    FInputMap: TGVInputMap;
    FSprite: TGVSprite;
    FScene: TGVActorScene;
    procedure UpdateTiming;
  public
    property Terminated: Boolean read FTerminated write FTerminated;
    property Ready: Boolean read FReady;
    property Settings: TGVGameSettings read FSettings write FSettings;
    property Font: TGVFont read FFont;
    property Archive: TGVArchive read FArchive;
    property InputMap: TGVInputMap read FInputMap;
    property MousePos: TGVVector read FMousePos;
    property MouseDelta: TGVVector read FMouseDelta;
    property MousePressure: Single read FMousePressure;
    property Sprite: TGVSprite read FSprite;
    property Scene: TGVActorScene read FScene;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnPreStartup; virtual;
    procedure OnPostStartup; virtual;
    procedure OnLoadConfig; virtual;
    procedure OnSaveConfig; virtual;
    procedure OnSetSettings(var aSettings: TGVGameSettings); virtual;
    procedure OnApplySettings; virtual;
    procedure OnUnApplySettings; virtual;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnRun; override;
    procedure OnReady(aReady: Boolean); virtual;
    procedure OnUpdateFrame(aDeltaTime: Double); virtual;
    procedure OnFixedUpdateFrame; virtual;
    procedure OnStartFrame; virtual;
    procedure OnEndFrame; virtual;
    procedure OnClearFrame; virtual;
    procedure OnRenderFrame; virtual;
    procedure OnRenderHUD; virtual;
    procedure OnShowFrame; virtual;
    procedure OnLoadVideo(const aFilename: string); virtual;
    procedure OnUnloadVideo(const aFilename: string); virtual;
    procedure OnStartVideo(const aFilename: string); virtual;
    procedure OnFinishedVideo(const aFilename: string); virtual;
    procedure OnSpeechWord(aFWord: string; aText: string); virtual;
    procedure OnScreenshot(const aFilename: string); virtual;
    procedure OnBeforeRenderScene(aSceneNum: Integer); virtual;
    procedure OnAfterRenderScene(aSceneNum: Integer); virtual;
    procedure OnProcessIMGUI; virtual;
    function  GetTime: Double;
    procedure ResetTiming(aSpeed: Single=0; aFixedSpeed: Single=0);
    procedure SetUpdateSpeed(aSpeed: Single);
    function  GetUpdateSpeed: Single;
    procedure SetFixedUpdateSpeed(aSpeed: Single);
    function  GetFixedUpdateSpeed: Single;
    function  GetDeltaTime: Double;
    function  GetFrameRate: Cardinal;
    function  FrameSpeed(var aTimer: Single; aSpeed: Single): Boolean;
    function  FrameElapsed(var aTimer: Single; aFrames: Single): Boolean;
    procedure SetTerminate(aTerminate: Boolean);
    function  IsTerminated: Boolean;
    procedure HudResetPos;
    procedure HudPos(aX: Integer; aY: Integer);
    procedure HudLineSpace(aLineSpace: Integer);
    procedure HudTextItemPadWidth(aWidth: Integer);
    procedure HudText(aFont: TGVFont; aColor: TGVColor; aAlign: TGVHAlign; const aMsg: string; const aArgs: array of const);
    function  HudTextItem(const aKey: string; const aValue: string; const aSeperator: string='-'): string;
  end;

  { TGVGameClass }
  TGVGameClass = class of TGVGame;

{ GVRunGame }
procedure GVRunGame(aGame: TGVCustomGameClass; aPause: Boolean=False);

implementation

uses
  System.IOUtils,
  WinApi.Windows,
  GameVision.Allegro,
  GameVision.Input,
  GameVision.Util,
  GameVision.Console,
  GameVision.Core;

procedure TGVGame.UpdateTiming;
begin
  FTimer.LNow := GetTime;
  FTimer.Passed := FTimer.LNow - FTimer.Last;
  FTimer.Last := FTimer.LNow;

  // process framerate
  Inc(FTimer.FrameCount);
  FTimer.FrameAccumulator := FTimer.FrameAccumulator + FTimer.Passed + GV_EPSILON;
  if FTimer.FrameAccumulator >= 1 then
  begin
    FTimer.FrameAccumulator := 0;
    FTimer.FrameRate := FTimer.FrameCount;
    FTimer.FrameCount := 0;
  end;

  // process variable update
  FTimer.Accumulator := FTimer.Accumulator + FTimer.Passed;
  while (FTimer.Accumulator >= FTimer.DeltaTime) do
  begin
    // process screen shakes
    GV.Screenshake.Process(FTimer.UpdateSpeed, FTimer.DeltaTime);

    // call herited update frame
    OnUpdateFrame(FTimer.DeltaTime);

    // call herited fixed update frame
    if FrameSpeed(FTimer.FixedUpdateTimer, FTimer.FixedUpdateSpeed) then
      OnFixedUpdateFrame;

    // update accumulator
    FTimer.Accumulator := FTimer.Accumulator - FTimer.DeltaTime;
  end;
end;

constructor TGVGame.Create;
begin
  inherited;
  // configfile
  FConfigFile := TGVConfigFile.Create;
  FConfigFile.Open;

  // inputmap
  FInputMap := TGVInputMap.Create;

  ResetTiming(60.0, 1.0);
  GV.Game := Self;
end;

destructor TGVGame.Destroy;
begin
  FreeAndNil(FInputMap);
  FreeAndNil(FConfigFile);
  GV.Game := nil;
  inherited;
end;

procedure TGVGame.OnPreStartup;
begin
end;

procedure TGVGame.OnPostStartup;
begin
end;

procedure TGVGame.OnLoadConfig;
begin
  // load settings
//  FSettings.WindowWidth := FConfigFile.GetValue('Settings', 'WindowWidth', 960);
//  FSettings.WindowHeight := FConfigFile.GetValue('Settings', 'WindowHeight', 540);
//  FSettings.WindowTitle := FConfigFile.GetValue('Settings', 'WindowTitle', FSettings.WindowTitle);
//  FConfigFile.GetValue('Settings', 'WindowClearColor', @FSettings.WindowClearColor, SizeOf(FSettings.WindowClearColor));
end;

procedure TGVGame.OnSaveConfig;
begin
  // save settings
//  FConfigFile.SetValue('Settings', 'WindowWidth', FSettings.WindowWidth);
//  FConfigFile.SetValue('Settings', 'WindowHeight', FSettings.WindowHeight);
//  FConfigFile.SetValue('Settings', 'WindowTitle', FSettings.WindowTitle) ;
//  FConfigFile.SetValue('Settings', 'WindowClearColor', @FSettings.WindowClearColor, SizeOf(FSettings.WindowClearColor));
end;

procedure TGVGame.OnSetSettings(var aSettings: TGVGameSettings);
begin
  // archive
  aSettings.ArchivePassword := '';
  aSettings.ArchiveFilename := '';

  // window settings
  aSettings.WindowWidth := 960;
  aSettings.WindowHeight := 540;
  aSettings.WindowTitle := 'GameVision Toolkit';
  aSettings.WindowClearColor := DARKSLATEBROWN;

  // font
  aSettings.FontFilename := '';
  aSettings.FontSize := 16;

  // hud
  aSettings.HudTextItemPadWidth := 10;
  aSettings.HudPosX := 3;
  aSettings.HudPosY := 3;
  aSettings.HudLineSpace := 0;

  // scene
  aSettings.SceneCount := 1;
  aSettings.SceneRenderAttr := [];
  aSettings.SceneUpdateAttr := [];
end;

procedure TGVGame.OnApplySettings;
begin
  // archive
  FArchive := TGVArchive.Create;
  FArchive.Open(FSettings.ArchivePassword, FSettings.ArchiveFilename);

  // window settings
  GV.Window.Open(FSettings.WindowWidth, FSettings.WindowHeight, FSettings.WindowTitle);

  // font
  FFont := TGVFont.Create;

  if (not FSettings.FontFilename.IsEmpty) and (FSettings.FontSize <> 0) then
    begin
      if not FFont.Load(FArchive, FSettings.FontSize, FSettings.FontFilename) then
        FFont.LoadDefault(FSettings.FontSize)
    end
  else
    if FSettings.FontSize > 0 then
      FFont.LoadDefault(FSettings.FontSize);

  // hud
  HudPos(FSettings.HudPosX, FSettings.HudPosY);
  HudLineSpace(FSettings.HudLineSpace);
  HudTextItemPadWidth(FSettings.HudTextItemPadWidth);

  // default inputmap
  // accept
  FInputMap.Add('accept', idKeyboard, KEY_ENTER);
  FInputMap.Add('accept', idKeyboard, KEY_PAD_ENTER);
  FInputMap.Add('accept', idKeyboard, KEY_SPACE);
  FInputMap.Add('accept', idJoystick, JOY_BTN_A);

  // select
  FInputMap.Add('select', idKeyboard, KEY_SPACE);
  FInputMap.Add('select', idJoystick, JOY_BTN_Y);

  // cancel
  FInputMap.Add('cancel', idKeyboard, KEY_ESCAPE);
  FInputMap.Add('cancel', idJoystick, JOY_BTN_B);

  // left
  FInputMap.Add('left', idKeyboard, KEY_LEFT);
  FInputMap.Add('left', idJoystick, JOY_BTN_LDPAD);
  FInputMap.Add('left', idKeyboard, KEY_A);

  // right
  FInputMap.Add('right', idKeyboard, KEY_RIGHT);
  FInputMap.Add('right', idJoystick, JOY_BTN_RDPAD);
  FInputMap.Add('right', idKeyboard, KEY_S);

  // up
  FInputMap.Add('up', idKeyboard, KEY_UP);
  FInputMap.Add('up', idJoystick, JOY_BTN_UDPAD);
  FInputMap.Add('up', idKeyboard, KEY_W);

  // down
  FInputMap.Add('down', idKeyboard, KEY_DOWN);
  FInputMap.Add('down', idJoystick, JOY_BTN_DDPAD);
  FInputMap.Add('down', idKeyboard, KEY_S);

  // pgup
  FInputMap.Add('pgup', idKeyboard, KEY_PGUP);

  // pgdn
  FInputMap.Add('pgdn', idKeyboard, KEY_PGDN);

  // home
  FInputMap.Add('home', idKeyboard, KEY_HOME);

  // end
  FInputMap.Add('end', idKeyboard, KEY_END);

  // sprite
  FSprite := TGVSprite.Create;

  // scene
  FScene := TGVActorScene.Create;
  FScene.Alloc(FSettings.SceneCount);
end;

procedure TGVGame.OnUnApplySettings;
begin
  // scene
  FreeAndNil(FScene);

  // sprite
  FreeAndNil(FSprite);

  // font
  FreeAndNil(FFont);

  // window settings
  GV.Window.Close;

  // archive
  FreeAndNil(FArchive);
end;

procedure TGVGame.OnStartup;
begin
  inherited;
  GV.Speech.Say('Hello World! Welcome to GameVision. Game development for Delphi, easy, fast, fun.', True);
end;

procedure TGVGame.OnShutdown;
begin
  inherited;
end;

procedure TGVGame.OnReady(aReady: Boolean);
begin
end;

procedure TGVGame.OnUpdateFrame(aDeltaTime: Double);
begin
  If FInputMap.Pressed('cancel') then
    SetTerminate(True);

  FScene.Update(Settings.SceneUpdateAttr, aDeltaTime);
end;

procedure TGVGame.OnFixedUpdateFrame;
begin
end;

procedure TGVGame.OnStartFrame;
begin
end;

procedure TGVGame.OnEndFrame;
begin
end;

procedure TGVGame.OnClearFrame;
begin
  GV.Window.Clear(FSettings.WindowClearColor);
end;

procedure TGVGame.OnRenderFrame;
begin
  FScene.Render(Settings.SceneRenderAttr, OnBeforeRenderScene, OnAfterRenderScene);
end;

procedure TGVGame.OnRenderHUD;
var
  LPos: TGVVector;
begin
  HudResetPos;
  HudText(FFont, WHITE, haLeft, 'fps %d', [GetFrameRate]);
  HudText(FFont, GREEN, haLeft, HudTextItem('ESC', 'Quit'), []);

  LPos.Assign(GV.Window.Width div 2, GV.Window.Height div 2, 0);
  FFont.PrintText(LPos.X, LPos.Y, 0, ORANGE, haCenter, 'Hello world, welcome to GameVision!', []);
end;

procedure TGVGame.OnShowFrame;
begin
  GV.Window.Show;
end;

procedure TGVGame.OnLoadVideo(const aFilename: string);
begin
end;

procedure TGVGame.OnUnloadVideo(const aFilename: string);
begin
end;

procedure TGVGame.OnStartVideo(const aFilename: string);
begin
end;

procedure TGVGame.OnFinishedVideo(const aFilename: string);
begin
end;

procedure TGVGame.OnSpeechWord(aFWord: string; aText: string);
begin
end;

procedure TGVGame.OnScreenshot(const aFilename: string);
begin
end;

procedure TGVGame.OnBeforeRenderScene(aSceneNum: Integer);
begin
end;

procedure TGVGame.OnAfterRenderScene(aSceneNum: Integer);
begin
end;

procedure TGVGame.OnProcessIMGUI;
begin
end;

function  TGVGame.GetTime: Double;
begin
  Result := al_get_time;
end;

procedure TGVGame.ResetTiming(aSpeed: Single; aFixedSpeed: Single);
begin
  FTimer.LNow := 0;
  FTimer.Passed := 0;
  FTimer.Last := 0;

  FTimer.Accumulator := 0;
  FTimer.FrameAccumulator := 0;

  FTimer.DeltaTime := 0;

  FTimer.FrameCount := 0;
  FTimer.FrameRate := 0;

  if aSpeed > 0 then
    SetUpdateSpeed(aSpeed)
  else
    SetUpdateSpeed(FTimer.UpdateSpeed);

  if aFixedSpeed > 0 then
    SetFixedUpdateSpeed(aFixedSpeed)
  else
    SetFixedUpdateSpeed(FTimer.FixedUpdateSpeed);

  FTimer.Last := GetTime;
end;

procedure TGVGame.SetUpdateSpeed(aSpeed: Single);
begin
  FTimer.UpdateSpeed := aSpeed;
  FTimer.DeltaTime := 1.0 / FTimer.UpdateSpeed;
end;

function  TGVGame.GetUpdateSpeed: Single;
begin
   Result := FTimer.UpdateSpeed;
end;

procedure TGVGame.SetFixedUpdateSpeed(aSpeed: Single);
begin
  FTimer.FixedUpdateSpeed := aSpeed;
  FTimer.FixedUpdateTimer := 0;
end;

function  TGVGame.GetFixedUpdateSpeed: Single;
begin
  Result := FTimer.FixedUpdateSpeed;
end;

function  TGVGame.GetDeltaTime: Double;
begin
  Result := FTimer.DeltaTime;
end;

function  TGVGame.GetFrameRate: Cardinal;
begin
  Result := FTimer.FrameRate;
end;

function  TGVGame.FrameSpeed(var aTimer: Single; aSpeed: Single): Boolean;
begin
  Result := False;
  aTimer := aTimer + (aSpeed / FTimer.UpdateSpeed);
  if aTimer >= 1.0 then
  begin
    aTimer := 0;
    Result := True;
  end;
end;

function  TGVGame.FrameElapsed(var aTimer: Single; aFrames: Single): Boolean;
begin
  Result := False;
  aTimer := aTimer + FTimer.DeltaTime;
  if aTimer > aFrames then
  begin
    aTimer := 0;
    Result := True;
  end;
end;

procedure TGVGame.SetTerminate(aTerminate: Boolean);
begin
  FTerminated := aTerminate;
end;

function  TGVGame.IsTerminated: Boolean;
begin
  Result := FTerminated;
end;

procedure TGVGame.HudResetPos;
begin
  HudPos(FSettings.HudPosX, FSettings.HudPosY);
end;

procedure TGVGame.HudPos(aX: Integer; aY: Integer);
begin
  FHud.Pos.Assign(aX, aY);
end;

procedure TGVGame.HudLineSpace(aLineSpace: Integer);
begin
  FHud.Pos.Z := aLineSpace;
end;

procedure TGVGame.HudTextItemPadWidth(aWidth: Integer);
begin
  FHud.TextItemPadWidth := aWidth;
end;

  procedure TGVGame.HudText(aFont: TGVFont; aColor: TGVColor; aAlign: TGVHAlign; const aMsg: string; const aArgs: array of const);
begin
  aFont.PrintText(FHud.Pos.X, FHud.Pos.Y, FHud.Pos.Z, aColor, aAlign, aMsg, aArgs);
end;

function  TGVGame.HudTextItem(const aKey: string; const aValue: string; const aSeperator: string='-'): string;
begin
  Result := Format('%s %s %s', [aKey.PadRight(FHud.TextItemPadWidth), aSeperator, aValue]);
end;

procedure TGVGame.OnRun;
var
  LCurrentTransform: ALLEGRO_TRANSFORM;
begin
  if not GV.Window.IsOpen then Exit;

  FTerminated := False;
  FReady := True;
  ResetTiming;

  GV.Audio.Open;
  GV.GUI.Open;

  while not FTerminated do
  begin
    GV.GUI.InputBegin;
    repeat
      Sleep(0);
      GV.Util.ProcessMessages;

      if al_get_next_event(GV.Queue, GV.Event) then
      begin

        GV.GUI.HandleEvent(GV.Event^);

        case GV.Event.type_ of
          ALLEGRO_EVENT_DISPLAY_CLOSE:
          begin
            FTerminated := True;
          end;

          ALLEGRO_EVENT_DISPLAY_RESIZE:
          begin
          end;

          ALLEGRO_EVENT_DISPLAY_DISCONNECTED,
          ALLEGRO_EVENT_DISPLAY_HALT_DRAWING,
          ALLEGRO_EVENT_DISPLAY_LOST,
          ALLEGRO_EVENT_DISPLAY_SWITCH_OUT:
          begin
            // clear input
            if GV.Event.type_ = ALLEGRO_EVENT_DISPLAY_SWITCH_OUT then
            begin
              GV.Input.Clear;
            end;

            // pause audio
            GV.Audio.Pause(True);

            // pause speech
            GV.Speech.Pause;

            // pause Video
            GV.Video.SetPause(True);

            // display not ready
            FReady := False;
            OnReady(FReady);
          end;

          ALLEGRO_EVENT_DISPLAY_CONNECTED,
          ALLEGRO_EVENT_DISPLAY_RESUME_DRAWING,
          ALLEGRO_EVENT_DISPLAY_FOUND,
          ALLEGRO_EVENT_DISPLAY_SWITCH_IN:
          begin
            // reset timing
            ResetTiming;

            // pause speech
            GV.Speech.Resume;

            // unpause audio
            GV.Audio.Pause(False);

            // unpause video
            GV.Video.SetPause(False);

            // display ready
            FReady := True;
            OnReady(FReady);
          end;

          ALLEGRO_EVENT_VIDEO_FINISHED:
          begin
            GV.Video.OnFinished(PALLEGRO_VIDEO(GV.Event.user.data1));
          end;
        end;

        // process input
        GV.Input.Update;
        GV.Input.GetMouseInfo(@FMousePos, @FMouseDelta, @FMousePressure);

      end;
    until al_is_event_queue_empty(GV.Queue);

    GV.GUI.InputEnd;

    if FReady then
      begin
        GV.Async.Process;
        OnStartFrame;
        //GV.Audio.Update;
        UpdateTiming;
        OnProcessIMGUI;
        OnClearFrame;
        OnRenderFrame;
        LCurrentTransform := al_get_current_transform^;
        GV.Window.ResetTransform;
        GV.GUI.Render;
        GV.GUI.Clear;
        OnRenderHUD;
        al_use_transform(@LCurrentTransform);
        GV.Screenshot.Process;
        OnShowFrame;
        OnEndFrame;
      end
    else
      begin
        Sleep(1);
      end;
  end;

  GV.Speech.Clear;
  GV.GUI.Close;
  GV.Audio.Close;
  GV.Video.Unload;

end;


{ GVRunGame }
procedure GVRunGame(aGame: TGVCustomGameClass; aPause: Boolean=False);
const
  cMsg = 'An instance of this program is already running, terminating!';
var
  LCustomGame: TGVCustomGame;

  // run custom game
  procedure RunCustomGame(aCustomGame: TGVCustomGame);
  begin
    aCustomGame.OnProcessCmdLine;
    aCustomGame.OnStartup;
    aCustomGame.OnRun;
    aCustomGame.OnShutdown;
  end;

  // run game
  procedure RunGame(aGame: TGVGame);
  begin
    aGame.OnProcessCmdLine;
    aGame.OnPreStartup;
    aGame.OnSetSettings(aGame.FSettings);
    aGame.OnLoadConfig;
    aGame.OnApplySettings;
    aGame.OnStartup;
    aGame.OnRun;
    aGame.OnShutdown;
    aGame.OnUnApplySettings;
    aGame.OnSaveConfig;
    aGame.OnPostStartup;
  end;

begin
  // report memory leaks
  ReportMemoryLeaksOnShutdown := True;

  // check for multiple instances
  if not TGVUtil.IsSingleInstance(TPath.GetFileName(ParamStr(0))) then
  begin
    if TGVConsole.IsPresent and TGVConsole.AtStartup then
      WriteLn(cMsg)
    else
      MessageBox(0, PChar(cMsg), 'Fatal Error', MB_ICONERROR);
    Exit;
  end;

  // exit if GV is already instantiated
  if GV <> nil then Exit;

  // create GV instance
  GV := TGV.Create;

  // create custom game
  LCustomGame := aGame.Create;

  // check if TGVCustome or TGVGame types
  if LCustomGame is TGVGame then
    // run TGVGame decendant
    RunGame(LCustomGame as TGVGame)
  else
    // run TGVCustomGame decendant
    RunCustomGame(LCustomGame);

  // free custom game
  FreeAndNil(LCustomGame);

  // check if should pause
  if aPause then GV.Console.Pause;

  // free & display of GV
  GV.Free;
  GV := nil;
end;

end.
