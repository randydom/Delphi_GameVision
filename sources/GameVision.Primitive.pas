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

unit GameVision.Primitive;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Base,
  GameVision.Color;

type
  { TGVPrimitive }
  TGVPrimitive = class(TGVObject)
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Line(aX1, aY1, aX2, aY2: Single; aColor: TGVColor; aThickness: Single);
    procedure Rectangle(aX, aY, aWidth, aHeight, aThickness: Single; aColor: TGVColor);
    procedure FilledRectangle(aX, aY, aWidth, aHeight: Single; aColor: TGVColor);
    procedure Circle(aX, aY, aRadius, aThickness: Single; aColor: TGVColor);
    procedure FilledCircle(aX, aY, aRadius: Single; aColor: TGVColor);
    procedure DrawPolygon(aVertices: System.PSingle; aVertexCount: Integer; aThickness: Single; aColor: TGVColor);
    procedure DrawFilledPolygon(aVertices: System.PSingle; aVertexCount: Integer; aColor: TGVColor);
  end;

implementation

uses
  WinApi.Windows,
  GameVision.Allegro,
  GameVision.Core;

{ TPrimitive }
constructor TGVPrimitive.Create;
begin
  inherited;
end;

destructor TGVPrimitive.Destroy;
begin
  inherited;
end;

procedure TGVPrimitive.Line(aX1, aY1, aX2, aY2: Single; aColor: TGVColor; aThickness: Single);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if not GV.Window.IsOpen then Exit;
  al_draw_line(aX1, aY1, aX2, aY2, LColor, aThickness);
end;

procedure TGVPrimitive.Rectangle(aX, aY, aWidth, aHeight, aThickness: Single; aColor: TGVColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if not GV.Window.IsOpen then Exit;
  al_draw_rectangle(aX, aY, aX + (aWidth-1), aY + (aHeight-1), LColor, aThickness);
end;

procedure TGVPrimitive.FilledRectangle(aX, aY, aWidth, aHeight: Single; aColor: TGVColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if not GV.Window.IsOpen then Exit;
  al_draw_filled_rectangle(aX, aY, aX + (aWidth-1), aY + (aHeight-1), LColor);
end;

procedure TGVPrimitive.Circle(aX, aY, aRadius, aThickness: Single; aColor: TGVColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if not GV.Window.IsOpen then Exit;
  al_draw_circle(aX, aY, aRadius, LColor, aThickness);
end;

procedure TGVPrimitive.FilledCircle(aX, aY, aRadius: Single; aColor: TGVColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if not GV.Window.IsOpen then Exit;
  al_draw_filled_circle(aX, aY, aRadius, LColor);
end;

procedure TGVPrimitive.DrawPolygon(aVertices: System.PSingle; aVertexCount: Integer; aThickness: Single; aColor: TGVColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if not GV.Window.IsOpen then Exit;
  al_draw_polygon(WinApi.Windows.PSingle(aVertices), aVertexCount, ALLEGRO_LINE_JOIN_ROUND, LColor, aThickness, 1.0);
end;

procedure TGVPrimitive.DrawFilledPolygon(aVertices: System.PSingle; aVertexCount: Integer; aColor: TGVColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if not GV.Window.IsOpen then Exit;
  al_draw_filled_polygon(WinApi.Windows.PSingle(aVertices), aVertexCount, LColor);
end;

end.
