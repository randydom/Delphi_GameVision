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

unit GameVision.Sprite;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Base,
  GameVision.Math,
  GameVision.Color,
  GameVision.Texture,
  GameVision.Polygon,
  GameVision.Archive;

type
  TGVPolyPoint = class;
  TGVSprite = class;

  { PolyPointTrace }
  PolyPointTrace = record
  private
    type
      TPointi = record
        X,Y: Integer;
      end;
  private
    class var
      mPolyArr: array of TPointi;
      mPntCount: Integer;
      mMju: Extended;
      mMaxStepBack: Integer;
      mAlphaThreshold: Byte; // alpha channel threshhold
    class function IsNeighbour(X1, Y1, X2, Y2: Integer): Boolean; static;
    class function IsPixEmpty(Tex: TGVTexture; X, Y: Integer; W, H: Single): Boolean; static;
    class procedure AddPoint(X, Y: Integer); static;
    class procedure DelPoint(Index: Integer); static;
    class function IsInList(X, Y: Integer): Boolean; static;
    class procedure FindStartingPoint(Tex: TGVTexture; var X, Y: Integer; W, H: Single); static;
    class function CountEmptyAround(Tex: TGVTexture; X, Y: Integer; W, H: Single): Integer; static;
    class function FindNearestButNotNeighbourOfOther(Tex: TGVTexture; Xs, Ys, XOther, YOther: Integer; var XF, YF: Integer; W, H: Single): Boolean; static;
    class function LineLength(X1, Y1, X2, Y2: Integer): Extended; static;
    //class function TriangleSquare(X1, Y1, X2, Y2, X3, Y3: Integer): Extended; static;
    class function TriangleThinness(X1, Y1, X2, Y2, X3, Y3: Integer): Extended; static;
  public
    class procedure Init(aMju: Extended = 6; aMaxStepBack: Integer = 10; aAlphaThreshold: Byte = 70); static;
    class procedure Done; static;
    class function  GetPointCount: Integer; static;
    class procedure PrimaryTrace(aTex: TGVTexture; aWidth, aHeight: Single); static;
    class procedure SimplifyPoly; static;
    class procedure ApplyPolyPoint(aPolyPoint: TGVPolyPoint; aNum: Integer; aOrigin: PGVVector); static;
  end;

  { TGVPolyPoint }
  TGVPolyPoint = class(TGVObject)
  protected
    FPolygon: array of TGVPolygon;
    FCount: Integer;
    procedure Clear;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Save(const aFilename: string): Boolean;
    function Load(aArchive: TGVArchive; const aFilename: string): Boolean;
    function CopyFrom(aPolyPoint: TGVPolyPoint): Boolean;
    procedure AddPoint(aNum: Integer; aX: Single; aY: Single; aOrigin: PGVVector);
    function TraceFromTexture(aTexture: TGVTexture; aMju: Single; aMaxStepBack: Integer; aAlphaThreshold: Integer; aOrigin: PGVVector): Integer;
    procedure TraceFromSprite(aSprite: TGVSprite; aGroup: Integer; aMju: Single; aMaxStepBack: Integer; aAlphaThreshold: Integer; aOrigin: PGVVector);
    function Count: Integer;
    procedure Render(aNum: Integer; aX: Single; aY: Single; aScale: Single; aAngle: Single; aColor: TGVColor; aOrigin: PGVVector; aHFlip: Boolean; aVFlip: Boolean);
    function Collide(aNum1: Integer; aGroup1: Integer; aX1: Single; aY1: Single;
      aScale1: Single; aAngle1: Single; aOrigin1: PGVVector; aHFlip1: Boolean;
      aVFlip1: Boolean; aPolyPoint2: TGVPolyPoint; aNum2: Integer;
      aGroup2: Integer; aX2: Single; aY2: Single; aScale2: Single;
      aAngle2: Single; aOrigin2: PGVVector; aHFlip2: Boolean; aVFlip2: Boolean;
      var aHitPos: TGVVector): Boolean;
    function CollidePoint(aNum: Integer; aGroup: Integer; aX: Single;
      aY: Single; aScale: Single; aAngle: Single; aOrigin: PGVVector;
      aHFlip: Boolean; aVFlip: Boolean; var aPoint: TGVVector): Boolean;
    function Polygon(aNum: Integer): TGVPolygon;
    function Valid(aNum: Integer): Boolean;
  end;

  { TGVSprite }
  TGVSprite = class(TGVObject)
  protected
    type
      { TSpriteImageRegion }
      PSpriteImageRegion = ^TSpriteImageRegion;
      TSpriteImageRegion = record
        Rect: TGVRectangle;
        Page: Integer;
      end;

      { TSpriteGroup }
      PSpriteGroup = ^TSpriteGroup;
      TSpriteGroup = record
        Image: array of TSpriteImageRegion;
        Count: Integer;
        PolyPoint: TGVPolypoint;
      end;
  protected
    FTexture: array of TGVTexture;
    FGroup: array of TSpriteGroup;
    FPageCount: Integer;
    FGroupCount: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear;
    function LoadPage(aArchive: TGVArchive; const aFilename: string; aColorKey: PGVColor): Integer;
    function AddGroup: Integer;
    function GetGroupCount: Integer;
    function AddImageFromRect(aPage: Integer; aGroup: Integer; aRect: TGVRectangle): Integer;
    function AddImageFromGrid(aPage: Integer; aGroup: Integer; aGridX: Integer; aGridY: Integer; aGridWidth: Integer; aGridHeight: Integer): Integer;
    function GetImageCount(aGroup: Integer): Integer;
    function GetImageWidth(aNum: Integer; aGroup: Integer): Single;
    function GetImageHeight(aNum: Integer; aGroup: Integer): Single;
    function GetImageTexture(aNum: Integer; aGroup: Integer): TGVTexture;
    function GetImageRect(aNum: Integer; aGroup: Integer): TGVRectangle;
    procedure DrawImage(aNum: Integer; aGroup: Integer; aX: Single; aY: Single; aOrigin: PGVVector; aScale: PGVVector; aAngle: Single; aColor: TGVColor; aHFlip: Boolean; aVFlip: Boolean; aDrawPolyPoint: Boolean);
    function GroupPolyPoint(aGroup: Integer): TGVPolyPoint;
    procedure GroupPolyPointTrace(aGroup: Integer; aMju: Single=6; aMaxStepBack: Integer=12; aAlphaThreshold: Integer=70; aOrigin: PGVVector=nil);
    function GroupPolyPointCollide(aNum1: Integer; aGroup1: Integer;
      aX1: Single; aY1: Single; aScale1: Single; aAngle1: Single;
      aOrigin1: PGVVector; aHFlip1: Boolean; aVFlip1: Boolean; aSprite2: TGVSprite;
      aNum2: Integer; aGroup2: Integer; aX2: Single; aY2: Single;
      aScale2: Single; aAngle2: Single; aOrigin2: PGVVector; aHFlip2: Boolean;
      aVFlip2: Boolean; aShrinkFactor: Single; var aHitPos: TGVVector): Boolean;
    function GroupPolyPointCollidePoint(aNum: Integer; aGroup: Integer;
      aX: Single; aY: Single; aScale: Single; aAngle: Single; aOrigin: PGVVector;
      aHFlip: Boolean; aVFlip: Boolean; aShrinkFactor: Single;
      var aPoint: TGVVector): Boolean;
  end;

