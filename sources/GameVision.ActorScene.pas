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

unit GameVision.ActorScene;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Base,
  GameVision.Actor;

type
  { TGVActorSceneEvent }
  TGVActorSceneEvent = procedure(aSceneNum: Integer) of object;

  { TGVActorScene }
  TGVActorScene = class(TGVObject)
  protected
    FLists: array of TGVActorList;
    FCount: Integer;
    function GetList(aIndex: Integer): TGVActorList;
    function GetCount: Integer;
  public
    property Lists[aIndex: Integer]: TGVActorList read GetList; default;
    property Count: Integer read GetCount;
    constructor Create; override;
    destructor Destroy; override;
    procedure Alloc(aNum: Integer);
    procedure Dealloc;
    procedure Clean(aIndex: Integer);
    procedure Clear(aIndex: Integer; aAttrs: TGVObjectAttributeSet);
    procedure ClearAll;
    procedure Update(aAttrs: TGVObjectAttributeSet; aDeltaTime: Double);
    procedure Render(aAttrs: TGVObjectAttributeSet; aBefore: TGVActorSceneEvent; aAfter: TGVActorSceneEvent);
    function SendMessage(aAttrs: TGVObjectAttributeSet; aMsg: PGVActorMessage; aBroadcast: Boolean): TGVActor;
  end;


implementation

{ TGVActorScene }
function TGVActorScene.GetList(aIndex: Integer): TGVActorList;
begin
  Result := FLists[aIndex];
end;

function TGVActorScene.GetCount: Integer;
begin
  Result := FCount;
end;

constructor TGVActorScene.Create;
begin
  inherited;
  FLists := nil;
  FCount := 0;
end;

destructor TGVActorScene.Destroy;
begin
  Dealloc;
  inherited;
end;

procedure TGVActorScene.Alloc(aNum: Integer);
var
  LI: Integer;
begin
  Dealloc;
  FCount := aNum;
  SetLength(FLists, FCount);
  for LI := 0 to FCount - 1 do
  begin
    FLists[LI] := TGVActorList.Create;
  end;
end;

procedure TGVActorScene.Dealloc;
var
  LI: Integer;
begin
  ClearAll;
  for LI := 0 to FCount - 1 do
  begin
    FLists[LI].Free;
  end;
  FLists := nil;
  FCount := 0;
end;

procedure TGVActorScene.Clean(aIndex: Integer);
begin
  if (aIndex < 0) or (aIndex > FCount - 1) then Exit;
  FLists[aIndex].Clean;
end;

procedure TGVActorScene.Clear(aIndex: Integer; aAttrs: TGVObjectAttributeSet);
begin
  if (aIndex < 0) or (aIndex > FCount - 1) then Exit;
  FLists[aIndex].Clear(aAttrs);
end;

procedure TGVActorScene.ClearAll;
var
  LI: Integer;
begin
  for LI := 0 to FCount - 1 do
  begin
    FLists[LI].Clear([]);
  end;
end;

procedure TGVActorScene.Update(aAttrs: TGVObjectAttributeSet; aDeltaTime: Double);
var
  LI: Integer;
begin
  for LI := 0 to FCount - 1 do
  begin
    FLists[LI].Update(aAttrs, aDeltaTime);
  end;
end;

procedure TGVActorScene.Render(aAttrs: TGVObjectAttributeSet; aBefore: TGVActorSceneEvent; aAfter: TGVActorSceneEvent);
var
  LI: Integer;
begin
  for LI := 0 to FCount - 1 do
  begin
    if Assigned(aBefore) then aBefore(LI);
    FLists[LI].Render(aAttrs);
    if Assigned(aAfter) then aAfter(LI);
  end;
end;

function TGVActorScene.SendMessage(aAttrs: TGVObjectAttributeSet; aMsg: PGVActorMessage; aBroadcast: Boolean): TGVActor;
var
  LI: Integer;
begin
  Result := nil;
  for LI := 0 to FCount - 1 do
  begin
    Result := FLists[LI].SendMessage(aAttrs, aMsg, aBroadcast);
    if not aBroadcast then
    begin
      if Result <> nil then
      begin
        Exit;
      end;
    end;
  end;
end;

end.
