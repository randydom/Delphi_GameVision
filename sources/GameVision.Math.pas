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

unit GameVision.Math;

{$I GameVision.Defines.inc}

interface

uses
  GameVision.Base;

type
  { TGVVector }
  TGVVector = record
    X,Y,Z, W: Single;
    constructor Create(aX, aY: Single); overload;
    constructor Create(aX, aY, aZ: Single); overload;
    constructor Create(aX, aY, aZ, aW: Single); overload;
    procedure Assign(aX, aY: Single); overload;
    procedure Assign(aX, aY, aZ: Single); overload;
    procedure Assign(aX, aY, aZ, aW: Single); overload;
    procedure Assign(aVector: TGVVector); overload;
    procedure Clear;
    procedure Add(aVector: TGVVector); inline;
    procedure Subtract(aVector: TGVVector);
    procedure Multiply(aVector: TGVVector);
    procedure Divide(aVector: TGVVector);
    function  Magnitude: Single;
    function  MagnitudeTruncate(aMaxMagitude: Single): TGVVector;
    function  Distance(aVector: TGVVector): Single;
    procedure Normalize;
    function  Angle(aVector: TGVVector): Single;
    procedure Thrust(aAngle: Single; aSpeed: Single);
    function  MagnitudeSquared: Single;
    function  DotProduct(aVector: TGVVector): Single;
    procedure Scale(aValue: Single);
    procedure DivideBy(aValue: Single);
    function  Project(aVector: TGVVector): TGVVector;
    procedure Negate;
  end;

  { PGVVector }
  PGVVector = ^TGVVector;

  { TGVRectangle }
  TGVRectangle = record
    X, Y, Width, Height: Single;
    constructor Create(aX, aY, aWidth, aHeight: Single);
    procedure Assign(aX, aY, aWidth, aHeight: Single); overload;
    procedure Assign(aRectangle: TGVRectangle); overload;
    procedure Clear;
    function Intersect(aRect: TGVRectangle): Boolean;
  end;

  { PGVRectangle }
  PGVRectangle = ^TGVRectangle;

  { TGVRange }
  PGVRange = ^TGVRange;
  TGVRange = record
    MinX, MinY, MaxX, MaxY: Single;
  end;

type
  { TGVMath }
  TGVMath = class(TGVObject)
  protected
    FCosTable: array [0 .. 360] of Single;
    FSinTable: array [0 .. 360] of Single;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Randomize;
    function  RandomRange(aMin, aMax: Integer): Integer; overload;
    function  RandomRange(aMin, aMax: Single): Single; overload;
    function  RandomBool: Boolean;
    function  GetRandomSeed: Integer;
    procedure SetRandomSeed(aValue: Integer);
    function  AngleCos(aAngle: Integer): Single;
    function  AngleSin(aAngle: Integer): Single;
    function  AngleDifference(aSrcAngle: Single; aDestAngle: Single): Single;
    procedure AngleRotatePos(aAngle: Single; var aX: Single; var aY: Single);
    function  ClipValue(var aValue: Single; aMin: Single; aMax: Single; aWrap: Boolean): Single; overload;
    function  ClipValue(var aValue: Integer; aMin: Integer; aMax: Integer; aWrap: Boolean): Integer; overload;
    function  SameSign(aValue1: Integer; aValue2: Integer): Boolean; overload;
    function  SameSign(aValue1: Single; aValue2: Single): Boolean; overload;
    function  SameValue(aA: Double; aB: Double; aEpsilon: Double = 0): Boolean; overload;
    function  SameValue(aA: Single; aB: Single; aEpsilon: Single = 0): Boolean; overload;
    function  Vector(aX: Single; aY: Single): TGVVector;
    function  Rectangle(aX: Single; aY: Single; aWidth: Single; aHeight: Single): TGVRectangle;
    procedure SmoothMove(var aValue: Single; aAmount: Single; aMax: Single; aDrag: Single);
    function  Lerp(aFrom: Double; aTo: Double; aTime: Double): Double;
  end;

implementation

uses
  System.Math,
  GameVision.Common,
  GameVision.Core;

{ TGVVector }
constructor TGVVector.Create(aX, aY: Single);
begin
  X := aX;
  Y := aY;
  Z := 0;
  W := 0;
end;