implementation

uses
  GameVision.Collision,
  GameVision.Core;

{ PolyPointTrace  }
class function PolyPointTrace.IsNeighbour(X1, Y1, X2, Y2: Integer): Boolean;
begin
  Result := (Abs(X2 - X1) <= 1) and (Abs(Y2 - Y1) <= 1);
end;

class function PolyPointTrace.IsPixEmpty(Tex: TGVTexture; X, Y: Integer; W, H: Single): Boolean;
var
  LColor: TGVColor;
begin
  if (X < 0) or (Y < 0) or (X > W - 1) or (Y > H - 1) then
    Result := true
  else
  begin
    LColor := Tex.GetPixel(X, Y);
    Result := Boolean(LColor.alpha * 255 < mAlphaThreshold);
  end;
end;

// some point list functions
class procedure PolyPointTrace.AddPoint(X, Y: Integer);
var
  LL: Integer;
begin
  Inc(mPntCount);
  // L := Length(PolyArr);
  LL := High(mPolyArr) + 1;
  if LL < mPntCount then
    SetLength(mPolyArr, LL + mMaxStepBack);
  mPolyArr[mPntCount - 1].X := X;
  mPolyArr[mPntCount - 1].Y := Y;
end;

class procedure PolyPointTrace.DelPoint(Index: Integer);
var
  LI: Integer;
begin
  if mPntCount > 1 then
    for LI := Index to mPntCount - 2 do
      mPolyArr[LI] := mPolyArr[LI + 1];
  Dec(mPntCount);
end;

class function PolyPointTrace.IsInList(X, Y: Integer): Boolean;
var
  LI: Integer;
begin
  Result := False;
  for LI := 0 to mPntCount - 1 do
  begin
    Result := (mPolyArr[LI].X = X) and (mPolyArr[LI].Y = Y);
    if Result then
      Break;
  end;
