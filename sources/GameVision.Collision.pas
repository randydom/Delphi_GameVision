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

unit GameVision.Collision;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Base,
  GameVision.Math;

type

  { TGVLineIntersection }
  TGVLineIntersection = (liNone, liTrue, liParallel);

  { TGVCollision }
  TGVCollision = class(TGVObject)
  public
    constructor Create; override;
    destructor Destroy; override;
    function PointInRectangle(aPoint: TGVVector; aRect: TGVRectangle): Boolean;
    function PointInCircle(aPoint, aCenter: TGVVector; aRadius: Single): Boolean;
    function PointInTriangle(aPoint, aP1, aP2, aP3: TGVVector): Boolean;
    function CirclesOverlap(aCenter1: TGVVector; aRadius1: Single; aCenter2: TGVVector; aRadius2: Single): Boolean;
    function CircleInRectangle(aCenter: TGVVector; aRadius: Single; aRect: TGVRectangle): Boolean;
    function RectanglesOverlap(aRect1: TGVRectangle; aRect2: TGVRectangle): Boolean;
    function RectangleIntersection(aRect1, aRect2: TGVRectangle): TGVRectangle;
    function LineIntersection(aX1, aY1, aX2, aY2, aX3, aY3, aX4, aY4: Integer; var aX: Integer; var aY: Integer): TGVLineIntersection;
    function RadiusOverlap(aRadius1, aX1, aY1, aRadius2, aX2, aY2, aShrinkFactor: Single): Boolean;
  end;

implementation

uses
  System.Math;

{ TGVCollision }
constructor TGVCollision.Create;
begin
  inherited;
end;

destructor TGVCollision.Destroy;
begin
  inherited;
end;

function TGVCollision.PointInRectangle(aPoint: TGVVector; aRect: TGVRectangle): Boolean;
begin
  if ((aPoint.x >= aRect.x) and (aPoint.x <= (aRect.x + aRect.width)) and
    (aPoint.y >= aRect.y) and (aPoint.y <= (aRect.y + aRect.height))) then
    Result := True
  else
    Result := False;
end;

function TGVCollision.PointInCircle(aPoint, aCenter: TGVVector; aRadius: Single): Boolean;
begin
  Result := CirclesOverlap(aPoint, 0, aCenter, aRadius);
end;

function TGVCollision.PointInTriangle(aPoint, aP1, aP2, aP3: TGVVector): Boolean;
var
  LAlpha, LBeta, LGamma: Single;
begin
  LAlpha := ((aP2.y - aP3.y) * (aPoint.x - aP3.x) + (aP3.x - aP2.x) *
    (aPoint.y - aP3.y)) / ((aP2.y - aP3.y) * (aP1.x - aP3.x) + (aP3.x - aP2.x) *
    (aP1.y - aP3.y));

  LBeta := ((aP3.y - aP1.y) * (aPoint.x - aP3.x) + (aP1.x - aP3.x) *
    (aPoint.y - aP3.y)) / ((aP2.y - aP3.y) * (aP1.x - aP3.x) + (aP3.x - aP2.x) *
    (aP1.y - aP3.y));

  LGamma := 1.0 - LAlpha - LBeta;

  if ((LAlpha > 0) and (LBeta > 0) and (LGamma > 0)) then
    Result := True
  else
    Result := False;
end;

function TGVCollision.CirclesOverlap(aCenter1: TGVVector; aRadius1: Single; aCenter2: TGVVector; aRadius2: Single): Boolean;
var
  LDX, LDY, LDistance: Single;
begin
  LDX := aCenter2.x - aCenter1.x; // X distance between centers
  LDY := aCenter2.y - aCenter1.y; // Y distance between centers

  LDistance := sqrt(LDX * LDX + LDY * LDY); // Distance between centers

  if (LDistance <= (aRadius1 + aRadius2)) then
    Result := True
  else
    Result := False;
end;

function TGVCollision.CircleInRectangle(aCenter: TGVVector; aRadius: Single; aRect: TGVRectangle): Boolean;
var
  LDX, LDY: Single;
  LCornerDistanceSq: Single;
  LRecCenterX: Integer;
  LRecCenterY: Integer;
begin
  LRecCenterX := Round(aRect.x + aRect.width / 2);
  LRecCenterY := Round(aRect.y + aRect.height / 2);

  LDX := abs(aCenter.x - LRecCenterX);
  LDY := abs(aCenter.y - LRecCenterY);

  if (LDX > (aRect.width / 2.0 + aRadius)) then
  begin
    Result := False;
    Exit;
  end;

  if (LDY > (aRect.height / 2.0 + aRadius)) then
  begin
    Result := False;
    Exit;
  end;

  if (LDX <= (aRect.width / 2.0)) then
  begin
    Result := True;
    Exit;
  end;
  if (LDY <= (aRect.height / 2.0)) then
  begin
    Result := True;
    Exit;
  end;

  LCornerDistanceSq := (LDX - aRect.width / 2.0) * (LDX - aRect.width / 2.0) +
    (LDY - aRect.height / 2.0) * (LDY - aRect.height / 2.0);

  Result := Boolean(LCornerDistanceSq <= (aRadius * aRadius));
end;

function TGVCollision.RectanglesOverlap(aRect1: TGVRectangle; aRect2: TGVRectangle): Boolean;
var
  LDX, LDY: Single;
begin
  LDX := abs((aRect1.x + aRect1.width / 2) - (aRect2.x + aRect2.width / 2));
  LDY := abs((aRect1.y + aRect1.height / 2) - (aRect2.y + aRect2.height / 2));

  if ((LDX <= (aRect1.width / 2 + aRect2.width / 2)) and
    ((LDY <= (aRect1.height / 2 + aRect2.height / 2)))) then
    Result := True
  else
    Result := False;
