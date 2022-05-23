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

unit GameVision.Window;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  WinApi.Windows,
  GameVision.Allegro,
  GameVision.Common,
  GameVision.Color,
  GameVision.Base,
  GameVision.Math,
  GameVision.RenderTarget;

const
  GV_BLEND_ZERO = 0;
  GV_BLEND_ONE = 1;
  GV_BLEND_ALPHA = 2;
  GV_BLEND_INVERSE_ALPHA = 3;
  GV_BLEND_SRC_COLOR = 4;
  GV_BLEND_DEST_COLOR = 5;
  GV_BLEND_INVERSE_SRC_COLOR = 6;
  GV_BLEND_INVERSE_DEST_COLOR = 7;
  GV_BLEND_CONST_COLOR = 8;
  GV_BLEND_INVERSE_CONST_COLOR = 9;
  GV_BLEND_ADD = 0;
  GV_BLEND_SRC_MINUS_DEST = 1;
  GV_BLEND_DEST_MINUS_SRC = 2;

type
  { TGVBlendMode }
  TGVBlendMode = (bmPreMultipliedAlpha, bmNonPreMultipliedAlpha, bmAdditiveAlpha, bmCopySrcToDest, bmMultiplySrcAndDest);

  { TGVBlendModeColor }
  TGVBlendModeColor = (bmcNormal, bmcAvgSrcDest);

  { TGVWindow }
  TGVWindow = class(TGVObject)
  protected
    FHandle: PALLEGRO_DISPLAY;
    FTransform: ALLEGRO_TRANSFORM;
    FWidth: Integer;
    FHeight: Integer;
    FScale: Single;
    FHWnd: HWND;
    FDpi: Integer;
    FRenderTarget: TGVRenderTarget;
    procedure GetWindowCenterScaledToDPI(aWidth: Integer; aHeight: Integer; var aX: Integer; var aY: Integer);
    procedure ScaleToDPI;
  public
    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
    property HWnd: HWND read FHWnd;
    property Scale: Single read FScale;
    property Dpi: Integer read FDpi;
    property Handle: PALLEGRO_DISPLAY read FHandle;
    property Transform: ALLEGRO_TRANSFORM read FTransform;
    constructor Create; override;
    destructor Destroy; override;
    function Open(aWidth: Integer; aHeight: Integer; aTitle: string): Boolean;
    function Close: Boolean;
    procedure Clear(aColor: TGVColor);
    procedure Show;
    procedure SetTitle(aTitle: string);
    function IsOpen: Boolean;
    procedure ResetTransform;
    procedure SetTransformPosition(aX: Single; aY: Single);
    procedure SetTransformAngle(aAngle: Single);
    procedure GetViewportSize(var aSize: TGVRectangle); overload;
    procedure SetRenderTarget(aRenderTarget: TGVRenderTarget);
    procedure SetBlender(aOperation: Integer; aSource: Integer; aDestination: Integer);
    procedure GetBlender(aOperation: PInteger; aSource: PInteger; aDestination: PInteger);
    procedure SetBlendColor(aColor: TGVColor);
    function  GetBlendColor: TGVColor;
    procedure SetBlendMode(aMode: TGVBlendMode);
    procedure SetBlendModeColor(aMode: TGVBlendModeColor; aColor: TGVColor);
    procedure RestoreDefaultBlendMode;
    procedure Save(const aFilename: string);
  end;

implementation

uses
  System.Math,
  System.IOUtils,
  GameVision.Core;

{ TGVWindow }
procedure TGVWindow.GetWindowCenterScaledToDPI(aWidth: Integer; aHeight: Integer; var aX: Integer; var aY: Integer);
var
  LDpi: Integer;
  LSX,LSY: Integer;
begin
  LDpi := al_get_monitor_dpi(0);

  LSX := MulDiv(aWidth, LDPI, GV_DISPLAY_DEFAULT_DPI);
  LSY := MulDiv(aHeight, LDpi, GV_DISPLAY_DEFAULT_DPI);

  aX := (GetSystemMetrics(SM_CXFULLSCREEN) - LSX) div 2;
  aY := (GetSystemMetrics(SM_CYFULLSCREEN) - LSY) div 2;
end;

procedure TGVWindow.ScaleToDPI;
var
  LDpi: Integer;
  LSX,LSY: Integer;
  LWX,LWY: Integer;
  LDW,LDH: Integer;
