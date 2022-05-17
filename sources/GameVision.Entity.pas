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

unit GameVision.Entity;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Base,
  GameVision.Sprite,
  GameVision.Math,
  GameVision.Color;

type
  { TGVEntity }
  TGVEntity = class(TGVObject)
  protected
    FSprite      : TGVSprite;
    FGroup       : Integer;
    FFrame       : Integer;
    FFrameFPS    : Single;
    FFrameTimer  : Single;
    FPos         : TGVVector;
    FDir         : TGVVector;
    FScale       : Single;
    FAngle       : Single;
    FAngleOffset : Single;
    FColor       : TGVColor;
    FHFlip       : Boolean;
    FVFlip       : Boolean;
    FLoopFrame   : Boolean;
    FWidth       : Single;
    FHeight      : Single;
    FRadius      : Single;
    FFirstFrame  : Integer;
    FLastFrame   : Integer;
    FShrinkFactor: Single;
    FOrigin      : TGVVector;
    FRenderPolyPoint: Boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Init(aSprite: TGVSprite; aGroup: Integer);
    procedure SetFrameRange(aFirst: Integer; aLast: Integer);
    function  NextFrame: Boolean;
    function  PrevFrame: Boolean;
    function  GetFrame: Integer;
    procedure SetFrame(aFrame: Integer);
    function  GetFrameFPS: Single;
    procedure SetFrameFPS(aFrameFPS: Single);
    function  GetFirstFrame: Integer;
    function  GetLastFrame: Integer;
    procedure SetPosAbs(aX: Single; aY: Single);
    procedure SetPosRel(aX: Single; aY: Single);
    function  GetPos: TGVVector;
    function  GetDir: TGVVector;
    procedure SetScaleAbs(aScale: Single);
    procedure SetScaleRel(aScale: Single);
    function  GetAngle: Single;
    function  GetAngleOffset: Single;
    procedure SetAngleOffset(aAngle: Single);
    procedure RotateAbs(aAngle: Single);
    procedure RotateRel(aAngle: Single);
    function  RotateToAngle(aAngle: Single; aSpeed: Single): Boolean;
    function  RotateToPos(aX: Single; aY: Single; aSpeed: Single): Boolean;
    function  RotateToPosAt(aSrcX: Single; aSrcY: Single; aDestX: Single; aDestY: Single; aSpeed: Single): Boolean;
    procedure Thrust(aSpeed: Single);
    procedure ThrustAngle(aAngle: Single; aSpeed: Single);
    function  ThrustToPos(aThrustSpeed: Single; aRotSpeed: Single; aDestX: Single; aDestY: Single; aSlowdownDist: Single; aStopDist: Single; aStopSpeed: Single; aStopSpeedEpsilon: Single; aDeltaTime: Single): Boolean;
    function  IsVisible(aVirtualX: Single; aVirtualY: Single): Boolean;
    function  IsFullyVisible(aVirtualX: Single; aVirtualY: Single): Boolean;
    function  Overlap(aX: Single; aY: Single; aRadius: Single; aShrinkFactor: Single): Boolean; overload;
    function  Overlap(aEntity: TGVEntity): Boolean; overload;
    procedure Render(aVirtualX: Single; aVirtualY: Single);
    procedure RenderAt(aX: Single; aY: Single);
    function  GetSprite: TGVSprite;
    function  GetGroup: Integer;
    function  GetScale: Single;
    function  GetColor: TGVColor;
    procedure SetColor(aColor: TGVColor);
    procedure GetFlipMode(aHFlip: PBoolean; aVFlip: PBoolean);
    procedure SetFlipMode(aHFlip: PBoolean; aVFlip: PBoolean);
    function  GetLoopFrame: Boolean;
    procedure SetLoopFrame(aLoop: Boolean);
    function  GetWidth: Single;
    function  GetHeight: Single;
    function  GetRadius: Single;
    function  GetShrinkFactor: Single;
    procedure SetShrinkFactor(aShrinkFactor: Single);
    procedure SetRenderPolyPoint(aRenderPolyPoint: Boolean);
    function  GetRenderPolyPoint: Boolean;
    procedure TracePolyPoint(aMju: Single=6; aMaxStepBack: Integer=12; aAlphaThreshold: Integer=70; aOrigin: PGVVector=nil);
    function  CollidePolyPoint(aEntity: TGVEntity; var aHitPos: TGVVector): Boolean;
    function  CollidePolyPointPoint(var aPoint: TGVVector): Boolean;
  end;

