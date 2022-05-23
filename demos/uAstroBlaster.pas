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

unit uAstroBlaster;

interface

uses
  System.SysUtils,
  GameVision.Common,
  GameVision.Color,
  GameVision.Math,
  GameVision.Texture,
  GameVision.Window,
  GameVision.Actor,
  GameVision.EntityActor,
  GameVision.Input,
  GameVision.Audio,
  GameVision.Core,
  GameVision.Game,
  uCommon;

const
  cMultiplier = 60;
  cPlayerMultiplier = 600;

  // player
  cPlayerTurnRate      = 2.7 * cPlayerMultiplier;
  cPlayerFriction      = 0.005* cPlayerMultiplier;
  cPlayerAccel         = 0.1* cPlayerMultiplier;
  cPlayerMagnitude     = 10 * 14;
  cPlayerHalfSize      = 32.0;
  cPlayerFrameFPS      = 12;
  cPlayerNeutralFrame  = 0;
  cPlayerFirstFrame    = 1;
  cPlayerLastFrame     = 3;
  cPlayerTurnAccel     = 300;
  cPlayerMaxTurn       = 150;
  cPlayerTurnDrag      = 150;

  // scene
  cSceneBkgrnd         = 0;
  cSceneRocks          = 1;
  cSceneRockExp        = 2;
  cSceneEnemyWeapon    = 3;
  cSceneEnemy          = 4;
  cSceneEnemyExp       = 5;
  cScenePlayerWeapon   = 6;
  cScenePlayer         = 7;
  cScenePlayerExp      = 8;
  cSceneCount          = 9;

  // sound effects
  cSfxRockExp          = 0;
  cSfxPlayerExp        = 1;
  cSfxEnemyExp         = 2;
  cSfxPlayerEngine     = 3;
  cSfxPlayerWeapon     = 4;

  // volume
  cVolPlayerEngine     = 0.40;
  cVolPlayerWeapon     = 0.30;
  cVolRockExp          = 0.25;
  cVolSong             = 0.55;

  // rocks
  cRocksMin            = 7;
  cRocksMax            = 21;

  DEBUG_RENDERPOLYPOINT = False;

type
  { TSpriteID }
  PSpriteID = ^TSpriteID;
  TSpriteID = record
    Page : Integer;
    Group: Integer;
  end;

  { TRockSize }
  TRockSize = (rsLarge, rsMedium, rsSmall);

  { TEntity }
  TBaseEntity = class(TGVEntityActor)
  protected
    //FTest: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure WrapPosAtEdge(var aPos: TGVVector);
  end;

  { TWeapon }
  TWeapon = class(TBaseEntity)
  protected
    FSpeed: Single;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnRender; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnCollide(aActor: TGVActor; aHitPos: TGVVector); override;
    procedure Spawn(aId: Integer; aPos: TGVVector; aAngle, aSpeed: Single);
  end;

  { TExplosion }
  TExplosion = class(TBaseEntity)
  protected
    FSpeed: Single;
    FCurDir: TGVVector;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnRender; override;
    procedure OnUpdate(aElapsedTime: Double); override;
    procedure Spawn(aPos: TGVVector; aDir: TGVVector; aSpeed, aScale: Single);
  end;

  { TParticle }
  TParticle = class(TBaseEntity)
  protected
    FSpeed: Single;
    FFadeSpeed: Single;
    FAlpha: Single;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnRender; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure Spawn(aId: Integer; aPos: TGVVector; aAngle, aSpeed, aScale, aFadeSpeed: Single; aScene: Integer);
  end;

  { TRock }
  TRock = class(TBaseEntity)
  protected
    FCurDir: TGVVector;
    FSpeed: Single;
    FRotSpeed: Single;
    FSize: TRockSize;
    function CalcScale(aSize: TRockSize): Single;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnRender; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnCollide(aActor: TGVActor; aHitPos: TGVVector); override;
    procedure Spawn(aId: Integer; aSize: TRockSize; aPos: TGVVector; aAngle: Single);
    procedure Split(aHitPos: TGVVector);
  end;

  { TPlayer }
  TPlayer = class(TBaseEntity)
  protected
    FTimer    : Single;
    FCurFrame : Integer;
    FThrusting: Boolean;
    FCurAngle : Single;
    FTurnSpeed: Single;
  public
    DirVec    : TGVVector;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnRender; override;
    procedure OnUpdate(aDelta: Double); override;
    procedure Spawn(aX, aY: Single);
    procedure FireWeapon(aSpeed: Single);
  end;

