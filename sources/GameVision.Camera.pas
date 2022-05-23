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

unit GameVision.Camera;

{$I GameVision.Defines.inc}

interface

uses
  GameVision.Allegro,
  GameVision.Common,
  GameVision.Base,
  GameVision.Math,
  GameVision.Core;

type
  { TGVCamera }
  TGVCamera = class(TGVObject)
  private
    type
      { TVec2b }
      TVec2b = record
        X: Boolean;
        Y: Boolean;
      end;
  private
    FPreviousTransform: ALLEGRO_TRANSFORM;
    FX,FY: Single;
    FWidth, FHeight: Single;
    FAlign: TGVVector;
    FScale: Single;
    FAnchor: TGVVector;
    FFlip: TVec2b;
    FRotation: Single;
    procedure BuildTransform(aTransform: PALLEGRO_TRANSFORM);
    procedure BuildReverseTransform(aTransform: PALLEGRO_TRANSFORM);
    procedure StartTransform;
    procedure StartReverseTransform;
    procedure RestoreTransform;
    function GetX: Single;
    procedure SetX(aValue: Single);
    function GetY: Single;
    procedure SetY(aValue: Single);
    function GetWidth: Single;
    procedure SetWidth(aValue: Single);
    function GetHeight: Single;
    procedure SetHeight(aValue: Single);
    function GetScale: Single;
    procedure SetScale(aValue: Single);
    function GetRotation: Single;
    procedure SetRotation(aValue: Single);
  public
    property X: Single read GetX write SetX;
    property Y: Single read GetY write SetY;
    property Width: Single read GetWidth write SetWidth;
    property Height: Single read GEtHeight write SetHeight;
    property Scale: Single read GetScale write SetScale;
    property Rotation: Single read GetRotation write SetRotation;
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear;
    procedure Init(aX: Single; aY: Single; aWidth: Single; aHeight: Single; aScale: Single=1.0; aRotation: Single=0.0);
    procedure Activate(aActivate: Boolean);
    procedure GetWorldToScreenPosition(var aX: Single; var aY: Single);
    procedure GetScreenToWorldPosition(var aX: Single; var aY: Single);
  end;

implementation

const
  cFalseTrue: array[False..True] of Integer = (1, -1);

{ TGVCamera }
procedure TGVCamera.BuildTransform(aTransform: PALLEGRO_TRANSFORM);
begin
  al_identity_transform(aTransform);
  al_translate_transform(aTransform, -FAlign.x*FWidth, -FAlign.y*FHeight);
  al_scale_transform(aTransform, FScale * cFalseTrue[FFlip.x], FScale * cFalseTrue[FFlip.y]);
  al_translate_transform(aTransform, FAnchor.x, FAnchor.y);
  al_rotate_transform(aTransform, FRotation * GV_DEG2RAD);
  al_translate_transform(aTransform, FX, FY);
end;

procedure TGVCamera.BuildReverseTransform(aTransform: PALLEGRO_TRANSFORM);
begin
  al_identity_transform(aTransform);
  al_translate_transform(aTransform, -FX, -FY);
  al_rotate_transform(aTransform, -FRotation * GV_DEG2RAD);
  al_translate_transform(aTransform, -FAnchor.x, -FAnchor.y);
  al_scale_transform(aTransform, 1.0/FScale * cFalseTrue[FFlip.x], 1.0/FScale * cFalseTrue[FFlip.y]);
  al_translate_transform(aTransform, FAlign.x*FWidth, FAlign.y*FHeight);
end;

procedure TGVCamera.StartTransform;
var
  LTransform: ALLEGRO_TRANSFORM;
begin
  if al_get_current_transform = nil then Exit;
  al_copy_transform(@FPreviousTransform, al_get_current_transform());
  BuildTransform(@LTransform);
  al_compose_transform(@LTransform, @FPreviousTransform);
  al_use_transform(@LTransform);
end;

procedure TGVCamera.StartReverseTransform;
var
  LTransform: ALLEGRO_TRANSFORM;
begin
  if al_get_current_transform = nil then Exit;
  al_copy_transform(@FPreviousTransform, al_get_current_transform());
  BuildReverseTransform(@LTransform);
  al_compose_transform(@LTransform, @FPreviousTransform);
  al_use_transform(@LTransform);
end;

procedure TGVCamera.RestoreTransform;
begin
  if al_get_current_transform = nil then Exit;
  al_use_transform(@FPreviousTransform);
end;

function TGVCamera.GetX: Single;
begin
  Result := FX;
end;

procedure TGVCamera.SetX(aValue: Single);
begin
  FX := aValue;
end;

function TGVCamera.GetY: Single;
begin
  Result := FY;
end;

procedure TGVCamera.SetY(aValue: Single);
begin
  FY := aValue;
end;

function TGVCamera.GetWidth: Single;
begin
  Result := FWidth;
end;

procedure TGVCamera.SetWidth(aValue: Single);
begin
  FWidth := aValue;
end;

function TGVCamera.GetHeight: Single;
begin
  Result := FHeight;
end;

procedure TGVCamera.SetHeight(aValue: Single);
begin
  FHeight := aValue;
end;

function TGVCamera.GetScale: Single;
begin
  Result := FScale;
end;

procedure TGVCamera.SetScale(aValue: Single);
begin
  FScale := aValue;
  if FScale < 1 then FScale := 1;

end;

function TGVCamera.GetRotation: Single;
begin
  Result := FRotation;
end;

procedure TGVCamera.SetRotation(aValue: Single);
begin
  FRotation := aValue;
end;

constructor TGVCamera.Create;
begin
  inherited;
  Clear;
end;

destructor TGVCamera.Destroy;
begin
  inherited;
end;

procedure TGVCamera.Clear;
begin
  FX := 0;
  FY := 0;
  FAlign.x := 0.5;
  FAlign.y := 0.5;
  FRotation := 0;
  FFlip.x := false;
  FFlip.y := false;
  FScale := 1;
  FWidth := GV.Window.Width;
  FHeight := GV.Window.Height;
  FAnchor.x := 0;
  FAnchor.y := 0;
end;

procedure TGVCamera.Init(aX: Single; aY: Single; aWidth: Single; aHeight: Single; aScale: Single=1.0; aRotation: Single=0.0);
begin
  FX := aX;
  FY := aY;
  FWidth := aWidth;
  FHeight := aHeight;
  FScale := aScale;
  FRotation := aRotation;
end;

procedure TGVCamera.Activate(aActivate: Boolean);
begin
  if aActivate then
    StartReverseTransform
  else
    RestoreTransform;
end;

procedure TGVCamera.GetWorldToScreenPosition(var aX: Single; var aY: Single);
var
  LTransform: ALLEGRO_TRANSFORM;
begin
  BuildTransform(@LTransform);
  al_invert_transform(@LTransform);
  al_transform_coordinates(@LTransform, @aX, @aY);
end;

procedure TGVCamera.GetScreenToWorldPosition(var aX: Single; var aY: Single);
var
  LTransform: ALLEGRO_TRANSFORM;
begin
  BuildTransform(@LTransform);
  al_transform_coordinates(@LTransform, @aX, @aY);
end;

end.
