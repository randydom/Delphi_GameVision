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

unit GameVision.Actor;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Base,
  GameVision.Math;

type

  { TGVActorList }
  TGVActorList = class;

  { TGVActorMessage }
  PGVActorMessage = ^TGVActorMessage;
  TGVActorMessage = record
    Id: Integer;
    Data: Pointer;
    DataSize: Cardinal;
  end;

  { TGVActor }
  TGVActor = class(TGVObject)
  protected
    FTerminated: Boolean;
    FActorList: TGVActorList;
    FCanCollide: Boolean;
    FChildren: TGVActorList;
  public
    property Terminated: Boolean read FTerminated write FTerminated;
    property Children: TGVActorList read FChildren write FChildren;
    property ActorList: TGVActorList read FActorList write FActorList;
    property CanCollide: Boolean read FCanCollide write FCanCollide;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnVisit(aSender: TGVActor; aEventId: Integer; var aDone: Boolean); virtual;
    procedure OnUpdate(aDeltaTime: Double); virtual;
    procedure OnRender; virtual;
    function OnMessage(aMsg: PGVActorMessage): TGVActor; virtual;
    procedure OnCollide(aActor: TGVActor; aHitPos: TGVVector); virtual;
    function Collide(aActor: TGVActor; var aHitPos: TGVVector): Boolean; virtual;
    function Overlap(aX, aY, aRadius, aShrinkFactor: Single): Boolean; overload; virtual;
    function Overlap(aActor: TGVActor): Boolean; overload; virtual;
  end;

  { TGVActorList }
  TGVActorList = class(TGVObjectList)
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Add(aObject: TGVObject); override;
    procedure Remove(aObject: TGVObject; aDispose: Boolean); override;
    procedure Clean; override;
    procedure Clear(aAttrs: TGVObjectAttributeSet); override;
    procedure ForEach(aSender: TGVActor; aAttrs: TGVObjectAttributeSet; aEventId: Integer; var aDone: Boolean);
    procedure Update(aAttrs: TGVObjectAttributeSet; aDeltaTime: Double);
    procedure Render(aAttrs: TGVObjectAttributeSet);
    function SendMessage(aAttrs: TGVObjectAttributeSet; aMsg: PGVActorMessage; aBroadcast: Boolean): TGVActor;
    procedure CheckCollision(aAttrs: TGVObjectAttributeSet; aActor: TGVActor);
  end;


implementation

{ TGVActor }
constructor TGVActor.Create;
begin
  inherited;
  FTerminated := False;
  FActorList := nil;
  FCanCollide := False;
  FChildren := TGVActorList.Create;
end;

destructor TGVActor.Destroy;
begin
  FreeAndNil(FChildren);
  inherited;
end;

procedure TGVActor.OnVisit(aSender: TGVActor; aEventId: Integer; var aDone: Boolean);
begin
end;

procedure TGVActor.OnUpdate(aDeltaTime: Double);
begin
  // update all children by default
  FChildren.Update([], aDeltaTime);
end;

procedure TGVActor.OnRender;
begin
  // render all children by default
  FChildren.Render([]);
end;

function TGVActor.OnMessage(aMsg: PGVActorMessage): TGVActor;
begin
  Result := nil;
end;

procedure TGVActor.OnCollide(aActor: TGVActor; aHitPos: TGVVector);
begin
end;

function TGVActor.Collide(aActor: TGVActor; var aHitPos: TGVVector): Boolean;
begin
  Result := False;
end;

function TGVActor.Overlap(aX, aY, aRadius, aShrinkFactor: Single): Boolean;
begin
  Result := False;
end;

function TGVActor.Overlap(aActor: TGVActor): Boolean;
begin
  Result := False;
end;

{ TGVActorList }
constructor TGVActorList.Create;
begin
  inherited;
end;

destructor TGVActorList.Destroy;
begin
  inherited;
end;

procedure TGVActorList.Add(aObject: TGVObject);
begin
  if aObject is TGVActor then
    inherited;
end;

procedure TGVActorList.Remove(aObject: TGVObject; aDispose: Boolean);
begin
  if aObject is TGVActor then
    inherited;
end;

procedure TGVActorList.Clean;
var
  LObj: TGVObject;
  LNext: TGVObject;
begin
  // get pointer to head
  LObj := FHead;

  // exit if list is empty
  if LObj = nil then
    Exit;

  repeat
    // save pointer to next object
    LNext := LObj.Next;

    if TGVActor(LObj).Terminated then
    begin
      Remove(LObj, True);
    end;

    // get pointer to next object
    LObj := LNext;

  until LNext = nil;
end;

procedure TGVActorList.Clear(aAttrs: TGVObjectAttributeSet);
begin
  inherited;
end;

procedure TGVActorList.ForEach(aSender: TGVActor; aAttrs: TGVObjectAttributeSet; aEventId: Integer; var aDone: Boolean);
var
  LObj: TGVObject;
  LNext: TGVObject;
  LNoAttrs: Boolean;
begin
  if not (aSender is TGVActor) then
    Exit;

  // get pointer to head
  LObj := FHead;

  // exit if list is empty
  if LObj = nil then
    Exit;

  // check if we should check for attrs
  LNoAttrs := Boolean(aAttrs = []);

  repeat
    // save pointer to next actor
    LNext := TGVActor(LObj.Next);

    // destroy actor if not terminated
    if not TGVActor(LObj).Terminated then
    begin
      // no attributes specified so update this actor
      if LNoAttrs then
      begin
        aDone := False;
        TGVActor(LObj).OnVisit(aSender, aEventId, aDone);
        if aDone then
        begin
          Exit;
        end;
      end
      else
      begin
        // update this actor if it has specified attribute
        if TGVActor(LObj).AttributesAreSet(aAttrs) then
        begin
          aDone := False;
          TGVActor(LObj).OnVisit(aSender, aEventId, aDone);
          if aDone then
          begin
            Exit;
          end;
        end;
      end;
    end;

    // get pointer to next actor
    LObj := LNext;

  until LObj = nil;
