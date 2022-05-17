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

unit GameVision.Audio;

{$I GameVision.Defines.inc}

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  GameVision.CSFMLAudio,
  GameVision.Base,
  GameVision.Archive;

const
  AUDIO_BUFFER_COUNT   = 256;
  AUDIO_CHANNEL_COUNT   = 16;
  AUDIO_DYNAMIC_CHANNEL = -1;
  AUDIO_INVALID_INDEX   = -2;

  AUDIO_MAX_CHANNELS = 16;

type
  TGVMusic        = type Integer;
  TGVSound        = type Integer;
  TGVSoundChannel = type Integer;

  { TGVAudioStatus }
  TGVAudioStatus = (Stopped, Paused, Playing);

  { TGVAudio }
  TGVAudio = class(TGVObject)
  protected
    type
      { TMusicItem }
      TMusicItem = record
        MusicHandle: PsfMusic;
        Size: Int64;
        Filename: string;
        MusicFile: TGVArchiveFile;
      end;

      { TAudioChannel }
      TAudioChannel = record
        Sound: PsfSound;
        Reserved: Boolean;
        Priority: Byte;
      end;
      { TAudioBuffer }
      TAudioBuffer = record
        Buffer: PsfSoundBuffer;
        Filename: string;
      end;
  protected
    FMusicList: TList<TMusicItem>;
    FBuffer: array [0 .. AUDIO_BUFFER_COUNT - 1] of TAudioBuffer;
    FChannel: array [0 .. AUDIO_CHANNEL_COUNT - 1] of TAudioChannel;
    FOpened: Boolean;
    function TimeAsSeconds(aValue: Single): TsfTime;
    function GetMusicItem(var aMusicItem: TMusicItem; aMusic: Integer): Boolean;
    function AddMusicItem(var aMusicItem: TMusicItem): Integer;
    function FindFreeBuffer(aFilename: string): Integer;
    function FindFreeChannel: Integer;
    procedure PlayMusic(aMusic: Integer); overload;
    function  PlaySound(aChannel: Integer; aSound: Integer): Integer; overload;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Open;
    procedure Close;
    procedure Pause(aPause: Boolean);
    procedure Reset;
    function  LoadMusic(aArchive: TGVArchive; const aFilename: string): Integer;
    procedure UnloadMusic(var aMusic: Integer);
    procedure UnloadAllMusic;
    procedure PlayMusic(aMusic: Integer; aVolume: Single; aLoop: Boolean); overload;
    procedure StopMusic(aMusic: Integer);
    procedure PauseMusic(aMusic: Integer);
    procedure PauseAllMusic(aPause: Boolean);
    procedure SetMusicLoop(aMusic: Integer; aLoop: Boolean);
    function  GetMusicLoop(aMusic: Integer): Boolean;
    procedure SetMusicVolume(aMusic: Integer; aVolume: Single);
    function  GetMusicVolume(aMusic: Integer): Single;
    function  GetMusicStatus(aMusic: Integer): TGVAudioStatus;
    procedure SetMusicOffset(aMusic: Integer; aSeconds: Single);
    function  LoadSound(aArchive: TGVArchive; const aFilename: string): Integer;
    procedure UnloadSound(aSound: Integer);
    function  PlaySound(aChannel: Integer; aSound: Integer; aVolume: Single; aLoop: Boolean): Integer; overload;
    procedure SetChannelReserved(aChannel: Integer; aReserve: Boolean);
    function  GetChannelReserved(aChannel: Integer): Boolean;
    procedure PauseChannel(aChannel: Integer; aPause: Boolean);
    function  GetChannelStatus(aChannel: Integer): TGVAudioStatus;
    procedure SetChannelVolume(aChannel: Integer; aVolume: Single);
    function  GetChannelVolume(aChannel: Integer): Single;
    procedure SetChannelLoop(aChannel: Integer; aLoop: Boolean);
    function  GetChannelLoop(aChannel: Integer): Boolean;
    procedure SetChannelPitch(aChannel: Integer; aPitch: Single);
    function  GetChannelPitch(aChannel: Integer): Single;
    procedure SetChannelPosition(aChannel: Integer; aX: Single; aY: Single);
    procedure GetChannelPosition(aChannel: Integer; var aX: Single; var aY: Single);
    procedure SetChannelMinDistance(aChannel: Integer; aDistance: Single);
    function  GetChannelMinDistance(aChannel: Integer): Single;
    procedure SetChannelRelativeToListener(aChannel: Integer; aRelative: Boolean);
    function  GetChannelRelativeToListener(aChannel: Integer): Boolean;
    procedure SetChannelAttenuation(aChannel: Integer; aAttenuation: Single);
    function  GetChannelAttenuation(aChannel: Integer): Single;
    procedure StopChannel(aChannel: Integer);
    procedure StopAllChannels;
    procedure SetListenerGlobalVolume(aVolume: Single);
    function  GetListenerGlobalVolume: Single;
    procedure SetListenerPosition(aX: Single; aY: Single);
    procedure GetListenerPosition(var aX: Single; var aY: Single);
  end;