implementation

uses
  GameVision.Core;

{ TGVEntity }
constructor TGVEntity.Create;
begin
  inherited;
end;

destructor TGVEntity.Destroy;
begin
  inherited;
end;

procedure TGVEntity.Init(aSprite: TGVSprite; aGroup: Integer);
begin
  FSprite      := aSprite;
  FGroup       := aGroup;
  FFrame       := 0;
  FFrameFPS    := 15;
  FScale       := 1.0;
  FAngle       := 0;
  FAngleOffset := 0;
  FColor       := WHITE;
  FHFlip       := False;
  FVFlip       := False;
  FLoopFrame   := True;
  FRenderPolyPoint := False;
  FShrinkFactor:= 1.0;
  FOrigin.X := 0.5;
  FOrigin.Y := 0.5;
  FFrameTimer := 0;
  SetPosAbs(0, 0);
  SetFrameRange(0, aSprite.GetImageCount(FGroup)-1);
  SetFrame(FFrame);
end;

procedure TGVEntity.SetFrameRange(aFirst: Integer; aLast: Integer);
begin
  FFirstFrame := aFirst;
  FLastFrame  := aLast;
end;

function  TGVEntity.NextFrame: Boolean;
begin
  Result := False;
  if GV.Game.FrameSpeed(FFrameTimer, FFrameFPS) then
  begin
    Inc(FFrame);
    if FFrame > FLastFrame then
    begin
      if FLoopFrame then
        FFrame := FFirstFrame
      else
        FFrame := FLastFrame;
      Result := True;
    end;
  end;
  SetFrame(FFrame);
end;

function  TGVEntity.PrevFrame: Boolean;
begin
  Result := False;
  if GV.Game.FrameSpeed(FFrameTimer, FFrameFPS) then
  begin
    Dec(FFrame);
    if FFrame < FFirstFrame then
    begin
      if FLoopFrame then
        FFrame := FLastFrame
      else
        FFrame := FFirstFrame;
      Result := True;
    end;
  end;

  SetFrame(FFrame);
end;

function  TGVEntity.GetFrame: Integer;
begin
  Result := FFrame;
end;

procedure TGVEntity.SetFrame(aFrame: Integer);
var
  LW, LH, LR: Single;
begin
  if aFrame > FSprite.GetImageCount(FGroup)-1  then
    FFrame := FSprite.GetImageCount(FGroup)-1
  else
    FFrame := aFrame;

  LW := FSprite.GetImageWidth(FFrame, FGroup);
  LH := FSprite.GetImageHeight(FFrame, FGroup);

  LR := (LW + LH) / 2;

  FWidth  := LW * FScale;
  FHeight := LH * FScale;
  FRadius := LR * FScale;
end;

function  TGVEntity.GetFrameFPS: Single;
begin
  Result := FFrameFPS;
end;

procedure TGVEntity.SetFrameFPS(aFrameFPS: Single);
begin
  FFrameFPS := aFrameFPS;
  FFrameTimer := 0;
end;

function  TGVEntity.GetFirstFrame: Integer;
begin
  Result := FFirstFrame;
end;

function  TGVEntity.GetLastFrame: Integer;
begin
  Result := FLastFrame;
end;

procedure TGVEntity.SetPosAbs(aX: Single; aY: Single);
begin
  FPos.X := aX;
  FPos.Y := aY;
  FDir.X := 0;
  FDir.Y := 0;
end;

procedure TGVEntity.SetPosRel(aX: Single; aY: Single);
begin
  FPos.X := FPos.X + aX;
  FPos.Y := FPos.Y + aY;
  FDir.X := aX;
  FDir.Y := aY;
end;

function  TGVEntity.GetPos: TGVVector;
begin
  Result := FPos;
end;

function  TGVEntity.GetDir: TGVVector;
begin
  Result := FDir;
end;

procedure TGVEntity.SetScaleAbs(aScale: Single);
begin
  FScale := aScale;
  SetFrame(FFrame);
end;

