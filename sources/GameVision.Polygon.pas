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

unit GameVision.Polygon;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Base,
  GameVision.Math,
  GameVision.Color,
  GameVision.Archive;

type
  { TPolygon }
  TGVPolygon = class(TGVObject)
  protected
    type
      { TPolygonSegment }
      TPolygonSegment = record
        Point: TGVVector;
        Visible: Boolean;
      end;
  protected
    FSegment: array of TPolygonSegment;
    FWorldPoint: array of TGVVector;
    FItemCount: Integer;
    procedure Clear;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Save(const aFilename: string): Boolean;
    function Load(aArchive: TGVArchive; const aFilename: string): Boolean;
    procedure CopyFrom(aPolygon: TGVPolygon);
    procedure AddLocalPoint(aX: Single; aY: Single; aVisible: Boolean);
    function  Transform(aX: Single; aY: Single; aScale: Single; aAngle: Single; aOrigin: PGVVector; aHFlip: Boolean; aVFlip: Boolean): Boolean;
    procedure Render(aX: Single; aY: Single; aScale: Single; aAngle: Single; aThickness: Integer; aColor: TGVColor; aOrigin: PGVVector; aHFlip: Boolean; aVFlip: Boolean);
    procedure SetSegmentVisible(aIndex: Integer; aVisible: Boolean);
    function  GetSegmentVisible(aIndex: Integer): Boolean;
    function  GetPointCount: Integer;
    function  GetWorldPoint(aIndex: Integer): PGVVector;
    function  GetLocalPoint(aIndex: Integer): PGVVector;
  end;

implementation

uses
  GameVision.Core;

{ TGVPolygon }
procedure TGVPolygon.Clear;
begin
  FSegment := nil;
  FWorldPoint := nil;
  FItemCount := 0;
end;

constructor TGVPolygon.Create;
begin
  inherited;
  Clear;
end;

destructor TGVPolygon.Destroy;
begin
  Clear;
  inherited;
end;

function TGVPolygon.Save(const aFilename: string): Boolean;
begin
  Result := False;
  // TODO:
end;

function TGVPolygon.Load(aArchive: TGVArchive; const aFilename: string): Boolean;
begin
  Result := False;
  // TODO:
end;

procedure TGVPolygon.CopyFrom(aPolygon: TGVPolygon);
var
  LI: Integer;
begin
  Clear;
  with TGVPolygon(aPolygon) do
  begin
    for LI := 0 to FItemCount - 1 do
    begin
      with FSegment[LI] do
      begin
        Self.AddLocalPoint(Round(Point.X), Round(Point.Y), Visible);
      end;
    end;
  end;
end;

procedure TGVPolygon.AddLocalPoint(aX: Single; aY: Single; aVisible: Boolean);
begin
  Inc(FItemCount);
  SetLength(FSegment, FItemCount);
  SetLength(FWorldPoint, FItemCount);
  FSegment[FItemCount - 1].Point.X := aX;
  FSegment[FItemCount - 1].Point.Y := aY;
  FSegment[FItemCount - 1].Visible := aVisible;
  FWorldPoint[FItemCount - 1].X := 0;
  FWorldPoint[FItemCount - 1].Y := 0;
end;

function  TGVPolygon.Transform(aX: Single; aY: Single; aScale: Single; aAngle: Single; aOrigin: PGVVector; aHFlip: Boolean; aVFlip: Boolean): Boolean;
var
  LI: Integer;
  LP: TGVVector;
begin
  Result := False;

  if FItemCount < 2 then
    Exit;

  for LI := 0 to FItemCount - 1 do
  begin
    // get local coord
    LP.X := FSegment[LI].Point.X;
    LP.Y := FSegment[LI].Point.Y;

    // move point to origin
    if aOrigin <> nil then
    begin
      LP.X := LP.X - aOrigin.X;
      LP.Y := LP.Y - aOrigin.Y;
    end;

    // horizontal flip
    if aHFlip then
    begin
      LP.X := -LP.X;
    end;

    // virtical flip
    if aVFlip then
    begin
      LP.Y := -LP.Y;
    end;

    // scale
    LP.X := LP.X * aScale;
    LP.Y := LP.Y * aScale;

    // rotate
    GV.Math.AngleRotatePos(aAngle, LP.X, LP.Y);

    // convert to world
    LP.X := LP.X + aX;
    LP.Y := LP.Y + aY;

    // set world point
    FWorldPoint[LI].X := LP.X;
    FWorldPoint[LI].Y := LP.Y;
  end;

  Result := True;
end;

procedure TGVPolygon.Render(aX: Single; aY: Single; aScale: Single; aAngle: Single; aThickness: Integer; aColor: TGVColor; aOrigin: PGVVector; aHFlip: Boolean; aVFlip: Boolean);
var
  LI: Integer;
begin
  if not Transform(aX, aY, aScale, aAngle, aOrigin, aHFlip, aVFlip) then Exit;

  // draw line segments
  for LI := 0 to FItemCount - 2 do
  begin
    if FSegment[LI].Visible then
    begin
      GV.Primitive.Line(FWorldPoint[LI].X, FWorldPoint[LI].Y, FWorldPoint[LI + 1].X, FWorldPoint[LI + 1].Y, aColor, aThickness);
    end;
  end;
end;

procedure TGVPolygon.SetSegmentVisible(aIndex: Integer; aVisible: Boolean);
begin
  FSegment[aIndex].Visible := True;
end;

function  TGVPolygon.GetSegmentVisible(aIndex: Integer): Boolean;
begin
  Result := FSegment[aIndex].Visible;
end;

function  TGVPolygon.GetPointCount: Integer;
begin
  Result := FItemCount;
end;

function  TGVPolygon.GetWorldPoint(aIndex: Integer): PGVVector;
begin
  Result := @FWorldPoint[aIndex];
end;

function  TGVPolygon.GetLocalPoint(aIndex: Integer): PGVVector;
begin
  Result := @FSegment[aIndex].Point;
end;

end.
