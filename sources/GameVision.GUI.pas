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

unit GameVision.GUI;

{$I GameVision.Defines.inc}

interface
uses
  System.SysUtils,
  GameVision.Allegro,
  GameVision.Nuklear,
  GameVision.Base,
  GameVision.Font,
  GameVision.Color,
  GameVision.Math;

const
  GUI_EDIT_BUFFER_LEN = (1024*1024);

  GUI_THEME_DEFAULT = 0;
  GUI_THEME_WHITE   = 1;
  GUI_THEME_RED     = 2;
  GUI_THEME_BLUE    = 3;
  GUI_THEME_DARK    = 4;

  GUI_WINDOW_BORDER = 1;
  GUI_WINDOW_MOVABLE = 2;
  GUI_WINDOW_SCALABLE = 4;
  GUI_WINDOW_CLOSABLE = 8;
  GUI_WINDOW_MINIMIZABLE = 16;
  GUI_WINDOW_NO_SCROLLBAR = 32;
  GUI_WINDOW_TITLE = 64;
  GUI_WINDOW_SCROLL_AUTO_HIDE = 128;
  GUI_WINDOW_BACKGROUND = 256;
  GUI_WINDOW_SCALE_LEFT = 512;
  GUI_WINDOW_NO_INPUT = 1024;

  GUI_EDIT_FILTER_DEFAULT = 0;
  GUI_EDIT_FILTER_ASCII = 1;
  GUI_EDIT_FILTER_FLOAT = 2;
  GUI_EDIT_FILTER_DECIMAL = 3;
  GUI_EDIT_FILTER_HEX = 4;
  GUI_EDIT_FILTER_OCT = 5;
  GUI_EDIT_FILTER_BINARY = 6;

  GUI_DYNAMIC = 0;
  GUI_STATIC  = 1;

  GUI_TEXT_LEFT = 17;
  GUI_TEXT_CENTERED = 18;
  GUI_TEXT_RIGHT  = 20;

type
  { TGVGUI }
  TGVGUI = class(TGVObject)
  protected
    FCtx: nk_context;
    FFont: TGVFont;
    FUserFont: nk_user_font;
    FEditBuffer: array of UTF8Char;
    FOpened: Boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure HandleEvent(aEvent: ALLEGRO_EVENT);
    procedure InputBegin;
    procedure InputEnd;
    procedure Render;
    procedure Clear;
    function  Open: Boolean;
    procedure Close;
    function  WindowBegin(const aName: string; const aTitle: string; aX: Single; aY: Single; aWidth: Single; aHeight: Single; aFlags: array of cardinal): Boolean;
    procedure WindowEnd;
    procedure LayoutRowStatic(aHeight: Single; aWidth: Integer; aColumns: Integer);
    procedure LayoutRowDynamic(aHeight: Single; aColumns: Integer);
    procedure LayoutRowBegin(aFormat: Integer; aHeight: Single; aColumns: Integer);
    procedure LayoutRowPush(aValue: Single);
    procedure LayoutRowEnd;
    procedure Button(const aTitle: string);
    function  Option(const aTitle: string; aActive: Boolean): Boolean;
    procedure &Label(const aTitle: string; aAlign: Integer);
    function  Slider(aMin: Single; aMax: Single; aStep: Single; var aValue: Single): Boolean;
    function  Checkbox(const aLabel: string; var aActive: Boolean): Boolean;
    function  Combobox(const aItems: array of string; aSelected: Integer; aItemHeight: Integer; aWidth: Single; aHeight: Single; var aChanged: Boolean): Integer;
    function  Edit(aType: Cardinal; aFilter: Integer; var aBuffer: string): Integer;
    function  Value(const aName: string; aValue: Integer; aMin: Integer; aMax: Integer; aStep: Integer; aIncPerPixel: Single): Integer; overload;
    function  Value(const aName: string; aValue: Double; aMin: Double; aMax: Double; aStep: Double; aIncPerPixel: Single): Double; overload;
    function  Progress(aCurrent: Cardinal; aMax: Cardinal; aModifyable: Boolean): Cardinal;
    procedure SetStyle(aTheme: Integer);
  end;

implementation

uses
  WinApi.Windows,
  GameVision.Common,
  GameVision.Core;

{ TGVGUI }
function get_font_width(handle: nk_handle; height: Single; const text: PAnsiChar; len: Integer): Single; cdecl;
var
  LFont: TGVFont;
  LBuff: PAnsiChar;
  LStr: AnsiString;
begin
  GetMem(LBuff, len + 1);
  LBuff[len] := #0;
  StrLCopy(LBuff, text, len);
  LStr := AnsiString(LBuff);
  LFont := TGVFont(handle.ptr);
  Result := LFont.GetTextWidth(string(LStr), []);
  FreeMem(LBuff, len + 1);
end;

function nk_color_to_allegro_color(color: nk_color): ALLEGRO_COLOR;
begin
  Result := al_map_rgba(color.r, color.g, color.b, color.a);
end;

