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

(*
  This is a game template you can use in your projects as a starting point.

  1. Add GameVision.GameTemplate unit to your project
  2. Save-as a new unit name
  3. Place cursor on TGVGameTemplate and press Shft+Ctrl+E to rename
  4. Update { TGVGameTemplate } throughout to your liking
  5. Enjoy
  --------------------------------------------------------------------------
  In GameVision you have a these OnXXX callback methods that you can
  override to add functionaliy to your game. The minimum methods that you
  must override include:
    OnSetSettings - set game settings
    OnStartup     - run game startup code
    OnShutdown    - run game shutdown code
    OnUpdateFrame - run game update code
    OnRenderFrame - run game rendering code
    OnRenderHUD   - run game hud rendering code
*)

unit uAudioPositional;

interface

uses
  System.SysUtils,
  GameVision.Color,
  GameVision.Math,
  GameVision.Core,
  GameVision.Game,
  uCommon;

type
  { TAudioPositional }
  TAudioPositional = class(TBaseExample)
  protected
    FSfx: Integer;
    FChan: Integer;
    FCenterPos: TGVVector;
  public
    procedure OnSetSettings(var aSettings: TGVGameSettings); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdateFrame(aDeltaTime: Double); override;
    procedure OnRenderFrame; override;
  end;

implementation

{ TAudioPositional }
procedure TAudioPositional.OnSetSettings(var aSettings: TGVGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'GameVision - Positional Audio';
end;

procedure TAudioPositional.OnStartup;
begin
  inherited;
  FCenterPos.Assign(Settings.WindowWidth/2, Settings.WindowHeight/2);

  GV.Audio.SetListenerPosition(Settings.WindowWidth/2, Settings.WindowHeight/2);
  FSfx := GV.Audio.LoadSound(Archive, 'arc/sfx/samp5.ogg');

  FChan := GV.Audio.PlaySound(0, FSfx, 1.0, True);
  GV.Audio.SetChannelMinDistance(FChan, 10);
  GV.Audio.SetChannelAttenuation(FChan, 0.5);
end;

procedure TAudioPositional.OnShutdown;
begin
  GV.Audio.UnloadSound(FSfx);
  inherited;
end;

procedure TAudioPositional.OnUpdateFrame(aDeltaTime: Double);
begin
  inherited;
  GV.Audio.SetChannelPosition(FChan, MousePos.X, MousePos.Y);
end;

procedure TAudioPositional.OnRenderFrame;
var
  LRadius: Single;
begin
  inherited;
  GV.Primitive.Line(FCenterPos.X, FCenterPos.Y, MousePos.X, MousePos.Y, GREEN, 1);
  GV.Primitive.FilledCircle(FCenterPos.X, FCenterPos.Y, 10, ORANGE);

  LRadius := FCenterPos.Distance(MousePos);

 GV.Primitive.Circle(FCenterPos.X, FCenterPos.Y, LRadius, 1, WHITE);

  GV.Primitive.Line(0, MousePos.Y, Settings.WindowWidth-1, MousePos.Y, YELLOW, 1);
  GV.Primitive.Line(MousePos.X, 0, MousePos.X, Settings.WindowHeight-1, YELLOW, 1);
end;

end.