type
  { TExampleTemplate }
  TAstroBlaster = class(TBaseExample)
  protected
    FBkPos: TGVVector;
    FBkColor: TGVColor;
    FMusic: Integer;
  public
    Sfx: array[0..7] of Integer;
    Background : array[0..3] of TGVTexture;
    PlayerSprID: TSpriteID;
    EnemySprID: TSpriteID;
    RocksSprID: TSpriteID;
    ShieldsSprID: TSpriteID;
    WeaponSprID: TSpriteID;
    ExplosionSprID: TSpriteID;
    ParticlesSprID: TSpriteID;

    constructor Create; override;
    destructor Destroy; override;
    function OnStartupDialog: Boolean; override;
    procedure OnSetSettings(var aSettings: TGVGameSettings); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdateFrame(aDeltaTime: Double); override;
    procedure OnRenderFrame; override;
    procedure OnRenderHUD; override;
    procedure OnBeforeRenderScene(aSceneNum: Integer); override;
    procedure OnAfterRenderScene(aSceneNum: Integer); override;
    procedure SpawnRocks;
    procedure SpawnPlayer;
    procedure SpawnLevel;
    function  LevelCleared: Boolean;
  end;

implementation

const
  cChanPlayerEngine = 0;
  cChanPlayerWeapon = 1;

var
  Player: TPlayer;
  Game: TAstroBlaster = nil;

function RandomRangedslNP(aMin, aMax: Single): Single;
begin
  Result := GV.Math.RandomRange(aMin, aMax);
  if GV.Math.RandomBool then Result := -Result;
end;

function RangeRangeIntNP(aMin, aMax: Integer): Integer;
begin
  Result := GV.Math.RandomRange(aMin, aMax);
  if GV.Math.RandomBool then Result := -Result;
end;

{ TBaseEntity }
constructor TBaseEntity.Create;
begin
  inherited;

  CanCollide := True;
end;

destructor TBaseEntity.Destroy;
begin

  inherited;
end;

procedure  TBaseEntity.WrapPosAtEdge(var aPos: TGVVector);
var
  LHH,LHW: Single;
begin
  LHW := Entity.GetWidth  / 2;
  LHH := Entity.GetHeight /2 ;

  if (aPos.X > (Game.Settings.WindowWidth-1)+LHW) then
    aPos.X := -LHW
  else if (aPos.X < -LHW) then
    aPos.X := (Game.Settings.WindowWidth-1)+LHW;

  if (aPos.Y > (Game.Settings.WindowHeight-1)+LHH) then
    aPos.Y := -LHH
  else if (aPos.Y < -LHW) then
    aPos.Y := (Game.Settings.WindowHeight-1)+LHH;
end;


{ TWeapon }
constructor TWeapon.Create;
begin
  inherited;

  Init(Game.Sprite, Game.WeaponSprId.Group);
  Entity.TracePolyPoint(6, 12, 70);
  Entity.SetRenderPolyPoint(DEBUG_RENDERPOLYPOINT);
end;

destructor TWeapon.Destroy;
begin

  inherited;
end;

procedure TWeapon.OnRender;
begin
  inherited;
end;

procedure TWeapon.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  if Entity.IsVisible(0,0) then
    begin
      Entity.Thrust(FSpeed*aDeltaTime);
      Game.Scene[cSceneRocks].CheckCollision([], Self);
    end
  else
    Terminated := True;
end;

procedure TWeapon.OnCollide(aActor: TGVActor; aHitPos: TGVVector);
begin
  CanCollide := False;
  Terminated := True;
end;

procedure  TWeapon.Spawn(aId: Integer; aPos: TGVVector; aAngle, aSpeed: Single);
begin
  FSpeed := aSpeed;
  Entity.SetFrame(aId);
  Entity.SetPosAbs(aPos.X, aPos.Y);
  Entity.RotateAbs(aAngle);
