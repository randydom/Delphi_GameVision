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

unit GameVision.Base;

{$I GameVision.Defines.inc}

interface

type
  { TGVObjectAttributeSet }
  TGVObjectAttributeSet = set of Byte;

  { TGVObjectList }
  TGVObjectList = class;

  { TGVObject }
  TGVObject = class
  protected
    FOwner: TGVObjectList;
    FPrev: TGVObject;
    FNext: TGVObject;
    FAttributes: TGVObjectAttributeSet;
    function GetAttribute(aIndex: Byte): Boolean;
    procedure SetAttribute(aIndex: Byte; aValue: Boolean);
    function GetAttributes: TGVObjectAttributeSet;
    procedure SetAttributes(aValue: TGVObjectAttributeSet);
  public
    property Owner: TGVObjectList read FOwner write FOwner;
    property Prev: TGVObject read FPrev write FPrev;
    property Next: TGVObject read FNext write FNext;
    property Attribute[aIndex: Byte]: Boolean read GetAttribute write SetAttribute;
    property Attributes: TGVObjectAttributeSet read GetAttributes  write SetAttributes;
    constructor Create; virtual;
    destructor Destroy; override;
    function AttributesAreSet(aAttrs: TGVObjectAttributeSet): Boolean;
  end;

  { TGVObjectList }
  TGVObjectList = class
  protected
    FHead: TGVObject;
    FTail: TGVObject;
    FCount: Integer;
  public
    property Count: Integer read FCount;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Add(aObject: TGVObject); virtual;
    procedure Remove(aObject: TGVObject; aDispose: Boolean); virtual;
    procedure Clean; virtual;
    procedure Clear(aAttrs: TGVObjectAttributeSet); virtual;
  end;

implementation

uses
  GameVision.Core;

{ TGVObject }
function TGVObject.GetAttribute(aIndex: Byte): Boolean;
begin
  Result := Boolean(aIndex in FAttributes);
end;

procedure TGVObject.SetAttribute(aIndex: Byte; aValue: Boolean);
begin
  if aValue then
    Include(FAttributes, aIndex)
  else
    Exclude(FAttributes, aIndex);
end;

function TGVObject.GetAttributes: TGVObjectAttributeSet;
begin
  Result := FAttributes;
end;

procedure TGVObject.SetAttributes(aValue: TGVObjectAttributeSet);
begin
  FAttributes := aValue;
end;

constructor TGVObject.Create;
begin
  inherited;
  FOwner := nil;
  FPrev := nil;
  FNext := nil;
  FAttributes := [];
  if GV <> nil then
    GV.MasterObjectList.Add(Self);
end;

destructor TGVObject.Destroy;
begin
  if FOwner <> nil then
  begin
    if GV <> nil then
      GV.MasterObjectList.Remove(Self, False);
  end;
  inherited;
end;

function TGVObject.AttributesAreSet(aAttrs: TGVObjectAttributeSet): Boolean;
var
  LAttr: Byte;
begin
  Result := False;
  for LAttr in aAttrs do
  begin
    if LAttr in FAttributes then
    begin
      Result := True;
      Break;
    end;
  end;
end;

{ TGVObjectList }
constructor TGVObjectList.Create;
begin
  inherited;
  FHead := nil;
  FTail := nil;
  FCount := 0;
end;

destructor TGVObjectList.Destroy;
begin
  Clean;
  inherited;
end;

procedure TGVObjectList.Add(aObject: TGVObject);
begin
  if aObject = nil then Exit;

  // check if already on this list
  if aObject.Owner = Self then Exit;

  // remove if on another list
  if aObject.Owner <> nil then
  begin
    aObject.Owner.Remove(aObject, False);
  end;

  aObject.Prev := FTail;
  aObject.Next := nil;
  aObject.Owner := Self;

  if FHead = nil then
    begin
      FHead := aObject;
      FTail := aObject;
    end
  else
    begin
      FTail.Next := aObject;
      FTail := aObject;
    end;

  Inc(FCount);
end;

procedure TGVObjectList.Remove(aObject: TGVObject; aDispose: Boolean);
var
  LFlag: Boolean;
begin
  if aObject = nil then Exit;

  LFlag := False;

  if aObject.Next <> nil then
  begin
    aObject.Next.Prev := aObject.Prev;
    LFlag := True;
  end;

  if aObject.Prev <> nil then
  begin
    aObject.Prev.Next := aObject.Next;
    LFlag := True;
  end;

  if FTail = aObject then
  begin
    FTail := FTail.Prev;
    LFlag := True;
  end;

  if FHead = aObject then
  begin
    FHead := FHead.Next;
    LFlag := True;
  end;

  if LFlag = True then
  begin
    aObject.Owner := nil;
    Dec(FCount);
    if aDispose then
    begin
      aObject.Free;
    end;
  end;
end;

procedure TGVObjectList.Clean;
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

    Remove(LObj, True);

    // get pointer to next object
    LObj := LNext;

  until LObj = nil;
end;

procedure TGVObjectList.Clear(aAttrs: TGVObjectAttributeSet);
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
    // save pointer to next object
    LNext := LObj.Next;

    if LNoAttrs then
      begin
        Remove(LObj, True);
      end
    else
      begin
        if LObj.AttributesAreSet(aAttrs) then
        begin
          Remove(LObj, True);
        end;
      end;

    // get pointer to next object
    LObj := LNext;

  until LObj = nil;
end;

end.