end;

class procedure PolyPointTrace.FindStartingPoint(Tex: TGVTexture; var X, Y: Integer; W, H: Single);
var
  LI, LJ: Integer;
begin
  X := 1000000; // init X and Y with huge values
  Y := 1000000;
  // and simply find the non-zero point with lowest Y
  LI := 0;
  LJ := 0;
  while (X = 1000000) and (LI <= H) and (LJ <= W) do
  begin
    if not IsPixEmpty(Tex, LI, LJ, W, H) then
    begin
      X := LI;
      Y := LJ;
    end;
    Inc(LI);
    if LI = W then
    begin
      LI := 0;
      Inc(LJ);
    end;
  end;
  if X = 1000000 then
  begin
    // do something awful - texture is empty!
     //ShowMessage('do something awful - texture is empty!', [], SHOWMESSAGE_ERROR);
     raise Exception.Create('do something awful - texture is empty!');
  end;
end;

const
  // this is an order of looking for neighbour. Order is quite important
  Neighbours: array [1 .. 8, 1 .. 2] of Integer = ((0, -1), (-1, 0), (0, 1),
    (1, 0), (-1, -1), (-1, 1), (1, 1), (1, -1));

class function PolyPointTrace.CountEmptyAround(Tex: TGVTexture; X, Y: Integer; W, H: Single): Integer;
var
  LI: Integer;
begin
  Result := 0;
  for LI := 1 to 8 do
    if IsPixEmpty(Tex, X + Neighbours[LI, 1], Y + Neighbours[LI, 2], W, H) then
      Inc(Result);
end;

// finds nearest non-empty pixel with maximum empty neighbours which is NOT neighbour of some other pixel
// Returns true if found and XF,YF - coordinates
// This function may look odd but I need it for finding primary circumscribed poly which later will be
// simplified
class function PolyPointTrace.FindNearestButNotNeighbourOfOther(Tex: TGVTexture; Xs, Ys, XOther, YOther: Integer; var XF, YF: Integer; W, H: Single): Boolean;
var
  LI, LMaxEmpty, LE: Integer;
  LXt, LYt: Integer;
begin
  LMaxEmpty := 0;
  Result := False;
  for LI := 1 to 8 do
  begin
    LXt := Xs + Neighbours[LI, 1];
    LYt := Ys + Neighbours[LI, 2];
    // is it non-empty and not-a-neighbour point?
    if (not IsInList(LXt, LYt)) and (not IsNeighbour(LXt, LYt, XOther, YOther)) and
      (not IsPixEmpty(Tex, LXt, LYt, W, H)) then
    begin
      LE := CountEmptyAround(Tex, LXt, LYt, W, H); // ok. count empties around
      if LE > LMaxEmpty then // the best choice point has max empty neighbours
      begin
        XF := LXt;
        YF := LYt;
        LMaxEmpty := LE;
        Result := true;
      end;
    end;
  end;
end;

// simplifying procedures
class function PolyPointTrace.LineLength(X1, Y1, X2, Y2: Integer): Extended;
var
  LA, LB: Integer;
begin
  LA := Abs(X2 - X1);
  LB := Abs(Y2 - Y1);
  Result := Sqrt(LA * LA + LB * LB);
end;

//class function PolyPointTrace.TriangleSquare(X1, Y1, X2, Y2, X3, Y3: Integer): Extended;
//var
//  LP: Extended;
//  LA, LB, LC: Extended;
//begin
//  LA := LineLength(X1, Y1, X2, Y2);
//  LB := LineLength(X2, Y2, X3, Y3);
//  LC := LineLength(X3, Y3, X1, Y1);
//  LP := LA + LB + LC;
//  Result := Sqrt(LP * (LP - LA) * (LP - LB) * (LP - LC)); // using Heron's formula
//end;

// for alternate method simplifying I decided to use "thinness" of triangles
// the idea is that if square of triangle is small but his perimeter is big it means that
// triangle is "thin" - so it can be approximated to line
class function PolyPointTrace.TriangleThinness(X1, Y1, X2, Y2, X3, Y3: Integer): Extended;
var
  LP: Extended;
  LA, LB, LC, LS: Extended;
begin
  LA := LineLength(X1, Y1, X2, Y2);
  LB := LineLength(X2, Y2, X3, Y3);
  LC := LineLength(X3, Y3, X1, Y1);
  LP := LA + LB + LC;
  LS := Sqrt(LP * (LP - LA) * (LP - LB) * (LP - LC));
  // using Heron's formula to find triangle'LS square
  Result := LS / LP;
  // so if this result less than some Mju then we can approximate particular triangle