end;


{ TExplosion }
constructor TExplosion.Create;
begin
  inherited;

  FSpeed := 0;
  FCurDir.X := 0;
  FCurDir.Y := 0;
end;

destructor TExplosion.Destroy;
begin

  inherited;
end;

procedure TExplosion.OnRender;
begin
  inherited;

end;

procedure TExplosion.OnUpdate(aElapsedTime: Double);
var
  LP, LV: TGVVector;
begin
  if Entity.NextFrame then
  begin
    Terminated := True;
  end;

  LV.X := (FCurDir.X + FSpeed) * aElapsedTime;
  LV.Y := (FCurDir.Y + FSpeed) * aElapsedTime;

  LP := Entity.GetPos;

  LP.X := LP.X + LV.X;
  LP.Y := LP.Y + LV.Y;

  Entity.SetPosAbs(LP.X, LP.Y);

  inherited;
end;

procedure TExplosion.Spawn(aPos: TGVVector; aDir: TGVVector; aSpeed, aScale: Single);
begin
  FSpeed := aSpeed;
  FCurDir := aDir;

  Init(Game.Sprite, Game.ExplosionSprID.Group);

  Entity.SetFrameFPS(14);
  Entity.SetScaleAbs(aScale);
  Entity.SetPosAbs(aPos.X, aPos.Y);

  Game.Scene[cSceneRockExp].Add(Self);
end;


{ TParticle }
constructor TParticle.Create;
begin
  inherited;

end;

destructor TParticle.Destroy;
begin

  inherited;
end;

procedure TParticle.OnRender;
begin
  inherited;

end;

procedure TParticle.OnUpdate(aDeltaTime: Double);
var
  LC,LC2: TGVColor;
  LA: Single;
begin
  Entity.Thrust(FSpeed*aDeltaTime);

  if Entity.IsVisible(0, 0) then
    begin
      FAlpha := FAlpha - (FFadeSpeed * aDeltaTime);
      if FAlpha <= 0 then
      begin
        FAlpha := 0;
        Terminated := True;
      end;
      LA := FAlpha / 255.0;
      LC2.Red := 1*LA; LC2.Green := 1*LA; LC2.Blue := 1*LA; LC2.Alpha := LA;
      //LC.Make(LC2.Red, LC2.Green, LC2.Blue, LC2.Alpha);
      //LC := GV.Color.Make(LC2.Red, LC2.Green, LC2.Blue, LC2.Alpha);
      LC := LC2;
      Entity.SetColor(LC);
    end
  else
    Terminated := True;

  inherited;
end;

procedure TParticle.Spawn(aId: Integer; aPos: TGVVector; aAngle, aSpeed, aScale, aFadeSpeed: Single; aScene: Integer);
begin
  FSpeed := aSpeed;
  FFadeSpeed := aFadeSpeed;
  FAlpha := 255;

  Init(Game.Sprite, Game.ParticlesSprID.Group);

  Entity.SetFrame(aId);
  Entity.SetScaleAbs(aScale);
  Entity.SetPosAbs(aPos.X, aPos.Y);
  Entity.RotateAbs(aAngle);

  Game.Scene[aScene].Add(Self);
end;


{ TRock }
function TRock.CalcScale(aSize: TRockSize): Single;
begin
  case aSize of
    rsLarge: Result := 1.0;
    rsMedium: Result := 0.65;
    rsSmall: Result := 0.45;
  else
    Result := 1.0;
  end;
end;

constructor TRock.Create;
begin
  inherited;
  FSpeed := 0;
  FRotSpeed := 0;
  FSize := rsLarge;

  Init(Game.Sprite, Game.RocksSprId.Group);

  Entity.TracePolyPoint(6, 12, 70);
  Entity.SetRenderPolyPoint(DEBUG_RENDERPOLYPOINT);
end;

destructor TRock.Destroy;
begin

  inherited;
end;

procedure TRock.OnRender;
begin
  inherited;

end;

procedure TRock.OnUpdate(aDeltaTime: Double);
var
  LP: TGVVector;
  LV: TGVVector;