constructor TGVVector.Create(aX, aY, aZ: Single);
begin
  X := aX;
  Y := aY;
  Z := aZ;
  W := 0;
end;

constructor TGVVector.Create(aX, aY, aZ, aW: Single);
begin
  X := aX;
  Y := aY;
  Z := aZ;
  W := aW;
end;

procedure TGVVector.Assign(aX, aY: Single);
begin
  X := aX;
  Y := aY;
  Z := 0;
  W := 0;
end;

procedure TGVVector.Assign(aX, aY, aZ: Single);
begin
  X := aX;
  Y := aY;
  Z := aZ;
  W := 0;
end;

procedure TGVVector.Assign(aX, aY, aZ, aW: Single);
begin
  X := aX;
  Y := aY;
  Z := aZ;
  W := aW;
end;

procedure TGVVector.Assign(aVector: TGVVector);
begin
  Self := aVector;
end;

procedure TGVVector.Clear;
begin
  X := 0;
  Y := 0;
  Z := 0;
  W := 0;
end;

procedure TGVVector.Add(aVector: TGVVector);
begin
  X := X + aVector.X;
  Y := Y + aVector.Y;
end;

procedure TGVVector.Subtract(aVector: TGVVector);
begin
  X := X - aVector.X;
  Y := Y - aVector.Y;
end;

procedure TGVVector.Multiply(aVector: TGVVector);
begin
  X := X * aVector.X;
  Y := Y * aVector.Y;
end;

procedure TGVVector.Divide(aVector: TGVVector);
begin
  X := X / aVector.X;
  Y := Y / aVector.Y;
end;

function  TGVVector.Magnitude: Single;
begin
  Result := Sqrt((X * X) + (Y * Y));
end;

function  TGVVector.MagnitudeTruncate(aMaxMagitude: Single): TGVVector;
var
  LMaxMagSqrd: Single;
  LVecMagSqrd: Single;
  LTruc: Single;
begin
  Result.Assign(X, Y);
  LMaxMagSqrd := aMaxMagitude * aMaxMagitude;
  LVecMagSqrd := Result.Magnitude;
  if LVecMagSqrd > LMaxMagSqrd then
  begin
    LTruc := (aMaxMagitude / Sqrt(LVecMagSqrd));
    Result.X := Result.X * LTruc;
    Result.Y := Result.Y * LTruc;
  end;
end;

function  TGVVector.Distance(aVector: TGVVector): Single;
var
  LDirVec: TGVVector;
begin
  LDirVec.X := X - aVector.X;
  LDirVec.Y := Y - aVector.Y;
  Result := LDirVec.Magnitude;
end;

procedure TGVVector.Normalize;
var
  LLen, LOOL: Single;
begin
  LLen := self.Magnitude;
  if LLen <> 0 then
  begin
    LOOL := 1.0 / LLen;
    X := X * LOOL;
    Y := Y * LOOL;
  end;
end;

function  TGVVector.Angle(aVector: TGVVector): Single;
var
  LXOY: Single;
  LR: TGVVector;
begin
  LR.Assign(self);
  LR.Subtract(aVector);
  LR.Normalize;

  if LR.Y = 0 then
  begin
    LR.Y := 0.001;
  end;

  LXOY := LR.X / LR.Y;

  Result := ArcTan(LXOY) * GV_RAD2DEG;
  if LR.Y < 0 then
    Result := Result + 180.0;
end;

procedure TGVVector.Thrust(aAngle: Single; aSpeed: Single);
var
  LA: Single;

begin
  LA := aAngle + 90.0;

  GV.Math.ClipValue(LA, 0, 360, True);

  X := X + GV.Math.AngleCos(Round(LA)) * -(aSpeed);
  Y := Y + GV.Math.AngleSin(Round(LA)) * -(aSpeed);
end;

function  TGVVector.MagnitudeSquared: Single;
begin
  Result := (X * X) + (Y * Y);
end;

function  TGVVector.DotProduct(aVector: TGVVector): Single;
begin
  Result := (X * aVector.X) + (Y * aVector.Y);
end;

procedure TGVVector.Scale(aValue: Single);
begin
  X := X * aValue;
  Y := Y * aValue;
end;

procedure TGVVector.DivideBy(aValue: Single);
begin
  X := X / aValue;
  Y := Y / aValue;