function nk_color_to_color(color: nk_color): TGVColor;
begin
  //Result := Piro.Color.Make(color.r, color.g, color.b, color.a);
  Result.Make(color.r, color.g, color.b, color.a);
end;

procedure TGVGUI.HandleEvent(aEvent: ALLEGRO_EVENT);
var
  LV2: nk_vec2;
  LPos: TGVVector;
begin
  //if GV.CmdConsole.GetActive then Exit;

  case aEvent.type_ of
    ALLEGRO_EVENT_MOUSE_AXES:
      begin
        GV.Input.GetMouseInfo(@LPos, nil, nil);
        nk_input_motion(@FCtx, round(LPos.x), round(LPos.y));
        if (aEvent.mouse.dz <> 0) then
        begin
          LV2.x := 0;
          LV2.y := LPos.Z / al_get_mouse_wheel_precision;
          nk_input_scroll(@FCtx, LV2);
        end;
      end;

    ALLEGRO_EVENT_MOUSE_BUTTON_DOWN, ALLEGRO_EVENT_MOUSE_BUTTON_UP:
      begin
        var LButton: Integer := NK_BUTTON_LEFT;
        var LDown: Integer := 0;
        if aEvent.type_ = ALLEGRO_EVENT_MOUSE_BUTTON_DOWN then LDown := 1;
        if (aEvent.mouse.Button = 2) then
          LButton := NK_BUTTON_RIGHT
        else if (aEvent.mouse.Button = 3) then
          LButton := NK_BUTTON_MIDDLE;
        GV.Input.GetMouseInfo(@LPos, nil, nil);
        nk_input_button(@FCtx, LButton, round(LPos.x), round(LPos.y), LDown);
      end;

    ALLEGRO_EVENT_TOUCH_BEGIN, ALLEGRO_EVENT_TOUCH_END:
      begin
      end;

    ALLEGRO_EVENT_TOUCH_MOVE:
      begin
      end;

    ALLEGRO_EVENT_KEY_DOWN, ALLEGRO_EVENT_KEY_UP:
      begin
        var LKC: Integer := aEvent.keyboard.keycode;
        var LDown: Integer := 0;
        if aEvent.type_ = ALLEGRO_EVENT_KEY_DOWN then  LDown := 1;
        if (LKC = ALLEGRO_KEY_LSHIFT) or (LKC = ALLEGRO_KEY_RSHIFT) then
          nk_input_key(@FCtx, NK_KEY_SHIFT, LDown)
        else if (LKC = ALLEGRO_KEY_DELETE) then
          nk_input_key(@FCtx, NK_KEY_DEL, LDown)
        else if (LKC = ALLEGRO_KEY_ENTER) then
          nk_input_key(@FCtx, NK_KEY_ENTER, LDown)
        else if (LKC = ALLEGRO_KEY_TAB) then
          nk_input_key(@FCtx, NK_KEY_TAB, LDown)
        else if (LKC = ALLEGRO_KEY_LEFT) then
          nk_input_key(@FCtx, NK_KEY_LEFT, LDown)
        else if (LKC = ALLEGRO_KEY_RIGHT) then
          nk_input_key(@FCtx, NK_KEY_RIGHT, LDown)
        else if (LKC = ALLEGRO_KEY_UP) then
          nk_input_key(@FCtx, NK_KEY_UP, LDown)
        else if (LKC = ALLEGRO_KEY_DOWN) then
          nk_input_key(@FCtx, NK_KEY_DOWN, LDown)
        else if (LKC = ALLEGRO_KEY_BACKSPACE) then
          nk_input_key(@FCtx, NK_KEY_BACKSPACE, LDown)
        else if (LKC = ALLEGRO_KEY_ESCAPE) then
          nk_input_key(@FCtx, NK_KEY_TEXT_RESET_MODE, LDown)
        else if (LKC = ALLEGRO_KEY_PGUP) then
          nk_input_key(@FCtx, NK_KEY_SCROLL_UP, LDown)
        else if (LKC = ALLEGRO_KEY_PGDN) then
          nk_input_key(@FCtx, NK_KEY_SCROLL_DOWN, LDown)
        else if (LKC = ALLEGRO_KEY_HOME) then
        begin
          nk_input_key(@FCtx, NK_KEY_TEXT_START, LDown);
          nk_input_key(@FCtx, NK_KEY_SCROLL_START, LDown);
        end
        else if (LKC = ALLEGRO_KEY_END) then
        begin
          nk_input_key(@FCtx, NK_KEY_TEXT_END, LDown);
          nk_input_key(@FCtx, NK_KEY_SCROLL_END, LDown);
        end;
      end;

    ALLEGRO_EVENT_KEY_CHAR:
      begin
        var LKC: Integer := aEvent.keyboard.keycode;
        var LControlMask: Integer :=
            (aEvent.keyboard.modifiers and ALLEGRO_KEYMOD_CTRL) or
            (aEvent.keyboard.modifiers and ALLEGRO_KEYMOD_COMMAND);

        if (LKC = ALLEGRO_KEY_C and LControlMask) then
          nk_input_key(@FCtx, NK_KEY_COPY, 1)
        else if (LKC = ALLEGRO_KEY_V and LControlMask) then
          nk_input_key(@FCtx, NK_KEY_PASTE, 1)
        else if (LKC = ALLEGRO_KEY_X and LControlMask) then
          nk_input_key(@FCtx, NK_KEY_CUT, 1)
        else if (LKC = ALLEGRO_KEY_Z and LControlMask) then
          nk_input_key(@FCtx, NK_KEY_TEXT_UNDO, 1)
        else if (LKC = ALLEGRO_KEY_R and LControlMask) then
          nk_input_key(@FCtx, NK_KEY_TEXT_REDO, 1)
        else if (LKC = ALLEGRO_KEY_A and LControlMask) then
          nk_input_key(@FCtx, NK_KEY_TEXT_SELECT_ALL, 1)
        else
        begin
          if (LKC <> ALLEGRO_KEY_BACKSPACE) and (LKC <> ALLEGRO_KEY_LEFT) and
            (LKC <> ALLEGRO_KEY_RIGHT) and (LKC <> ALLEGRO_KEY_UP) and
            (LKC <> ALLEGRO_KEY_DOWN) and (LKC <> ALLEGRO_KEY_HOME) and
            (LKC <> ALLEGRO_KEY_DELETE) and (LKC <> ALLEGRO_KEY_ENTER) and
            (LKC <> ALLEGRO_KEY_END) and (LKC <> ALLEGRO_KEY_ESCAPE) and
            (LKC <> ALLEGRO_KEY_PGDN) and (LKC <> ALLEGRO_KEY_PGUP) then
            nk_input_unicode(@FCtx, aEvent.keyboard.unichar);
        end;
      end;
  end;