begin
  inherited;

  Entity.RotateRel(FRotSpeed*aDeltaTime);
  LV.X := (FCurDir.X + FSpeed);
  LV.Y := (FCurDir.Y + FSpeed);
  LP := Entity.GetPos;
  LP.X := LP.X + LV.X*aDeltaTime;
  LP.Y := LP.Y + LV.Y*aDeltaTime;
  WrapPosAtEdge(LP);
  Entity.SetPosAbs(LP.X, LP.Y);
end;

procedure TRock.OnCollide(aActor: TGVActor; aHitPos: TGVVector);
begin
  CanCollide := False;
  Split(aHitPos);
end;

procedure TRock.Spawn(aId: Integer; aSize: TRockSize; aPos: TGVVector; aAngle: Single);
begin
  FSpeed := RandomRangedslNP(0.2*cMultiplier, 2*cMultiplier);
  FRotSpeed := RandomRangedslNP(0.2*cMultiplier, 2*cMultiplier);

  FSize := aSize;
  Entity.SetFrame(aId);
  Entity.SetPosAbs(aPos.X, aPos.Y);
  Entity.RotateAbs(GV.Math.RandomRange(0, 259));
  Entity.Thrust(1);

  FCurDir := Entity.GetDir;
  FCurDir.Normalize;
  Entity.SetScaleAbs(CalcScale(FSize));
end;

procedure TRock.Split(aHitPos: TGVVector);

  procedure DoSplit(aId: Integer; aSize: TRockSize; aPos: TGVVector);
  var
    LR: TRock;
  begin
    LR := TRock.Create;
    LR.Spawn(aId, aSize, aPos, 0);
    Game.Scene[cSceneRocks].Add(LR);
  end;

  procedure DoExplosion(aScale: Single);
  var
    LP: TGVVector;
    LE: TExplosion;
  begin
    LP := Entity.GetPos;
    LE := TExplosion.Create;
    LE.Spawn(LP, FCurDir, FSpeed, aScale);
  end;

  procedure DoParticles;
  var
    LC, LI: Integer;
    LP: TParticle;
    LAngle, LSpeed, LFade: Single;
  begin
    LC := 0;
    case FSize of
      rsLarge :
        begin
          LC := 50;
          GV.Screenshake.Start(30, 3);
        end;
      rsMedium:
        begin
          LC := 25;
          GV.Screenshake.Start(30, 2);
        end;
      rsSmall :
        begin
          LC := 15;
          GV.Screenshake.Start(30, 1);
        end;
    end;

    for LI := 1 to LC do
    begin
      LP := TParticle.Create;
      LAngle := GV.Math.RandomRange(0, 255);
      LSpeed := GV.Math.RandomRange(1*cMultiplier, 7*cMultiplier);
      LFade := GV.Math.RandomRange(3*cMultiplier, 7*cMultiplier);

      LP.Spawn(0, aHitPos, LAngle, LSpeed, 0.10, LFade, cSceneRockExp);
    end;
  end;

begin
  case FSize of
    rsLarge:
      begin
        DoSplit(Entity.GetFrame, rsMedium, Entity.GetPos);
        DoSplit(Entity.GetFrame, rsMedium, Entity.GetPos );
        DoExplosion(3.0);
        DoParticles;
        GV.Audio.PlaySound(AUDIO_DYNAMIC_CHANNEL, Game.Sfx[cSfxRockExp], cVolRockExp, False);
      end;

    rsMedium:
      begin
        DoSplit(Entity.GetFrame, rsSmall, Entity.GetPos);
        DoSplit(Entity.GetFrame, rsSmall, Entity.GetPos);
        DoExplosion(2.5);
        DoParticles;
        GV.Audio.PlaySound(AUDIO_DYNAMIC_CHANNEL, Game.Sfx[cSfxRockExp], cVolRockExp, False);

      end;

    rsSmall:
      begin
        DoExplosion(1.5);
        DoParticles;
        GV.Audio.PlaySound(AUDIO_DYNAMIC_CHANNEL, Game.Sfx[cSfxRockExp], cVolRockExp, False);
      end;
  end;

  Terminated := True;
end;


