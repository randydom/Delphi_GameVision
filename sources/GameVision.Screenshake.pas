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

unit GameVision.Screenshake;

{$I GameVision.Defines.inc}

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  GameVision.Allegro,
  GameVision.Base,
  GameVision.Math;

type
  { TGVAScreenshake }
  TGVAScreenshake = class
  protected
    FActive: Boolean;
    FDuration: Single;
    FMagnitude: Single;
    FTimer: Single;
    FPos: TGVVector;
  public
    constructor Create(aDuration: Single; aMagnitude: Single);
    destructor Destroy; override;
    procedure Process(aSpeed: Single; aDeltaTime: Double);
    property Active: Boolean read FActive;
  end;

  { TGVScreenshake }
  TGVScreenshake = class(TGVObject)
  protected
    FTrans: ALLEGRO_TRANSFORM;
    FList: TObjectList<TGVAScreenshake>;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Process(aSpeed: Single; aDeltaTime: Double);
    procedure Start(aDuration: Single; aMagnitude: Single);
    procedure Clear;
    function  Active: Boolean;
  end;

implementation

uses
  GameVision.Core;

{ TGVAScreenshake }
constructor TGVAScreenshake.Create(aDuration: Single; aMagnitude: Single);
begin
  inherited Create;

  FActive := True;
  FDuration := aDuration;
  FMagnitude := aMagnitude;
  FTimer := 0;
  FPos.x := 0;
  FPos.y := 0;
end;

destructor TGVAScreenshake.Destroy;
begin

  inherited;
end;

function lerp(t: Single; a: Single; b: Single): Single; inline;
begin
  Result := (1 - t) * a + t * b;
end;

procedure TGVAScreenshake.Process(aSpeed: Single; aDeltaTime: Double);
begin
  if not FActive then Exit;

  FDuration := FDuration - (aSpeed * aDeltaTime);
  if FDuration <= 0 then
  begin
    GV.Window.SetTransformPosition(-FPos.x, -FPos.y);
    FActive := False;
    Exit;
  end;

  if Round(FDuration) <> Round(FTimer) then
  begin
    GV.Window.SetTransformPosition(-FPos.x, -FPos.y);

    FPos.x := Round(GV.Math.RandomRange(-FMagnitude, FMagnitude));
    FPos.y := Round(GV.Math.RandomRange(-FMagnitude, FMagnitude));

    GV.Window.SetTransformPosition(FPos.x, FPos.y);

    FTimer := FDuration;
  end;
end;

{ TGVScreenshake }
procedure TGVScreenshake.Process(aSpeed: Single; aDeltaTime: Double);
var
  LShake: TGVAScreenshake;
  LFlag: Boolean;
begin
  // process shakes
  LFlag := Active;
  for LShake in FList do
  begin
    if LShake.Active then
    begin
      LShake.Process(aSpeed, aDeltaTime);
    end
    else
    begin
      FList.Remove(LShake);
    end;
  end;

  if LFlag then
  begin
    if not Active then
    begin
      // Lib.Display.ResetTransform;
    end;
  end;
end;

constructor TGVScreenshake.Create;
begin
  inherited;
  FList := TObjectList<TGVAScreenshake>.Create(True);
  al_identity_transform(@FTrans);
end;

destructor TGVScreenshake.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

procedure TGVScreenshake.Start(aDuration: Single; aMagnitude: Single);
var
  LShake: TGVAScreenshake;
begin
  LShake := TGVAScreenshake.Create(aDuration, aMagnitude);
  FList.Add(LShake);
end;

procedure TGVScreenshake.Clear;
begin
  FList.Clear;
end;

function TGVScreenshake.Active: Boolean;
begin
  Result := Boolean(FList.Count > 0);
end;

end.
