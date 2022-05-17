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

unit GameVision.Texture;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Allegro,
  GameVision.Common,
  GameVision.Base,
  GameVision.Color,
  GameVision.Math,
  GameVision.Archive;

type
  { TGVTextureData }
  PGVTextureData = ^TGVTextureData;
  TGVTextureData = record
    Memory: Pointer;
    Format: Integer;
    Pitch: Integer;
    PixelSize: Integer;
  end;

  { TGVTexture }
  TGVTexture = class(TGVObject)
  protected
    FHandle: PALLEGRO_BITMAP;
    FWidth: Single;
    FHeight: Single;
    FLocked: Boolean;
    FLockedRegion: TGVRectangle;
    FFilename: string;
  public
    property Width: Single read FWidth;
    property Height: Single read FHeight;
    property Filename: string read FFilename;
    property Handle: PALLEGRO_BITMAP read FHandle;
    constructor Create; override;
    destructor Destroy; override;
    function  Allocate(aWidth: Integer; aHeight: Integer): Boolean;
    function  Load(aArchive: TGVArchive; const aFilename: string; aColorKey: PGVColor): Boolean;
    function Unload: Boolean;
    function Lock(aRegion: PGVRectangle; aData: PGVTextureData=nil): Boolean;
    function Unlock: Boolean;
    function  GetPixel(aX: Integer; aY: Integer): TGVColor;
    procedure SetPixel(aX: Integer; aY: Integer; aColor: TGVColor);
    procedure Draw(aX, aY: Single; aRegion: PGVRectangle; aCenter: PGVVector;  aScale: PGVVector; aAngle: Single; aColor: TGVColor; aHFlip: Boolean=False; aVFlip: Boolean=False); overload;
    procedure Draw(aX, aY, aScale, aAngle: Single; aColor: TGVColor; aHAlign: TGVHAlign; aVAlign: TGVVAlign; aHFlip: Boolean=False; aVFlip: Boolean=False); overload;
    procedure DrawTiled(aDeltaX: Single; aDeltaY: Single);
  end;

implementation

uses
  System.Math,
  System.IOUtils,
  WinApi.Windows,
  GameVision.Core;


{ TGVTexture }
constructor TGVTexture.Create;
begin
  inherited;
end;

destructor TGVTexture.Destroy;
begin
  Unload;
  inherited;
end;

function  TGVTexture.Allocate(aWidth: Integer; aHeight: Integer): Boolean;
var
  LHandle: PALLEGRO_BITMAP;
begin
  Result := False;
  al_set_new_bitmap_flags(ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR or ALLEGRO_MIPMAP or ALLEGRO_VIDEO_BITMAP);
  LHandle := al_create_bitmap(aWidth, aHeight);
  if LHandle = nil then Exit;
  Unload;
  FHandle := LHandle;
  FWidth := al_get_bitmap_width(FHandle);
  FHeight := al_get_bitmap_height(FHandle);
  FFilename := '';
  Result := True;
end;

function  TGVTexture.Load(aArchive: TGVArchive; const aFilename: string; aColorKey: PGVColor): Boolean;
var
  LMarshaller: TMarshaller;
  LHandle: PALLEGRO_BITMAP;
  LFilename: string;
  LColorKey: PALLEGRO_COLOR absolute aColorKey;
begin
  Result := False;
  if aFilename.IsEmpty then Exit;

  if aArchive <> nil then
    begin
      if not aArchive.IsOpen then Exit;
      if not aArchive.FileExist(aFilename) then Exit;
      LFilename := string(aArchive.GetPasswordFilename(aFilename));
    end
  else
    begin
      if not TFile.Exists(aFilename) then Exit;
      LFilename := aFilename;
    end;

   if aArchive = nil then GV.SetFileSandBoxed(False);
   LHandle := al_load_bitmap(LMarshaller.AsUtf8(LFilename).ToPointer);
   if aArchive = nil then GV.SetFileSandBoxed(True);
   if LHandle = nil then Exit;

  Unload;
  FHandle := LHandle;
  FWidth := al_get_bitmap_width(FHandle);
  FHeight := al_get_bitmap_height(FHandle);
  FFilename := aFilename;

  if aColorKey <> nil then
    al_convert_mask_to_alpha(FHandle, LColorKey^);

  Result := True;