end;

class procedure PolyPointTrace.ApplyPolyPoint(aPolyPoint: TGVPolyPoint; aNum: Integer; aOrigin: PGVVector);
var
  LI: Integer;
begin
  for LI := 0 to mPntCount - 1 do
  begin
    aPolyPoint.AddPoint(aNum, mPolyArr[LI].X, mPolyArr[LI].Y, aOrigin);
  end;
end;

class procedure PolyPointTrace.Init(aMju: Extended = 6; aMaxStepBack: Integer = 10; aAlphaThreshold: Byte = 70);
begin
  Done;
  mMju := aMju;
  mMaxStepBack := aMaxStepBack;
  mAlphaThreshold := aAlphaThreshold;
end;

class procedure PolyPointTrace.Done;
begin
  mPntCount := 0;
  mPolyArr := nil;
end;

class function PolyPointTrace.GetPointCount: Integer;
begin
  Result := mPntCount;
end;

// primarily tracer procedure (gives too precise polyline - need to simplify later)
class procedure PolyPointTrace.PrimaryTrace(aTex: TGVTexture; aWidth, aHeight: Single);
var
  LI: Integer;
  LXn, LYn, LXnn, LYnn: Integer;
  LNextPointFound: Boolean;
  LBack: Integer;
  LLStepBack: Integer;
begin
  FindStartingPoint(aTex, LXn, LYn, aWidth, aHeight);
  LNextPointFound := LXn <> 1000000;
  LLStepBack := 0;
  while LNextPointFound do
  begin
    LNextPointFound := False;
    // checking if we got LBack to starting point...
    if not((mPntCount > 3) and IsNeighbour(LXn, LYn, mPolyArr[0].X, mPolyArr[0].Y))
    then
    begin
      if mPntCount > 7 then
        LBack := 7
      else
        LBack := mPntCount;
      if LBack = 0 then // no points in list - take any near point
        LNextPointFound := FindNearestButNotNeighbourOfOther(aTex, LXn, LYn, -100,
          -100, LXnn, LYnn, aWidth, aHeight)
      else
        // checking near but not going LBack
        for LI := 1 to LBack do
        begin
          LNextPointFound := FindNearestButNotNeighbourOfOther(aTex, LXn, LYn,
            mPolyArr[mPntCount - LI].X, mPolyArr[mPntCount - LI].Y, LXnn, LYnn, aWidth, aHeight);
          LNextPointFound := LNextPointFound and (not IsInList(LXnn, LYnn));
          if LNextPointFound then
            Break;
        end;
      AddPoint(LXn, LYn);
      if LNextPointFound then
      begin
        LXn := LXnn;
        LYn := LYnn;
        LLStepBack := 0;
      end
      else if LLStepBack < mMaxStepBack then
      begin
        LXn := mPolyArr[mPntCount - LLStepBack * 2 - 2].X;
        LYn := mPolyArr[mPntCount - LLStepBack * 2 - 2].Y;
        Inc(LLStepBack);
        LNextPointFound := true;
      end;
    end;
  end;
  // close the poly
  if mPntCount > 0 then
    AddPoint(mPolyArr[0].X, mPolyArr[0].Y);
end;

class procedure PolyPointTrace.SimplifyPoly;
var
  I: Integer;
  Finished: Boolean;
  Thinness: Extended;
begin
  Finished := False;
  while not Finished do
  begin
    I := 0;
    Finished := true;
    while I <= mPntCount - 3 do
    begin
      Thinness := TriangleThinness(mPolyArr[I].X, mPolyArr[I].Y, mPolyArr[I + 1].X,
        mPolyArr[I + 1].Y, mPolyArr[I + 2].X, mPolyArr[I + 2].Y);
      if Thinness < mMju then
      // the square of triangle is too thin - we can approximate it!
      begin
        DelPoint(I + 1); // so delete middle point
        Finished := False;
      end;
      Inc(I);
    end;
  end;
end;

{ TGVPolyPoint }
procedure TGVPolyPoint.Clear;
var
  LI: Integer;
begin
  for LI := 0 to Count - 1 do
  begin
    if Assigned(FPolygon[LI]) then
    begin
      FreeAndNil(FPolygon[LI]);
    end;
  end;
  FPolygon := nil;
  FCount := 0;
end;

constructor TGVPolyPoint.Create;
begin
  inherited;
  FPolygon := nil;
  FCount := 0;
end;

destructor TGVPolyPoint.Destroy;
begin
  Clear;
  inherited;
end;

function TGVPolyPoint.Save(const aFilename: string): Boolean;
begin
  Result := False;
  // TODO:
end;