{ TPlayer }
constructor TPlayer.Create;
begin
  Player := Self;

  inherited;

  FTimer    := 0;
  FCurFrame := 0;
  FThrusting:= False;
  FCurAngle := 0;
  DirVec.Clear;
  FTurnSpeed := 0;

  Init(Game.Sprite, Game.PlayerSprID.Group);
  Entity.TracePolyPoint(6, 12, 70);
  Entity.SetPosAbs(Game.Settings.WindowWidth /2, Game.Settings.WindowHeight /2);
  Entity.SetRenderPolyPoint(DEBUG_RENDERPOLYPOINT);
end;

destructor TPlayer.Destroy;
begin
  inherited;

  Player := nil;
end;

procedure TPlayer.OnRender;
begin
  inherited;
end;

procedure TPlayer.OnUpdate(aDelta: Double);
var
  LP: TGVVector;
  LFire: Boolean;
  LTurn: Integer;
  LAccel: Boolean;
begin
  if GV.Input.KeyPressed(KEY_LCTRL) or
     GV.Input.KeyPressed(KEY_RCTRL) or
     GV.Input.JoystickPressed(JOY_BTN_RB) then
    LFire := True
  else
    LFire := False;

  if GV.Input.KeyDown(KEY_RIGHT) or
     GV.Input.JoystickDown(JOY_BTN_RDPAD) then
    LTurn := 1
  else
  if GV.Input.KeyDown(KEY_LEFT) or
     GV.Input.JoystickDown(JOY_BTN_LDPAD) then
    LTurn := -1
  else
    LTurn := 0;

  if (GV.Input.KeyDown(KEY_UP)) or
     GV.Input.JoystickDown(JOY_BTN_UDPAD) then
    LAccel := true
  else
    LAccel := False;

  // update keys
  if LFire then
  begin
    FireWeapon(10*cMultiplier);
  end;

  if LTurn = 1 then
  begin
    GV.Math.SmoothMove(FTurnSpeed, cPlayerTurnAccel*aDelta, cPlayerMaxTurn, cPlayerTurnDrag*aDelta);
  end
  else if LTurn = -1 then
    begin
      GV.Math.SmoothMove(FTurnSpeed, -cPlayerTurnAccel*aDelta, cPlayerMaxTurn, cPlayerTurnDrag*aDelta);
    end
  else
    begin
      GV.Math.SmoothMove(FTurnSpeed, 0, cPlayerMaxTurn, cPlayerTurnDrag*aDelta);
    end;

  FCurAngle := FCurAngle + FTurnSpeed*aDelta;
  if FCurAngle > 360 then
    FCurAngle := FCurAngle - 360
  else if FCurAngle < 0 then
    FCurAngle := FCurAngle + 360;

  FThrusting := False;
  if (LAccel) then
  begin
    FThrusting := True;

    if (DirVec.Magnitude < cPlayerMagnitude) then
    begin
      DirVec.Thrust(FCurAngle, cPlayerAccel*aDelta);
    end;

    if GV.Audio.GetChannelStatus(cChanPlayerEngine) = TGVAudioStatus.Stopped then
    begin
      GV.Audio.PlaySound(cChanPlayerEngine, Game.Sfx[cSfxPlayerEngine], cVolPlayerEngine, True);
    end;

  end;

  GV.Math.SmoothMove(DirVec.X, 0, cPlayerMagnitude, cPlayerFriction*aDelta);
  GV.Math.SmoothMove(DirVec.Y, 0, cPlayerMagnitude, cPlayerFriction*aDelta);

  LP := Entity.GetPos;
  LP.X := LP.X + DirVec.X*aDelta;
  LP.Y := LP.Y + DirVec.Y*aDelta;

  WrapPosAtEdge(LP);

  if (FThrusting) then
    begin
      if (GV.Game.FrameSpeed(FTimer, cPlayerFrameFPS)) then
      begin
        FCurFrame := FCurFrame + 1;
        if (FCurFrame > cPlayerLastFrame) then
        begin
          FCurFrame := cPlayerFirstFrame;
        end
      end;

    end
  else
    begin
      FCurFrame := cPlayerNeutralFrame;

      if GV.Audio.GetChannelStatus(cChanPlayerEngine) = TGVAudioStatus.Playing then
      begin
        GV.Audio.StopChannel(cChanPlayerEngine);
      end;
    end;

  Entity.RotateAbs(FCurAngle);
  Entity.SetFrame(FCurFrame);
  Entity.SetPosAbs(LP.X, LP.Y);

  //inherited;