end;

constructor TGVGUI.Create;
begin
  inherited;
  FOpened := False;
  GV.Logger.Log('Initialized %s Subsystem', ['GUI']);
end;

destructor TGVGUI.Destroy;
begin
  Close;
  GV.Logger.Log('Shutdown %s Subsystem', ['GUI']);
  inherited;
end;

procedure TGVGUI.InputBegin;
begin
  nk_input_begin(@FCtx);
end;

procedure TGVGUI.InputEnd;
begin
  nk_input_end(@FCtx);
end;

procedure TGVGUI.Render;
var
  LCmd: pnk_command;
  LColor: ALLEGRO_COLOR;
  LVertices: array of Single;
  Points: array [0 .. 7] of Single;
  LVX,LVY,LVW,LVH: Integer;
begin
  al_get_clipping_rectangle(@LVX, @LVY, @LVW, @LVH);
  LCmd := nk__begin(@FCtx);
  while LCmd <> nil do
  begin

    case LCmd.type_ of
      NK_COMMAND_NOP_:
        begin
        end;

      NK_COMMAND_SCISSOR_:
        begin
          var c: Pnk_command_scissor := Pnk_command_scissor(LCmd);
          var cx, cy, cw, ch, scale: Single;
          scale := GV.Window.Scale;
          cx := (c.x * scale) + (GV.Window.Width * GV.Window.Scale) - 1;
          cy := (c.y * scale) + (GV.Window.Height * GV.Window.Scale) - 1;
          cw := c.w * scale;
          ch := c.h * scale;
          al_set_clipping_rectangle(round(cx), round(cy), round(cw), round(ch));
        end;

      NK_COMMAND_LINE_:
        begin
          var c: Pnk_command_line := Pnk_command_line(LCmd);
          LColor := nk_color_to_allegro_color(c.Color);
          al_draw_line(c.begin_.x, c.begin_.y, c.end_.x, c.end_.y, LColor,  c.line_thickness);
        end;

      NK_COMMAND_RECT_:
        begin
          var c: Pnk_command_rect := Pnk_command_rect(LCmd);
          LColor := nk_color_to_allegro_color(c.Color);
          al_draw_rounded_rectangle(c.x, c.y, (c.x + c.w), (c.y + c.h), c.rounding, c.rounding, LColor, c.line_thickness);
        end;

      NK_COMMAND_RECT_FILLED_:
        begin
          var c: Pnk_command_rect_filled := Pnk_command_rect_filled(LCmd);
          LColor := nk_color_to_allegro_color(c.Color);
          al_draw_filled_rounded_rectangle(c.x, c.y, (c.x + c.w), (c.y + c.h), c.rounding, c.rounding, LColor);
        end;

      NK_COMMAND_CIRCLE_:
        begin
          var c: Pnk_command_circle := Pnk_command_circle(LCmd);
          LColor := nk_color_to_allegro_color(c.Color);
          var xr: Single := c.w / 2;
          var yr: Single := c.h / 2;
          al_draw_ellipse(c.x + xr, c.y + yr, xr, yr, LColor, c.line_thickness);
        end;

      NK_COMMAND_CIRCLE_FILLED_:
        begin
          var c: Pnk_command_circle_filled := Pnk_command_circle_filled(LCmd);
          LColor := nk_color_to_allegro_color(c.Color);
          var xr: Single := c.w / 2;
          var yr: Single := c.h / 2;
          al_draw_filled_ellipse(c.x + xr, c.y + yr, xr, yr, LColor);
        end;

      NK_COMMAND_TRIANGLE_:
        begin
          var c: Pnk_command_triangle := Pnk_command_triangle(LCmd);
          LColor := nk_color_to_allegro_color(c.Color);
          al_draw_triangle(c.a.x, c.a.y, c.b.x, c.b.y, c.c.x, c.c.y, LColor,  c.line_thickness);
        end;

      NK_COMMAND_TRIANGLE_FILLED_:
        begin
          var c: Pnk_command_triangle_filled := Pnk_command_triangle_filled(LCmd);
          LColor := nk_color_to_allegro_color(c.Color);
          al_draw_filled_triangle(c.a.x, c.a.y, c.b.x, c.b.y, c.c.x, c.c.y, LColor);
        end;

      NK_COMMAND_POLYGON_:
        begin
          var c: Pnk_command_polygon := Pnk_command_polygon(LCmd);
          LColor := nk_color_to_allegro_color(c.Color);
          SetLength(LVertices, c.point_count * 2);
          for var i := 0 to c.point_count - 1 do
          begin
            LVertices[i * 2] := c.Points[i].x;
            LVertices[(i * 2) + 1] := c.Points[i].y;
          end;
          al_draw_polyline(@LVertices, (2 * sizeof(Single)), c.point_count, ALLEGRO_LINE_JOIN_ROUND, ALLEGRO_LINE_CAP_CLOSED, LColor, c.line_thickness, 0.0);
          LVertices := nil;
        end;

      NK_COMMAND_POLYGON_FILLED_:
        begin
          var c: Pnk_command_polygon_filled := Pnk_command_polygon_filled(LCmd);
          LColor := nk_color_to_allegro_color(c.Color);
          SetLength(LVertices, c.point_count * 2);
          for var i := 0 to c.point_count - 1 do
          begin
            LVertices[i * 2] := c.Points[i].x;
            LVertices[(i * 2) + 1] := c.Points[i].y;
          end;
          al_draw_filled_polygon(@LVertices, c.point_count, LColor);
          LVertices := nil;
        end;

      NK_COMMAND_POLYLINE_:
        begin
          var c: Pnk_command_polyline := Pnk_command_polyline(LCmd);
          LColor := nk_color_to_allegro_color(c.Color);
          SetLength(LVertices, c.point_count * 2);
          for var i := 0 to c.point_count - 1 do
          begin
            LVertices[i * 2] := c.Points[i].x;
            LVertices[(i * 2) + 1] := c.Points[i].y;
          end;
          al_draw_polyline(@LVertices, (2 * sizeof(Single)), c.point_count,  ALLEGRO_LINE_JOIN_ROUND, ALLEGRO_LINE_CAP_ROUND, LColor, c.line_thickness, 0.0);
          LVertices := nil;
        end;

      NK_COMMAND_TEXT_:
        begin
          var c: Pnk_command_text := Pnk_command_text(LCmd);
          var col: TGVColor := nk_color_to_color(c.foreground);
          var Font: TGVFont := c.Font.userdata.ptr;
          Font.PrintText(c.x, c.y, col, haLeft, string(PUTF8Char(@c.string_[0])), []);
        end;

      NK_COMMAND_CURVE_:
        begin
          var c: Pnk_command_curve := Pnk_command_curve(LCmd);
          LColor := nk_color_to_allegro_color(c.Color);
          Points[0] := c.begin_.x;
          Points[1] := c.begin_.y;
          Points[2] := c.ctrl[0].x;
          Points[3] := c.ctrl[0].y;
          Points[4] := c.ctrl[1].x;
          Points[5] := c.ctrl[1].y;
          Points[6] := c.end_.x;
          Points[7] := c.end_.y;
          al_draw_spline(@Points, LColor, c.line_thickness);
        end;

      NK_COMMAND_ARC_:
        begin
          var c: Pnk_command_arc := Pnk_command_arc(LCmd);
          LColor := nk_color_to_allegro_color(c.Color);
          al_draw_arc(c.cx, c.cy, c.r, c.a[0], c.a[1], LColor, c.line_thickness);
        end;

      NK_COMMAND_IMAGE_:
        begin
          var  c: Pnk_command_image := Pnk_command_image(LCmd);
          al_draw_bitmap_region(c.img.handle.ptr, 0, 0, c.w, c.h, c.x, c.y, 0);
        end;

      NK_COMMAND_RECT_MULTI_COLOR_:
        begin
        end;

      NK_COMMAND_ARC_FILLED_:
        begin
        end;

    end;
    LCmd := nk__next(@FCtx, LCmd);
  end;
  al_set_clipping_rectangle(LVX, LVY, LVW, LVH);