function TGVPolyPoint.Load(aArchive: TGVArchive; const aFilename: string): Boolean;
begin
  Result := False;
  // TODO:
end;

function TGVPolyPoint.CopyFrom(aPolyPoint: TGVPolyPoint): Boolean;
begin
  Result := False;
  // TODO:
end;

procedure TGVPolyPoint.AddPoint(aNum: Integer; aX: Single; aY: Single; aOrigin: PGVVector);
var
  LX, LY: Single;
begin
  LX := aX;
  LY := aY;

  if aOrigin <> nil then
  begin
    LX := LX - aOrigin.X;
    LY := LY - aOrigin.Y;
  end;

  FPolygon[aNum].AddLocalPoint(LX, LY, True);
end;

function TGVPolyPoint.TraceFromTexture(aTexture: TGVTexture; aMju: Single; aMaxStepBack: Integer; aAlphaThreshold: Integer; aOrigin: PGVVector): Integer;
var
  LI: Integer;
  LW, LH: Single;
begin
  Inc(FCount);
  SetLength(FPolygon, FCount);
  LI := FCount - 1;
  FPolygon[LI] := TGVPolygon.Create;
  LW := aTexture.Width;
  LH := aTexture.Height;
  aTexture.Lock(nil);
  PolyPointTrace.Init(aMju, aMaxStepBack, aAlphaThreshold);
  PolyPointTrace.PrimaryTrace(aTexture, LW, LH);
  PolyPointTrace.SimplifyPoly;
  PolyPointTrace.ApplyPolyPoint(Self, LI, aOrigin);
  PolyPointTrace.Done;
  aTexture.Unlock;

  Result := LI;
end;

procedure TGVPolyPoint.TraceFromSprite(aSprite: TGVSprite; aGroup: Integer; aMju: Single; aMaxStepBack: Integer; aAlphaThreshold: Integer; aOrigin: PGVVector);
var
  LI: Integer;
  LRect: TGVRectangle;
  LTex: TGVTexture;
  LW, LH: Integer;
begin
  Clear;
  FCount := aSprite.GetImageCount(aGroup);
  SetLength(FPolygon, Count);
  for LI := 0 to Count - 1 do
  begin
    FPolygon[LI] := TGVPolygon.Create;
    LTex := TGVTexture(aSprite.GetImageTexture(LI, aGroup));
    LRect := aSprite.GetImageRect(LI, aGroup);
    LW := Round(LRect.width);
    LH := Round(LRect.height);
    LTex.Lock(@LRect);
    PolyPointTrace.Init(aMju, aMaxStepBack, aAlphaThreshold);
    PolyPointTrace.PrimaryTrace(LTex, LW, LH);
    PolyPointTrace.SimplifyPoly;
    PolyPointTrace.ApplyPolyPoint(Self, LI, aOrigin);
    PolyPointTrace.Done;
    LTex.Unlock;
  end;
end;

function TGVPolyPoint.Count: Integer;
begin
  Result := FCount;
end;

procedure TGVPolyPoint.Render(aNum: Integer; aX: Single; aY: Single; aScale: Single; aAngle: Single; aColor: TGVColor; aOrigin: PGVVector; aHFlip: Boolean; aVFlip: Boolean);
begin
  if aNum >= FCount then Exit;
  FPolygon[aNum].Render(aX, aY, aScale, aAngle, 1, aColor, aOrigin, aHFlip, aVFlip);
end;

function TGVPolyPoint.Collide(aNum1: Integer; aGroup1: Integer; aX1: Single; aY1: Single;
  aScale1: Single; aAngle1: Single; aOrigin1: PGVVector; aHFlip1: Boolean;
  aVFlip1: Boolean; aPolyPoint2: TGVPolyPoint; aNum2: Integer;
  aGroup2: Integer; aX2: Single; aY2: Single; aScale2: Single;
  aAngle2: Single; aOrigin2: PGVVector; aHFlip2: Boolean; aVFlip2: Boolean;
  var aHitPos: TGVVector): Boolean;
var
  LL1, LL2, LIX, LIY: Integer;
  LCnt1, LCnt2: Integer;
  LPos: array [0 .. 3] of PGVVector;
  LPoly1, LPoly2: TGVPolygon;
