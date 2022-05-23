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

unit uRenderTargets;

interface

uses
  System.SysUtils,
  System.Math,
  GameVision.Common,
  GameVision.Math,
  GameVision.Color,
  GameVision.Actor,
  GameVision.RenderTarget,
  GameVision.Starfield,
  GameVision.Polygon,
  GameVision.Texture,
  GameVision.Core,
  GameVision.Game,
  uCommon;

const
  GRAVITY        = 0.4;
  XDECAY         = 0.97;
  YDECAY         = 0.97;
  ELASTICITY     = 0.77;
  WALLDECAY      = 1.0;
  BALL_SIZE      = 30;
  BALL_SIZE_HALF = BALL_SIZE div 2;

type

  { TViewportWindow }
  TViewportWindow = record
    w,h: Integer;
    x,y,sx,sy: Single;
    minx,maxx: Single;
    miny,maxy: Single;
    color: TGVColor;
  end;

  { TAViewport }
  TAViewport = class(TGVActor)
  protected
    FHandle: TGVRenderTarget;
    FSize : TGVVector;
    FPos  : TGVVector;
    FSpeed: TGVVector;
    FRange: TGVRange;
    FColor: TGVColor;
    FCaption: string;
  public
    property Caption: string read FCaption write FCaption;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure PrintCaption(aColor: TGVColor);
  end;

  { TAViewport1 }
  TAViewport1 = class(TAViewport)
  protected
    FPolygon: TGVPolygon;
    FOrigin : TGVVector;
    FAngle  : Single;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
  end;

  { TAViewport2 }
  TAViewport2 = class(TAViewport)
  protected
    FBallPos: TGVVector;
    FBallSpeed: TGVVector;
    FTimer: Single;
  public
    constructor Create;  override;
    destructor Destroy; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
  end;

  { TAViewport3 }
  TAViewport3 = class(TAViewport)
  protected
    FTileTexture: TGVTexture;
    FTilePos: TGVVector;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
  end;

  { TAViewport4 }
  TAViewport4 = class(TAViewport)
  protected
    FStarfield: TGVStarfield;
  public
    constructor Create;  override;
    destructor Destroy; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
  end;


  { TRenderTargets }
  TRenderTargets = class(TBaseExample)
  protected
    FMusic: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnSetSettings(var aSettings: TGVGameSettings); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
  end;

implementation

var
  Game: TRenderTargets = nil;

{  TAViewport }
constructor TAViewport.Create;
begin
  inherited;

  FPos.X := 10;
  FPos.Y := 10;
  FSize.X := 50;
  FSize.Y := 50;
  FRange.miny := 0;
  FRange.minx := 0;
  FRange.maxx := FRange.minx + 20;
  FRange.maxy := FRange.miny + 20;
  FSpeed.x := GV.Math.RandomRange(0.1*60,0.3*60);
  FSpeed.y := GV.Math.RandomRange(0.1*60,0.3*60);

  FColor := WHITE;
  FCaption := 'A RenderTarget';

  FHandle := nil;
end;

destructor TAViewport.Destroy;
begin
  //GV.Release(FHandle);
  FreeAndNil(FHandle);
  inherited;
end;

procedure TAViewport.OnUpdate(aDeltaTime: Double);
begin
  // update horizontal movement
  FPos.x := FPos.x + (FSpeed.x * aDeltaTime);
  if (FPos.x < FRange.MinX) then
    begin
      FPos.x  := FRange.Minx;
      FSpeed.x := -FSpeed.x;
    end
  else if (FPos.x > FRange.Maxx) then
    begin
      FPos.x  := FRange.Maxx;
      FSpeed.x := -FSpeed.x;
    end;

  // update horizontal movement
  FPos.y := FPos.y + (FSpeed.y * aDeltaTime);
  if (FPos.y < FRange.Miny) then
    begin
      FPos.y  := FRange.Miny;
      FSpeed.y := -FSpeed.y;
    end
  else if (FPos.y > FRange.Maxy) then
    begin
      FPos.y  := FRange.Maxy;
      FSpeed.y := -FSpeed.y;
    end;

  FHandle.SetPosition(Round(FPos.X), Round(FPos.y));
end;

procedure TAViewport.OnRender;
begin
  //GV.Window.SetRenderTarget(FHandle);
  FHandle.SetActive(True);
  GV.Window.Clear(FColor);
end;

procedure TAViewport.PrintCaption(aColor: TGVColor);
begin
  Game.Font.PrintText(3, 3, aColor, haLeft, FCaption, []);
end;