end;

function  TGVVector.Project(aVector: TGVVector): TGVVector;
var
  LDP: Single;
begin
  LDP := DotProduct(aVector);
  Result.X := (LDP / (aVector.X * aVector.X + aVector.Y * aVector.Y)) * aVector.X;
  Result.Y := (LDP / (aVector.X * aVector.X + aVector.Y * aVector.Y)) * aVector.Y;
end;

procedure TGVVector.Negate;
begin
  X := -X;
  Y := -Y;
end;

{ TGVRectangle }
constructor TGVRectangle.Create(aX, aY, aWidth, aHeight: Single);
begin
  X := aX;
  Y := aY;
  Width := aWidth;
  Height := aHeight;
end;

procedure TGVRectangle.Assign(aX, aY, aWidth, aHeight: Single);
begin
  X := aX;
  Y := aY;
  Width := aWidth;
  Height := aHeight;
end;

procedure TGVRectangle.Assign(aRectangle: TGVRectangle);
begin
  X := aRectangle.X;
  Y := aRectangle.Y;
  Width := aRectangle.Width;
  Height := aRectangle.Height;
end;

procedure TGVRectangle.Clear;
begin
  X := 0;
  Y := 0;
  Width := 0;
  Height := 0;
end;

function TGVRectangle.Intersect(aRect: TGVRectangle): Boolean;
var
  LR1R, LR1B: Single;
  LR2R, LR2B: Single;
begin
  LR1R := X - (Width - 1);
  LR1B := Y - (Height - 1);
  LR2R := aRect.X - (aRect.Width - 1);
  LR2B := aRect.Y - (aRect.Height - 1);

  Result := (X < LR2R) and (LR1R > aRect.X) and (Y < LR2B) and (LR1B > aRect.Y);
end;

{ TGVMath }
constructor TGVMath.Create;
var
  LI: Integer;
begin
  inherited;

  Randomize;

  for LI := 0 to 360 do
  begin
    FCosTable[LI] := cos((LI * PI / 180.0));
    FSinTable[LI] := sin((LI * PI / 180.0));
  end;
end;

destructor TGVMath.Destroy;
begin
  inherited;
end;

procedure TGVMath.Randomize;
begin
  System.Randomize;
end;

function _RandomRange(const aFrom, aTo: Integer): Integer;
var
  LFrom: Integer;
  LTo: Integer;
begin
  LFrom := aFrom;
  LTo := aTo;

  if AFrom > ATo then
    Result := Random(LFrom - LTo) + ATo
  else
    Result := Random(LTo - LFrom) + AFrom;

  //Result := RandomRange(aFrom, Result);
end;

function  TGVMath.RandomRange(aMin, aMax: Integer): Integer;
begin
  //Result := System.Math.RandomRange(aMin, aMax + 1);
  Result := _RandomRange(aMin, aMax + 1);
end;

function  TGVMath.RandomRange(aMin, aMax: Single): Single;
var
  LNum: Single;
begin
  //LNum := System.Math.RandomRange(0, MaxInt) / MaxInt;
  LNum := _RandomRange(0, MaxInt) / MaxInt;
  Result := aMin + (LNum * (aMax - aMin));
end;

function  TGVMath.RandomBool: Boolean;
begin
  Result := Boolean(System.Math.RandomRange(0, 2) = 1);
end;

function  TGVMath.GetRandomSeed: Integer;
begin
  Result := System.RandSeed;
end;

procedure TGVMath.SetRandomSeed(aValue: Integer);
begin
  System.RandSeed := aValue;
end;

function  TGVMath.AngleCos(aAngle: Integer): Single;
begin
  Result := 0;
  if (aAngle < 0) or (aAngle > 360) then Exit;
  Result := FCosTable[aAngle];
end;

function  TGVMath.AngleSin(aAngle: Integer): Single;
begin
  Result := 0;
  if (aAngle < 0) or (aAngle > 360) then Exit;
  Result := FSinTable[aAngle];
end;

function  TGVMath.AngleDifference(aSrcAngle: Single; aDestAngle: Single): Single;
var
  LC: Single;
begin
  LC := aDestAngle - aSrcAngle -
    (Floor((aDestAngle - aSrcAngle) / 360.0) * 360.0);

  if LC >= (360.0 / 2) then
  begin
    LC := LC - 360.0;
  end;
  Result := LC;