begin
  Result := False;

  if (aPolyPoint2 = nil) then Exit;

  LPoly1 := FPolygon[aNum1];
  LPoly2 := aPolyPoint2.Polygon(aNum2);

  // transform to world points
  LPoly1.Transform(aX1, aY1, aScale1, aAngle1, aOrigin1, aHFlip1, aVFlip1);
  LPoly2.Transform(aX2, aY2, aScale2, aAngle2, aOrigin2, aHFlip2, aVFlip2);

  LCnt1 := LPoly1.GetPointCount;
  LCnt2 := LPoly2.GetPointCount;

  if LCnt1 < 2 then Exit;
  if LCnt2 < 2 then Exit;

  for LL1 := 0 to LCnt1 - 2 do
  begin
    LPos[0] := LPoly1.GetWorldPoint(LL1);
    LPos[1] := LPoly1.GetWorldPoint(LL1 + 1);

    for LL2 := 0 to LCnt2 - 2 do
    begin

      LPos[2] := LPoly2.GetWorldPoint(LL2);
      LPos[3] := LPoly2.GetWorldPoint(LL2 + 1);
      if GV.Collision.LineIntersection(Round(LPos[0].X), Round(LPos[0].Y), Round(LPos[1].X),
        Round(LPos[1].Y), Round(LPos[2].X), Round(LPos[2].Y), Round(LPos[3].X),
        Round(LPos[3].Y), LIX, LIY) = liTrue then
      begin
        aHitPos.X := LIX;
        aHitPos.Y := LIY;
        Result := True;
        Exit;
      end;
    end;
  end;
end;

function TGVPolyPoint.CollidePoint(aNum: Integer; aGroup: Integer; aX: Single;
  aY: Single; aScale: Single; aAngle: Single; aOrigin: PGVVector;
  aHFlip: Boolean; aVFlip: Boolean; var aPoint: TGVVector): Boolean;
var
  LL1, LIX, LIY: Integer;
  LCnt1: Integer;
  LPos: array [0 .. 3] of PGVVector;
  LPoint2: TGVVector;
  LPoly1: TGVPolygon;
begin
  Result := False;

  LPoly1 := FPolygon[aNum];

  // transform to world points
  LPoly1.Transform(aX, aY, aScale, aAngle, aOrigin, aHFlip, aVFlip);

  LCnt1 := LPoly1.GetPointCount;

  if LCnt1 < 2 then
    Exit;

  LPoint2.X := aPoint.X + 1;
  LPoint2.Y := aPoint.Y + 1;
  LPos[2] := @aPoint;
  LPos[3] := @LPoint2;

  for LL1 := 0 to LCnt1 - 2 do
  begin
    LPos[0] := LPoly1.GetWorldPoint(LL1);
    LPos[1] := LPoly1.GetWorldPoint(LL1 + 1);

    if GV.Collision.LineIntersection(Round(LPos[0].X), Round(LPos[0].Y), Round(LPos[1].X),
      Round(LPos[1].Y), Round(LPos[2].X), Round(LPos[2].Y), Round(LPos[3].X),
      Round(LPos[3].Y), LIX, LIY) = liTrue then
    begin
      aPoint.X := LIX;
      aPoint.Y := LIY;
      Result := True;
      Exit;
    end;
  end;
end;

function TGVPolyPoint.Polygon(aNum: Integer): TGVPolygon;
begin
  Result := FPolygon[aNum];
end;

function TGVPolyPoint.Valid(aNum: Integer): Boolean;
begin
  Result := False;
  if aNum >= FCount then Exit;
  Result := Boolean(FPolygon[aNum].GetPointCount >= 2);
end;

{ TGVSprite }
constructor TGVSprite.Create;
begin
  inherited;
  FTexture := nil;
  FGroup := nil;
  FPageCount := 0;
  FGroupCount := 0;
end;

destructor TGVSprite.Destroy;
begin
  Clear;
  inherited;
end;

procedure TGVSprite.Clear;
var
  LI: Integer;
begin
  if FTexture <> nil then
  begin
    // free group data
    for LI := 0 to FGroupCount - 1 do
    begin
      // free image array
      FGroup[LI].Image := nil;

      // free polypoint
      FreeAndNil(FGroup[LI].PolyPoint);
    end;

    // free page
    for LI := 0 to FPageCount - 1 do
    begin
      if Assigned(FTexture[LI]) then
      begin
        FreeAndNil(FTexture[LI]);
      end;
    end;

    FTexture := nil;
    FGroup := nil;
    FPageCount := 0;
    FGroupCount := 0;
  end;
end;

function TGVSprite.LoadPage(aArchive: TGVArchive; const aFilename: string; aColorKey: PGVColor): Integer;
begin
  Result := FPageCount;
  Inc(FPageCount);
  SetLength(FTexture, FPageCount);
  FTexture[Result] := TGVTexture.Create;
  FTexture[Result].Load(aArchive, aFilename, aColorKey);
end;

function TGVSprite.AddGroup: Integer;
begin
  Result := FGroupCount;
  Inc(FGroupCount);
  SetLength(FGroup, FGroupCount);
  FGroup[Result].PolyPoint := TGVPolyPoint.Create;