implementation

uses
  System.IOUtils,
  GameVision.Core;

{ TGVAudio }
function TGVAudio.TimeAsSeconds(aValue: Single): TsfTime;
begin
  Result.MicroSeconds := Round(aValue * 1000000);
end;

function TGVAudio.GetMusicItem(var aMusicItem: TMusicItem; aMusic: Integer): Boolean;
begin
  // assume false
  Result := False;

  // check for valid music id
  if (aMusic < 0) or (aMusic > FMusicList.Count-1) then Exit;

  // get item
  aMusicItem := FMusicList.Items[aMusic];

  // check if valid
  if aMusicItem.MusicHandle = nil then
    Result := False
  else
    // return true
    Result := True;
end;

function TGVAudio.AddMusicItem(var aMusicItem: TMusicItem): Integer;
var
  LIndex: Integer;
  LItem: TMusicItem;
begin
  Result := -1;
  for LIndex := 0 to FMusicList.Count-1 do
  begin
    LItem := FMusicList.Items[LIndex];
    if LItem.MusicHandle = nil then
    begin
      FMusicList.Items[LIndex] := aMusicItem;
      Result := LIndex;
      Exit;
    end;
  end;

  //if LItem.MusicHandle <> nil then
  if Result = -1 then
  begin
    Result := FMusicList.Add(aMusicItem);
  end;
end;

function TGVAudio.FindFreeBuffer(aFilename: string): Integer;
var
  LI: Integer;
begin
  Result := AUDIO_INVALID_INDEX;
  for LI := 0 to AUDIO_BUFFER_COUNT - 1 do
  begin
    if FBuffer[LI].Filename = aFilename then
    begin
      Exit;
    end;

    if FBuffer[LI].Buffer = nil then
    begin
      Result := LI;
      Break;
    end;
  end;
end;

function TGVAudio.FindFreeChannel: Integer;
var
  LI: Integer;
begin
  Result := AUDIO_INVALID_INDEX;
  for LI := 0 to AUDIO_CHANNEL_COUNT - 1 do
  begin
    if sfSound_getStatus(FChannel[LI].Sound) =   TsfSoundStatus.sfStopped then
    begin
      if not FChannel[LI].Reserved then
      begin
        Result := LI;
        Break;
      end;
    end;
  end;
end;

procedure TGVAudio.Open;
var
  LI: Integer;
  LVec: TsfVector3f;
begin
  if FOpened then Exit;

  //FillChar(FBuffer, SizeOf(FBuffer), 0);
  //FillChar(FChannel, SizeOf(FChannel), 0);
  FOpened := False;

  // init music list
  FMusicList := TList<TMusicItem>.Create;

  // init channels
  for LI := 0 to AUDIO_CHANNEL_COUNT - 1 do
  begin
    FChannel[LI].Sound := sfSound_create;
    FChannel[LI].Reserved := False;
    FChannel[LI].Priority := 0;
  end;

  // init buffers
  for LI := 0 to AUDIO_BUFFER_COUNT - 1 do
  begin
    FBuffer[LI].Buffer := nil;
    FBuffer[LI].Filename := '';
  end;

  sfListener_setGlobalVolume(100);

  LVec.X := 0; LVec.Y := 0; LVec.Z := 0;
  sfListener_setPosition(LVec);

  LVec.X := 0; LVec.Y := 0; LVec.Z := -1;
  sfListener_setDirection(LVec);

  LVec.X := 0; LVec.Y := 1; LVec.Z := 0;
  sfListener_setUpVector(LVec);

  FOpened := True;

  GV.Logger.Log('Initialized %s Subsystem', ['Audio']);
