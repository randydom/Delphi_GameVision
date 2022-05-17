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

unit GameVision.InputMap;

{$I GameVision.Defines.inc}

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  GameVision.Base,
  GameVision.Archive;

type
  { TGVInputMapDevice }
  TGVInputMapDevice = (idKeyboard, idMouse, idJoystick);

  { TGVInputMap }
  TGVInputMap = class(TGVObject)
  protected
    type
      { TInputMapDeviceInput }
      TInputMapDeviceInput = record
        Device: TGVInputMapDevice;
        Data: Integer;
      end;

      { TInputMapAction }
      TInputMapAction = record
        Action: string;
        List: TList<TInputMapDeviceInput>;
      end;
  protected
    FList: TDictionary<string, TInputMapAction>;
    function NewAction(const aAction: string; aDevice: TGVInputMapDevice; aData: Integer): TInputMapAction;
  public
    constructor Create; override;
    destructor Destroy; override;
  public
    procedure Clear;
    function Add(const aAction: string; aDevice: TGVInputMapDevice; aData: Integer): Boolean;
    function Remove(const aAction: string): Boolean; overload;
    function Remove(const aAction: string; aDevice: TGVInputMapDevice; aData: Integer): Boolean; overload;
    function Pressed(const aAction: string): Boolean;
    function Released(const aAction: string): Boolean;
    function Down(const aAction: string): Boolean;
    function Save(const aFilename: string): Boolean;
    function Load(aArchive: TGVArchive; const aFilename: string): Boolean;
  end;

implementation

uses
  System.Classes,
  System.IOUtils,
  GameVision.Buffer,
  GameVision.Core;

{ TInputMap }
function TGVInputMap.NewAction(const aAction: string; aDevice: TGVInputMapDevice; aData: Integer): TInputMapAction;
var
  LInput: TInputMapDeviceInput;
begin
  Result.Action := aAction;
  Result.List := TList<TInputMapDeviceInput>.Create;
  LInput.Device := aDevice;
  LInput.Data := aData;
  Result.List.Add(LInput);
end;

constructor TGVInputMap.Create;
begin
  inherited;
  FList := TDictionary<string, TInputMapAction>.Create;
end;

destructor TGVInputMap.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited;
end;

procedure TGVInputMap.Clear;
var
  LItem: TPair<string, TInputMapAction>;
begin
  for LItem in FList do
  begin
    FreeAndNil(LItem.Value.List);
  end;
  FList.Clear;
end;

function TGVInputMap.Add(const aAction: string; aDevice: TGVInputMapDevice; aData: Integer): Boolean;
var
  LAction: TInputMapAction;
  LInput: TInputMapDeviceInput;
begin
  Result := False;
  if FList.TryGetValue(aAction, LAction) then
    begin
      LInput.Device := aDevice;
      LInput.Data := aData;
      if LAction.List.Contains(LInput) then
        begin
          Exit;
        end
      else
        begin
          LAction.List.Add(LInput);
          Result := False;
        end;
    end
  else
    begin
      LAction := NewAction(aAction, aDevice, aData);
      FList.Add(aAction, LAction);
    end;
end;

function TGVInputMap.Remove(const aAction: string): Boolean;
var
  LAction: TInputMapAction;
begin
  Result := False;
  if FList.TryGetValue(aAction, LAction) then
  begin
    FList.Remove(aAction);
    FreeAndNil(LAction.List);
    FList.TrimExcess;
    Result := True;
  end;
end;

function TGVInputMap.Remove(const aAction: string; aDevice: TGVInputMapDevice; aData: Integer): Boolean;
var
  LAction: TInputMapAction;
  LInput: TInputMapDeviceInput;
begin
  Result := False;

  if not FList.TryGetValue(aAction, LAction) then Exit;
  LInput.Device := aDevice;
  LInput.Data := aData;
  if LAction.List.Contains(LInput) then
  begin
    LAction.List.Remove(LInput);
    LAction.List.Pack;
    Result := True;
  end;
end;

function TGVInputMap.Pressed(const aAction: string): Boolean;
var
  LAction: TInputMapAction;
begin
  Result := False;
  if FList.TryGetValue(aAction, LAction) then
  begin
    for var I := 0 to LAction.List.Count-1 do
    begin
      case LAction.List.Items[I].Device of
        idKeyboard:
          begin
            Result := GV.Input.KeyPressed(LAction.List.Items[I].Data);
            if Result then Break;
          end;
        idMouse:
          begin
            Result := GV.Input.MousePressed(LAction.List.Items[I].Data);
            if Result then Break;
          end;
        idJoystick:
          begin
            Result := GV.Input.JoystickPressed(LAction.List.Items[I].Data);
            if Result then Break;
          end;
      end;
    end;
  end;