end;

procedure TPlayer.Spawn(aX, aY: Single);
begin
end;

procedure TPlayer.FireWeapon(aSpeed: Single);
var
  LP: TGVVector;
  LW: TWeapon;
begin
  LP := Entity.GetPos;
  LP.Thrust(Entity.GetAngle, 16);
  LW := TWeapon.Create;
  LW.Spawn(0, LP, Entity.GetAngle, aSpeed);
  Game.Scene[cScenePlayerWeapon].Add(LW);
  GV.Audio.PlaySound(cChanPlayerWeapon, Game.Sfx[cSfxPlayerWeapon], cVolPlayerWeapon, False);
end;


{ TExampleTemplate }
constructor TAstroBlaster.Create;
begin
  inherited;
  Game := Self;
end;

destructor TAstroBlaster.Destroy;
begin
  Game := nil;
  inherited;
end;

function TAstroBlaster.OnStartupDialog: Boolean;
begin
  StartupDialog.SetCaption('GameVision - AstroBlaster Demo');
  StartupDialog.SetLogo(Archive, 'arc/startupdialog/banner.png');
  StartupDialog.SetLogoClickUrl('https://gamevisiontoolkit.com');
  StartupDialog.SetReadme(Archive, 'arc/startupdialog/README.rtf');
  StartupDialog.SetLicense(Archive, 'arc/startupdialog/LICENSE.rtf');
  StartupDialog.SetReleaseInfo('Version '+GV_VERSION);
  Result := True;
end;