end;

function TGVTexture.Unload: Boolean;
begin
  Result := False;
  if FHandle = nil then Exit;
  al_destroy_bitmap(FHandle);
  FHandle := nil;
  FWidth := 0;
  FHeight := 0;
  FLocked := False;
  FFilename := '';
end;

function TGVTexture.Lock(aRegion: PGVRectangle; aData: PGVTextureData): Boolean;
var
  LLock: PALLEGRO_LOCKED_REGION;
begin
  Result := False;

  if FLocked then Exit;
  if FHandle = nil then Exit;

  LLock := nil;
  if not FLocked then
  begin
    if aRegion <> nil then
      begin
        LLock := al_lock_bitmap_region(FHandle, Round(aRegion.X), Round(aRegion.Y), Round(aRegion.Width), Round(aRegion.Height), ALLEGRO_PIXEL_FORMAT_ANY, ALLEGRO_LOCK_READWRITE);
        if LLock = nil then Exit;
        FLockedRegion.X := aRegion.X;
        FLockedRegion.Y := aRegion.Y;
        FLockedRegion.Width := aRegion.Width;
        FLockedRegion.Height := aRegion.Height;
      end
    else
      begin
        LLock := al_lock_bitmap(FHandle, ALLEGRO_PIXEL_FORMAT_ANY, ALLEGRO_LOCK_READWRITE);
        if LLock = nil then Exit;
        FLockedRegion.X := 0;
        FLockedRegion.Y := 0;
        FLockedRegion.Width := FWidth;
        FLockedRegion.Height := FHeight;
      end;
    FLocked := True;
  end;

  if LLock <> nil then
  begin
    if aData <> nil then
    begin
      aData.Memory := LLock.data;
      aData.Format := LLock.format;
      aData.Pitch := LLock.pitch;
      aData.PixelSize := LLock.pixel_size;
    end;
  end;

  Result := True;
end;

function TGVTexture.Unlock: Boolean;
begin
  Result := False;
  if not FLocked then Exit;
  if FHandle = nil then Exit;

  al_unlock_bitmap(FHandle);
  FLocked := False;
  FLockedRegion.X := 0;
  FLockedRegion.Y := 0;
  FLockedRegion.Width := 0;
  FLockedRegion.Height := 0;

  Result := True;
end;

function  TGVTexture.GetPixel(aX: Integer; aY: Integer): TGVColor;
var
  LX,LY: Integer;
  LResult: ALLEGRO_COLOR absolute Result;
begin
  Result := BLANK;
  if FHandle = nil then Exit;
  LX := Round(aX + FLockedRegion.X);
  LY := Round(aY + FlockedRegion.Y);
  LResult := al_get_pixel(FHandle, LX, LY);
end;

procedure TGVTexture.SetPixel(aX: Integer; aY: Integer; aColor: TGVColor);
var
  LX,LY: Integer;
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle = nil then Exit;
  LX := Round(aX + FLockedRegion.X);
  LY := Round(aY + FlockedRegion.Y);
  al_put_pixel(LX, LY, LColor);
end;

procedure TGVTexture.Draw(aX, aY: Single; aRegion: PGVRectangle; aCenter: PGVVector;  aScale: PGVVector; aAngle: Single; aColor: TGVColor; aHFlip: Boolean; aVFlip: Boolean);
var
  LA: Single;
  LRG: TGVRectangle;
  LCP: TGVVector;
  LSC: TGVVector;
  LC: ALLEGRO_COLOR absolute aColor;
  LFlags: Integer;