end;

procedure TGVGUI.Clear;
begin
  nk_clear(@FCtx);
end;

function  TGVGUI.Open: Boolean;
begin
  Result := False;
  if FOpened then Exit;

  SetLength(FEditBuffer, GUI_EDIT_BUFFER_LEN);
  FFont := TGVFont.Create;
  FFont.LoadDefault(20);
  FUserFont.userdata.ptr := FFont;
  FUserFont.height := FFont.GetLineHeight;
  FUserFont.width := get_font_width;
  if nk_init_default(@FCtx, @FUserFont) = 1 then
    FOpened := True
  else
    FOpened := False;

  Result := FOpened;
end;

procedure TGVGUI.Close;
begin
  if not FOpened then Exit;
  nk_free(@FCtx);
  FreeAndNil(FFont);
  FEditBuffer := nil;
  FOpened := False;
end;

function  TGVGUI.WindowBegin(const aName: string; const aTitle: string; aX: Single; aY: Single; aWidth: Single; aHeight: Single; aFlags: array of cardinal): Boolean;
var
  LFlags: cardinal;
  LFlag: cardinal;
begin
  LFlags := 0;
  for LFlag in aFlags do
  begin
    LFlags := LFlags or LFlag;
  end;
  Result := Boolean(nk_begin_titled(@FCtx, PAnsiChar(AnsiString(aName)), PAnsiChar(AnsiString(aTitle)), nk_rect_(aX, aY, aWidth, aHeight), LFlags));