{ TAViewport1 }
constructor TAViewport1.Create;
begin
  inherited;

  Caption := 'RenderTarget #1';

  FSize.x := 380;
  FSize.y := 280;

  FPos.x := 10;
  FPos.y := 10;

  FRange.miny := 0;
  FRange.minx := 0;
  FRange.maxx := FRange.minx + 20;
  FRange.maxy := FRange.miny + 20;

  FColor := DIMGRAY;

  //GV.Get(IViewport, FHandle);
  FHandle := TGVRenderTarget.Create;
  FHandle.Init(Round(FSize.X), Round(FSize.Y));
  FHandle.SetPosition(FPos.X, FPos.Y);

  // init polygon
  //Piro.Get(IPolygon, FPolygon);
  FPolygon := TGVPolygon.Create;
  FPolygon.AddLocalPoint(0, 0, True);
  FPolygon.AddLocalPoint(128, 0, True);
  FPolygon.AddLocalPoint(128, 128, True);
  FPolygon.AddLocalPoint(0, 128, True);
  FPolygon.AddLocalPoint(0, 0, True);

  // you can either use local coords such as -64, -64, 64, 64 etc and when
  // transformed it will be center or easier just use specify an origin. In this
  // case this polygon span is 128 so set the origin xy to 64 to center it on
  // screen.
  FOrigin.X := 64;
  FOrigin.Y := 64;
end;

destructor TAViewport1.Destroy;
begin
  //Piro.Release(FPolygon);
  FreeAndNil(FPolygon);
  inherited;
end;

procedure TAViewport1.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  // update angle by DeltaTime to keep it constant. In this case the default
  // fps is 30 so we are in effect adding on degree every second.
  FAngle := FAngle + (30.0 * aDeltaTime);

  // just clip between 0 and 360 with wrapping. if greater than max value, it
  // will set min to value-max.
  GV.Math.ClipValue(FAngle, 0, 360, True);
end;

procedure TAViewport1.OnRender;
begin
  inherited;

  // render polygon in center of screen
  //Polygon_Render(FPolygon, Round(FSize.X / 2), Round(FSize.Y / 2), 1, FAngle, 1, YELLOW, FLIP_NONE, @FOrigin);
  FPolygon.Render(FSize.X / 2, FSize.Y / 2, 1, FAngle, 1, YELLOW, @FOrigin, False, False);
  PrintCaption(BLACK);

  FHandle.SetActive(False);
  FHandle.Show;

  //Piro.Display.SetViewport(nil);
end;

{ TAViewport2 }
constructor TAViewport2.Create;
begin
  inherited;

  Caption := 'RenderTarget #2';

  FSize.x := 380;
  FSize.y := 280;

  FPos.x := 410;
  FPos.y := 10;

  FRange.miny := 0;
  FRange.minx := 400-10;
  FRange.maxx := FRange.minx + 20;
  FRange.maxy := FRange.miny + 20;

  FColor.FromByte(77, 157, 251, 255);

  //GV.Get(IViewport, FHandle);
  FHandle := TGVRenderTarget.Create;
  FHandle.Init(Round(FSize.X), Round(FSize.Y));
  FHandle.SetPosition(FPos.X, FPos.y);

  FBallPos.x := GV.Math.RandomRange(BALL_SIZE_HALF, FSize.x-BALL_SIZE_HALF);
  FBallPos.y := BALL_SIZE_HALF;

  FBallSpeed.x := GV.Math.RandomRange(-50,50);
  FBallSpeed.y := GV.Math.RandomRange(3,7);
  FTimer := 0;
end;

destructor TAViewport2.Destroy;
begin
  inherited;
end;

procedure TAViewport2.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  if not GV.Game.FrameSpeed(FTimer, 60) then
    Exit;

  if GV.Math.SameValue(FBallSpeed.x, 0, 0.001) then
  begin
    FBallPos.x := GV.Math.RandomRange(BALL_SIZE_HALF, FSize.x-BALL_SIZE_HALF);
    FBallPos.y := BALL_SIZE_HALF;
    FBallSpeed.x := GV.Math.RandomRange(-50,50);
    FBallSpeed.y := GV.Math.RandomRange(3,7);
  end;

  // decay
  FBallSpeed.x := FBallSpeed.x * XDECAY;
  FBallSpeed.y := FBallSpeed.y * XDECAY;

  // gravity
  FBallSpeed.y := FBallSpeed.y + GRAVITY;

  // move
  FBallPos.x := FBallPos.x + FBallSpeed.x;
  FBallPos.y := FBallPos.y + FBallSpeed.y;

  if (FBallPos.x < BALL_SIZE) then
    begin
      FBallPos.x  := BALL_SIZE;
      FBallSpeed.x := -FBallSpeed.x * WALLDECAY;
    end;
  //else
  if (FBallPos.x > FSize.x-BALL_SIZE) then
    begin
      FBallPos.x  := FSize.x-BALL_SIZE;
      FBallSpeed.x := -FBallSpeed.x * WALLDECAY;
    end;

  // update horizontal movement

  if (FBallPos.y < BALL_SIZE) then
    begin
      FBallPos.y  := BALL_SIZE;
      FBallSpeed.y := -FBallSpeed.y * WALLDECAY;
    end;
  //else
  if (FBallPos.y > FSize.y-BALL_SIZE) then
    begin
      FBallPos.y  := FSize.y-BALL_SIZE;
      FBallSpeed.y := -FBallSpeed.y * WALLDECAY;
    end;