end;

procedure TGVAudio.Close;
var
  LI: Integer;
begin
  if not FOpened then Exit;

  // shutdown music
  UnloadAllMusic;
  FreeAndNil(FMusicList);

  // shutdown channels
  for LI := 0 to AUDIO_CHANNEL_COUNT - 1 do
  begin
    if FChannel[LI].Sound <> nil then
    begin
      sfSound_destroy(FChannel[LI].Sound);
      FChannel[LI].Reserved := False;
      FChannel[LI].Priority := 0;
      FChannel[LI].Sound := nil;
    end;
  end;

  // shutdown buffers
  for LI := 0 to AUDIO_BUFFER_COUNT - 1 do
  begin
    if FBuffer[LI].Buffer <> nil then
    begin
      sfSoundBuffer_destroy(FBuffer[LI].Buffer);
      FBuffer[LI].Buffer := nil;
      FBuffer[LI].Filename := '';
    end;
  end;

  //FillChar(FBuffer, SizeOf(FBuffer), 0);
  //FillChar(FChannel, SizeOf(FChannel), 0);
  FOpened := False;

  GV.Logger.Log('Shutdown %s Subsystem', ['Audio']);
end;

procedure TGVAudio.PlayMusic(aMusic: Integer);
var
  LItem: TMusicItem;
begin
  if not FOpened then Exit;

  // check for valid music id
  if not GetMusicItem(LItem, aMusic) then Exit;

  // play music
  sfMusic_play(LItem.MusicHandle);
end;

function  TGVAudio.PlaySound(aChannel: Integer; aSound: Integer): Integer;
var
  LI: Integer;
  LVec: TsfVector3f;
begin
  Result := AUDIO_INVALID_INDEX;
  if not FOpened then Exit;

  // check if sound is in range
  if (aSound < 0) or (aSound > AUDIO_BUFFER_COUNT - 1) then Exit;

  // check if channel is in range
  LI := aChannel;
  if LI = AUDIO_DYNAMIC_CHANNEL then LI := FindFreeChannel
  else if (LI < 0) or (LI > AUDIO_CHANNEL_COUNT - 1) then Exit;

  // play sound
  sfSound_setBuffer(FChannel[LI].Sound, FBuffer[aSound].Buffer);
  sfSound_play(FChannel[LI].Sound);

  sfSound_setLoop(FChannel[LI].Sound, Ord(False));
  sfSound_setPitch(FChannel[LI].Sound, 1);
  sfSound_setVolume(FChannel[LI].Sound, 100);

  LVec.X := 0; LVec.Y := 0; LVec.Z := 0;
  sfSound_setPosition(FChannel[LI].Sound, LVec);

  sfSound_setRelativeToListener(FChannel[LI].Sound, Ord(False));
  sfSound_setMinDistance(FChannel[LI].Sound, 1);
  sfSound_setAttenuation(FChannel[LI].Sound, 0);

  Result := LI;
end;

constructor TGVAudio.Create;
begin
  inherited;
  Open;
end;

destructor TGVAudio.Destroy;
begin
  Close;
  inherited;
end;

procedure TGVAudio.Pause(aPause: Boolean);
var
  LI: Integer;
begin
  if not FOpened then Exit;

  PauseAllMusic(aPause);

  // pause channel
  for LI := 0 to AUDIO_CHANNEL_COUNT - 1 do
  begin
    PauseChannel(LI, aPause);
  end;
end;

procedure TGVAudio.Reset;
begin
end;