end;

procedure TGVGUI.WindowEnd;
begin
  nk_end(@FCtx);
end;

procedure TGVGUI.LayoutRowStatic(aHeight: Single; aWidth: Integer; aColumns: Integer);
begin
  nk_layout_row_static(@FCtx, aHeight, aWidth, aColumns);
end;

procedure TGVGUI.LayoutRowDynamic(aHeight: Single; aColumns: Integer);
begin
  nk_layout_row_dynamic(@FCtx, aHeight, aColumns);
end;

procedure TGVGUI.LayoutRowBegin(aFormat: Integer; aHeight: Single; aColumns: Integer);
begin
  nk_layout_row_begin(@FCtx, aFormat, aHeight, aColumns);
end;

procedure TGVGUI.LayoutRowPush(aValue: Single);
begin
  nk_layout_row_push(@FCtx, aValue);
end;

procedure TGVGUI.LayoutRowEnd;
begin
  nk_layout_row_end(@FCtx);
end;

procedure TGVGUI.Button(const aTitle: string);
var
  LMarshaller: TMarshaller;
begin
  nk_button_label(@FCtx, LMarshaller.AsUtf8(aTitle).ToPointer);
end;

function  TGVGUI.Option(const aTitle: string; aActive: Boolean): Boolean;
var
  LMarshaller: TMarshaller;
begin
  Result := Boolean(nk_option_label(@FCtx, LMarshaller.AsUtf8(aTitle).ToPointer,  Ord(aActive)));
end;

procedure TGVGUI.&Label(const aTitle: string; aAlign: Integer);
var
  LMarshaller: TMarshaller;
begin
  nk_label(@FCtx, LMarshaller.AsUtf8(aTitle).ToPointer, aAlign);
end;

function  TGVGUI.Slider(aMin: Single; aMax: Single; aStep: Single; var aValue: Single): Boolean;
begin
  Result := Boolean(nk_slider_float(@FCtx, aMin, @aValue, aMax, aStep));
end;

function  TGVGUI.Checkbox(const aLabel: string; var aActive: Boolean): Boolean;
var
  LMarshaller: TMarshaller;
  LActive: Integer;
begin
  LActive := Ord(aActive);
  Result := Boolean(nk_checkbox_label(@FCtx, LMarshaller.AsUtf8(aLabel).ToPointer, @LActive));
  aActive := Boolean(LActive);
end;

function  TGVGUI.Combobox(const aItems: array of string; aSelected: Integer; aItemHeight: Integer; aWidth: Single; aHeight: Single; var aChanged: Boolean): Integer;
var
  LItems: array of AnsiString;
  LItem: string;
  LSize: nk_vec2;
  LCount: Integer;
  LI: Integer;
begin
  LCount := Length(aItems);
  SetLength(LItems, LCount);
  LI := 0;
  for LItem in aItems do
  begin
    LItems[LI] := AnsiString(LItem);
    Inc(LI);
  end;
  LSize.x := aWidth;
  LSize.y := aHeight;
  Result := nk_combo(@FCtx, PPUTF8Char(@LItems[0]), LCount, aSelected, aItemHeight, LSize);
  if Result <> aSelected then
    aChanged := True
  else
    aChanged := False;
  LItems := nil;
end;

function  TGVGUI.Edit(aType: Cardinal; aFilter: Integer; var aBuffer: string): Integer;
var
  LBuffer: UTF8String;
  LLen: Integer;
  LFilter: nk_plugin_filter;
