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

unit GameVision.Color;

{$I GameVision.Defines.inc}

interface

type

  { TGVColor }
  TGVColor = record
    Red,Green,Blue,Alpha: Single;
    function FromByte(aRed: Byte; aGreen: Byte; aBlue: Byte; aAlpha: Byte): TGVColor; overload;
    function FromFloat(aRed: Single; aGreen: Single; aBlue: Single; aAlpha: Single): TGVColor; overload;
    function FromName(const aName: string): TGVColor; overload;
    function Fade(aTo: TGVColor; aPos: Single): TGVColor;
    function Equal(aColor: TGVColor): Boolean;
  end;

  { PGVColor }
  PGVColor = ^TGVColor;

{$REGION 'Common Colors'}
const
  ALICEBLUE           : TGVColor = (Red:$F0/$FF; Green:$F8/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  ANTIQUEWHITE        : TGVColor = (Red:$FA/$FF; Green:$EB/$FF; Blue:$D7/$FF; Alpha:$FF/$FF);
  AQUA                : TGVColor = (Red:$00/$FF; Green:$FF/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  AQUAMARINE          : TGVColor = (Red:$7F/$FF; Green:$FF/$FF; Blue:$D4/$FF; Alpha:$FF/$FF);
  AZURE               : TGVColor = (Red:$F0/$FF; Green:$FF/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  BEIGE               : TGVColor = (Red:$F5/$FF; Green:$F5/$FF; Blue:$DC/$FF; Alpha:$FF/$FF);
  BISQUE              : TGVColor = (Red:$FF/$FF; Green:$E4/$FF; Blue:$C4/$FF; Alpha:$FF/$FF);
  BLACK               : TGVColor = (Red:$00/$FF; Green:$00/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  BLANCHEDALMOND      : TGVColor = (Red:$FF/$FF; Green:$EB/$FF; Blue:$CD/$FF; Alpha:$FF/$FF);
  BLUE                : TGVColor = (Red:$00/$FF; Green:$00/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  BLUEVIOLET          : TGVColor = (Red:$8A/$FF; Green:$2B/$FF; Blue:$E2/$FF; Alpha:$FF/$FF);
  BROWN               : TGVColor = (Red:$A5/$FF; Green:$2A/$FF; Blue:$2A/$FF; Alpha:$FF/$FF);
  BURLYWOOD           : TGVColor = (Red:$DE/$FF; Green:$B8/$FF; Blue:$87/$FF; Alpha:$FF/$FF);
  CADETBLUE           : TGVColor = (Red:$5F/$FF; Green:$9E/$FF; Blue:$A0/$FF; Alpha:$FF/$FF);
  CHARTREUSE          : TGVColor = (Red:$7F/$FF; Green:$FF/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  CHOCOLATE           : TGVColor = (Red:$D2/$FF; Green:$69/$FF; Blue:$1E/$FF; Alpha:$FF/$FF);
  CORAL               : TGVColor = (Red:$FF/$FF; Green:$7F/$FF; Blue:$50/$FF; Alpha:$FF/$FF);
  CORNFLOWERBLUE      : TGVColor = (Red:$64/$FF; Green:$95/$FF; Blue:$ED/$FF; Alpha:$FF/$FF);
  CORNSILK            : TGVColor = (Red:$FF/$FF; Green:$F8/$FF; Blue:$DC/$FF; Alpha:$FF/$FF);
  CRIMSON             : TGVColor = (Red:$DC/$FF; Green:$14/$FF; Blue:$3C/$FF; Alpha:$FF/$FF);
  CYAN                : TGVColor = (Red:$00/$FF; Green:$FF/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  DARKBLUE            : TGVColor = (Red:$00/$FF; Green:$00/$FF; Blue:$8B/$FF; Alpha:$FF/$FF);
  DARKCYAN            : TGVColor = (Red:$00/$FF; Green:$8B/$FF; Blue:$8B/$FF; Alpha:$FF/$FF);
  DARKGOLDENROD       : TGVColor = (Red:$B8/$FF; Green:$86/$FF; Blue:$0B/$FF; Alpha:$FF/$FF);
  DARKGRAY            : TGVColor = (Red:$A9/$FF; Green:$A9/$FF; Blue:$A9/$FF; Alpha:$FF/$FF);
  DARKGREEN           : TGVColor = (Red:$00/$FF; Green:$64/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  DARKGREY            : TGVColor = (Red:$A9/$FF; Green:$A9/$FF; Blue:$A9/$FF; Alpha:$FF/$FF);
  DARKKHAKI           : TGVColor = (Red:$BD/$FF; Green:$B7/$FF; Blue:$6B/$FF; Alpha:$FF/$FF);
  DARKMAGENTA         : TGVColor = (Red:$8B/$FF; Green:$00/$FF; Blue:$8B/$FF; Alpha:$FF/$FF);
  DARKOLIVEGREEN      : TGVColor = (Red:$55/$FF; Green:$6B/$FF; Blue:$2F/$FF; Alpha:$FF/$FF);
  DARKORANGE          : TGVColor = (Red:$FF/$FF; Green:$8C/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  DARKORCHID          : TGVColor = (Red:$99/$FF; Green:$32/$FF; Blue:$CC/$FF; Alpha:$FF/$FF);
  DARKRED             : TGVColor = (Red:$8B/$FF; Green:$00/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  DARKSALMON          : TGVColor = (Red:$E9/$FF; Green:$96/$FF; Blue:$7A/$FF; Alpha:$FF/$FF);
  DARKSEAGREEN        : TGVColor = (Red:$8F/$FF; Green:$BC/$FF; Blue:$8F/$FF; Alpha:$FF/$FF);
  DARKSLATEBLUE       : TGVColor = (Red:$48/$FF; Green:$3D/$FF; Blue:$8B/$FF; Alpha:$FF/$FF);
  DARKSLATEGRAY       : TGVColor = (Red:$2F/$FF; Green:$4F/$FF; Blue:$4F/$FF; Alpha:$FF/$FF);
  DARKSLATEGREY       : TGVColor = (Red:$2F/$FF; Green:$4F/$FF; Blue:$4F/$FF; Alpha:$FF/$FF);
  DARKTURQUOISE       : TGVColor = (Red:$00/$FF; Green:$CE/$FF; Blue:$D1/$FF; Alpha:$FF/$FF);
  DARKVIOLET          : TGVColor = (Red:$94/$FF; Green:$00/$FF; Blue:$D3/$FF; Alpha:$FF/$FF);
  DEEPPINK            : TGVColor = (Red:$FF/$FF; Green:$14/$FF; Blue:$93/$FF; Alpha:$FF/$FF);
  DEEPSKYBLUE         : TGVColor = (Red:$00/$FF; Green:$BF/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  DIMGRAY             : TGVColor = (Red:$69/$FF; Green:$69/$FF; Blue:$69/$FF; Alpha:$FF/$FF);
  DIMGREY             : TGVColor = (Red:$69/$FF; Green:$69/$FF; Blue:$69/$FF; Alpha:$FF/$FF);
  DODGERBLUE          : TGVColor = (Red:$1E/$FF; Green:$90/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  FIREBRICK           : TGVColor = (Red:$B2/$FF; Green:$22/$FF; Blue:$22/$FF; Alpha:$FF/$FF);
  FLORALWHITE         : TGVColor = (Red:$FF/$FF; Green:$FA/$FF; Blue:$F0/$FF; Alpha:$FF/$FF);
  FORESTGREEN         : TGVColor = (Red:$22/$FF; Green:$8B/$FF; Blue:$22/$FF; Alpha:$FF/$FF);
  FUCHSIA             : TGVColor = (Red:$FF/$FF; Green:$00/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  GAINSBORO           : TGVColor = (Red:$DC/$FF; Green:$DC/$FF; Blue:$DC/$FF; Alpha:$FF/$FF);
  GHOSTWHITE          : TGVColor = (Red:$F8/$FF; Green:$F8/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  GOLD                : TGVColor = (Red:$FF/$FF; Green:$D7/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  GOLDENROD           : TGVColor = (Red:$DA/$FF; Green:$A5/$FF; Blue:$20/$FF; Alpha:$FF/$FF);
  GRAY                : TGVColor = (Red:$80/$FF; Green:$80/$FF; Blue:$80/$FF; Alpha:$FF/$FF);
  GREEN               : TGVColor = (Red:$00/$FF; Green:$80/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  GREENYELLOW         : TGVColor = (Red:$AD/$FF; Green:$FF/$FF; Blue:$2F/$FF; Alpha:$FF/$FF);
  GREY                : TGVColor = (Red:$80/$FF; Green:$80/$FF; Blue:$80/$FF; Alpha:$FF/$FF);
  HONEYDEW            : TGVColor = (Red:$F0/$FF; Green:$FF/$FF; Blue:$F0/$FF; Alpha:$FF/$FF);
  HOTPINK             : TGVColor = (Red:$FF/$FF; Green:$69/$FF; Blue:$B4/$FF; Alpha:$FF/$FF);
  INDIANRED           : TGVColor = (Red:$CD/$FF; Green:$5C/$FF; Blue:$5C/$FF; Alpha:$FF/$FF);
  INDIGO              : TGVColor = (Red:$4B/$FF; Green:$00/$FF; Blue:$82/$FF; Alpha:$FF/$FF);
  IVORY               : TGVColor = (Red:$FF/$FF; Green:$FF/$FF; Blue:$F0/$FF; Alpha:$FF/$FF);
  KHAKI               : TGVColor = (Red:$F0/$FF; Green:$E6/$FF; Blue:$8C/$FF; Alpha:$FF/$FF);
  LAVENDER            : TGVColor = (Red:$E6/$FF; Green:$E6/$FF; Blue:$FA/$FF; Alpha:$FF/$FF);
  LAVENDERBLUSH       : TGVColor = (Red:$FF/$FF; Green:$F0/$FF; Blue:$F5/$FF; Alpha:$FF/$FF);
  LAWNGREEN           : TGVColor = (Red:$7C/$FF; Green:$FC/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  LEMONCHIFFON        : TGVColor = (Red:$FF/$FF; Green:$FA/$FF; Blue:$CD/$FF; Alpha:$FF/$FF);
  LIGHTBLUE           : TGVColor = (Red:$AD/$FF; Green:$D8/$FF; Blue:$E6/$FF; Alpha:$FF/$FF);
  LIGHTCORAL          : TGVColor = (Red:$F0/$FF; Green:$80/$FF; Blue:$80/$FF; Alpha:$FF/$FF);
  LIGHTCYAN           : TGVColor = (Red:$E0/$FF; Green:$FF/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  LIGHTGOLDENRODYELLOW: TGVColor = (Red:$FA/$FF; Green:$FA/$FF; Blue:$D2/$FF; Alpha:$FF/$FF);
  LIGHTGRAY           : TGVColor = (Red:$D3/$FF; Green:$D3/$FF; Blue:$D3/$FF; Alpha:$FF/$FF);
  LIGHTGREEN          : TGVColor = (Red:$90/$FF; Green:$EE/$FF; Blue:$90/$FF; Alpha:$FF/$FF);
  LIGHTGREY           : TGVColor = (Red:$D3/$FF; Green:$D3/$FF; Blue:$D3/$FF; Alpha:$FF/$FF);
  LIGHTPINK           : TGVColor = (Red:$FF/$FF; Green:$B6/$FF; Blue:$C1/$FF; Alpha:$FF/$FF);
  LIGHTSALMON         : TGVColor = (Red:$FF/$FF; Green:$A0/$FF; Blue:$7A/$FF; Alpha:$FF/$FF);
  LIGHTSEAGREEN       : TGVColor = (Red:$20/$FF; Green:$B2/$FF; Blue:$AA/$FF; Alpha:$FF/$FF);
  LIGHTSKYBLUE        : TGVColor = (Red:$87/$FF; Green:$CE/$FF; Blue:$FA/$FF; Alpha:$FF/$FF);
  LIGHTSLATEGRAY      : TGVColor = (Red:$77/$FF; Green:$88/$FF; Blue:$99/$FF; Alpha:$FF/$FF);
  LIGHTSLATEGREY      : TGVColor = (Red:$77/$FF; Green:$88/$FF; Blue:$99/$FF; Alpha:$FF/$FF);
  LIGHTSTEELBLUE      : TGVColor = (Red:$B0/$FF; Green:$C4/$FF; Blue:$DE/$FF; Alpha:$FF/$FF);
  LIGHTYELLOW         : TGVColor = (Red:$FF/$FF; Green:$FF/$FF; Blue:$E0/$FF; Alpha:$FF/$FF);
  LIME                : TGVColor = (Red:$00/$FF; Green:$FF/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  LIMEGREEN           : TGVColor = (Red:$32/$FF; Green:$CD/$FF; Blue:$32/$FF; Alpha:$FF/$FF);
  LINEN               : TGVColor = (Red:$FA/$FF; Green:$F0/$FF; Blue:$E6/$FF; Alpha:$FF/$FF);
  MAGENTA             : TGVColor = (Red:$FF/$FF; Green:$00/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  MAROON              : TGVColor = (Red:$80/$FF; Green:$00/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  MEDIUMAQUAMARINE    : TGVColor = (Red:$66/$FF; Green:$CD/$FF; Blue:$AA/$FF; Alpha:$FF/$FF);
  MEDIUMBLUE          : TGVColor = (Red:$00/$FF; Green:$00/$FF; Blue:$CD/$FF; Alpha:$FF/$FF);
  MEDIUMORCHID        : TGVColor = (Red:$BA/$FF; Green:$55/$FF; Blue:$D3/$FF; Alpha:$FF/$FF);
  MEDIUMPURPLE        : TGVColor = (Red:$93/$FF; Green:$70/$FF; Blue:$DB/$FF; Alpha:$FF/$FF);
  MEDIUMSEAGREEN      : TGVColor = (Red:$3C/$FF; Green:$B3/$FF; Blue:$71/$FF; Alpha:$FF/$FF);
  MEDIUMSLATEBLUE     : TGVColor = (Red:$7B/$FF; Green:$68/$FF; Blue:$EE/$FF; Alpha:$FF/$FF);
  MEDIUMSPRINGGREEN   : TGVColor = (Red:$00/$FF; Green:$FA/$FF; Blue:$9A/$FF; Alpha:$FF/$FF);
  MEDIUMTURQUOISE     : TGVColor = (Red:$48/$FF; Green:$D1/$FF; Blue:$CC/$FF; Alpha:$FF/$FF);
  MEDIUMVIOLETRED     : TGVColor = (Red:$C7/$FF; Green:$15/$FF; Blue:$85/$FF; Alpha:$FF/$FF);
  MIDNIGHTBLUE        : TGVColor = (Red:$19/$FF; Green:$19/$FF; Blue:$70/$FF; Alpha:$FF/$FF);
  MINTCREAM           : TGVColor = (Red:$F5/$FF; Green:$FF/$FF; Blue:$FA/$FF; Alpha:$FF/$FF);
  MISTYROSE           : TGVColor = (Red:$FF/$FF; Green:$E4/$FF; Blue:$E1/$FF; Alpha:$FF/$FF);
  MOCCASIN            : TGVColor = (Red:$FF/$FF; Green:$E4/$FF; Blue:$B5/$FF; Alpha:$FF/$FF);
  NAVAJOWHITE         : TGVColor = (Red:$FF/$FF; Green:$DE/$FF; Blue:$AD/$FF; Alpha:$FF/$FF);
  NAVY                : TGVColor = (Red:$00/$FF; Green:$00/$FF; Blue:$80/$FF; Alpha:$FF/$FF);
  OLDLACE             : TGVColor = (Red:$FD/$FF; Green:$F5/$FF; Blue:$E6/$FF; Alpha:$FF/$FF);
  OLIVE               : TGVColor = (Red:$80/$FF; Green:$80/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  OLIVEDRAB           : TGVColor = (Red:$6B/$FF; Green:$8E/$FF; Blue:$23/$FF; Alpha:$FF/$FF);
  ORANGE              : TGVColor = (Red:$FF/$FF; Green:$A5/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  ORANGERED           : TGVColor = (Red:$FF/$FF; Green:$45/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  ORCHID              : TGVColor = (Red:$DA/$FF; Green:$70/$FF; Blue:$D6/$FF; Alpha:$FF/$FF);
  PALEGOLDENROD       : TGVColor = (Red:$EE/$FF; Green:$E8/$FF; Blue:$AA/$FF; Alpha:$FF/$FF);
  PALEGREEN           : TGVColor = (Red:$98/$FF; Green:$FB/$FF; Blue:$98/$FF; Alpha:$FF/$FF);
  PALETURQUOISE       : TGVColor = (Red:$AF/$FF; Green:$EE/$FF; Blue:$EE/$FF; Alpha:$FF/$FF);
  PALEVIOLETRED       : TGVColor = (Red:$DB/$FF; Green:$70/$FF; Blue:$93/$FF; Alpha:$FF/$FF);
  PAPAYAWHIP          : TGVColor = (Red:$FF/$FF; Green:$EF/$FF; Blue:$D5/$FF; Alpha:$FF/$FF);
  PEACHPUFF           : TGVColor = (Red:$FF/$FF; Green:$DA/$FF; Blue:$B9/$FF; Alpha:$FF/$FF);
  PERU                : TGVColor = (Red:$CD/$FF; Green:$85/$FF; Blue:$3F/$FF; Alpha:$FF/$FF);
  PINK                : TGVColor = (Red:$FF/$FF; Green:$C0/$FF; Blue:$CB/$FF; Alpha:$FF/$FF);
  PLUM                : TGVColor = (Red:$DD/$FF; Green:$A0/$FF; Blue:$DD/$FF; Alpha:$FF/$FF);
  POWDERBLUE          : TGVColor = (Red:$B0/$FF; Green:$E0/$FF; Blue:$E6/$FF; Alpha:$FF/$FF);
  PURPLE              : TGVColor = (Red:$80/$FF; Green:$00/$FF; Blue:$80/$FF; Alpha:$FF/$FF);
  REBECCAPURPLE       : TGVColor = (Red:$66/$FF; Green:$33/$FF; Blue:$99/$FF; Alpha:$FF/$FF);
  RED                 : TGVColor = (Red:$FF/$FF; Green:$00/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  ROSYBROWN           : TGVColor = (Red:$BC/$FF; Green:$8F/$FF; Blue:$8F/$FF; Alpha:$FF/$FF);
  ROYALBLUE           : TGVColor = (Red:$41/$FF; Green:$69/$FF; Blue:$E1/$FF; Alpha:$FF/$FF);
  SADDLEBROWN         : TGVColor = (Red:$8B/$FF; Green:$45/$FF; Blue:$13/$FF; Alpha:$FF/$FF);
  SALMON              : TGVColor = (Red:$FA/$FF; Green:$80/$FF; Blue:$72/$FF; Alpha:$FF/$FF);
  SANDYBROWN          : TGVColor = (Red:$F4/$FF; Green:$A4/$FF; Blue:$60/$FF; Alpha:$FF/$FF);
  SEAGREEN            : TGVColor = (Red:$2E/$FF; Green:$8B/$FF; Blue:$57/$FF; Alpha:$FF/$FF);
  SEASHELL            : TGVColor = (Red:$FF/$FF; Green:$F5/$FF; Blue:$EE/$FF; Alpha:$FF/$FF);
  SIENNA              : TGVColor = (Red:$A0/$FF; Green:$52/$FF; Blue:$2D/$FF; Alpha:$FF/$FF);
  SILVER              : TGVColor = (Red:$C0/$FF; Green:$C0/$FF; Blue:$C0/$FF; Alpha:$FF/$FF);
  SKYBLUE             : TGVColor = (Red:$87/$FF; Green:$CE/$FF; Blue:$EB/$FF; Alpha:$FF/$FF);
  SLATEBLUE           : TGVColor = (Red:$6A/$FF; Green:$5A/$FF; Blue:$CD/$FF; Alpha:$FF/$FF);
  SLATEGRAY           : TGVColor = (Red:$70/$FF; Green:$80/$FF; Blue:$90/$FF; Alpha:$FF/$FF);
  SLATEGREY           : TGVColor = (Red:$70/$FF; Green:$80/$FF; Blue:$90/$FF; Alpha:$FF/$FF);
  SNOW                : TGVColor = (Red:$FF/$FF; Green:$FA/$FF; Blue:$FA/$FF; Alpha:$FF/$FF);
  SPRINGGREEN         : TGVColor = (Red:$00/$FF; Green:$FF/$FF; Blue:$7F/$FF; Alpha:$FF/$FF);
  STEELBLUE           : TGVColor = (Red:$46/$FF; Green:$82/$FF; Blue:$B4/$FF; Alpha:$FF/$FF);
  TAN                 : TGVColor = (Red:$D2/$FF; Green:$B4/$FF; Blue:$8C/$FF; Alpha:$FF/$FF);
  TEAL                : TGVColor = (Red:$00/$FF; Green:$80/$FF; Blue:$80/$FF; Alpha:$FF/$FF);
  THISTLE             : TGVColor = (Red:$D8/$FF; Green:$BF/$FF; Blue:$D8/$FF; Alpha:$FF/$FF);
  TOMATO              : TGVColor = (Red:$FF/$FF; Green:$63/$FF; Blue:$47/$FF; Alpha:$FF/$FF);
  TURQUOISE           : TGVColor = (Red:$40/$FF; Green:$E0/$FF; Blue:$D0/$FF; Alpha:$FF/$FF);
  VIOLET              : TGVColor = (Red:$EE/$FF; Green:$82/$FF; Blue:$EE/$FF; Alpha:$FF/$FF);
  WHEAT               : TGVColor = (Red:$F5/$FF; Green:$DE/$FF; Blue:$B3/$FF; Alpha:$FF/$FF);
  WHITE               : TGVColor = (Red:$FF/$FF; Green:$FF/$FF; Blue:$FF/$FF; Alpha:$FF/$FF);
  WHITESMOKE          : TGVColor = (Red:$F5/$FF; Green:$F5/$FF; Blue:$F5/$FF; Alpha:$FF/$FF);
  YELLOW              : TGVColor = (Red:$FF/$FF; Green:$FF/$FF; Blue:$00/$FF; Alpha:$FF/$FF);
  YELLOWGREEN         : TGVColor = (Red:$9A/$FF; Green:$CD/$FF; Blue:$32/$FF; Alpha:$FF/$FF);
  BLANK               : TGVColor = (Red:$00;     Green:$00;     Blue:$00;     Alpha:$00);
  WHITE2              : TGVColor = (Red:$F5/$FF; Green:$F5/$FF; Blue:$F5/$FF; Alpha:$FF/$FF);
  RED22               : TGVColor = (Red:$7E/$FF; Green:$32/$FF; Blue:$3F/$FF; Alpha:255/$FF);
  COLORKEY            : TGVColor = (Red:$FF/$FF; Green:$00;     Blue:$FF/$FF; Alpha:$FF/$FF);
  OVERLAY1            : TGVColor = (Red:$00/$FF; Green:$20/$FF; Blue:$29/$FF; Alpha:$B4/$FF);
  OVERLAY2            : TGVColor = (Red:$01/$FF; Green:$1B/$FF; Blue:$01/$FF; Alpha:255/$FF);
  DIMWHITE            : TGVColor = (Red:$10/$FF; Green:$10/$FF; Blue:$10/$FF; Alpha:$10/$FF);
  DARKSLATEBROWN      : TGVColor = (Red:30/255; Green:31/255; Blue:30/255; Alpha:1);
{$ENDREGION}

implementation

uses
  System.SysUtils,
  GameVision.Allegro;

{ TGVColor }
function TGVColor.FromByte(aRed: Byte; aGreen: Byte; aBlue: Byte; aAlpha: Byte): TGVColor;
var
  LColor: ALLEGRO_COLOR;
begin
  LColor := al_map_rgba(aRed, aGreen, aBlue, aAlpha);
  Red := LColor.r;
  Green := LColor.g;
  Blue := LColor.b;
  Alpha := LColor.a;
  Result := Self;
end;

function TGVColor.FromFloat(aRed: Single; aGreen: Single; aBlue: Single; aAlpha: Single): TGVColor;
var
  LColor: ALLEGRO_COLOR;
begin
  LColor := al_map_rgba_f(aRed, aGreen, aBlue, aAlpha);
  Red := LColor.r;
  Green := LColor.g;
  Blue := LColor.b;
  Alpha := LColor.a;
  Result := Self;
end;

function TGVColor.FromName(const aName: string): TGVColor;
var
  LMarshaller: TMarshaller;
  LColor: ALLEGRO_COLOR absolute Result;
begin
  LColor := al_color_name(LMarshaller.AsAnsi(aName).ToPointer);
  Red := LColor.r;
  Green := LColor.g;
  Blue := LColor.b;
  Alpha := LColor.a;
  Result := Self;
end;

function TGVColor.Fade(aTo: TGVColor; aPos: Single): TGVColor;
var
  LColor: TGVColor;
begin
  // clip to ranage 0.0 - 1.0
  if aPos < 0 then
    aPos := 0
  else if aPos > 1.0 then
    aPos := 1.0;

  // fade colors
  LColor.Alpha := Alpha + ((aTo.Alpha - Alpha) * aPos);
  LColor.Blue := Blue + ((aTo.Blue - Blue) * aPos);
  LColor.Green := Green + ((aTo.Green - Green) * aPos);
  LColor.Red := Red + ((aTo.Red - Red) * aPos);
  Result := FromFloat(LColor.Red, LColor.Green, LColor.Blue, LColor.Alpha);
end;

function TGVColor.Equal(aColor: TGVColor): Boolean;
begin
  if (Red = aColor.Red) and (Green = aColor.Green) and
    (Blue = aColor.Blue) and (Alpha = aColor.Alpha) then
    Result := True
  else
    Result := False;
end;

end.
