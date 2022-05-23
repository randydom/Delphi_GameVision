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

unit GameVision.Input;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Base,
  GameVision.Math;

const
  MAX_AXES = 3;
  MAX_STICKS = 16;
  MAX_BUTTONS = 32;

  MOUSE_BUTTON_LEFT = 1;
  MOUSE_BUTTON_RIGHT = 2;
  MOUSE_BUTTON_MIDDLE = 3;

{$REGION 'Keyboard Constants'}
const
  KEY_A = 1;
  KEY_B = 2;
  KEY_C = 3;
  KEY_D = 4;
  KEY_E = 5;
  KEY_F = 6;
  KEY_G = 7;
  KEY_H = 8;
  KEY_I = 9;
  KEY_J = 10;
  KEY_K = 11;
  KEY_L = 12;
  KEY_M = 13;
  KEY_N = 14;
  KEY_O = 15;
  KEY_P = 16;
  KEY_Q = 17;
  KEY_R = 18;
  KEY_S = 19;
  KEY_T = 20;
  KEY_U = 21;
  KEY_V = 22;
  KEY_W = 23;
  KEY_X = 24;
  KEY_Y = 25;
  KEY_Z = 26;
  KEY_0 = 27;
  KEY_1 = 28;
  KEY_2 = 29;
  KEY_3 = 30;
  KEY_4 = 31;
  KEY_5 = 32;
  KEY_6 = 33;
  KEY_7 = 34;
  KEY_8 = 35;
  KEY_9 = 36;
  KEY_PAD_0 = 37;
  KEY_PAD_1 = 38;
  KEY_PAD_2 = 39;
  KEY_PAD_3 = 40;
  KEY_PAD_4 = 41;
  KEY_PAD_5 = 42;
  KEY_PAD_6 = 43;
  KEY_PAD_7 = 44;
  KEY_PAD_8 = 45;
  KEY_PAD_9 = 46;
  KEY_F1 = 47;
  KEY_F2 = 48;
  KEY_F3 = 49;
  KEY_F4 = 50;
  KEY_F5 = 51;
  KEY_F6 = 52;
  KEY_F7 = 53;
  KEY_F8 = 54;
  KEY_F9 = 55;
  KEY_F10 = 56;
  KEY_F11 = 57;
  KEY_F12 = 58;
  KEY_ESCAPE = 59;
  KEY_TILDE = 60;
  KEY_MINUS = 61;
  KEY_EQUALS = 62;
  KEY_BACKSPACE = 63;
  KEY_TAB = 64;
  KEY_OPENBRACE = 65;
  KEY_CLOSEBRACE = 66;
  KEY_ENTER = 67;
  KEY_SEMICOLON = 68;
  KEY_QUOTE = 69;
  KEY_BACKSLASH = 70;
  KEY_BACKSLASH2 = 71;
  KEY_COMMA = 72;
  KEY_FULLSTOP = 73;
  KEY_SLASH = 74;
  KEY_SPACE = 75;
  KEY_INSERT = 76;
  KEY_DELETE = 77;
  KEY_HOME = 78;
  KEY_END = 79;
  KEY_PGUP = 80;
  KEY_PGDN = 81;
  KEY_LEFT = 82;
  KEY_RIGHT = 83;
  KEY_UP = 84;
  KEY_DOWN = 85;
  KEY_PAD_SLASH = 86;
  KEY_PAD_ASTERISK = 87;
  KEY_PAD_MINUS = 88;
  KEY_PAD_PLUS = 89;
  KEY_PAD_DELETE = 90;
  KEY_PAD_ENTER = 91;
  KEY_PRINTSCREEN = 92;
  KEY_PAUSE = 93;
  KEY_ABNT_C1 = 94;
  KEY_YEN = 95;
  KEY_KANA = 96;
  KEY_CONVERT = 97;
  KEY_NOCONVERT = 98;
  KEY_AT = 99;
  KEY_CIRCUMFLEX = 100;
  KEY_COLON2 = 101;
  KEY_KANJI = 102;
  KEY_PAD_EQUALS = 103;
  KEY_BACKQUOTE = 104;
  KEY_SEMICOLON2 = 105;
  KEY_COMMAND = 106;
  KEY_BACK = 107;
  KEY_VOLUME_UP = 108;
  KEY_VOLUME_DOWN = 109;
  KEY_SEARCH = 110;
  KEY_DPAD_CENTER = 111;
  KEY_BUTTON_X = 112;
  KEY_BUTTON_Y = 113;
  KEY_DPAD_UP = 114;
  KEY_DPAD_DOWN = 115;
  KEY_DPAD_LEFT = 116;
  KEY_DPAD_RIGHT = 117;
  KEY_SELECT = 118;
  KEY_START = 119;
  KEY_BUTTON_L1 = 120;
  KEY_BUTTON_R1 = 121;
  KEY_BUTTON_L2 = 122;
  KEY_BUTTON_R2 = 123;
  KEY_BUTTON_A = 124;
  KEY_BUTTON_B = 125;
  KEY_THUMBL = 126;
  KEY_THUMBR = 127;
  KEY_UNKNOWN = 128;
  KEY_MODIFIERS = 215;
  KEY_LSHIFT = 215;
  KEY_RSHIFT = 216;
  KEY_LCTRL = 217;
  KEY_RCTRL = 218;
  KEY_ALT = 219;
  KEY_ALTGR = 220;
  KEY_LWIN = 221;
  KEY_RWIN = 222;
  KEY_MENU = 223;
  KEY_SCROLLLOCK = 224;
  KEY_NUMLOCK = 225;
  KEY_CAPSLOCK = 226;
  KEY_MAX = 227;
  KEYMOD_SHIFT = $0001;
  KEYMOD_CTRL = $0002;
  KEYMOD_ALT = $0004;
  KEYMOD_LWIN = $0008;
  KEYMOD_RWIN = $0010;
  KEYMOD_MENU = $0020;
  KEYMOD_COMMAND = $0040;
  KEYMOD_SCROLOCK = $0100;
  KEYMOD_NUMLOCK = $0200;
  KEYMOD_CAPSLOCK = $0400;
  KEYMOD_INALTSEQ = $0800;
  KEYMOD_ACCENT1 = $1000;
  KEYMOD_ACCENT2 = $2000;
  KEYMOD_ACCENT3 = $4000;
  KEYMOD_ACCENT4 = $8000;
{$ENDREGION}

  // sticks
  JOY_STICK_LS = 0;
  JOY_STICK_RS = 1;
  JOY_STICK_LT = 2;
  JOY_STICK_RT = 3;

  // axes
  JOY_AXES_X = 0;
  JOY_AXES_Y = 1;
  JOY_AXES_Z = 2;

  // buttons
  JOY_BTN_A = 0;
  JOY_BTN_B = 1;
  JOY_BTN_X = 2;
  JOY_BTN_Y = 3;
  JOY_BTN_RB = 4;
  JOY_BTN_LB = 5;
  JOY_BTN_RT = 6;
  JOY_BTN_LT = 7;
  JOY_BTN_BACK = 8;
  JOY_BTN_START = 9;
  JOY_BTN_RDPAD = 10;
  JOY_BTN_LDPAD = 11;
  JOY_BTN_DDPAD = 12;
  JOY_BTN_UDPAD = 13;