end;

function TGVSprite.GetGroupCount: Integer;
begin
  Result := FGroupCount;
end;

function TGVSprite.AddImageFromRect(aPage: Integer; aGroup: Integer; aRect: TGVRectangle): Integer;
begin
  Result := FGroup[aGroup].Count;
  Inc(FGroup[aGroup].Count);
  SetLength(FGroup[aGroup].Image, FGroup[aGroup].Count);

  FGroup[aGroup].Image[Result].Rect.X := aRect.X;
  FGroup[aGroup].Image[Result].Rect.Y := aRect.Y;
  FGroup[aGroup].Image[Result].Rect.Width := aRect.Width;
  FGroup[aGroup].Image[Result].Rect.Height := aRect.Height;
  FGroup[aGroup].Image[Result].Page := aPage;
end;

function TGVSprite.AddImageFromGrid(aPage: Integer; aGroup: Integer; aGridX: Integer; aGridY: Integer; aGridWidth: Integer; aGridHeight: Integer): Integer;
begin
  Result := FGroup[aGroup].Count;
  Inc(FGroup[aGroup].Count);
  SetLength(FGroup[aGroup].Image, FGroup[aGroup].Count);

  FGroup[aGroup].Image[Result].Rect.X := aGridWidth * aGridX;
  FGroup[aGroup].Image[Result].Rect.Y := aGridHeight * aGridY;
  FGroup[aGroup].Image[Result].Rect.Width := aGridWidth;
  FGroup[aGroup].Image[Result].Rect.Height := aGridHeight;
  FGroup[aGroup].Image[Result].Page := aPage;
end;

function TGVSprite.GetImageCount(aGroup: Integer): Integer;
begin
  Result := FGroup[aGroup].Count;
end;

function TGVSprite.GetImageWidth(aNum: Integer; aGroup: Integer): Single;
begin
  Result := FGroup[aGroup].Image[aNum].Rect.Width;
end;

function TGVSprite.GetImageHeight(aNum: Integer; aGroup: Integer): Single;
begin
  Result := FGroup[aGroup].Image[aNum].Rect.Height;
end;

function TGVSprite.GetImageTexture(aNum: Integer; aGroup: Integer): TGVTexture;
begin
  Result := FTexture[FGroup[aGroup].Image[aNum].Page];
end;

function TGVSprite.GetImageRect(aNum: Integer; aGroup: Integer): TGVRectangle;
begin
  Result := FGroup[aGroup].Image[aNum].Rect;
end;

procedure TGVSprite.DrawImage(aNum: Integer; aGroup: Integer; aX: Single; aY: Single; aOrigin: PGVVector; aScale: PGVVector; aAngle: Single; aColor: TGVColor; aHFlip: Boolean; aVFlip: Boolean; aDrawPolyPoint: Boolean);
var
  LPageNum: Integer;
  LRectP: PGVRectangle;
  LOXY: TGVVector;
begin
  LRectP := @FGroup[aGroup].Image[aNum].Rect;
  LPageNum := FGroup[aGroup].Image[aNum].Page;
  FTexture[LPageNum].Draw(aX, aY, LRectP, aOrigin, aScale, aAngle, aColor, aHFlip, aVFlip);

  if aDrawPolyPoint then
  begin
    LOXY.X := 0;
    LOXY.Y := 0;
    if aOrigin <> nil then
    begin
      LOXY.X := FGroup[aGroup].Image[aNum].Rect.Width;
      LOXY.Y := FGroup[aGroup].Image[aNum].Rect.Height;

      LOXY.X := Round(LOXY.X * aOrigin.X);
      LOXY.Y := Round(LOXY.Y * aOrigin.Y);
    end;
    FGroup[aGroup].PolyPoint.Render(aNum, aX, aY, aScale.X, aAngle, YELLOW, @LOXY, aHFlip, aVFlip);
  end;
end;

function TGVSprite.GroupPolyPoint(aGroup: Integer): TGVPolyPoint;
begin
  Result := FGroup[aGroup].PolyPoint;
end;

procedure TGVSprite.GroupPolyPointTrace(aGroup: Integer; aMju: Single=6; aMaxStepBack: Integer=12; aAlphaThreshold: Integer=70; aOrigin: PGVVector=nil);
begin
  FGroup[aGroup].PolyPoint.TraceFromSprite(Self, aGroup, aMju, aMaxStepBack, aAlphaThreshold, aOrigin);
end;