procedure TAstroBlaster.OnSetSettings(var aSettings: TGVGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'GameVision - AstroBlaster Demo';
  aSettings.WindowClearColor := BLACK;
  aSettings.SceneCount := cSceneCount;
end;

procedure TAstroBlaster.OnStartup;
begin
  inherited;

// init background
  FBkColor.FromByte(255,255,255,128);

  Background[0] := TGVTexture.Create;
  Background[1] := TGVTexture.Create;
  Background[2] := TGVTexture.Create;
  Background[3] := TGVTexture.Create;

  Background[0].Load(Archive, 'arc/images/space.png',  @BLACK);
  Background[1].Load(Archive, 'arc/images/nebula.png', @BLACK);
  Background[2].Load(Archive, 'arc/images/spacelayer1.png', @BLACK);
  Background[3].Load(Archive, 'arc/images/spacelayer2.png', @BLACK);

    // init player sprites
  PlayerSprID.Page := Sprite.LoadPage(Archive, 'arc/images/ship.png', nil);
  PlayerSprID.Group := Sprite.AddGroup;
  Sprite.AddImageFromGrid(PlayerSprID.Page, PlayerSprID.Group, 0, 0, 64, 64);
  Sprite.AddImageFromGrid(PlayerSprID.Page, PlayerSprID.Group, 1, 0, 64, 64);
  Sprite.AddImageFromGrid(PlayerSprID.Page, PlayerSprID.Group, 2, 0, 64, 64);
  Sprite.AddImageFromGrid(PlayerSprID.Page, PlayerSprID.Group, 3, 0, 64, 64);


  // init enemy sprites
  EnemySprID.Page := PlayerSprID.Page;
  EnemySprID.Group := Sprite.AddGroup;
  Sprite.AddImageFromGrid(EnemySprID.Page, EnemySprID.Group, 0, 1, 64, 64);
  Sprite.AddImageFromGrid(EnemySprID.Page, EnemySprID.Group, 1, 1, 64, 64);
  Sprite.AddImageFromGrid(EnemySprID.Page, EnemySprID.Group, 2, 1, 64, 64);

  // init shield sprites
  ShieldsSprID.Page := PlayerSprID.Page;
  ShieldsSprID.Group := Sprite.AddGroup;
  Sprite.AddImageFromGrid(ShieldsSprID.Page, ShieldsSprID.Group, 0, 4, 32, 32);
  Sprite.AddImageFromGrid(ShieldsSprID.Page, ShieldsSprID.Group, 1, 4, 32, 32);
  Sprite.AddImageFromGrid(ShieldsSprID.Page, ShieldsSprID.Group, 2, 4, 32, 32);

  // init wepason sprites
  WeaponSprID.Page := PlayerSprID.Page;
  WeaponSprID.Group := Sprite.AddGroup;
  Sprite.AddImageFromGrid(WeaponSprID.Page, WeaponSprID.Group, 3, 4, 32, 32);
  Sprite.AddImageFromGrid(WeaponSprID.Page, WeaponSprID.Group, 4, 4, 32, 32);
  Sprite.AddImageFromGrid(WeaponSprID.Page, WeaponSprID.Group, 5, 4, 32, 32);

  // init rock sprites
  RocksSprID.Page := Sprite.LoadPage(Archive, 'arc/images/rocks.png', nil);
  RocksSprID.Group := Sprite.AddGroup;
  Sprite.AddImageFromGrid(RocksSprID.Page, RocksSprID.Group, 0, 0, 128, 128);
  Sprite.AddImageFromGrid(RocksSprID.Page, RocksSprID.Group, 1, 0, 128, 128);
  Sprite.AddImageFromGrid(RocksSprID.Page, RocksSprID.Group, 0, 1, 128, 128);


  // init explosion sprites
  ExplosionSprID.Page := Sprite.LoadPage(Archive, 'arc/images/explosion.png', nil);
  ExplosionSprID.Group := Sprite.AddGroup;
  Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 0, 0, 64, 64);
  Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 1, 0, 64, 64);
  Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 2, 0, 64, 64);
  Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 3, 0, 64, 64);

  Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 0, 1, 64, 64);
  Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 1, 1, 64, 64);
  Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 2, 1, 64, 64);
  Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 3, 1, 64, 64);

  Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 0, 2, 64, 64);
  Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 1, 2, 64, 64);
  Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 2, 2, 64, 64);
  Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 3, 2, 64, 64);

  Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 0, 3, 64, 64);
  Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 1, 3, 64, 64);
  Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 2, 3, 64, 64);
  Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 3, 3, 64, 64);

  // init particles
  ParticlesSprID.Page := Sprite.LoadPage(Archive, 'arc/images/particles.png', nil);
  ParticlesSprID.Group := Sprite.AddGroup;
  Sprite.AddImageFromGrid(ParticlesSprID.Page, ParticlesSprID.Group, 0, 0, 64, 64);

  GV.Audio.SetChannelReserved(0, True);
  GV.Audio.SetChannelReserved(1, True);

  // init sfx
  Sfx[cSfxRockExp] := GV.Audio.LoadSound(Archive, 'arc/sfx/explo_rock.ogg');
  Sfx[cSfxPlayerExp] := GV.Audio.LoadSound(Archive, 'arc/sfx/explo_player.ogg');
  Sfx[cSfxEnemyExp] := GV.Audio.LoadSound(Archive, 'arc/sfx/explo_enemy.ogg');
  Sfx[cSfxPlayerEngine] := GV.Audio.LoadSound(Archive, 'arc/sfx/engine_player.ogg');
  Sfx[cSfxPlayerWeapon] := GV.Audio.LoadSound(Archive, 'arc/sfx/weapon_player.ogg');

  FMusic := GV.Audio.LoadMusic(Archive, 'arc/music/song13.ogg');
  GV.Audio.PlayMusic(FMusic, 1.0, True);
end;

procedure TAstroBlaster.OnShutdown;
begin
  Scene.ClearAll;

  GV.Audio.UnloadMusic(FMusic);

  GV.Audio.UnloadSound(Sfx[cSfxRockExp]);
  GV.Audio.UnloadSound(Sfx[cSfxPlayerExp]);
  GV.Audio.UnloadSound(Sfx[cSfxEnemyExp]);
  GV.Audio.UnloadSound(Sfx[cSfxPlayerEngine]);
  GV.Audio.UnloadSound(Sfx[cSfxPlayerWeapon]);

  FreeAndNil(Background[3]);
  FreeAndNil(Background[2]);
  FreeAndNil(Background[1]);
  FreeAndNil(Background[0]);

  inherited;