begin
  LBuffer := UTF8String(aBuffer);
  StrLCopy(PUTF8Char(@FEditBuffer[0]), PUTF8Char(LBuffer), GUI_EDIT_BUFFER_LEN);
  case aFilter of
    GUI_EDIT_FILTER_DEFAULT: LFilter := nk_filter_default;
    GUI_EDIT_FILTER_ASCII: LFilter := nk_filter_ascii;
    GUI_EDIT_FILTER_FLOAT: LFilter := nk_filter_float;
    GUI_EDIT_FILTER_DECIMAL: LFilter := nk_filter_decimal;
    GUI_EDIT_FILTER_HEX: LFilter := nk_filter_hex;
    GUI_EDIT_FILTER_OCT: LFilter := nk_filter_oct;
    GUI_EDIT_FILTER_BINARY: LFilter := nk_filter_binary;
  else
    LFilter := nk_filter_default;
  end;
  Result := nk_edit_string_zero_terminated(@FCtx, aType, PUTF8Char(@FEditBuffer[0]),
    GUI_EDIT_BUFFER_LEN-1, LFilter);
  LLen := StrLen(PUTF8Char(@FEditBuffer[0]));
  if LLen > 0 then
    begin
      SetLength(LBuffer, LLen);
      StrLCopy(PUTF8Char(LBuffer), @FEditBuffer[0], LLen);
      aBuffer := string(LBuffer);
    end
  else
    aBuffer := '';
end;

function  TGVGUI.Value(const aName: string; aValue: Integer; aMin: Integer; aMax: Integer; aStep: Integer; aIncPerPixel: Single): Integer;
var
  LMarshaller: TMarshaller;
begin
  Result := nk_propertyi(@FCtx, LMarshaller.AsUtf8(aName).ToPointer, aMin, aValue, aMax, aStep, aIncPerPixel);
end;

function  TGVGUI.Value(const aName: string; aValue: Double; aMin: Double; aMax: Double; aStep: Double; aIncPerPixel: Single): Double;
var
  LMarshaller: TMarshaller;
begin
  Result := nk_propertyd(@FCtx, LMarshaller.AsUtf8(aName).ToPointer, aMin, aValue, aMax, aStep, aIncPerPixel);
end;

function  TGVGUI.Progress(aCurrent: Cardinal; aMax: Cardinal; aModifyable: Boolean): Cardinal;
begin
  Result := nk_prog(@FCtx, aCurrent, aMax, Ord(aModifyable));
end;

procedure TGVGUI.SetStyle(aTheme: Integer);
var
  LTable: array[0 .. NK_COLOR_COUNT-1] of nk_color;