type
  { TGVJoystick }
  TGVJoystick = record
    Name: string;
    Sticks: Integer;
    Buttons: Integer;
    StickName: array[0..MAX_STICKS-1] of string;
    Axes: array[0..MAX_STICKS-1] of Integer;
    AxesName: array[0..MAX_STICKS-1, 0..MAX_AXES-1] of string;
    Pos: array[0..MAX_STICKS-1, 0..MAX_AXES-1] of Single;
    Button: array[0..1, 0..MAX_BUTTONS-1] of Boolean;
    ButtonName: array[0..MAX_BUTTONS- 1] of string;
    procedure Setup(aNum: Integer);
    function GetPos(aStick: Integer; aAxes: Integer): Single;
    function GetButton(aButton: Integer): Boolean;
    procedure Clear;
  end;

  { TGVInput }
  TGVInput = class(TGVObject)
  protected
    FKeyCode: Integer;
    FKeyCodeRepeat: Boolean;
    FMouseButtons: array [0..1, 0..256] of Boolean;
    FKeyButtons: array [0..1, 0..256] of Boolean;
    FJoyStick: TGVJoystick;
    FMouse: record
      Postion: TGVVector;
      Delta: TGVVector;
      Pressure: Single;
    end;
  public
    property KeyCode: Integer read FKeyCode;
    property KeyCodeRepeat: Boolean read FKeyCodeRepeat;
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear;
    procedure Update;
    function  KeyDown(aKey: Cardinal): Boolean;
    function  KeyPressed(aKey: Cardinal): Boolean;
    function  KeyReleased(aKey: Cardinal): Boolean;

    function  MouseDown(aButton: Cardinal): Boolean;
    function  MousePressed(aButton: Cardinal): Boolean;
    function  MouseReleased(aButton: Cardinal): Boolean;
    procedure MouseSetPos(aX: Integer; aY: Integer);
    procedure GetMouseInfo(aPosition: PGVVector; aDelta: PGVVector; aPressure: System.PSingle);

    function  JoystickDown(aButton: Cardinal): Boolean;
    function  JoystickPressed(aButton: Cardinal): Boolean;
    function  JoystickReleased(aButton: Cardinal): Boolean;
    function  JoystickPosition(aStick: Integer; aAxes: Integer): Single;
  end;