begin
  if FHandle = nil then Exit;

  LDW := al_get_display_width(FHandle);
  LDH := al_get_display_height(FHandle);

  al_identity_transform(@FTransform);
  al_use_transform(@FTransform);
  al_set_clipping_rectangle(0, 0, LDW, LDH);

  LDpi:= GetDpiForWindow(al_get_win_window_handle(FHandle));
  LSX := MulDiv(Round(Self.Width), LDPI, GV_DISPLAY_DEFAULT_DPI);
  LSY := MulDiv(Round(Self.Height), LDpi, GV_DISPLAY_DEFAULT_DPI);

  LWX := (GetSystemMetrics(SM_CXFULLSCREEN) - LSX) div 2;
  LWY := (GetSystemMetrics(SM_CYFULLSCREEN) - LSY) div 2;
  al_set_window_position(FHandle, LWX, LWY);
  al_resize_display(FHandle, LSX, LSY);

  FScale := min(LSX / Self.Width, LSY / Self.Height);
  al_set_clipping_rectangle(0, 0, LSX, LSY);
  al_build_transform(@FTransform, 0, 0, FScale, FScale, 0);
  al_use_transform(@FTransform);

  al_set_window_constraints(FHandle, LSX, LSY, LSX, LSY);
  al_apply_window_constraints(FHandle, True);
end;

procedure TGVWindow.SetRenderTarget(aRenderTarget: TGVRenderTarget);
begin
  FRenderTarget := aRenderTarget;
end;

constructor TGVWindow.Create;
begin
  inherited;
  FHandle := nil;
  al_identity_transform(@FTransform);
end;

destructor TGVWindow.Destroy;
begin
  Close;
  inherited;
end;

function TGVWindow.Open(aWidth: Integer; aHeight: Integer; aTitle: string): Boolean;
var
  LMarshaller: TMarshaller;
begin
  Result := False;
  if FHandle <> nil then Exit;
  al_set_new_display_flags(ALLEGRO_OPENGL_3_0 or ALLEGRO_RESIZABLE or ALLEGRO_PROGRAMMABLE_PIPELINE);
  al_set_new_display_option(ALLEGRO_COMPATIBLE_DISPLAY, 1, ALLEGRO_REQUIRE);
  al_set_new_display_option(ALLEGRO_VSYNC, 2, ALLEGRO_SUGGEST);
  al_set_new_display_option(ALLEGRO_CAN_DRAW_INTO_BITMAP, 1, ALLEGRO_REQUIRE);
  al_set_new_display_option(ALLEGRO_SAMPLE_BUFFERS, 1, ALLEGRO_SUGGEST);
  al_set_new_display_option(ALLEGRO_SAMPLES, 8, ALLEGRO_SUGGEST);
  al_set_new_window_title(LMarshaller.AsUtf8(aTitle).ToPointer);
  FHandle := al_create_display(aWidth, aHeight);
  if FHandle = nil then Exit;
  FHWnd := al_get_win_window_handle(FHandle);
  SetWindowLong(FHwnd, GWL_STYLE, GetWindowLong(FHWnd, GWL_STYLE) and (not WS_MAXIMIZEBOX));
  FWidth := aWidth;
  FHeight := aHeight;
  FScale := 1;
  FDpi := GetDpiForWindow(al_get_win_window_handle(FHandle));
  FRenderTarget := nil;
  al_register_event_source(GV.Queue, al_get_display_event_source(FHandle));
  ScaleToDPI;
end;

function TGVWindow.Close: Boolean;
begin
  Result := False;
  if FHandle = nil then Exit;
  if al_is_event_source_registered(GV.Queue, al_get_display_event_source(FHandle)) then
    al_unregister_event_source(GV.Queue, al_get_display_event_source(FHandle));
  al_destroy_display(FHandle);
  FHandle := nil;
end;

