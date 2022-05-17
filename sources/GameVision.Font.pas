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

unit GameVision.Font;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Allegro,
  GameVision.Base,
  GameVision.Common,
  GameVision.Color,
  GameVision.Archive;

const
  // Resource Name Constants
  GV_RESNAME_DEFAULT_FONT = 'f83c944ce5144cbe8e05f80becffead2';

type
  { TGVFont }
  TGVFont = class(TGVObject)
  protected
    FHandle: PALLEGRO_FONT;
    FFilename: string;
    FSize: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    function LoadBuiltIn: Boolean;
    function LoadDefault(aSize: Cardinal): Boolean;
    function Load(aArchive: TGVArchive; aSize: Cardinal; aFilename: string): Boolean;
    function Unload: Boolean;
    procedure PrintText(aX: Single; aY: Single; aColor: TGVColor; aAlign: TGVHAlign; const aMsg: string; const aArgs: array of const); overload;
    procedure PrintText(aX: Single; var aY: Single; aLineSpace: Single; aColor: TGVColor; aAlign: TGVHAlign; const aMsg: string; const aArgs: array of const); overload;
    procedure PrintText(aX: Single; aY: Single; aColor: TGVColor; aAngle: Single; const aMsg: string; const aArgs: array of const); overload;
    function  GetTextWidth(const aMsg: string; const aArgs: array of const): Single;
    function  GetLineHeight: Single;
  end;


implementation

uses
  System.Classes,
  System.IOUtils,
  WinApi.Windows,
  GameVision.Core;

  { TGVFont }
constructor TGVFont.Create;
begin
  inherited;
  FHandle := nil;
  FFilename := '';
  FSize := 0;
  LoadBuiltIn;
end;

destructor TGVFont.Destroy;
begin
  Unload;
  inherited;
end;

function TGVFont.LoadBuiltIn: Boolean;
var
  LHandle: PALLEGRO_FONT;
begin
  Result := FAlse;
  if FHandle <> nil then Exit;
  al_set_new_bitmap_flags(ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR or ALLEGRO_MIPMAP or ALLEGRO_VIDEO_BITMAP);
  LHandle := al_create_builtin_font;
  if LHandle = nil then Exit;

  Unload;
  FHandle := LHandle;
  FFilename := '';
  FSize := 8;

  Result := True;
end;

(*
function TGVFont.LoadDefault(aSize: Cardinal): Boolean;
var
  LFilename: string;
begin
  Result := False;
  if aSize = 0 then Exit;
  LFilename := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), 'default.ttf');
  if not TFile.Exists(LFilename) then Exit;

  Result := Load(nil, aSize, LFilename);
end;
*)

function TGVFont.LoadDefault(aSize: Cardinal): Boolean;
var
  LStream: TResourceStream;
  LMemFile: PALLEGRO_FILE;
  LHandle: PALLEGRO_FONT;
begin
  Result := False;
  if aSize = 0 then Exit;
  if not GV.Util.ResourceExists(HInstance, GV_RESNAME_DEFAULT_FONT) then Exit;

  LStream := TResourceStream.Create(HInstance, GV_RESNAME_DEFAULT_FONT, RT_RCDATA);
  try
    LMemFile := al_open_memfile(LStream.Memory, LStream.Size, 'rb');
    if LMemFile = nil then Exit;

    al_set_new_bitmap_flags(ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR or ALLEGRO_MIPMAP or ALLEGRO_VIDEO_BITMAP);
    LHandle := al_load_ttf_font_f(LMemFile, '', -aSize, 0);
    if LHandle = nil then
    begin
      al_fclose(LMemFile);
      Exit;
    end;

    Unload;
    FHandle := LHandle;
    FFilename := '';
    FSize := aSize;
  finally
    FreeAndNil(LStream);
  end;
end;

function TGVFont.Load(aArchive: TGVArchive; aSize: Cardinal; aFilename: string): Boolean;
var
  LMarshaller: TMarshaller;
  LFilename: string;
  LHandle: PALLEGRO_FONT;