implementation

uses
  System.Math,
  GameVision.Allegro,
  GameVision.Core;

{ TGVJoystick }
procedure TGVJoystick.Setup(aNum: Integer);
var
  LJoyCount: Integer;
  LJoy: PALLEGRO_JOYSTICK;
  LJoyState: ALLEGRO_JOYSTICK_STATE;
  LI, LJ: Integer;
begin
  LJoyCount := al_get_num_joysticks;
  if (aNum < 0) or (aNum > LJoyCount - 1) then
    Exit;

  LJoy := al_get_joystick(aNum);
  if LJoy = nil then
  begin
    Sticks := 0;
    Buttons := 0;
    Exit;
  end;

  Name := string(al_get_joystick_name(LJoy));

  al_get_joystick_state(LJoy, @LJoyState);

  Sticks := al_get_joystick_num_sticks(LJoy);
  if (Sticks > MAX_STICKS) then
    Sticks := MAX_STICKS;

  for LI := 0 to Sticks - 1 do
  begin
    StickName[LI] := string(al_get_joystick_stick_name(LJoy, LI));
    Axes[LI] := al_get_joystick_num_axes(LJoy, LI);
    for LJ := 0 to Axes[LI] - 1 do
    begin
      Pos[LI, LJ] := LJoyState.stick[LI].axis[LJ];
      AxesName[LI, LJ] := string(al_get_joystick_axis_name(LJoy, LI, LJ));
    end;
  end;

  Buttons := al_get_joystick_num_buttons(LJoy);
  if (Buttons > MAX_BUTTONS) then
    Buttons := MAX_BUTTONS;

  for LI := 0 to Buttons - 1 do
  begin
    ButtonName[LI] := string(al_get_joystick_button_name(LJoy, LI));
    Button[0, LI] := Boolean(LJoyState.Button[LI] >= 16384);
  end
end;

function TGVJoystick.GetPos(aStick: Integer; aAxes: Integer): Single;
begin
  Result := Pos[aStick, aAxes];
end;

function TGVJoystick.GetButton(aButton: Integer): Boolean;
begin
  Result := Button[0, aButton];
end;

procedure TGVJoystick.Clear;
begin
  FillChar(Button, SizeOf(Button), False);
  FillChar(Pos, SizeOf(Pos), 0);
end;

{ TGVInput }
constructor TGVInput.Create;
begin
  inherited;
  Clear;
  FJoystick.Setup(0);
end;

destructor TGVInput.Destroy;
begin
  inherited;