end;

function TGVInputMap.Released(const aAction: string): Boolean;
var
  LAction: TInputMapAction;
  LI: Integer;
begin
  Result := False;
  if FList.TryGetValue(aAction, LAction) then
  begin
    for LI := 0 to LAction.List.Count-1 do
    begin
      case LAction.List.Items[LI].Device of
        idKeyboard:
          begin
            Result := GV.Input.KeyReleased(LAction.List.Items[LI].Data);
            if Result then Break;
          end;
        idMouse:
          begin
            Result := GV.Input.MouseReleased(LAction.List.Items[LI].Data);
            if Result then Break;
          end;
        idJoystick:
          begin
            Result := GV.Input.JoystickReleased(LAction.List.Items[LI].Data);
            if Result then Break;
          end;
      end;
    end;
  end;
end;

function TGVInputMap.Down(const aAction: string): Boolean;
var
  LAction: TInputMapAction;
  LI: Integer;
begin
  Result := False;
  if FList.TryGetValue(aAction, LAction) then
  begin
    for LI := 0 to LAction.List.Count-1 do
    begin
      case LAction.List.Items[LI].Device of
       idKeyboard:
          begin
            Result := GV.Input.KeyDown(LAction.List.Items[LI].Data);
            if Result then Break;
          end;
        idMouse:
          begin
            Result := GV.Input.MouseDown(LAction.List.Items[LI].Data);
            if Result then Break;
          end;
        idJoystick:
          begin
            Result := GV.Input.JoystickDown(LAction.List.Items[LI].Data);
            if Result then Break;
          end;
      end;
    end;
  end;
end;

function TGVInputMap.Save(const aFilename: string): Boolean;
var
  LStream: TFileStream;
  LAction: TInputMapAction;
  LIndex: Integer;
begin
  Result := False;
  if aFilename.IsEmpty then Exit;

  LStream := TFile.Create(aFilename);
  try
    // save FList count
    LStream.WriteData(FList.Count);

    // loop thru each action
    for LAction in FList.Values do
    begin
      // save LAction count
      LStream.WriteData(LAction.List.Count);

      // save Action name
      GV.Util.WriteStringToStream(LStream, LAction.Action);

      // save action list data
      for LIndex := 0 to LAction.List.Count-1 do
      begin
        LStream.WriteData(LAction.List.Items[LIndex].Device);
        LStream.WriteData(LAction.List.Items[LIndex].Data);
      end;
    end;

    Result := TFile.Exists(aFilename);
  finally
    FreeAndNil(LStream);
  end;
end;

function TGVInputMap.Load(aArchive: TGVArchive; const aFilename: string): Boolean;
var
  LBuffer: TGVBuffer;
  LCount: Integer;
  LIndex: Integer;
  LAction: string;
  LDevice: TGVInputMapDevice;
  LData: Integer;
begin
  Result := False;
  if aFilename.IsEmpty then Exit;

  if aArchive <> nil then
    begin
      if not aArchive.IsOpen then Exit;
      if not aArchive.FileExist(aFilename) then Exit;
      LBuffer := aArchive.ExtractToBuffer(aFilename);
      // TODO: check for errors
    end
  else
    begin
      if not TFile.Exists(aFilename) then Exit;
      LBuffer := TGVBuffer.Create;
      // TODO: check for errors
      LBuffer.LoadFromFile(aFilename);
    end;

  Self.Clear;

  LBuffer.Position := 0;

  // read FList Count
  LBuffer.Read(@LCount, SizeOf(LCount));

  // loop thru each action
  while not LBuffer.Eof do
  begin
    // load LAction count
    LBuffer.Read(@LCount, SizeOf(LCount));

    // load action name
    LAction := TGVBuffer.ReadString(LBuffer);

    for LIndex := 0 to LCount-1 do
    begin
      // load action data
      LBuffer.Read(@LDevice, SizeOf(LDevice));
      LBuffer.Read(@LData, SizeOf(LData));

      // add action map
      self.Add(LAction, LDevice, LData);
    end;
  end;

  FreeAndNil(LBuffer);

  Result := True;
end;

end.