procedure TGVEntity.SetScaleRel(aScale: Single);
begin
  FScale := FScale + aScale;
  SetFrame(FFrame);
end;

function  TGVEntity.GetAngle: Single;
begin
  Result := FAngle;
end;

function  TGVEntity.GetAngleOffset: Single;
begin
  Result := FAngleOffset;
end;

procedure TGVEntity.SetAngleOffset(aAngle: Single);
begin
  aAngle := aAngle + FAngleOffset;
  GV.Math.ClipValue(aAngle, 0, 360, True);
  FAngleOffset := aAngle;
end;

procedure TGVEntity.RotateAbs(aAngle: Single);
begin
  GV.Math.ClipValue(aAngle, 0, 360, True);
  FAngle := aAngle;
end;

procedure TGVEntity.RotateRel(aAngle: Single);
begin
  aAngle := aAngle + FAngle;
  GV.Math.ClipValue(aAngle, 0, 360, True);
  FAngle := aAngle;
end;

function  TGVEntity.RotateToAngle(aAngle: Single; aSpeed: Single): Boolean;
var
  Step: Single;
  Len : Single;
  S   : Single;
begin
  Result := False;
  Step := GV.Math.AngleDifference(FAngle, aAngle);
  Len  := Sqrt(Step*Step);
  if Len = 0 then
    Exit;
  S    := (Step / Len) * aSpeed;
  FAngle := FAngle + S;
  if GV.Math.SameValue(Step, 0, S) then
  begin
    RotateAbs(aAngle);
    Result := True;
  end;
end;

function  TGVEntity.RotateToPos(aX: Single; aY: Single; aSpeed: Single): Boolean;
var
  LAngle: Single;
  LStep: Single;
  LLen: Single;
  LS: Single;
  LTmpPos: TGVVector;
begin
  Result := False;
  LTmpPos.X  := aX;
  LTmpPos.Y  := aY;

  LAngle := -FPos.Angle(LTmpPos);
  LStep := GV.Math.AngleDifference(FAngle, LAngle);
  LLen  := Sqrt(LStep*LStep);
  if LLen = 0 then
    Exit;
  LS := (LStep / LLen) * aSpeed;

  if not GV.Math.SameValue(LStep, LS, aSpeed) then
    RotateRel(LS)
  else begin
    RotateRel(LStep);
    Result := True;
  end;
end;

function  TGVEntity.RotateToPosAt(aSrcX: Single; aSrcY: Single; aDestX: Single; aDestY: Single; aSpeed: Single): Boolean;
var
  LAngle: Single;
  LStep : Single;
  LLen  : Single;
  LS    : Single;
  LSPos,LDPos : TGVVector;
begin
  Result := False;
  LSPos.X := aSrcX;
  LSPos.Y := aSrcY;
  LDPos.X  := aDestX;
  LDPos.Y  := aDestY;

  LAngle := LSPos.Angle(LDPos);
  LStep := GV.Math.AngleDifference(FAngle, LAngle);
  LLen  := Sqrt(LStep*LStep);
  if LLen = 0 then
    Exit;
  LS := (LStep / LLen) * aSpeed;
  if not GV.Math.SameValue(LStep, LS, aSpeed) then
    RotateRel(LS)
  else begin
    RotateRel(LStep);
    Result := True;
  end;
end;

procedure TGVEntity.Thrust(aSpeed: Single);
var
  LA, LS: Single;
begin
  LA := FAngle + 90.0;
  GV.Math.ClipValue(LA, 0, 360, True);

  LS := -aSpeed;

  FDir.x := GV.Math.AngleCos(Round(LA)) * LS;
  FDir.y := GV.Math.AngleSin(Round(LA)) * LS;

  FPos.x := FPos.x + FDir.x;
  FPos.y := FPos.y + FDir.y;
end;

procedure TGVEntity.ThrustAngle(aAngle: Single; aSpeed: Single);
var
  LA, LS: Single;
begin
  LA := aAngle;

  GV.Math.ClipValue(LA, 0, 360, True);

  LS := -aSpeed;

  FDir.x := GV.Math.AngleCos(Round(LA)) * LS;
  FDir.y := GV.Math.AngleSin(Round(LA)) * LS;

  FPos.x := FPos.x + FDir.x;
  FPos.y := FPos.y + FDir.y;