end;

procedure TAViewport2.OnRender;
begin
  inherited;

  GV.Primitive.FilledCircle(FBallPos.X, FBallPos.Y, BALL_SIZE, RED);

  PrintCaption(YELLOW);

  Game.Font.PrintTExt(1, 15, WHITE, haLeft, 'x,y: %f,%f',[Abs(FBallSpeed.x),Abs(FBallSpeed.y)]);

  FHandle.SetActive(False);
  FHandle.Show;
  //Piro.Display.SetViewport(nil);
end;

{ TAViewport3 }
constructor TAViewport3.Create;
begin
  inherited;

  Caption := 'RenderTarget #3';

  FSize.x := 380;
  FSize.y := 280;

  FPos.x := 10;
  FPos.y := 310;

  FRange.miny := 300-10;
  FRange.minx := 0;
  FRange.maxx := FRange.minx + 20;
  FRange.maxy := FRange.miny + 20;

  FColor := BLACK;

  //Piro.Get(IViewport, FHandle);
  FHandle := TGVRenderTarget.Create;
  FHandle.Init(Round(FSize.X), Round(FSize.Y));
  FHandle.SetPosition(FPos.X, FPos.Y);

  FTilePos.x := 0;
  FTilePos.y := 0;

  //Piro.Get(IBitmap, FTileTexture);
  FTileTexture := TGVTexture.Create;
  FTileTexture.Load(Game.Archive, 'arc/images/bluestone.png', nil);
end;

destructor TAViewport3.Destroy;
begin
  //Piro.Release(FTileTexture);
  FreeAndNil(FTileTexture);
  inherited;
end;

procedure TAViewport3.OnUpdate(aDeltaTime: Double);
begin
  inherited;
  FTilePos.y := FTilePos.y + ((7.0*60) * aDeltaTime);
end;

procedure TAViewport3.OnRender;
begin
  inherited;

  // tile texture across viewport
  FTileTexture.DrawTiled(FTilePos.x,FTilePos.y);

  // display the viewport caption
  PrintCaption(WHITE);

  //GV.Display.SetViewport(nil);
  FHandle.SetActive(False);
  FHandle.Show;
end;

{ TAViewport4 }
constructor TAViewport4.Create;
begin
  inherited;

  Caption := 'RenderTarget #4';

  FSize.x := 380;
  FSize.y := 280;

  FPos.x := 410;
  FPos.y := 310;


  FRange.miny := 300-10;
  FRange.minx := 400-10;
  FRange.maxx := FRange.minx + 20;
  FRange.maxy := FRange.miny + 20;

  FColor := BLACK;

  //Piro.Get(IViewport, FHandle);
  FHandle := TGVRenderTarget.Create;
  FHandle.Init(Round(FSize.X), Round(FSize.Y));
  FHandle.SetPosition(FPos.X, FPos.y);

  //Piro.Get(IStarfield, FStarfield);
  FStarfield := TGVStarfield.Create;
  FStarfield.SetZSpeed(-(60*3));
end;

destructor TAViewport4.Destroy;
begin
  //Piro.Release(FStarField);
  FreeAndNil(FStarfield);

  inherited;
end;

procedure TAViewport4.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  FStarfield.Update(aDeltaTime);
end;

procedure TAViewport4.OnRender;
begin
  inherited;

  FStarfield.Render;
  PrintCaption(WHITE);
  //Piro.Display.SetViewport(nil);
  FHandle.SetActive(False);
  FHandle.Show;
end;

{ TRenderTargets }
constructor TRenderTargets.Create;
begin
  inherited;
  Game := Self;
end;

destructor TRenderTargets.Destroy;
begin
  Game := nil;
  inherited;
end;
procedure TRenderTargets.OnSetSettings(var aSettings: TGVGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'GameVision - RenderTargets';
  aSettings.WindowWidth := 800;
  aSettings.WindowHeight := 600;
  aSettings.WindowClearColor := DIMWHITE;
end;

procedure TRenderTargets.OnStartup;
begin
  inherited;
  //Scene[0].Add(TAViewport.Create);


  Scene[0].Add(TAViewport1.Create);
  Scene[0].Add(TAViewport2.Create);
  Scene[0].Add(TAViewport3.Create);
  Scene[0].Add(TAViewport4.Create);

  FMusic := GV.Audio.LoadMusic(Archive, 'arc/music/song01.ogg');
  GV.Audio.PlayMusic(FMusic, 1.0, True);
end;

procedure TRenderTargets.OnShutdown;
begin
  GV.Audio.UnloadMusic(FMusic);
  inherited;
end;



end.