function  TGVAudio.LoadMusic(aArchive: TGVArchive; const aFilename: string): Integer;
var
  LItem: TMusicItem;
  LArchiveFile: TGVArchiveFile;
begin
  Result := -1;
  if not FOpened then Exit;
  if aFilename.IsEmpty then Exit;

  if aArchive <> nil then
    begin
      if not aArchive.IsOpen then Exit;
      if not aArchive.FileExist(aFilename) then Exit;
      LArchiveFile := aArchive.OpenFile(aFilename);
      if LArchiveFile = nil then Exit;
    end
  else
    begin
      if not TFile.Exists(aFilename) then Exit;
      LArchiveFile := TGVArchiveFile.Create;
      if LArchiveFile = nil then Exit;
      if not LArchiveFile.Open(nil, aFilename) then
      begin
        FreeAndNil(LArchiveFile);
        Exit;
      end;
    end;

  LItem.Filename := aFilename;
  LItem.Size := LArchiveFile.Size;
  LItem.MusicHandle := sfMusic_createFromStream(LArchiveFile.InputStream);
  if LItem.MusicHandle = nil then
  begin
    FreeAndNil(LArchiveFile);
    GV.Logger.Log('Failed to load music file: %s', [aFilename]);
    Exit;
  end;
  LItem.MusicFile := LArchiveFile;

  Result := AddMusicItem(LItem);

  GV.Logger.Log('Sucessfully loaded music "%s"', [aFilename]);
end;

procedure TGVAudio.UnloadMusic(var aMusic: Integer);
var
  LItem: TMusicItem;
begin
  if not FOpened then Exit;

  // check for valid music id
  if not GetMusicItem(LItem, aMusic) then Exit;

  // stop music
  StopMusic(aMusic);

  // free music handle
  sfMusic_destroy(LItem.MusicHandle);

  // free music file
  FreeAndNil(LItem.MusicFile);

  // clear item data
  LItem.MusicHandle := nil;
  LItem.Size := 0;
  LItem.Filename := '';
  LItem.MusicFile := nil;
  FMusicList.Items[aMusic] := LItem;

  GV.Logger.Log('Unloaded music "%s"', [LItem.Filename]);

  // return handle as invalid
  aMusic := -1;
end;

procedure TGVAudio.UnloadAllMusic;
var
  LIndex: Integer;
  LMusic: Integer;
begin
  if not FOpened then Exit;

  for LIndex := 0 to FMusicList.Count-1 do
  begin
    LMusic := LIndex;
    StopMusic(LMusic);
    UnloadMusic(LMusic);
  end;
end;

procedure TGVAudio.PlayMusic(aMusic: Integer; aVolume: Single; aLoop: Boolean);
begin
  if not FOpened then Exit;

  PlayMusic(aMusic);
  SetMusicVolume(aMusic, aVolume);
  SetMusicLoop(aMusic, aLoop);
end;

procedure TGVAudio.StopMusic(aMusic: Integer);
var
  LItem: TMusicItem;
begin
  if not FOpened then Exit;

  // check for valid music id
  if not GetMusicItem(LItem, aMusic) then Exit;

  // stop music playing
  sfMusic_stop(LItem.MusicHandle);
end;

procedure TGVAudio.PauseMusic(aMusic: Integer);
var
  LItem: TMusicItem;
begin
  if not FOpened then Exit;

  // check for valid music id
  if not GetMusicItem(LItem, aMusic) then Exit;

  // pause audio
  sfMusic_pause(LItem.MusicHandle);
end;

procedure TGVAudio.PauseAllMusic(aPause: Boolean);
var
  LItem: TMusicItem;
  LIndex: Integer;
begin
  if not FOpened then Exit;

  for LIndex := 0 to FMusicList.Count-1 do
  begin
    if GetMusicItem(LItem, LIndex) then
    begin
      if aPause then
        PauseMusic(LIndex)
      else
        PlayMusic(LIndex);
    end;
  end;
end;

procedure TGVAudio.SetMusicLoop(aMusic: Integer; aLoop: Boolean);
var
  LItem: TMusicItem;