end;

function TGVCollision.RectangleIntersection(aRect1, aRect2: TGVRectangle): TGVRectangle;
var
  LDXX, LDYY: Single;
begin
  Result.Assign(0, 0, 0, 0);

  if RectanglesOverlap(aRect1, aRect2) then
  begin
    LDXX := abs(aRect1.x - aRect2.x);
    LDYY := abs(aRect1.y - aRect2.y);

    if (aRect1.x <= aRect2.x) then
    begin
      if (aRect1.y <= aRect2.y) then
      begin
        Result.x := aRect2.x;
        Result.y := aRect2.y;
        Result.width := aRect1.width - LDXX;
        Result.height := aRect1.height - LDYY;
      end
      else
      begin
        Result.x := aRect2.x;
        Result.y := aRect1.y;
        Result.width := aRect1.width - LDXX;
        Result.height := aRect2.height - LDYY;
      end
    end
    else
    begin
      if (aRect1.y <= aRect2.y) then
      begin
        Result.x := aRect1.x;
        Result.y := aRect2.y;
        Result.width := aRect2.width - LDXX;
        Result.height := aRect1.height - LDYY;
      end
      else
      begin
        Result.x := aRect1.x;
        Result.y := aRect1.y;
        Result.width := aRect2.width - LDXX;
        Result.height := aRect2.height - LDYY;
      end
    end;

    if (aRect1.width > aRect2.width) then
    begin
      if (Result.width >= aRect2.width) then
        Result.width := aRect2.width;
    end
    else
    begin
      if (Result.width >= aRect1.width) then
        Result.width := aRect1.width;
    end;

    if (aRect1.height > aRect2.height) then
    begin
      if (Result.height >= aRect2.height) then
        Result.height := aRect2.height;
    end
    else
    begin
      if (Result.height >= aRect1.height) then
        Result.height := aRect1.height;
    end
  end;
end;

function TGVCollision.LineIntersection(aX1, aY1, aX2, aY2, aX3, aY3, aX4, aY4: Integer; var aX: Integer; var aY: Integer): TGVLineIntersection;
var
  LAX, LBX, LCX, LAY, LBY, LCY, LD, LE, LF, LNum: Integer;
  LOffset: Integer;
  LX1Lo, LX1Hi, LY1Lo, LY1Hi: Integer;
begin
  Result := liNone;

  LAX := aX2 - aX1;
  LBX := aX3 - aX4;

  if (LAX < 0) then // X bound box test
  begin
    LX1Lo := aX2;
    LX1Hi := aX1;
  end
  else
  begin
    LX1Hi := aX2;
    LX1Lo := aX1;
  end;

  if (LBX > 0) then
  begin
    if (LX1Hi < aX4) or (aX3 < LX1Lo) then
      Exit;
  end
  else
  begin
    if (LX1Hi < aX3) or (aX4 < LX1Lo) then
      Exit;
  end;

  LAY := aY2 - aY1;
  LBY := aY3 - aY4;

  if (LAY < 0) then // Y bound box test
  begin
    LY1Lo := aY2;
    LY1Hi := aY1;
  end
  else
  begin
    LY1Hi := aY2;
    LY1Lo := aY1;
  end;

  if (LBY > 0) then
  begin
    if (LY1Hi < aY4) or (aY3 < LY1Lo) then
      Exit;
  end
  else
  begin
    if (LY1Hi < aY3) or (aY4 < LY1Lo) then
      Exit;
  end;

  LCX := aX1 - aX3;
  LCY := aY1 - aY3;
  LD := LBY * LCX - LBX * LCY; // alpha numerator
  LF := LAY * LBX - LAX * LBY; // both denominator

  if (LF > 0) then // alpha tests
  begin
    if (LD < 0) or (LD > LF) then
      Exit;
  end
  else
  begin
    if (LD > 0) or (LD < LF) then
      Exit
  end;

  LE := LAX * LCY - LAY * LCX; // beta numerator
  if (LF > 0) then // beta tests
  begin
    if (LE < 0) or (LE > LF) then
      Exit;
  end
  else
  begin
    if (LE > 0) or (LE < LF) then
      Exit;
  end;

  // compute intersection coordinates

  if (LF = 0) then
  begin
    Result := liParallel;
    Exit;
  end;

  LNum := LD * LAX; // numerator
  // if SameSigni(num, f) then
  if Sign(LNum) = Sign(LF) then

    LOffset := LF div 2
  else
    LOffset := -LF div 2;
  aX := aX1 + (LNum + LOffset) div LF; // intersection x

  LNum := LD * LAY;
  // if SameSigni(num, f) then
  if Sign(LNum) = Sign(LF) then
    LOffset := LF div 2
  else
    LOffset := -LF div 2;

  aY := aY1 + (LNum + LOffset) div LF; // intersection y

  Result := liTrue;
end;

function TGVCollision.RadiusOverlap(aRadius1, aX1, aY1, aRadius2, aX2, aY2, aShrinkFactor: Single): Boolean;

var
  LDist: Single;
  LR1, LR2: Single;
  LV1, LV2: TGVVector;
begin
  LR1 := aRadius1 * aShrinkFactor;
  LR2 := aRadius2 * aShrinkFactor;

  LV1.x := aX1;
  LV1.y := aY1;
  LV2.x := aX2;
  LV2.y := aY2;

  LDist := LV1.distance(LV2);

  if (LDist < LR1) or (LDist < LR2) then
    Result := True
  else
    Result := False;
end;

end.
