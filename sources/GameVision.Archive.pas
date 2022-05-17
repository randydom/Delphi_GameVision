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

unit GameVision.Archive;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  GameVision.Allegro,
  GameVision.CSFMLAudio,
  GameVision.Common,
  GameVision.Base,
  GameVision.Buffer;

type
  { TGVArchiveBuildProgressEvent }
  TGVArchiveBuildProgressEvent = procedure(const aFilename: string; aProgress: Integer; aNewFile: Boolean) of object;

  { TGVArchiveFile}
  TGVArchiveFile = class;

  { TGVArchive }
  TGVArchive = class(TGVObject)
  protected
    FPassword: string;
    FFilename: string;
    FPasswordFilename: string;
    FIsOpen: Boolean;
    function GetCRC32(aStream: TStream): Cardinal;
  public
    property IsOpen: Boolean read FIsOpen;
    constructor Create; override;
    destructor Destroy; override;
    function Open(const aPassword: string; const aFilename: string): Boolean;
    function Close: Boolean;
    function FileExist(const aFilename: string): Boolean;
    function GetPasswordFilename(const aFilename: string): PAnsiChar;
    function OpenFile(const aFilename: string): TGVArchiveFile; overload;
    function ExtractToBuffer(const aFilename: string): TGVBuffer;
    function Build(const aPassword: string; const aFilename: string; const aDirectory: string; aOnProgress: TGVArchiveBuildProgressEvent): Boolean;
  end;

  { TGVArchiveFile }
  TGVArchiveFile = class(TGVObject)
  protected
    FHandle: PALLEGRO_FILE;
    FInputStream: TsfInputStream;
    function InputStreamRead(aData: Pointer; aSize: Int64): Int64;
    function InputStreamSeek(aPosition: Int64): Int64;
    function InputStreamTell: Int64;
    function InputStreamGetSize: Int64;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Open(aArchive: TGVArchive; const aFilename: string): Boolean;
    function Close: Boolean;
    function IsOpen: Boolean;
    function Size: UInt64;
    function Eof: Boolean;
    function Seek(aOffset: Int64; aSeek: TGVSeekOperation): UInt64;
    function Tell: UInt64;
    function Read(aBuffer: Pointer; aSize: UInt64): UInt64;
    function LastError: string;
    function InputStream: PsfInputStream;
  end;

implementation

uses
  System.Types,
  System.IOUtils,
  WinApi.Windows,
  GameVision.ZLib,
  GameVision.Core;

{ TGVArchive }
function TGVArchive.GetCRC32(aStream: TStream): Cardinal;
var
  LBytesRead: Integer;
  LBuffer: array of Byte;
begin
  SetLength(LBuffer, 65521);

  Result := Crc32(0, nil, 0);
  repeat
    LBytesRead := AStream.Read(LBuffer[0], Length(LBuffer));
    Result := Crc32(Result, @LBuffer[0], LBytesRead);
  until LBytesRead = 0;

  LBuffer := nil;
end;

constructor TGVArchive.Create;
begin
  inherited;
  FFilename := '';
  FPassword := '';
  FIsOpen := False;
end;

destructor TGVArchive.Destroy;
begin
  Close;
  inherited;
end;

function TGVArchive.Open(const aPassword: string; const aFilename: string): Boolean;
var
  LMarshaller: TMarshaller;
begin
  Result := False;
  if FIsOpen then Exit;
  if not TFile.Exists(aFilename) then Exit;
  Result := Boolean(PHYSFS_mount(LMarshaller.AsUtf8(aFilename).ToPointer, nil, 1) <> 0);
  if Result then
  begin
    FPassword := aPassword;
    FFilename := aFilename;
    FPasswordFilename := '';
    FIsOpen := True;
  end;
end;

function TGVArchive.Close: Boolean;
var
  LMarshaller: TMarshaller;
begin
  Result := False;
  if not FIsOpen then Exit;
  Result := Boolean(PHYSFS_unmount(LMarshaller.AsUtf8(FFilename).ToPointer) <> 0);
  if Result then
  begin
    FIsOpen := False;
    FFilename := '';
    FPassword := '';
    FPasswordFilename := '';
  end;
end;

function TGVArchive.FileExist(const aFilename: string): Boolean;
var
  LMarshaller: TMarshaller;
begin
  Result := al_filename_exists(LMarshaller.AsUtf8(aFilename).ToPointer);
end;