begin
  if not FOpened then Exit;

  // check for valid music id
  if not GetMusicItem(LItem, aMusic) then Exit;

  // set music loop status
  sfMusic_setLoop(LItem.MusicHandle, Ord(aLoop));
end;

function  TGVAudio.GetMusicLoop(aMusic: Integer): Boolean;
var
  LItem: TMusicItem;
begin
  Result := False;

  if not FOpened then Exit;

  // check for valid music id
  if not GetMusicItem(LItem, aMusic) then Exit;

  // get music loop status
  Result := Boolean(sfMusic_getLoop(LItem.MusicHandle));
end;

procedure TGVAudio.SetMusicVolume(aMusic: Integer; aVolume: Single);
var
  LVol: Single;
  LItem: TMusicItem;
begin
  if not FOpened then Exit;

  // check for valid music id
  if not GetMusicItem(LItem, aMusic) then Exit;

  // check volume range
  if aVolume < 0 then
    aVolume := 0
  else if aVolume > 1 then
    aVolume := 1;

  // unnormalize value
  LVol := aVolume * 100;

  // set music volume
  sfMusic_setVolume(LItem.MusicHandle, LVol);
end;

function  TGVAudio.GetMusicVolume(aMusic: Integer): Single;
var
  LItem: TMusicItem;
begin
  Result := 0;
  if not FOpened then Exit;
  if not GetMusicItem(LItem, aMusic) then Exit;
  Result := sfMusic_getVolume(LItem.MusicHandle);
  Result := Result / 100;
end;

function  TGVAudio.GetMusicStatus(aMusic: Integer): TGVAudioStatus;
var
  LItem: TMusicItem;
begin
  Result := TGVAudioStatus.Stopped;
  if not FOpened then Exit;
  if not GetMusicItem(LItem, aMusic) then Exit;
  Result := TGVAudioStatus(sfMusic_getStatus(LItem.MusicHandle));
end;

procedure TGVAudio.SetMusicOffset(aMusic: Integer; aSeconds: Single);
var
  LItem: TMusicItem;
begin
  if not FOpened then Exit;
  if not GetMusicItem(LItem, aMusic) then Exit;
  sfMusic_setPlayingOffset(LItem.MusicHandle, TimeAsSeconds(aSeconds));
end;

function  TGVAudio.LoadSound(aArchive: TGVArchive; const aFilename: string): Integer;
var
  LI: Integer;
  LArchiveFile: TGVArchiveFile;
begin
  Result := AUDIO_INVALID_INDEX;
  if not FOpened then Exit;
  if aFilename.IsEmpty then Exit;

  if aArchive <> nil then
    begin
      if not aArchive.IsOpen then Exit;
      if not aArchive.FileExist(aFilename) then Exit;
      LArchiveFile := aArchive.OpenFile(aFilename);
      if LArchiveFile = nil then Exit;
    end
  else
    begin
      if not TFile.Exists(aFilename) then Exit;
      LArchiveFile := TGVArchiveFile.Create;
      if not LArchiveFile.Open(nil, aFilename) then
      begin
        GV.Logger.Log('Failed to load sound file: %s', [aFilename]);
        FreeAndNil(LArchiveFile);
        Exit;
      end;
    end;

  LI := FindFreeBuffer(aFilename);
  if LI = AUDIO_INVALID_INDEX then Exit;

  FBuffer[LI].Buffer := sfSoundBuffer_createFromStream(LArchiveFile.InputStream);
  if FBuffer[LI].Buffer = nil then
  begin
    FreeAndNil(LArchiveFile);
    GV.Logger.Log('Failed to load sound file: %s', [aFilename]);
    Exit;
  end;

  FBuffer[LI].Filename := aFilename;
  GV.Logger.Log('Sucessfully loaded sound "%s"', [aFilename]);

  FreeAndNil(LArchiveFile);

  Result := LI;
end;

procedure TGVAudio.UnloadSound(aSound: Integer);
var
  LBuff: PsfSoundBuffer;
  LSnd: PsfSound;
  LI: Integer;