begin
  Result := False;
  if FHandle = nil then Exit;
  if aFilename.IsEmpty then Exit;
  if aSize = 0 then Exit;

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

  al_set_new_bitmap_flags(ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR or ALLEGRO_MIPMAP or ALLEGRO_VIDEO_BITMAP);
  if aArchive = nil then GV.SetFileSandBoxed(False);
  LHandle := al_load_ttf_font(LMarshaller.AsUtf8(LFilename).ToPointer, -aSize, 0);
  if aArchive = nil then GV.SetFileSandBoxed(True);
  if LHandle = nil then Exit;

  Unload;
  FHandle := LHandle;
  FFilename := aFilename;
  FSize := aSize;
end;

function TGVFont.Unload: Boolean;
begin
  Result := False;
  if FHandle = nil then Exit;
  al_destroy_font(FHandle);
  FHandle := nil;
  FFilename := '';
  FSize := 0;
  Result := True;
end;

procedure TGVFont.PrintText(aX: Single; aY: Single; aColor: TGVColor; aAlign: TGVHAlign; const aMsg: string; const aArgs: array of const);
var
  LUstr: PALLEGRO_USTR;
  LText: string;
  LColor: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle = nil then Exit;
  LText := Format(aMsg, aArgs);
  if LText.IsEmpty then  Exit;
  LUstr := al_ustr_new_from_utf16(PUInt16(PChar(LText)));
  al_draw_ustr(FHandle, LColor, aX, aY, Ord(aAlign) or ALLEGRO_ALIGN_INTEGER, LUstr);
  al_ustr_free(LUstr);
end;

procedure TGVFont.PrintText(aX: Single; var aY: Single; aLineSpace: Single; aColor: TGVColor; aAlign: TGVHAlign; const aMsg: string; const aArgs: array of const);
begin
  if FHandle = nil then Exit;
  PrintText(aX, aY, aColor, aAlign, aMsg, aArgs);
  aY := aY + GetLineHeight + aLineSpace;
end;

procedure TGVFont.PrintText(aX: Single; aY: Single; aColor: TGVColor; aAngle: Single; const aMsg: string; const aArgs: array of const);
var
  LUstr: PALLEGRO_USTR;
  LText: string;
  LFX, LFY: Single;
  LTR: ALLEGRO_TRANSFORM;
  LColor: ALLEGRO_COLOR absolute aColor;
  LTrans: ALLEGRO_TRANSFORM;
begin
  if FHandle = nil then Exit;
  LText := Format(aMsg, aArgs);
  if LText.IsEmpty then Exit;
  LFX := GetTextWidth(LText, []) / 2;
  LFY := GetLineHeight / 2;
  al_identity_transform(@LTR);
  al_translate_transform(@LTR, -LFX, -LFY);
  al_rotate_transform(@LTR, aAngle * GV_DEG2RAD);
  GV.Math.AngleRotatePos(aAngle, LFX, LFY);
  al_translate_transform(@LTR, aX + LFX, aY + LFY);
  LTrans := GV.Window.Transform;
  al_compose_transform(@LTR, @LTrans);
  al_use_transform(@LTR);
  LUstr := al_ustr_new_from_utf16(PUInt16(PChar(LText)));
  al_draw_ustr(FHandle, LColor, 0, 0, ALLEGRO_ALIGN_LEFT or ALLEGRO_ALIGN_INTEGER, LUstr);
  al_ustr_free(LUstr);
  LTrans := GV.Window.Transform;
  al_use_transform(@LTrans);
end;

function  TGVFont.GetTextWidth(const aMsg: string; const aArgs: array of const): Single;
var
  LUstr: PALLEGRO_USTR;
  LText: string;
begin
  Result := 0;
  if FHandle = nil then Exit;
  LText := Format(aMsg, aArgs);
  if LText.IsEmpty then  Exit;
  LUstr := al_ustr_new_from_utf16(PUInt16(PChar(LText)));
  Result := al_get_ustr_width(FHandle, LUstr);
  al_ustr_free(LUstr);
end;

function  TGVFont.GetLineHeight: Single;
begin
  Result := 0;
  if FHandle = nil then Exit;
  Result := al_get_font_line_height(FHandle);
end;

end.