end;

procedure TGVInput.Clear;
begin
  FillChar(FMouseButtons, SizeOf(FMouseButtons), False);
  FillChar(FKeyButtons, SizeOf(FKeyButtons), False);
  FJoystick.Clear;

  if GV.Window.Handle <> nil then
  begin
    al_clear_keyboard_state(GV.Window.Handle);
  end;
end;

procedure TGVInput.Update;
begin
  FKeyCode := 0;

  case GV.Event.type_ of
    ALLEGRO_EVENT_KEY_CHAR:
    begin
      FKeyCode := GV.Event.keyboard.unichar;
      FKeyCodeRepeat := GV.Event.keyboard.repeat_;
    end;

    ALLEGRO_EVENT_JOYSTICK_AXIS:
    begin
      if (GV.Event.Joystick.stick < MAX_STICKS) and
        (GV.Event.Joystick.axis < MAX_AXES) then
      begin
        FJoystick.Pos[GV.Event.Joystick.stick][GV.Event.Joystick.axis] :=
          GV.Event.Joystick.Pos;
      end;
    end;

    ALLEGRO_EVENT_KEY_DOWN:
    begin
      FKeyButtons[0, GV.Event.keyboard.keycode] := True;
    end;

    ALLEGRO_EVENT_KEY_UP:
    begin
      FKeyButtons[0, GV.Event.keyboard.keycode] := False;
    end;

    ALLEGRO_EVENT_MOUSE_BUTTON_DOWN:
    begin
      FMouseButtons[0, GV.Event.mouse.button] := True;
    end;

    ALLEGRO_EVENT_MOUSE_BUTTON_UP:
    begin
      FMouseButtons[0, GV.Event.mouse.button] := False;
    end;

    ALLEGRO_EVENT_MOUSE_AXES:
    begin
      FMouse.Postion.X := Round(GV.Event.mouse.x / GV.Window.Scale);
      FMouse.Postion.Y := Round(GV.Event.mouse.y / GV.Window.Scale);
      FMouse.Postion.Z := GV.Event.mouse.z;
      FMouse.Postion.W := GV.Event.mouse.w;

      FMouse.Delta.X := GV.Event.mouse.dx;
      FMouse.Delta.Y := GV.Event.mouse.dy;
      FMouse.Delta.Z := GV.Event.mouse.dz;
      FMouse.Delta.W := GV.Event.mouse.dw;

      FMouse.Pressure := GV.Event.mouse.pressure;
    end;

    ALLEGRO_EVENT_JOYSTICK_BUTTON_DOWN:
    begin
      FJoystick.Button[0, GV.Event.Joystick.Button] := True;
    end;

    ALLEGRO_EVENT_JOYSTICK_BUTTON_UP:
    begin
      FJoystick.Button[0, GV.Event.Joystick.Button] := False;
    end;

    ALLEGRO_EVENT_JOYSTICK_CONFIGURATION:
    begin
      al_reconfigure_joysticks;
      FJoystick.Setup(0);
    end;
  end;
end;

function TGVInput.KeyDown(aKey: Cardinal): Boolean;
begin
  Result := False;
  if not InRange(aKey, 0, 255) then  Exit;
  Result := FKeyButtons[0, aKey];
end;

function TGVInput.KeyPressed(aKey: Cardinal): Boolean;
begin
  Result := False;
  if not InRange(aKey, 0, 255) then  Exit;
  if KeyDown(aKey) and (not FKeyButtons[1, aKey]) then
  begin
    FKeyButtons[1, aKey] := True;
    Result := True;
  end
  else if (not KeyDown(aKey)) and (FKeyButtons[1, aKey]) then
  begin
    FKeyButtons[1, aKey] := False;
    Result := False;
  end;
end;

function TGVInput.KeyReleased(aKey: Cardinal): Boolean;
begin
  Result := False;
  if not InRange(aKey, 0, 255) then Exit;
  if KeyDown(aKey) and (not FKeyButtons[1, aKey]) then
  begin
    FKeyButtons[1, aKey] := True;
    Result := False;
  end
  else if (not KeyDown(aKey)) and (FKeyButtons[1, aKey]) then
  begin
    FKeyButtons[1, aKey] := False;
    Result := True;
  end;