begin
  if not FOpened then Exit;

  if (aSound < 0) or (aSound > AUDIO_BUFFER_COUNT - 1) then  Exit;
  LBuff := FBuffer[aSound].Buffer;
  if LBuff = nil then Exit;

  // stop all channels playing this buffer
  for LI := 0 to AUDIO_CHANNEL_COUNT - 1 do
  begin
    LSnd := FChannel[LI].Sound;
    if LSnd <> nil then
    begin
      if sfSound_getBuffer(LSnd) = LBuff then
      begin
        sfSound_stop(LSnd);
        sfSound_destroy(LSnd);
        FChannel[LI].Sound := nil;
        FChannel[LI].Reserved := False;
        FChannel[LI].Priority := 0;
      end;
    end;
  end;

  // destroy this buffer
  sfSoundBuffer_destroy(LBuff);
  GV.Logger.Log('Unloaded sound "%s"', [FBuffer[aSound].Filename]);
  FBuffer[aSound].Buffer := nil;
  FBuffer[aSound].Filename := '';
end;

function  TGVAudio.PlaySound(aChannel: Integer; aSound: Integer; aVolume: Single; aLoop: Boolean): Integer;
begin
  Result := AUDIO_INVALID_INDEX;
  if not FOpened then Exit;

  Result := PlaySound(aChannel, aSound);
  SetChannelVolume(Result, aVolume);
  SetChannelLoop(Result, aLoop);
end;

procedure TGVAudio.SetChannelReserved(aChannel: Integer; aReserve: Boolean);
begin
  if not FOpened then Exit;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  FChannel[aChannel].Reserved := aReserve;
end;

function  TGVAudio.GetChannelReserved(aChannel: Integer): Boolean;
begin
  Result := False;
  if not FOpened then Exit;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then  Exit;
  Result := FChannel[aChannel].Reserved;
end;

procedure TGVAudio.PauseChannel(aChannel: Integer; aPause: Boolean);
var
  LStatus: TsfSoundStatus;
begin
  if not FOpened then Exit;

  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;

  LStatus := sfSound_getStatus(FChannel[aChannel].Sound);

  case aPause of
    False:
      begin
        if LStatus = TsfSoundStatus.sfPaused then
          sfSound_play(FChannel[aChannel].Sound);
      end;
    True:
      begin
        if LStatus = TsfSoundStatus.sfPlaying then
          sfSound_pause(FChannel[aChannel].Sound);
      end;
  end;
end;

function  TGVAudio.GetChannelStatus(aChannel: Integer): TGVAudioStatus;
begin
  Result := TGVAudioStatus.Stopped;
  if not FOpened then Exit;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  Result := TGVAudioStatus(sfSound_getStatus(FChannel[aChannel].Sound));
end;

procedure TGVAudio.SetChannelVolume(aChannel: Integer; aVolume: Single);
var
  LV: Single;
begin
  if not FOpened then Exit;

  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;

  if aVolume < 0 then
    aVolume := 0
  else if aVolume > 1 then
    aVolume := 1;

  LV := aVolume * 100;
  sfSound_setVolume(FChannel[aChannel].Sound, LV);
end;

function  TGVAudio.GetChannelVolume(aChannel: Integer): Single;
begin
  Result := 0;
  if not FOpened then Exit;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  Result := sfSound_getVolume(FChannel[aChannel].Sound);
  Result := Result / 100;
end;

procedure TGVAudio.SetChannelLoop(aChannel: Integer; aLoop: Boolean);
begin
  if not FOpened then Exit;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  sfSound_setLoop(FChannel[aChannel].Sound, Ord(aLoop));
end;

function  TGVAudio.GetChannelLoop(aChannel: Integer): Boolean;
begin
  Result := False;
  if not FOpened then Exit;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  Result := Boolean(sfSound_getLoop(FChannel[aChannel].Sound));
end;

procedure TGVAudio.SetChannelPitch(aChannel: Integer; aPitch: Single);
begin
  if not FOpened then Exit;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  sfSound_setPitch(FChannel[aChannel].Sound, aPitch);
end;