end;

procedure TGVActorList.Update(aAttrs: TGVObjectAttributeSet; aDeltaTime: Double);
var
  LObj: TGVObject;
  LNext: TGVObject;
  LNoAttrs: Boolean;
begin
  // get pointer to head
  LObj := FHead;

  // exit if list is empty
  if LObj = nil then  Exit;

  // check if we should check for attrs
  LNoAttrs := Boolean(aAttrs = []);

  repeat
    // save pointer to next actor
    LNext := LObj.Next;

    // destroy actor if not terminated
    if not TGVActor(LObj).Terminated then
    begin
      // no attributes specified so update this actor
      if LNoAttrs then
      begin
        // call actor's OnUpdate method
        TGVActor(LObj).OnUpdate(aDeltaTime);
      end
      else
      begin
        // update this actor if it has specified attribute
        if LObj.AttributesAreSet(aAttrs) then
        begin
          // call actor's OnUpdate method
          TGVActor(LObj).OnUpdate(aDeltaTime);
        end;
      end;
    end;

    // get pointer to next actor
    LObj := LNext;

  until LObj = nil;

  // perform garbage collection
  Clean;
end;

procedure TGVActorList.Render(aAttrs: TGVObjectAttributeSet);
var
  LObj: TGVObject;
  LNext: TGVObject;
  LNoAttrs: Boolean;
begin
  // get pointer to head
  LObj := FHead;

  // exit if list is empty
  if LObj = nil then Exit;

  // check if we should check for attrs
  LNoAttrs := Boolean(aAttrs = []);

  repeat
    // save pointer to next actor
    LNext := LObj.Next;

    // destroy actor if not terminated
    if not TGVActor(LObj).Terminated then
    begin
      // no attributes specified so update this actor
      if LNoAttrs then
      begin
        // call actor's OnRender method
        TGVActor(LObj).OnRender;
      end
      else
      begin
        // update this actor if it has specified attribute
        if LObj.AttributesAreSet(aAttrs) then
        begin
          // call actor's OnRender method
          TGVActor(LObj).OnRender;
        end;
      end;
    end;

    // get pointer to next actor
    LObj := LNext;

  until LObj = nil;
end;

function TGVActorList.SendMessage(aAttrs: TGVObjectAttributeSet; aMsg: PGVActorMessage; aBroadcast: Boolean): TGVActor;
var
  LObj: TGVObject;
  LNext: TGVObject;
  LNoAttrs: Boolean;
begin
  Result := nil;

  // get pointer to head
  LObj := FHead;

  // exit if list is empty
  if LObj = nil then Exit;

  // check if we should check for attrs
  LNoAttrs := Boolean(aAttrs = []);

  repeat
    // save pointer to next actor
    LNext := LObj.Next;

    // destroy actor if not terminated
    if not TGVActor(LObj).Terminated then
    begin
      // no attributes specified so update this actor
      if LNoAttrs then
      begin
        // send message to object
        Result := TGVActor(LObj).OnMessage(aMsg);
        if not aBroadcast then
        begin
          if Result <> nil then
          begin
            Exit;
          end;
        end;
      end
      else
      begin
        // update this actor if it has specified attribute
        if LObj.AttributesAreSet(aAttrs) then
        begin
          // send message to object
          Result := TGVActor(LObj).OnMessage(aMsg);
          if not aBroadcast then
          begin
            if Result <> nil then
            begin
              Exit;
            end;
          end;

        end;
      end;
    end;

    // get pointer to next actor
    LObj := LNext;

  until LObj = nil;
end;

procedure TGVActorList.CheckCollision(aAttrs: TGVObjectAttributeSet; aActor: TGVActor);
var
  LObj: TGVObject;
  LNext: TGVObject;
  LNoAttrs: Boolean;
  LHitPos: TGVVector;
begin
  // check if terminated
  if aActor.Terminated then Exit;

  // check if can collide
  if not aActor.CanCollide then Exit;

  // get pointer to head
  LObj := FHead;

  // exit if list is empty
  if LObj = nil then Exit;

  // check if we should check for attrs
  LNoAttrs := Boolean(aAttrs = []);

  repeat
    // save pointer to next actor
    LNext := LObj.Next;

    // destroy actor if not terminated
    if not TGVActor(LObj).Terminated then
    begin
      // no attributes specified so check collision with this actor
      if LNoAttrs then
      begin

        if TGVActor(LObj).CanCollide then
        begin
          // HitPos.Clear;
          LHitPos.X := 0;
          LHitPos.Y := 0;
          if aActor.Collide(TGVActor(LObj), LHitPos) then
          begin
            TGVActor(LObj).OnCollide(aActor, LHitPos);
            aActor.OnCollide(TGVActor(LObj), LHitPos);
            // Exit;
          end;
        end;

      end
      else
      begin
        // check collision with this actor if it has specified attribute
        if TGVActor(LObj).AttributesAreSet(aAttrs) then
        begin
          if TGVActor(LObj).CanCollide then
          begin
            // HitPos.Clear;
            LHitPos.X := 0;
            LHitPos.Y := 0;
            if aActor.Collide(TGVActor(LObj), LHitPos) then
            begin
              TGVActor(LObj).OnCollide(aActor, LHitPos);
              aActor.OnCollide(TGVActor(LObj), LHitPos);
              // Exit;
            end;
          end;

        end;
      end;
    end;

    // get pointer to next actor
    LObj := LNext;

  until LObj = nil;
end;

end.