procedure TGVWindow.Clear(aColor: TGVColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle = nil then Exit;
  al_clear_to_color(LColor);
end;

procedure TGVWindow.Show;
begin
  if FHandle = nil then Exit;
  al_flip_display;
end;

procedure TGVWindow.SetTitle(aTitle: string);
var
  LMarshaller: TMarshaller;
begin
  if FHandle = nil then Exit;
  al_set_window_title(FHandle, LMarshaller.AsUtf8(aTitle).ToPointer);
end;

function TGVWindow.IsOpen: Boolean;
begin
  Result := Boolean(FHandle <> nil);
end;

procedure TGVWindow.ResetTransform;
begin
  if FHandle = nil then Exit;
  al_use_transform(@FTransform);
end;

procedure TGVWindow.SetTransformPosition(aX: Single; aY: Single);
var
  LTransform: ALLEGRO_TRANSFORM;
begin
  if FHandle = nil then Exit;
  al_copy_transform(@LTransform, al_get_current_transform);
  al_translate_transform(@LTransform, aX, aY);
  al_use_transform(@LTransform);
end;

procedure TGVWindow.SetTransformAngle(aAngle: Single);
var
  LTransform: ALLEGRO_TRANSFORM;
  LX, LY: Integer;
begin
  if FHandle = nil then Exit;
  LX := al_get_display_width(FHandle);
  LY := al_get_display_height(FHandle);
  al_copy_transform(@FTransform, al_get_current_transform);
  al_translate_transform(@FTransform, -(LX div 2), -(LY div 2));
  al_rotate_transform(@LTransform, aAngle * GV_DEG2RAD);
  al_translate_transform(@LTransform, 0, 0);
  al_translate_transform(@LTransform, LX div 2, LY div 2);
  al_use_transform(@LTransform);
end;

procedure TGVWindow.GetViewportSize(var aSize: TGVRectangle);
begin
  if FRenderTarget = nil then
    aSize.Assign(0, 0, FWidth, FHeight)
  else
    FRenderTarget.GetSize(aSize);
end;

procedure TGVWindow.SetBlender(aOperation: Integer; aSource: Integer; aDestination: Integer);
begin
  if FHandle = nil then Exit;
  al_set_blender(aOperation, aSource, aDestination);
end;

procedure TGVWindow.GetBlender(aOperation: PInteger; aSource: PInteger; aDestination: PInteger);
begin
  if FHandle = nil then Exit;
  al_get_blender(aOperation, aSource, aDestination);
end;

procedure TGVWindow.SetBlendColor(aColor: TGVColor);
var
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle = nil then Exit;
  al_set_blend_color(LColor);
end;

function  TGVWindow.GetBlendColor: TGVColor;
var
  LResult: ALLEGRO_COLOR absolute Result;
begin
  Result := BLANK;
  if FHandle = nil then Exit;
  LResult := al_get_blend_color;
end;

procedure TGVWindow.SetBlendMode(aMode: TGVBlendMode);
begin
  if FHandle = nil then Exit;
  case aMode of
    bmPreMultipliedAlpha:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_INVERSE_ALPHA);
      end;
    bmNonPreMultipliedAlpha:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_ALPHA, ALLEGRO_INVERSE_ALPHA);
      end;
    bmAdditiveAlpha:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_ONE);
      end;
    bmCopySrcToDest:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_ZERO);
      end;
    bmMultiplySrcAndDest:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_DEST_COLOR, ALLEGRO_ZERO);
      end;
  end;
end;

procedure TGVWindow.SetBlendModeColor(aMode: TGVBlendModeColor; aColor: TGVColor);
begin
  if FHandle = nil then Exit;
  case aMode of
    bmcNormal:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_CONST_COLOR, ALLEGRO_ONE);
        al_set_blend_color(al_map_rgba_f(aColor.red, aColor.green, aColor.blue, aColor.alpha));
      end;
    bmcAvgSrcDest:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_CONST_COLOR, ALLEGRO_CONST_COLOR);
        al_set_blend_color(al_map_rgba_f(aColor.red, aColor.green, aColor.blue, aColor.alpha));
      end;
  end;
end;

procedure TGVWindow.RestoreDefaultBlendMode;
begin
  if FHandle = nil then Exit;
  al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_INVERSE_ALPHA);
  al_set_blend_color(al_map_rgba(255, 255, 255, 255));
end;

procedure TGVWindow.Save(const aFilename: string);
var
  LBackbuffer: PALLEGRO_BITMAP;
  LScreenshot: PALLEGRO_BITMAP;
  LVX, LVY, LVW, LVH: Integer;
  LFilename: string;
  LMarshallar: TMarshaller;
  LSize: TGVRectangle;
begin
  if FHandle = nil then Exit;

  // get viewport size
  GetViewportSize(LSize);
  LVX := Round(LSize.X);
  LVY := Round(LSize.Y);
  LVW := Round(LSize.Width);
  LVH := Round(LSize.Height);

  // create LScreenshot bitmpat
  al_set_new_bitmap_flags(ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR);
  LScreenshot := al_create_bitmap(LVW, LVH);

  // exit if failed to create LScreenshot bitmap
  if LScreenshot = nil then Exit;

  // get LBackbuffer
  LBackbuffer := al_get_backbuffer(FHandle);

  // set target to LScreenshot bitmap
  al_set_target_bitmap(LScreenshot);

  // draw viewport area of LBackbuffer to LScreenshot bitmap
  al_draw_bitmap_region(LBackbuffer, LVX, LVY, LVW, LVH, 0, 0, 0);

  // restore LBackbuffer target
  al_set_target_bitmap(LBackbuffer);

  // make sure filename is a PNG file
  LFilename := aFilename;
  LFilename := TPath.ChangeExtension(LFilename, GV_FILEEXT_PNG);

  // save screen bitmap to PNG filename
  GV.SetFileSandBoxed(False);
  if not al_save_bitmap(LMarshallar.AsUtf8(LFilename).ToPointer, LScreenshot) then
  GV.SetFileSandBoxed(True);

  // destroy LScreenshot bitmap
  al_destroy_bitmap(LScreenshot);
end;

end.