function  TGVAudio.GetChannelPitch(aChannel: Integer): Single;
begin
  Result := 0;
  if not FOpened then Exit;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then  Exit;
  Result := sfSound_getPitch(FChannel[aChannel].Sound);
end;

procedure TGVAudio.SetChannelPosition(aChannel: Integer; aX: Single; aY: Single);
var
  LV: TsfVector3f;
begin
  if not FOpened then Exit;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  LV.X := aX;
  LV.Y := 0;
  LV.Z := aY;
  sfSound_setPosition(FChannel[aChannel].Sound, LV);
end;

procedure TGVAudio.GetChannelPosition(aChannel: Integer; var aX: Single; var aY: Single);
var
  LV: TsfVector3f;
begin
  if not FOpened then Exit;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  LV := sfSound_getPosition(FChannel[aChannel].Sound);
  aX := LV.X;
  aY := LV.Z;
end;

procedure TGVAudio.SetChannelMinDistance(aChannel: Integer; aDistance: Single);
begin
  if not FOpened then Exit;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  if aDistance < 1 then  aDistance := 1;
  sfSound_setMinDistance(FChannel[aChannel].Sound, aDistance);
end;

function  TGVAudio.GetChannelMinDistance(aChannel: Integer): Single;
begin
  Result := 0;
  if not FOpened then Exit;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  Result := sfSound_getMinDistance(FChannel[aChannel].Sound);
end;

procedure TGVAudio.SetChannelRelativeToListener(aChannel: Integer; aRelative: Boolean);
begin
  if not FOpened then Exit;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  sfSound_setRelativeToListener(FChannel[aChannel].Sound, Ord(aRelative));
end;

function  TGVAudio.GetChannelRelativeToListener(aChannel: Integer): Boolean;
begin
  Result := False;
  if not FOpened then Exit;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  Result := Boolean(sfSound_isRelativeToListener(FChannel[aChannel].Sound));
end;

procedure TGVAudio.SetChannelAttenuation(aChannel: Integer; aAttenuation: Single);
begin
  if not FOpened then Exit;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then  Exit;
  sfSound_setAttenuation(FChannel[aChannel].Sound, aAttenuation);
end;

function  TGVAudio.GetChannelAttenuation(aChannel: Integer): Single;
begin
  Result := 0;
  if not FOpened then Exit;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  Result := sfSound_getAttenuation(FChannel[aChannel].Sound);
end;

procedure TGVAudio.StopChannel(aChannel: Integer);
begin
  if not FOpened then Exit;
  if (aChannel < 0) or (aChannel > AUDIO_CHANNEL_COUNT - 1) then Exit;
  sfSound_stop(FChannel[aChannel].Sound);
end;

procedure TGVAudio.StopAllChannels;
var
  LI: Integer;
begin
  if not FOpened then Exit;
  for LI := 0 to AUDIO_CHANNEL_COUNT-1 do
  begin
    sfSound_stop(FChannel[LI].Sound);
  end;
end;

procedure TGVAudio.SetListenerGlobalVolume(aVolume: Single);
var
  LV: Single;
begin
  if not FOpened then Exit;
  LV := aVolume;
  if (LV < 0) then
    LV := 0
  else if (LV > 1) then
    LV := 1;

  LV := LV * 100;
  sfListener_setGlobalVolume(LV);
end;

function  TGVAudio.GetListenerGlobalVolume: Single;
begin
  Result := 0;
  if not FOpened then Exit;
  Result := sfListener_getGlobalVolume;
  Result := Result / 100;
end;

procedure TGVAudio.SetListenerPosition(aX: Single; aY: Single);
var
  LV: TsfVector3f;
begin
  if not FOpened then Exit;
  LV.X := aX;
  LV.Y := 0;
  LV.Z := aY;
  sfListener_setPosition(LV);
end;

procedure TGVAudio.GetListenerPosition(var aX: Single; var aY: Single);
var
  LV: TsfVector3f;
begin
  if not FOpened then Exit;
  LV := sfListener_getPosition;
  aX := LV.X;
  aY := LV.Z;
end;
end.