end;

procedure TGVMath.AngleRotatePos(aAngle: Single; var aX: Single; var aY: Single);
var
  LNX, LNY: Single;
  LIA: Integer;
begin
  ClipValue(aAngle, 0, 359, True);

  LIA := Round(aAngle);

  LNX := aX * FCosTable[LIA] - aY * FSinTable[LIA];
  LNY := aY * FCosTable[LIA] + aX * FSinTable[LIA];

  aX := LNX;
  aY := LNY;
end;

function  TGVMath.ClipValue(var aValue: Single; aMin: Single; aMax: Single; aWrap: Boolean): Single;
begin
  if aWrap then
    begin
      if (aValue > aMax) then
      begin
        aValue := aMin + Abs(aValue - aMax);
        if aValue > aMax then
          aValue := aMax;
      end
      else if (aValue < aMin) then
      begin
        aValue := aMax - Abs(aValue - aMin);
        if aValue < aMin then
          aValue := aMin;
      end
    end
  else
    begin
      if aValue < aMin then
        aValue := aMin
      else if aValue > aMax then
        aValue := aMax;
    end;

  Result := aValue;

end;

function  TGVMath.ClipValue(var aValue: Integer; aMin: Integer; aMax: Integer; aWrap: Boolean): Integer;
begin
  if aWrap then
    begin
      if (aValue > aMax) then
      begin
        aValue := aMin + Abs(aValue - aMax);
        if aValue > aMax then
          aValue := aMax;
      end
      else if (aValue < aMin) then
      begin
        aValue := aMax - Abs(aValue - aMin);
        if aValue < aMin then
          aValue := aMin;
      end
    end
  else
    begin
      if aValue < aMin then
        aValue := aMin
      else if aValue > aMax then
        aValue := aMax;
    end;

  Result := aValue;
end;

function  TGVMath.SameSign(aValue1: Integer; aValue2: Integer): Boolean;
begin
  if Sign(aValue1) = Sign(aValue2) then
    Result := True
  else
    Result := False;
end;

function  TGVMath.SameSign(aValue1: Single; aValue2: Single): Boolean;
begin
  if Sign(aValue1) = Sign(aValue2) then
    Result := True
  else
    Result := False;
end;

function  TGVMath.SameValue(aA: Double; aB: Double; aEpsilon: Double): Boolean;
begin
  Result := System.Math.SameValue(aA, aB, aEpsilon);
end;

function  TGVMath.SameValue(aA: Single; aB: Single; aEpsilon: Single): Boolean;
begin
  Result := System.Math.SameValue(aA, aB, aEpsilon);
end;

function  TGVMath.Vector(aX: Single; aY: Single): TGVVector;
begin
  Result.X := aX;
  Result.Y := aY;
  Result.Z := 0;
  Result.Z := 0;
  Result.W := 0;
end;

function  TGVMath.Rectangle(aX: Single; aY: Single; aWidth: Single; aHeight: Single): TGVRectangle;
begin
  Result.X := aX;
  Result.Y := aY;
  Result.Width := aWidth;
  Result.Height := aHeight;
end;

procedure TGVMath.SmoothMove(var aValue: Single; aAmount: Single; aMax: Single; aDrag: Single);
var
  LAmt: Single;
begin
  LAmt := aAmount;

  if LAmt > 0 then
  begin
    aValue := aValue + LAmt;
    if aValue > aMax then
      aValue := aMax;
  end else if LAmt < 0 then
  begin
    aValue := aValue + LAmt;
    if aValue < -aMax then
      aValue := -aMax;
  end else
  begin
    if aValue > 0 then
    begin
      aValue := aValue - aDrag;
      if aValue < 0 then
        aValue := 0;
    end else if aValue < 0 then
    begin
      aValue := aValue + aDrag;
      if aValue > 0 then
        aValue := 0;
    end;
  end;
end;

function  TGVMath.Lerp(aFrom: Double; aTo: Double; aTime: Double): Double;
begin
  if aTime <= 0.5 then
    Result := aFrom + (aTo - aFrom) * aTime
  else
    Result := aTo - (aTo - aFrom) * (1.0 - aTime);
end;

end.