end;

procedure TAstroBlaster.OnUpdateFrame(aDeltaTime: Double);
var
  LP: TGVVector;
begin
  inherited;

  if Assigned(Player) then
  begin
    LP := Player.DirVec;
    FBkPos.X := FBkPos.X + (LP.X * aDeltaTime);
    FBkPos.Y := FBkPos.Y + (LP.Y * aDeltaTime);
  end;

  if LevelCleared then
  begin
    SpawnLevel;
  end;
end;

const
  mBM = 3;

procedure TAstroBlaster.OnRenderFrame;
begin
  // render background
  Background[0].DrawTiled(-(FBkPos.X/1.9*mBM), -(FBkPos.Y/1.9*mBM));

  GV.Window.SetBlendMode(bmAdditiveAlpha);
  Background[1].DrawTiled(-(FBkPos.X/1.9*mBM), -(FBkPos.Y/1.9*mBM));
  GV.Window.RestoreDefaultBlendMode;
  Background[2].DrawTiled(-(FBkPos.X/1.6*mBM), -(FBkPos.Y/1.6*mBM));
  Background[3].DrawTiled(-(FBkPos.X/1.3*mBM), -(FBkPos.Y/1.3*mBM));

  inherited;
end;

procedure TAstroBlaster.OnRenderHUD;
begin
  inherited;

  HudText(Font, GREEN,  haLeft, HudTextItem('Left', 'Rotate left'), []);
  HudText(Font, GREEN,  haLeft, HudTextItem('Right', 'Rotate right'), []);
  HudText(Font, GREEN,  haLeft, HudTextItem('Up', 'Thrust'), []);
  HudText(Font, GREEN,  haLeft, HudTextItem('Ctrl', 'Fire'), []);
  HudText(Font, YELLOW, haLeft, HudTextItem('Count:', ' %d', ''), [Scene[cSceneRocks].Count]);
end;

procedure TAstroBlaster.OnBeforeRenderScene(aSceneNum: Integer);
begin
  case aSceneNum of
    cSceneRockExp:
    begin
      GV.Window.SetBlendMode(bmAdditiveAlpha);
    end
  else
    //TBitmap.EnableDrawDeferred(True);
  end;
end;

procedure TAstroBlaster.OnAfterRenderScene(aSceneNum: Integer);
begin
  case aSceneNum of
    cSceneRockExp:
    begin
      GV.Window.RestoreDefaultBlendMode;
    end
  else
    //TBitmap.EnableDrawDeferred(False);
  end;
end;

procedure TAstroBlaster.SpawnRocks;
var
  LI, LC: Integer;
  LId: Integer;
  LSize: TRockSize;
  LAngle: Single;
  LRock: TRock;
  LRadius : Single;
  LPos: TGVVector;
begin

  LC := GV.Math.RandomRange(cRocksMin, cRocksMax);

  for LI := 1 to LC do
  begin
    LId := GV.Math.RandomRange(0, 2);
    LSize := TRockSize(GV.Math.RandomRange(0, 2));

    LPos.x := Settings.WindowWidth / 2;
    LPos.y := Settings.WindowHeight /2;

    LRadius := (LPos.x + LPos.y) / 2;
    LAngle := GV.Math.RandomRange(0, 359);
    LPos.Thrust(LAngle, LRadius);

    LRock := TRock.Create;
    LRock.Spawn(LId, LSize, LPos, LAngle);
    Game.Scene[cSceneRocks].Add(LRock);
  end;
end;

procedure TAstroBlaster.SpawnPlayer;
begin
  Scene.Lists[cScenePlayer].Add(TPlayer.Create);
end;

procedure TAstroBlaster.SpawnLevel;
begin
  Scene.ClearAll;
  SpawnRocks;
  SpawnPlayer;
end;

function TAstroBlaster.LevelCleared: Boolean;
begin
  if (Scene[cSceneRocks].Count        > 0) or
     (Scene[cSceneRockExp].Count      > 0) or
     (Scene[cScenePlayerWeapon].Count > 0) then
    Result := False
  else
    Result := True;
end;

end.
