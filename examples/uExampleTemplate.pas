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

unit uExampleTemplate;

interface

uses
  System.SysUtils,
  GameVision.Game,
  uCommon;

type
  { TExampleTemplate }
  TExampleTemplate = class(TBaseExample)
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnPreStartup; override;
    procedure OnPostStartup; override;
    procedure OnLoadConfig; override;
    procedure OnSaveConfig; override;
    procedure OnSetSettings(var aSettings: TGVGameSettings); override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnReady(aReady: Boolean); override;
    procedure OnUpdateFrame(aDeltaTime: Double); override;
    procedure OnFixedUpdateFrame; override;
    procedure OnStartFrame; override;
    procedure OnEndFrame; override;
    procedure OnClearFrame; override;
    procedure OnRenderFrame; override;
    procedure OnRenderHUD; override;
    procedure OnShowFrame; override;
    procedure OnLoadVideo(const aFilename: string); override;
    procedure OnUnloadVideo(const aFilename: string); override;
    procedure OnStartVideo(const aFilename: string); override;
    procedure OnFinishedVideo(const aFilename: string); override;
    procedure OnSpeechWord(aFWord: string; aText: string); override;
  end;

implementation

{ TExampleTemplate }
constructor TExampleTemplate.Create;
begin
  inherited;
end;

destructor TExampleTemplate.Destroy;
begin
  inherited;
end;

procedure TExampleTemplate.OnPreStartup;
begin
  inherited;
end;

procedure TExampleTemplate.OnPostStartup;
begin
  inherited;
end;

procedure TExampleTemplate.OnLoadConfig;
begin
  inherited;
end;

procedure TExampleTemplate.OnSaveConfig;
begin
  inherited;
end;

procedure TExampleTemplate.OnSetSettings(var aSettings: TGVGameSettings);
begin
  inherited;
  aSettings.WindowTitle := 'TExampleTemplate';
end;

procedure TExampleTemplate.OnStartup;
begin
  inherited;
end;

procedure TExampleTemplate.OnShutdown;
begin
  inherited;
end;

procedure TExampleTemplate.OnReady(aReady: Boolean);
begin
  inherited;
end;

procedure TExampleTemplate.OnUpdateFrame(aDeltaTime: Double);
begin
  inherited;
end;

procedure TExampleTemplate.OnFixedUpdateFrame;
begin
  inherited;
end;

procedure TExampleTemplate.OnStartFrame;
begin
  inherited;
end;

procedure TExampleTemplate.OnEndFrame;
begin
  inherited;
end;

procedure TExampleTemplate.OnClearFrame;
begin
  inherited;
end;

procedure TExampleTemplate.OnRenderFrame;
begin
  inherited;
end;

procedure TExampleTemplate.OnRenderHUD;
begin
  inherited;
end;

procedure TExampleTemplate.OnShowFrame;
begin
  inherited;
end;

procedure TExampleTemplate.OnLoadVideo(const aFilename: string);
begin
  inherited;
end;

procedure TExampleTemplate.OnUnloadVideo(const aFilename: string);
begin
  inherited;
end;

procedure TExampleTemplate.OnStartVideo(const aFilename: string);
begin
  inherited;
end;

procedure TExampleTemplate.OnFinishedVideo(const aFilename: string);
begin
  inherited;
end;

procedure TExampleTemplate.OnSpeechWord(aFWord: string; aText: string);
begin
  inherited;
end;

end.