function TGVArchive.GetPasswordFilename(const aFilename: string): PAnsiChar;
begin
  if FPassword.IsEmpty then
    FPasswordFilename := aFilename
  else
    FPasswordFilename := aFilename + '$' + FPassword;
  Result := PAnsiChar(AnsiString(FPasswordFilename));
end;

function TGVArchive.OpenFile(const aFilename: string): TGVArchiveFile;
var
  LResult: TGVArchiveFile;
begin
  Result := nil;
  if not FIsOpen then Exit;
  LResult := TGVArchiveFIle.Create;
  if not LResult.Open(Self, aFilename) then
  begin
    FreeAndNil(LResult);
    Exit;
  end;
  Result := LResult;
end;

function TGVArchive.ExtractToBuffer(const aFilename: string): TGVBuffer;
var
  LFile: TGVArchiveFile;
  LResult: TGVBuffer;
begin
  Result := nil;
  if not FIsOpen then Exit;
  LFile := OpenFile(aFilename);
  if LFile = nil then Exit;
  if LFile.Size = 0 then
  begin
    FreeAndNil(LFile);
    Exit;
  end;
  LResult := TGVBuffer.Create;
  if not LResult.Allocate(LFile.Size) then
  begin
    FreeAndNil(LResult);
    FreeAndNil(LFile);
    Exit;
  end;
  LFile.Read(LResult.Memory, LResult.Size);
  FreeAndNil(LFile);
  Result := LResult;
end;

function TGVArchive.Build(const aPassword: string; const aFilename: string; const aDirectory: string; aOnProgress: TGVArchiveBuildProgressEvent): Boolean;
var
  LMarshaller: array[0..1] of TMarshaller;
  LFileList: TStringDynArray;
  LFilename: string;
  LZipFile: zipFile;
  LZipFileInfo: zip_fileinfo;
  LFile: TStream;
  LCrc: Cardinal;
  LBytesRead: Integer;
  LBuffer: array of Byte;
  LFileSize: Int64;
  LProgress: Single;
  LNewFile: Boolean;
begin
  Result := False;

  // check if directory exists
  if not TDirectory.Exists(aDirectory) then Exit;

  // init variabls
  SetLength(LBuffer, 1024*4);
  FillChar(LZipFileInfo, SizeOf(LZipFileInfo), 0);

  // scan folder and build file list
  LFileList := TDirectory.GetFiles(aDirectory, '*', TSearchOption.soAllDirectories);

  // create a zip file
  LZipFile := zipOpen(LMarshaller[0].AsUtf8(aFilename).ToPointer, APPEND_STATUS_CREATE);

  // process zip file
  if LZipFile <> nil then
  begin
    // loop through all files in list
    for LFilename in LFileList do
    begin
      // open file
      LFile := TFile.OpenRead(LFilename);

      // get file size
      LFileSize := LFile.Size;

      // get file crc
      LCrc := GetCRC32(LFile);

      // open new file in zip
      if ZipOpenNewFileInZip3(LZipFile, LMarshaller[0].AsUtf8(LFilename).ToPointer,
        @LZipFileInfo, nil, 0, nil, 0, '',  Z_DEFLATED, 9, 0, 15, 9,
        Z_DEFAULT_STRATEGY, LMarshaller[1].AsUtf8(aPassword).ToPointer, LCrc) = Z_OK then
      begin
        // make sure we start at star of stream
        LFile.Position := 0;

        // this is a new file
        LNewFile := True;

        // read through file
        repeat
          // read in a buffer length of file
          LBytesRead := LFile.Read(LBuffer[0], Length(LBuffer));

          // write buffer out to zip file
          zipWriteInFileInZip(LZipFile, @LBuffer[0], LBytesRead);

          // calc file progress percentage
          LProgress := 100.0 * (LFile.Position / LFileSize);

          // show progress
          if Assigned(aOnProgress) then
            aOnProgress(LFilename, Round(LProgress), LNewFile);

          // reset new file flag
          LNewFile := False;
        until LBytesRead = 0;

        // close file in zip
        zipCloseFileInZip(LZipFile);

        // free file stream
        FreeAndNil(LFile);
      end;
    end;

    // close zip file
    zipClose(LZipFile, '');
  end;

  // return true if new zip file exits
  Result := TFile.Exists(aFilename);
end;

{ --- ARCHIVEFILE ----------------------------------------------------------- }
{ TGVArchiveFile }
function TArchiveFile_InputStreamRead(aData: Pointer; aSize: Int64; aUserData: Pointer): Int64; cdecl;
begin
  Result := TGVArchiveFile(aUserData).InputStreamRead(aData, aSize);