begin
  if FHandle = nil then Exit;

  // angle
  LA := aAngle * GV_DEG2RAD;
  LA := EnsureRange(LA, 0, 359);

  // region
  if Assigned(aRegion) then
    begin
      LRG.X := aRegion.X;
      LRG.Y := aRegion.Y;
      LRG.Width := aRegion.Width;
      LRG.Height := aRegion.Height;
    end
  else
    begin
      LRG.X := 0;
      LRG.Y := 0;
      LRG.Width := FWidth;
      LRG.Height := FHeight;
    end;

  if LRG.X < 0 then
    LRG.X := 0;
  if LRG.X > FWidth - 1 then
    LRG.X := FWidth - 1;

  if LRG.Y < 0 then
    LRG.Y := 0;
  if LRG.Y > FHeight - 1 then
    LRG.Y := FHeight - 1;

  if LRG.Width < 0 then
    LRG.Width := 0;
  if LRG.Width > FWidth then
    LRG.Width := LRG.Width;

  if LRG.Height < 0 then
    LRG.Height := 0;
  if LRG.Height > FHeight then
    LRG.Height := LRG.Height;

  // center
  if Assigned(aCenter) then
    begin
      LCP.X := (LRG.Width * aCenter.X);
      LCP.Y := (LRG.Height * aCenter.Y);
    end
  else
    begin
      LCP.X := 0;
      LCP.Y := 0;
    end;

  // scale
  if Assigned(aScale) then
    begin
      LSC.X := aScale.X;
      LSC.Y := aScale.Y;
    end
  else
    begin
      LSC.X := 1;
      LSC.Y := 1;
    end;

  // flags
  LFlags := 0;
  if aHFlip then LFlags := LFlags or ALLEGRO_FLIP_HORIZONTAL;
  if aVFlip then LFlags := LFlags or ALLEGRO_FLIP_VERTICAL;

  // render
  al_draw_tinted_scaled_rotated_bitmap_region(FHandle, LRG.X, LRG.Y, LRG.Width, LRG.Height, LC, LCP.X, LCP.Y, aX, aY, LSC.X, LSC.Y, LA, LFlags);
end;

procedure TGVTexture.Draw(aX, aY, aScale, aAngle: Single; aColor: TGVColor; aHAlign: TGVHAlign; aVAlign: TGVVAlign; aHFlip: Boolean; aVFlip: Boolean);
var
  LCenter: TGVVector;
  LScale: TGVVector;
begin
  if FHandle = nil then Exit;

  LCenter.X := 0;
  LCenter.Y := 0;

  LScale.X := aScale;
  LScale.Y := aScale;

  case aHAlign of
    haLeft  : LCenter.X := 0;
    haCenter: LCenter.X := 0.5;
    haRight : LCenter.X := 1;
  end;

  case aVAlign of
    vaTop   : LCenter.Y := 0;
    vaCenter: LCenter.Y := 0.5;
    vaBottom: LCenter.Y := 1;
  end;

  Draw(aX, aY, nil, @LCenter, @LScale, aAngle, aColor, aHFlip, aVFlip);
end;

procedure TGVTexture.DrawTiled(aDeltaX: Single; aDeltaY: Single);
var
  LW,LH    : Integer;
  LOX,LOY  : Integer;
  LPX,LPY  : Single;
  LFX,LFY  : Single;
  LTX,LTY  : Integer;
  //LVPW,LVPH: Single;
  LVP      : TGVRectangle;
  LVR,LVB  : Integer;
  LIX,LIY  : Integer;
begin
  if FHandle = nil then Exit;

  GV.Window.GetViewportSize(LVP);

  LW := Round(FWidth);
  LH := Round(FHeight);

  LOX := -LW+1;
  LOY := -LH+1;

  LPX := aDeltaX;
  LPY := aDeltaY;

  LFX := LPX-floor(LPX);
  LFY := LPY-floor(LPY);

  LTX := floor(LPX)-LOX;
  LTY := floor(LPY)-LOY;

  if (LTX>=0) then LTX := LTX mod LW + LOX else LTX := LW - -LTX mod LW + LOX;
  if (LTY>=0) then LTY := LTY mod LH + LOY else LTY := LH - -LTY mod LH + LOY;

  LVR := Round(LVP.Width);
  LVB := Round(LVP.Height);
  LIY := LTY;

  while LIY<LVB do
  begin
    LIX := LTX;
    while LIX<LVR do
    begin
      al_draw_bitmap(FHandle, LIX+LFX, LIY+LFY, 0);
      LIX := LIX+LW;
    end;
   LIY := LIY+LH;
  end;
end;

end.
