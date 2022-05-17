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

unit GameVision.Buffer;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  GameVision.Base;

const
  // Buffer Constants
  GV_BUFFER_COPYCACHESIZE = $100000;

type
  { TGVBuffer }
  TGVBuffer = class(TGVObject)
  protected
    FHandle: THandle;
    FMemory: Pointer;
    FSize: UInt64;
    FPosition: UInt64;
    function GetPosition: UInt64;
    procedure SetPosition(aPosition: UInt64);
  public
    property Position: UInt64 read GetPosition write SetPosition;
    property Memory: Pointer read FMemory;
    property Size: UInt64 read FSize;
    constructor Create; override;
    destructor Destroy; override;
    function Allocate(aSize: UInt64): Boolean;
    procedure Release;
    function Read(const aBuffer: Pointer; aCount: UInt64): UInt64;
    function Write(aBuffer: Pointer; aCount: UInt64): UInt64;
    function LoadFromFile(const aFilename: string): Boolean;
    function SaveToFile(const aFilename: string): Boolean;
    function LoadFromStream(const aStream: TStream): UInt64;
    function SaveToStream(const aStream: TStream): UInt64;
    function Eof: Boolean;
    class function LoadFromResource(aInstance: THandle; const aResName: string): TGVBuffer;
    class function  ReadString(const aBuffer: TGVBuffer): string;
  end;

implementation

uses
  System.IOUtils,
  WinApi.Windows,
  GameVision.Util;

{ TGVBuffer }
function TGVBuffer.GetPosition: UInt64;
begin
  Result := FPosition;
end;

procedure TGVBuffer.SetPosition(aPosition: UInt64);
begin
  if aPosition > FSize-1 then
    FPosition := FSize-1
  else
    FPosition := aPosition;
end;

constructor TGVBuffer.Create;
begin
  inherited;
  FHandle := 0;
  FMemory := nil;
  FSize := 0;
  FPosition := 0;
end;

destructor TGVBuffer.Destroy;
begin
  Release;
  inherited;
end;

function TGVBuffer.Allocate(aSize: UInt64): Boolean;
var
  LName: string;
  LHandle: THandle;
  LMemory: Pointer;
begin
  Result := False;

  LName := TPath.GetGUIDFileName;
  LHandle := CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE, 0, aSize, PChar(LName));
  if LHandle = 0 then
  begin
    Release;
    Exit;
  end;

  LMemory := MapViewOfFile(LHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
  if LMemory = nil then
  begin
    Release;
    Exit;
  end;

  FHandle := LHandle;
  FMemory := LMemory;
  FSize   := aSize;
  FPosition := 0;

  Result := True;
end;

procedure TGVBuffer.Release;
begin
  if FMemory <> nil then
  begin
    // TODO: check for errors
    UnmapViewOfFile(FMemory);
    FMemory := nil;
  end;

  if FHandle <> 0 then
  begin
    // TODO: check for errors
    CloseHandle(FHandle);
    FHandle := 0;
  end;

  if (FMemory = nil) and (FHandle = 0) then
  begin
    FSize := 0;
    FPosition := 0;
  end;
end;

function TGVBuffer.Read(const aBuffer: Pointer; aCount: UInt64): UInt64;
begin
  if (FPosition >= 0) and (aCount >= 0) then
  begin
    if (FSize - FPosition) > 0 then
    begin
      if FSize > aCount + FPosition then Result := aCount
      else Result := FSize - FPosition;
      Move((PByte(FMemory) + FPosition)^, aBuffer^, Result);
      Inc(FPosition, Result);
      Exit;
    end;
  end;
  Result := 0;
end;

function TGVBuffer.Write(aBuffer: Pointer; aCount: UInt64): UInt64;
var
  LPos: UInt64;
begin
  if (FPosition >= 0) and (aCount >= 0) then
  begin
    LPos := FPosition + aCount;
    if LPos > 0 then
    begin
      if LPos > FSize then
      begin
        Result := 0;
        Exit;
      end;
      System.Move(aBuffer^, (PByte(FMemory) + FPosition)^, aCount);
      FPosition := LPos;
      Result := aCount;
      Exit;
    end;
  end;
  Result := 0;
end;

function TGVBuffer.LoadFromFile(const aFilename: string): Boolean;
var
  FStream: TFileStream;
  LNum: UInt64;
begin
  Result := False;
  if not TFile.Exists(aFilename) then Exit;
  FStream := TFile.OpenRead(aFilename);
  if FStream = nil then Exit;
  if FStream.Size = 0 then
  begin
    FreeAndNil(FStream);
    Exit;
  end;
  LNum := LoadFromStream(FStream);
  FreeAndNil(FStream);
  Result := Boolean(LNum <> 0);
end;

function TGVBuffer.SaveToFile(const aFilename: string): Boolean;
var
  FStream: TFileStream;
  LNum: UInt64;
begin
  Result := False;
  FStream := TFile.Create(aFilename);
  if FStream = nil then Exit;
  LNum := SaveToStream(FStream);
  FreeAndNil(FStream);
  Result := Boolean(LNum <> 0);
end;

function TGVBuffer.LoadFromStream(const aStream: TStream): UInt64;
var
  LNum: Integer;
  LBuffer: TBytes;
begin
  Result := 0;
  if aStream = nil then Exit;
  if aStream.Size = 0 then Exit;
  Release;
  Allocate(aStream.Size);
  aStream.Position := 0;
  SetLength(LBuffer, GV_BUFFER_COPYCACHESIZE);
  while True do
  begin
    LNum := aStream.Read(LBuffer, GV_BUFFER_COPYCACHESIZE);
    if LNum = 0 then Break;
    Write(LBuffer, LNum);
    Inc(Result, LNum);
  end;
end;

function TGVBuffer.SaveToStream(const aStream: TStream): UInt64;
var
  LNum: Integer;
  LBuffer: TBytes;
begin
  Result := 0;
  if FHandle = 0 then Exit;
  if FMemory = nil then Exit;
  FPosition := 0;
  SetLength(LBuffer, GV_BUFFER_COPYCACHESIZE);
  while True do
  begin
    LNum := Read(LBuffer, GV_BUFFER_COPYCACHESIZE);
    if LNum = 0 then Break;
    aStream.Write(LBuffer, LNum);
    Inc(Result, LNum);
  end;
end;

function TGVBuffer.Eof: Boolean;
begin
  Result := Boolean(FPosition >= FSize);
end;

class function TGVBuffer.LoadFromResource(aInstance: THandle; const aResName: string): TGVBuffer;
var
  LStream: TResourceStream;
begin
  Result := nil;
  if not TGVUtil.ResourceExists(aInstance, aResName) then Exit;
  LStream := TResourceStream.Create(aInstance, aResName, RT_RCDATA);
  try
    Result := TGVBuffer.Create;
    Result.LoadFromStream(LStream);
  finally
    FreeAndNil(LStream);
  end;
end;

class function  TGVBuffer.ReadString(const aBuffer: TGVBuffer): string;
var
  LLength: LongInt;
begin
  aBuffer.Read(@LLength, SizeOf(LLength));
  SetLength(Result, LLength);
  if LLength > 0 then aBuffer.Read(@Result[1], LLength * SizeOf(Char));
end;

end.