end;

function TArchiveFile_InputStreamSeek(aPosition: Int64; aUserData: Pointer): Int64; cdecl;
begin
  Result := TGVArchiveFile(aUserData).InputStreamSeek(aPosition);
end;

function TArchiveFile_InputStreamTell(aUserData: Pointer): Int64; cdecl;
begin
  Result := TGVArchiveFile(aUserData).InputStreamTell;
end;

function TArchiveFile_InputStreamGetSize(aUserData: Pointer): Int64; cdecl;
begin
  Result := TGVArchiveFile(aUserData).InputStreamGetSize;
end;

function TGVArchiveFile.InputStreamRead(aData: Pointer; aSize: Int64): Int64;
begin
  Result := Read(aData, aSize);
end;

function TGVArchiveFile.InputStreamSeek(aPosition: Int64): Int64;
begin
  Result := Seek(aPosition, soStart);
end;

function TGVArchiveFile.InputStreamTell: Int64;
begin
  Result := Tell;
end;

function TGVArchiveFile.InputStreamGetSize: Int64;
begin
  Result := self.Size;
end;

constructor TGVArchiveFile.Create;
begin
  inherited;
  FHandle := nil;
  FInputStream.read := nil;
  FINputStream.seek := nil;
  FINputStream.tell := nil;
  FInputStream.getSize := nil;
  FInputStream.userData := nil;
end;

destructor TGVArchiveFile.Destroy;
begin
  Close;
  inherited;
end;

function TGVArchiveFile.Open(aArchive: TGVArchive; const aFilename: string): Boolean;
var
  LHandle: PALLEGRO_FILE;
begin
  Result := False;
  if IsOpen then Exit;
  if aArchive = nil then Exit;
  if not aArchive.IsOpen then Exit;
  if not aArchive.FileExist(aFilename) then Exit;
  if aArchive = nil then GV.SetFileSandBoxed(False);
  LHandle := al_fopen(aArchive.GetPasswordFilename(aFilename), 'rb');
  if aArchive = nil then GV.SetFileSandBoxed(True);
  if LHandle = nil then Exit;
  FHandle := LHandle;
  Result := IsOpen;

  FInputStream.read := TArchiveFile_InputStreamRead;
  FINputStream.seek := TArchiveFile_InputStreamSeek;
  FINputStream.tell := TArchiveFile_InputStreamTell;
  FInputStream.getSize := TArchiveFile_InputStreamGetSize;
  FInputStream.userData := Self;
end;

function TGVArchiveFile.Close: Boolean;
begin
  Result := False;
  if not IsOpen then Exit;
  Result := al_fclose(FHandle);
  if Result then
  begin
    FHandle := nil;
    FInputStream.read := nil;
    FINputStream.seek := nil;
    FINputStream.tell := nil;
    FInputStream.getSize := nil;
    FInputStream.userData := nil;
  end;
end;

function TGVArchiveFile.IsOpen: Boolean;
begin
  Result := Boolean(FHandle <> nil);
end;

function TGVArchiveFile.Size: UInt64;
begin
  Result := 0;
  if not IsOpen then Exit;
  Result := al_fsize(FHandle);
end;

function TGVArchiveFile.Eof: Boolean;
begin
  Result := False;
  if not IsOpen then Exit;
  Result := al_feof(FHandle);
end;

function TGVArchiveFile.Seek(aOffset: Int64; aSeek: TGVSeekOperation): UInt64;
var
  LSeek: Boolean;
begin
  Result := 0;
  if not IsOpen then Exit;
  LSeek := al_fseek(FHandle, aOffset, Ord(aSeek));
  if LSeek then
    Result := Self.Tell;
end;

function TGVArchiveFile.Tell: UInt64;
var
  LResult: Int64;
begin
  Result := 0;
  if not IsOpen then Exit;
  LResult := al_ftell(FHandle);
  if LResult = -1 then Exit;
  Result := LResult;
end;

function TGVArchiveFile.Read(aBuffer: Pointer; aSize: UInt64): UInt64;
begin
  Result := 0;
  if not IsOpen then Exit;
  Result := al_fread(FHandle, aBuffer, aSize);
end;

function TGVArchiveFile.LastError: string;
begin
  Result := '';
  if not IsOpen then Exit;
  Result := string(al_ferrmsg(FHandle));
end;

function TGVArchiveFile.InputStream: PsfInputStream;
begin
  Result := @FInputStream;
end;

end.