end;

function  TGVEntity.ThrustToPos(aThrustSpeed: Single; aRotSpeed: Single; aDestX: Single; aDestY: Single; aSlowdownDist: Single; aStopDist: Single; aStopSpeed: Single; aStopSpeedEpsilon: Single; aDeltaTime: Single): Boolean;
var
  LDist : Single;
  LStep : Single;
  LSpeed: Single;
  LDestPos: TGVVector;
begin
  Result := False;

  if aSlowdownDist <= 0 then Exit;
  if aStopDist < 0 then aStopDist := 0;

  LDestPos.X := aDestX;
  LDestPos.Y := aDestY;
  LDist := FPos.Distance(LDestPos);

  LDist := LDist - aStopDist;

  if LDist > aSlowdownDist then
    begin
      LSpeed := aThrustSpeed;
    end
  else
    begin
      LStep := (LDist/aSlowdownDist);
      LSpeed := (aThrustSpeed * LStep);
      if LSpeed <= aStopSpeed then
      begin
        LSpeed := 0;
        Result := True;
      end;
    end;

  if RotateToPos(aDestX, aDestY, aRotSpeed*aDeltaTime) then
  begin
    Thrust(LSpeed*aDeltaTime);
  end;
end;

function  TGVEntity.IsVisible(aVirtualX: Single; aVirtualY: Single): Boolean;
var
  LHW,LHH: Single;
  LVPW,LVPH: Integer;
  LX,LY: Single;
  LSize: TGVRectangle;
begin
  Result := False;

  LHW := FWidth / 2;
  LHH := FHeight / 2;

  GV.Window.GetViewportSize(LSize);
  LVPW := Round(LSize.Width);
  LVPH := Round(LSize.Height);

  Dec(LVPW); Dec(LVPH);

  LX := FPos.X - aVirtualX;
  LY := FPos.Y - aVirtualY;

  if LX > (LVPW + LHW) then Exit;
  if LX < -LHW    then Exit;
  if LY > (LVPH + LHH) then Exit;
  if LY < -LHH    then Exit;

  Result := True;
end;

function  TGVEntity.IsFullyVisible(aVirtualX: Single; aVirtualY: Single): Boolean;
var
  LHW,LHH: Single;
  LVPW,LVPH: Integer;
  LX,LY: Single;
  LSize: TGVRectangle;
begin
  Result := False;

  LHW := FWidth / 2;
  LHH := FHeight / 2;

  GV.Window.GetViewportSize(LSize);
  LVPW := Round(LSize.Width);
  LVPH := Round(LSize.Height);

  Dec(LVPW); Dec(LVPH);

  LX := FPos.X - aVirtualX;
  LY := FPos.Y - aVirtualY;

  if LX > (LVPW - LHW) then Exit;
  if LX <  LHW       then Exit;
  if LY > (LVPH - LHH) then Exit;
  if LY <  LHH       then Exit;

  Result := True;
end;

function  TGVEntity.Overlap(aX: Single; aY: Single; aRadius: Single; aShrinkFactor: Single): Boolean;
var
  LDist: Single;
  LR1,LR2: Single;
  LV0,LV1: TGVVector;
begin
  LR1  := FRadius * aShrinkFactor;
  LR2  := aRadius * aShrinkFactor;

  LV0.X := FPos.X;
  LV0.Y := FPos.Y;

  LV1.x := aX;
  LV1.y := aY;

  LDist := LV0.Distance(LV1);

  if (LDist < LR1) or (LDist < LR2) then
    Result := True
  else
   Result := False;
end;

function  TGVEntity.Overlap(aEntity: TGVEntity): Boolean;
begin
  Result := Overlap(aEntity.GetPos.X, aEntity.GetPos.Y, aEntity.GetRadius, aEntity.GetShrinkFactor);
end;

procedure TGVEntity.Render(aVirtualX: Single; aVirtualY: Single);
var
  LX,LY: Single;
  LSV: TGVVector;
begin
  LX := FPos.X - aVirtualX;
  LY := FPos.Y - aVirtualY;
  LSV.Assign(FScale, FScale);
  FSprite.DrawImage(FFrame, FGroup, LX, LY, @FOrigin, @LSV, FAngle, FColor, FHFlip, FVFlip, FRenderPolyPoint);