function TGVSprite.GroupPolyPointCollide(aNum1: Integer; aGroup1: Integer;
  aX1: Single; aY1: Single; aScale1: Single; aAngle1: Single;
  aOrigin1: PGVVector; aHFlip1: Boolean; aVFlip1: Boolean; aSprite2: TGVSprite;
  aNum2: Integer; aGroup2: Integer; aX2: Single; aY2: Single;
  aScale2: Single; aAngle2: Single; aOrigin2: PGVVector; aHFlip2: Boolean;
  aVFlip2: Boolean; aShrinkFactor: Single; var aHitPos: TGVVector): Boolean;
var
  LPP1, LPP2: TGVPolyPoint;
  LRadius1: Integer;
  LRadius2: Integer;
  LOrigini1, LOrigini2: TGVVector;
  LOrigini1P, LOrigini2P: PGVVector;
begin
  Result := False;

  if (aSprite2 = nil) then
    Exit;

  LPP1 := FGroup[aGroup1].PolyPoint;
  LPP2 := aSprite2.FGroup[aGroup2].PolyPoint;

  if not LPP1.Valid(aNum1) then
    Exit;
  if not LPP2.Valid(aNum2) then
    Exit;

  LRadius1 := Round(FGroup[aGroup1].Image[aNum1].Rect.Height + FGroup[aGroup1]
    .Image[aNum1].Rect.Width) div 2;

  LRadius2 := Round(aSprite2.FGroup[aGroup2].Image[aNum2].Rect.Height +
    TGVSprite(aSprite2).FGroup[aGroup2].Image[aNum2].Rect.Width) div 2;

  if not GV.Collision.RadiusOverlap(LRadius1, aX1, aY1, LRadius2, aX2, aY2, aShrinkFactor) then Exit;

  LOrigini2.X := aSprite2.FGroup[aGroup2].Image[aNum2].Rect.Width;
  LOrigini2.Y := aSprite2.FGroup[aGroup2].Image[aNum2].Rect.Height;

  LOrigini1P := nil;
  if aOrigin1 <> nil then
  begin
    LOrigini1.X := Round(FGroup[aGroup1].Image[aNum1].Rect.Width * aOrigin1.X);
    LOrigini1.Y := Round(FGroup[aGroup1].Image[aNum1].Rect.Height * aOrigin1.Y);
    LOrigini1P := @LOrigini1;
  end;

  LOrigini2P := nil;
  if aOrigin2 <> nil then
  begin
    LOrigini2.X := Round(aSprite2.FGroup[aGroup2].Image[aNum2]
      .Rect.Width * aOrigin2.X);
    LOrigini2.Y := Round(aSprite2.FGroup[aGroup2].Image[aNum2]
      .Rect.Height * aOrigin2.Y);
    LOrigini2P := @LOrigini2;
  end;

  Result := LPP1.Collide(aNum1, aGroup1, aX1, aY1, aScale1, aAngle1, LOrigini1P,
    aHFlip1, aVFlip1, LPP2, aNum2, aGroup2, aX2, aY2, aScale2, aAngle2,
    LOrigini2P, aHFlip2, aVFlip2, aHitPos);
end;

function TGVSprite.GroupPolyPointCollidePoint(aNum: Integer; aGroup: Integer;
  aX: Single; aY: Single; aScale: Single; aAngle: Single; aOrigin: PGVVector;
  aHFlip: Boolean; aVFlip: Boolean; aShrinkFactor: Single;
  var aPoint: TGVVector): Boolean;
var
  LPP1: TGVPolyPoint;
  LRadius1: Integer;
  LRadius2: Integer;
  LOrigini1: TGVVector;
  LOrigini1P: PGVVector;
begin
  Result := False;

  LPP1 := FGroup[aGroup].PolyPoint;

  if not LPP1.Valid(aNum) then
    Exit;

  LRadius1 := Round(FGroup[aGroup].Image[aNum].Rect.Height + FGroup[aGroup].Image
    [aNum].Rect.Width) div 2;

  LRadius2 := 2;

  if not GV.Collision.RadiusOverlap(LRadius1, aX, aY, LRadius2, aPoint.X, aPoint.Y,
    aShrinkFactor) then
    Exit;

  LOrigini1P := nil;
  if aOrigin <> nil then
  begin
    LOrigini1.X := FGroup[aGroup].Image[aNum].Rect.Width * aOrigin.X;
    LOrigini1.Y := FGroup[aGroup].Image[aNum].Rect.Height * aOrigin.Y;
    LOrigini1P := @LOrigini1;
  end;

  Result := LPP1.CollidePoint(aNum, aGroup, aX, aY, aScale, aAngle, LOrigini1P,
    aHFlip, aVFlip, aPoint);
end;

end.