end;

function TGVInput.MouseDown(aButton: Cardinal): Boolean;
begin
  Result := False;
  if not InRange(aButton, MOUSE_BUTTON_LEFT, MOUSE_BUTTON_MIDDLE) then Exit;
  Result := FMouseButtons[0, aButton];
end;

function TGVInput.MousePressed(aButton: Cardinal): Boolean;
begin
  Result := False;
  if not InRange(aButton, MOUSE_BUTTON_LEFT, MOUSE_BUTTON_MIDDLE) then Exit;

  if MouseDown(aButton) and (not FMouseButtons[1, aButton]) then
  begin
    FMouseButtons[1, aButton] := True;
    Result := True;
  end
  else if (not MouseDown(aButton)) and (FMouseButtons[1, aButton]) then
  begin
    FMouseButtons[1, aButton] := False;
    Result := False;
  end;
end;

function TGVInput.MouseReleased(aButton: Cardinal): Boolean;
begin
  Result := False;
  if not InRange(aButton, MOUSE_BUTTON_LEFT, MOUSE_BUTTON_MIDDLE) then Exit;

  if MouseDown(aButton) and (not FMouseButtons[1, aButton]) then
  begin
    FMouseButtons[1, aButton] := True;
    Result := False;
  end
  else if (not MouseDown(aButton)) and (FMouseButtons[1, aButton]) then
  begin
    FMouseButtons[1, aButton] := False;
    Result := True;
  end;
end;

procedure TGVInput.MouseSetPos(aX: Integer; aY: Integer);
var
  LX, LY: Integer;
begin
  LX := Round(aX * GV.Window.Scale);
  LY := Round(aY * GV.Window.Scale);
  al_set_mouse_xy(GV.Window.Handle, LX, LY);
end;

procedure TGVInput.GetMouseInfo(aPosition: PGVVector; aDelta: PGVVector; aPressure: System.PSingle);
begin
  if aPosition <> nil then
    aPosition^ := FMouse.Postion;
  if aDelta <> nil then
    aDelta^ := FMouse.Delta;
  if aPressure <> nil then
    aPressure^ := FMouse.Pressure;
end;

function TGVInput.JoystickDown(aButton: Cardinal): Boolean;
begin
  Result := False;
  if not InRange(aButton, 0, MAX_BUTTONS-1) then Exit;
  Result := FJoystick.Button[0, aButton];
end;

function TGVInput.JoystickPressed(aButton: Cardinal): Boolean;
begin
  Result := False;
  if not InRange(aButton, 0, MAX_BUTTONS-1) then Exit;

  if JoystickDown(aButton) and (not FJoystick.Button[1, aButton]) then
  begin
    FJoystick.Button[1, aButton] := True;
    Result := True;
  end
  else if (not JoystickDown(aButton)) and (FJoystick.Button[1, aButton]) then
  begin
    FJoystick.Button[1, aButton] := False;
    Result := False;
  end;
end;

function TGVInput.JoystickReleased(aButton: Cardinal): Boolean;
begin
  Result := False;
  if not InRange(aButton, 0, MAX_BUTTONS-1) then Exit;

  if JoystickDown(aButton) and (not FJoystick.Button[1, aButton]) then
  begin
    FJoystick.Button[1, aButton] := True;
    Result := False;
  end
  else if (not JoystickDown(aButton)) and (FJoystick.Button[1, aButton]) then
  begin
    FJoystick.Button[1, aButton] := False;
    Result := True;
  end;
end;

function  TGVInput.JoystickPosition(aStick: Integer; aAxes: Integer): Single;
begin
  Result := 0;
  if not InRange(aStick, 0, MAX_STICKS-1) then Exit;
  if not InRange(aAxes, 0, MAX_AXES-1) then Exit;
  Result := FJoystick.Pos[aStick, aAxes];
end;

end.