end;

procedure TGVEntity.RenderAt(aX: Single; aY: Single);
var
  LSV: TGVVector;
begin
  LSV.Assign(FScale, FScale);
  FSprite.DrawImage(FFrame, FGroup, aX, aY, @FOrigin, @LSV, FAngle, FColor, FHFlip, FVFlip, FRenderPolyPoint);
end;

function  TGVEntity.GetSprite: TGVSprite;
begin
  Result := FSprite;
end;

function  TGVEntity.GetGroup: Integer;
begin
  Result := FGroup;
end;

function  TGVEntity.GetScale: Single;
begin
  Result := FScale;
end;

function  TGVEntity.GetColor: TGVColor;
begin
 Result := FColor;
end;

procedure TGVEntity.SetColor(aColor: TGVColor);
begin
  FColor := aColor;
end;

procedure TGVEntity.GetFlipMode(aHFlip: PBoolean; aVFlip: PBoolean);
begin
  if Assigned(aHFlip) then
    aHFlip^ := FHFlip;
  if Assigned(aVFlip) then
    aVFlip^ := FVFlip;
end;

procedure TGVEntity.SetFlipMode(aHFlip: PBoolean; aVFlip: PBoolean);
begin
  if aHFlip <> nil then
    FHFlip := aHFlip^;

  if aVFlip <> nil then
    FVFlip := aVFlip^;
end;

function  TGVEntity.GetLoopFrame: Boolean;
begin
  Result := FLoopFrame;
end;

procedure TGVEntity.SetLoopFrame(aLoop: Boolean);
begin
  FLoopFrame := aLoop;
end;

function  TGVEntity.GetWidth: Single;
begin
  Result := FWidth;
end;

function  TGVEntity.GetHeight: Single;
begin
  Result := FHeight;
end;

function  TGVEntity.GetRadius: Single;
begin
  Result := FRadius;
end;

function  TGVEntity.GetShrinkFactor: Single;
begin
  Result := FShrinkFactor;
end;

procedure TGVEntity.SetShrinkFactor(aShrinkFactor: Single);
begin
  FShrinkFactor := aShrinkFactor;
end;

procedure TGVEntity.SetRenderPolyPoint(aRenderPolyPoint: Boolean);
begin
  FRenderPolyPoint := aRenderPolyPoint;
end;

function  TGVEntity.GetRenderPolyPoint: Boolean;
begin
  Result := FRenderPolyPoint;
end;

procedure TGVEntity.TracePolyPoint(aMju: Single; aMaxStepBack: Integer; aAlphaThreshold: Integer; aOrigin: PGVVector);
begin
  FSprite.GroupPolyPointTrace(FGroup, aMju, aMaxStepBack, aAlphaThreshold, aOrigin);
end;

function  TGVEntity.CollidePolyPoint(aEntity: TGVEntity; var aHitPos: TGVVector): Boolean;
var
  LShrinkFactor: Single;
  LHFlip,LVFlip: Boolean;
begin
  LShrinkFactor := (FShrinkFactor + aEntity.GetShrinkFactor) / 2.0;

  aEntity.GetFlipMode(@LHFlip, @LVFlip);

  Result := FSprite.GroupPolyPointCollide(
    FFrame, FGroup, Round(FPos.X), Round(FPos.Y), FScale, FAngle, @FOrigin,
    FHFlip, FVFlip, aEntity.FSprite, aEntity.FFrame, aEntity.FGroup,
    Round(aEntity.FPos.X), Round(aEntity.FPos.Y), aEntity.FScale,
    aEntity.FAngle, @aEntity.FOrigin, LHFlip, LVFlip,
    LShrinkFactor, aHitPos);
end;

function  TGVEntity.CollidePolyPointPoint(var aPoint: TGVVector): Boolean;
var
  LShrinkFactor: Single;
begin
  LShrinkFactor := FShrinkFactor;

  Result := FSprite.GroupPolyPointCollidePoint(FFrame, FGroup, FPos.X, FPos.Y,
    FScale, FAngle, @FOrigin, FHFlip, FVFlip, LShrinkFactor, aPoint);
end;

end.