begin
  case aTheme of
    GUI_THEME_DEFAULT:
      begin
        nk_style_default(@FCtx);
      end;
    GUI_THEME_WHITE:
      begin
        LTable[NK_COLOR_TEXT] := nk_rgba_(70, 70, 70, 255);
        LTable[NK_COLOR_WINDOW] := nk_rgba_(175, 175, 175, 255);
        LTable[NK_COLOR_HEADER] := nk_rgba_(175, 175, 175, 255);
        LTable[NK_COLOR_BORDER] := nk_rgba_(0, 0, 0, 255);
        LTable[NK_COLOR_BUTTON] := nk_rgba_(185, 185, 185, 255);
        LTable[NK_COLOR_BUTTON_HOVER] := nk_rgba_(170, 170, 170, 255);
        LTable[NK_COLOR_BUTTON_ACTIVE] := nk_rgba_(160, 160, 160, 255);
        LTable[NK_COLOR_TOGGLE] := nk_rgba_(150, 150, 150, 255);
        LTable[NK_COLOR_TOGGLE_HOVER] := nk_rgba_(120, 120, 120, 255);
        LTable[NK_COLOR_TOGGLE_CURSOR] := nk_rgba_(175, 175, 175, 255);
        LTable[NK_COLOR_SELECT] := nk_rgba_(190, 190, 190, 255);
        LTable[NK_COLOR_SELECT_ACTIVE] := nk_rgba_(175, 175, 175, 255);
        LTable[NK_COLOR_SLIDER] := nk_rgba_(190, 190, 190, 255);
        LTable[NK_COLOR_SLIDER_CURSOR] := nk_rgba_(80, 80, 80, 255);
        LTable[NK_COLOR_SLIDER_CURSOR_HOVER] := nk_rgba_(70, 70, 70, 255);
        LTable[NK_COLOR_SLIDER_CURSOR_ACTIVE] := nk_rgba_(60, 60, 60, 255);
        LTable[NK_COLOR_PROPERTY] := nk_rgba_(175, 175, 175, 255);
        LTable[NK_COLOR_EDIT] := nk_rgba_(150, 150, 150, 255);
        LTable[NK_COLOR_EDIT_CURSOR] := nk_rgba_(0, 0, 0, 255);
        LTable[NK_COLOR_COMBO] := nk_rgba_(175, 175, 175, 255);
        LTable[NK_COLOR_CHART] := nk_rgba_(160, 160, 160, 255);
        LTable[NK_COLOR_CHART_COLOR] := nk_rgba_(45, 45, 45, 255);
        LTable[NK_COLOR_CHART_COLOR_HIGHLIGHT] := nk_rgba_( 255, 0, 0, 255);
        LTable[NK_COLOR_SCROLLBAR] := nk_rgba_(180, 180, 180, 255);
        LTable[NK_COLOR_SCROLLBAR_CURSOR] := nk_rgba_(140, 140, 140, 255);
        LTable[NK_COLOR_SCROLLBAR_CURSOR_HOVER] := nk_rgba_(150, 150, 150, 255);
        LTable[NK_COLOR_SCROLLBAR_CURSOR_ACTIVE] := nk_rgba_(160, 160, 160, 255);
        LTable[NK_COLOR_TAB_HEADER] := nk_rgba_(180, 180, 180, 255);
        nk_style_from_table(@FCtx, @LTable);
      end;
    GUI_THEME_RED:
      begin
        LTable[NK_COLOR_TEXT] := nk_rgba_(190, 190, 190, 255);
        LTable[NK_COLOR_WINDOW] := nk_rgba_(30, 33, 40, 215);
        LTable[NK_COLOR_HEADER] := nk_rgba_(181, 45, 69, 220);
        LTable[NK_COLOR_BORDER] := nk_rgba_(51, 55, 67, 255);
        LTable[NK_COLOR_BUTTON] := nk_rgba_(181, 45, 69, 255);
        LTable[NK_COLOR_BUTTON_HOVER] := nk_rgba_(190, 50, 70, 255);
        LTable[NK_COLOR_BUTTON_ACTIVE] := nk_rgba_(195, 55, 75, 255);
        LTable[NK_COLOR_TOGGLE] := nk_rgba_(51, 55, 67, 255);
        LTable[NK_COLOR_TOGGLE_HOVER] := nk_rgba_(45, 60, 60, 255);
        LTable[NK_COLOR_TOGGLE_CURSOR] := nk_rgba_(181, 45, 69, 255);
        LTable[NK_COLOR_SELECT] := nk_rgba_(51, 55, 67, 255);
        LTable[NK_COLOR_SELECT_ACTIVE] := nk_rgba_(181, 45, 69, 255);
        LTable[NK_COLOR_SLIDER] := nk_rgba_(51, 55, 67, 255);
        LTable[NK_COLOR_SLIDER_CURSOR] := nk_rgba_(181, 45, 69, 255);
        LTable[NK_COLOR_SLIDER_CURSOR_HOVER] := nk_rgba_(186, 50, 74, 255);
        LTable[NK_COLOR_SLIDER_CURSOR_ACTIVE] := nk_rgba_(191, 55, 79, 255);
        LTable[NK_COLOR_PROPERTY] := nk_rgba_(51, 55, 67, 255);
        LTable[NK_COLOR_EDIT] := nk_rgba_(51, 55, 67, 225);
        LTable[NK_COLOR_EDIT_CURSOR] := nk_rgba_(190, 190, 190, 255);
        LTable[NK_COLOR_COMBO] := nk_rgba_(51, 55, 67, 255);
        LTable[NK_COLOR_CHART] := nk_rgba_(51, 55, 67, 255);
        LTable[NK_COLOR_CHART_COLOR] := nk_rgba_(170, 40, 60, 255);
        LTable[NK_COLOR_CHART_COLOR_HIGHLIGHT] := nk_rgba_( 255, 0, 0, 255);
        LTable[NK_COLOR_SCROLLBAR] := nk_rgba_(30, 33, 40, 255);
        LTable[NK_COLOR_SCROLLBAR_CURSOR] := nk_rgba_(64, 84, 95, 255);
        LTable[NK_COLOR_SCROLLBAR_CURSOR_HOVER] := nk_rgba_(70, 90, 100, 255);
        LTable[NK_COLOR_SCROLLBAR_CURSOR_ACTIVE] := nk_rgba_(75, 95, 105, 255);
        LTable[NK_COLOR_TAB_HEADER] := nk_rgba_(181, 45, 69, 220);
        nk_style_from_table(@FCtx, @LTable);
      end;
    GUI_THEME_BLUE:
      begin
        LTable[NK_COLOR_TEXT] := nk_rgba_(20, 20, 20, 255);
        LTable[NK_COLOR_WINDOW] := nk_rgba_(202, 212, 214, 215);
        LTable[NK_COLOR_HEADER] := nk_rgba_(137, 182, 224, 220);
        LTable[NK_COLOR_BORDER] := nk_rgba_(140, 159, 173, 255);
        LTable[NK_COLOR_BUTTON] := nk_rgba_(137, 182, 224, 255);
        LTable[NK_COLOR_BUTTON_HOVER] := nk_rgba_(142, 187, 229, 255);
        LTable[NK_COLOR_BUTTON_ACTIVE] := nk_rgba_(147, 192, 234, 255);
        LTable[NK_COLOR_TOGGLE] := nk_rgba_(177, 210, 210, 255);
        LTable[NK_COLOR_TOGGLE_HOVER] := nk_rgba_(182, 215, 215, 255);
        LTable[NK_COLOR_TOGGLE_CURSOR] := nk_rgba_(137, 182, 224, 255);
        LTable[NK_COLOR_SELECT] := nk_rgba_(177, 210, 210, 255);
        LTable[NK_COLOR_SELECT_ACTIVE] := nk_rgba_(137, 182, 224, 255);
        LTable[NK_COLOR_SLIDER] := nk_rgba_(177, 210, 210, 255);
        LTable[NK_COLOR_SLIDER_CURSOR] := nk_rgba_(137, 182, 224, 245);
        LTable[NK_COLOR_SLIDER_CURSOR_HOVER] := nk_rgba_(142, 188, 229, 255);
        LTable[NK_COLOR_SLIDER_CURSOR_ACTIVE] := nk_rgba_(147, 193, 234, 255);
        LTable[NK_COLOR_PROPERTY] := nk_rgba_(210, 210, 210, 255);
        LTable[NK_COLOR_EDIT] := nk_rgba_(210, 210, 210, 225);
        LTable[NK_COLOR_EDIT_CURSOR] := nk_rgba_(20, 20, 20, 255);
        LTable[NK_COLOR_COMBO] := nk_rgba_(210, 210, 210, 255);
        LTable[NK_COLOR_CHART] := nk_rgba_(210, 210, 210, 255);
        LTable[NK_COLOR_CHART_COLOR] := nk_rgba_(137, 182, 224, 255);
        LTable[NK_COLOR_CHART_COLOR_HIGHLIGHT] := nk_rgba_( 255, 0, 0, 255);
        LTable[NK_COLOR_SCROLLBAR] := nk_rgba_(190, 200, 200, 255);
        LTable[NK_COLOR_SCROLLBAR_CURSOR] := nk_rgba_(64, 84, 95, 255);
        LTable[NK_COLOR_SCROLLBAR_CURSOR_HOVER] := nk_rgba_(70, 90, 100, 255);
        LTable[NK_COLOR_SCROLLBAR_CURSOR_ACTIVE] := nk_rgba_(75, 95, 105, 255);
        LTable[NK_COLOR_TAB_HEADER] := nk_rgba_(156, 193, 220, 255);
        nk_style_from_table(@FCtx, @LTable);
      end;
    GUI_THEME_DARK:
      begin
        LTable[NK_COLOR_TEXT] := nk_rgba_(210, 210, 210, 255);
        LTable[NK_COLOR_WINDOW] := nk_rgba_(57, 67, 71, 215);
        LTable[NK_COLOR_HEADER] := nk_rgba_(51, 51, 56, 220);
        LTable[NK_COLOR_BORDER] := nk_rgba_(46, 46, 46, 255);
        LTable[NK_COLOR_BUTTON] := nk_rgba_(48, 83, 111, 255);
        LTable[NK_COLOR_BUTTON_HOVER] := nk_rgba_(58, 93, 121, 255);
        LTable[NK_COLOR_BUTTON_ACTIVE] := nk_rgba_(63, 98, 126, 255);
        LTable[NK_COLOR_TOGGLE] := nk_rgba_(50, 58, 61, 255);
        LTable[NK_COLOR_TOGGLE_HOVER] := nk_rgba_(45, 53, 56, 255);
        LTable[NK_COLOR_TOGGLE_CURSOR] := nk_rgba_(48, 83, 111, 255);
        LTable[NK_COLOR_SELECT] := nk_rgba_(57, 67, 61, 255);
        LTable[NK_COLOR_SELECT_ACTIVE] := nk_rgba_(48, 83, 111, 255);
        LTable[NK_COLOR_SLIDER] := nk_rgba_(50, 58, 61, 255);
        LTable[NK_COLOR_SLIDER_CURSOR] := nk_rgba_(48, 83, 111, 245);
        LTable[NK_COLOR_SLIDER_CURSOR_HOVER] := nk_rgba_(53, 88, 116, 255);
        LTable[NK_COLOR_SLIDER_CURSOR_ACTIVE] := nk_rgba_(58, 93, 121, 255);
        LTable[NK_COLOR_PROPERTY] := nk_rgba_(50, 58, 61, 255);
        LTable[NK_COLOR_EDIT] := nk_rgba_(50, 58, 61, 225);
        LTable[NK_COLOR_EDIT_CURSOR] := nk_rgba_(210, 210, 210, 255);
        LTable[NK_COLOR_COMBO] := nk_rgba_(50, 58, 61, 255);
        LTable[NK_COLOR_CHART] := nk_rgba_(50, 58, 61, 255);
        LTable[NK_COLOR_CHART_COLOR] := nk_rgba_(48, 83, 111, 255);
        LTable[NK_COLOR_CHART_COLOR_HIGHLIGHT] := nk_rgba_(255, 0, 0, 255);
        LTable[NK_COLOR_SCROLLBAR] := nk_rgba_(50, 58, 61, 255);
        LTable[NK_COLOR_SCROLLBAR_CURSOR] := nk_rgba_(48, 83, 111, 255);
        LTable[NK_COLOR_SCROLLBAR_CURSOR_HOVER] := nk_rgba_(53, 88, 116, 255);
        LTable[NK_COLOR_SCROLLBAR_CURSOR_ACTIVE] := nk_rgba_(58, 93, 121, 255);
        LTable[NK_COLOR_TAB_HEADER] := nk_rgba_(48, 83, 111, 255);
        nk_style_from_table(@FCtx, @LTable);
      end;
  else
    nk_style_default(@FCtx);
  end;
end;

end.
