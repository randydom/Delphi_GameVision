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

unit GameVision.EntityActor;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Base,
  GameVision.Actor,
  GameVision.Entity,
  GameVision.Sprite,
  GameVision.Math;

type
  { TGVEntityActor }
  TGVEntityActor = class(TGVActor)
  protected
    FEntity: TGVEntity;
  public
    property Entity: TGVEntity read FEntity;
    constructor Create; override;
    destructor Destroy; override;
    procedure Init(aSprite: TGVSprite; aGroup: Integer); virtual;
    function Collide(aActor: TGVActor; var aHitPos: TGVVector): Boolean; override;
    function Overlap(aX, aY, aRadius, aShrinkFactor: Single): Boolean; override;
    function Overlap(aActor: TGVActor): Boolean; override;
    procedure OnRender; override;
  end;


implementation

{ TGVEntityActor }
constructor TGVEntityActor.Create;
begin
  inherited;
  FEntity := nil;
end;

destructor TGVEntityActor.Destroy;
begin
  FreeAndNil(FEntity);
  inherited;
end;

procedure TGVEntityActor.Init(aSprite: TGVSprite; aGroup: Integer);
begin
  FEntity := TGVEntity.Create;
  FEntity.Init(aSprite, aGroup);
end;

function TGVEntityActor.Collide(aActor: TGVActor; var aHitPos: TGVVector): Boolean;
begin
  Result := False;
  if FEntity = nil then Exit;
  if aActor is TGVEntityActor then
  begin
    Result := FEntity.CollidePolyPoint(TGVEntityActor(aActor).Entity, aHitPos);
  end
end;

function TGVEntityActor.Overlap(aX, aY, aRadius, aShrinkFactor: Single): Boolean;
begin
  Result := FAlse;
  if FEntity = nil then Exit;
  Result := FEntity.Overlap(aX, aY, aRadius, aShrinkFactor);
end;

function TGVEntityActor.Overlap(aActor: TGVActor): Boolean;
begin
  Result := False;
  if FEntity = nil then Exit;
  if aActor is TGVEntityActor then
  begin
    Result := FEntity.Overlap(TGVEntityActor(aActor).Entity);
  end;
end;

procedure TGVEntityActor.OnRender;
begin
  if FEntity = nil then Exit;
  FEntity.Render(0, 0);
end;

end.
