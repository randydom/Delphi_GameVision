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

unit GameVision.CSFMLAudio;

{$I GameVision.Defines.inc}

{$MINENUMSIZE 4}
{$WARN SYMBOL_PLATFORM OFF}

interface

const
  CSFMLAUDIO_DLL = 'csfml-audio-2.dll';

  sfFalse = 0;
  sfTrue = 1;

type
  TsfBool = type Integer;

  TsfTime = record
    MicroSeconds: Int64;
  end;

  TsfVector3f = record
    X, Y, Z: Single;
  end;

  TsfInputStreamReadFunc = function(Data: Pointer; Size: Int64; UserData: Pointer): Int64; cdecl;
  TsfInputStreamSeekFunc = function(Position: Int64; UserData: Pointer): Int64; cdecl;
  TsfInputStreamTellFunc = function(UserData: Pointer): Int64; cdecl;
  TsfInputStreamGetSizeFunc = function(UserData: Pointer): Int64; cdecl;

  PsfInputStream = ^TsfInputStream;
  TsfInputStream = record
    Read: TsfInputStreamReadFunc;
    Seek: TsfInputStreamSeekFunc;
    Tell: TsfInputStreamTellFunc;
    GetSize: TsfInputStreamGetSizeFunc;
    UserData: Pointer;
  end;

  PsfMusic = ^TsfMusic;
  TsfMusic = record end;

  PsfSound = ^TsfSound;
  TsfSound = record end;

  PsfSoundBuffer = ^TsfSoundBuffer;
  TsfSoundBuffer = record end;

  PsfSoundBufferRecorder = ^TsfSoundBufferRecorder;
  TsfSoundBufferRecorder = record end;

  PsfSoundRecorder = ^TsfSoundRecorder;
  TsfSoundRecorder = record end;

  PsfSoundStream = ^TsfSoundStream;
  TsfSoundStream = record end;

  TsfSoundStatus = (sfStopped, sfPaused, sfPlaying);

  PsfSoundStreamChunk = ^TsfSoundStreamChunk;
  TsfSoundStreamChunk = record
    Samples: PSmallInt;
    SampleCount: Cardinal;
  end;

  TsfSoundStreamGetDataCallback = function(Chunk: PsfSoundStreamChunk; UserData: Pointer): Boolean; cdecl;
  TsfSoundStreamSeekCallback = procedure(Time: TsfTime; UserData: Pointer); cdecl;
  TsfSoundRecorderStartCallback = function(UserData: Pointer): Boolean; cdecl;
  TsfSoundRecorderProcessCallback = function(Data: PSmallInt; SampleFrames: NativeUInt; UserData: Pointer): Boolean; cdecl;
  TsfSoundRecorderStopCallback = procedure(UserData: Pointer); cdecl;

  TsfTimeSpan = record
    offset: TsfTime;
    length: TsfTime;
  end;

  // Listener
procedure sfListener_setGlobalVolume(Volume: Single); cdecl; external CSFMLAUDIO_DLL delayed;
function  sfListener_getGlobalVolume: Single; cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfListener_setPosition(Position: TsfVector3f); cdecl; external CSFMLAUDIO_DLL delayed;
function  sfListener_getPosition: TsfVector3f; cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfListener_setDirection(Direction: TsfVector3f); cdecl; external CSFMLAUDIO_DLL delayed;
function  sfListener_getDirection: TsfVector3f; cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfListener_setUpVector(UpVector: TsfVector3f); cdecl; external CSFMLAUDIO_DLL delayed;
function  sfListener_getUpVector: TsfVector3f; cdecl; external CSFMLAUDIO_DLL delayed;

// Music
function  sfMusic_createFromFile(const FileName: PAnsiChar): PsfMusic; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfMusic_createFromMemory(const Data: Pointer; SizeInBytes: NativeUInt): PsfMusic; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfMusic_createFromStream(Stream: PsfInputStream): PsfMusic; cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfMusic_destroy(Music: PsfMusic); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfMusic_setLoop(Music: PsfMusic; Loop: TsfBool); cdecl; external CSFMLAUDIO_DLL delayed;
function  sfMusic_getLoop(const Music: PsfMusic): Integer; cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfMusic_play(Music: PsfMusic); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfMusic_pause(Music: PsfMusic); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfMusic_stop(Music: PsfMusic); cdecl; external CSFMLAUDIO_DLL delayed;
function  sfMusic_getChannelCount(const Music: PsfMusic): Cardinal; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfMusic_getSampleRate(const Music: PsfMusic): Cardinal; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfMusic_getStatus(const Music: PsfMusic): TsfSoundStatus; cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfMusic_setPitch(Music: PsfMusic; Pitch: Single); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfMusic_setVolume(Music: PsfMusic; Volume: Single); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfMusic_setPosition(Music: PsfMusic; Position: TsfVector3f); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfMusic_setRelativeToListener(Music: PsfMusic; Relative: Integer); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfMusic_setMinDistance(Music: PsfMusic; Distance: Single); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfMusic_setAttenuation(Music: PsfMusic; Attenuation: Single); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfMusic_setPlayingOffset(Music: PsfMusic; TimeOffset: TsfTime); cdecl; external CSFMLAUDIO_DLL delayed;
function  sfMusic_getPitch(const Music: PsfMusic): Single; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfMusic_getVolume(const Music: PsfMusic): Single; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfMusic_getPosition(const Music: PsfMusic): TsfVector3f; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfMusic_isRelativeToListener(const Music: PsfMusic): Integer; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfMusic_getMinDistance(const Music: PsfMusic): Single; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfMusic_getAttenuation(const Music: PsfMusic): Single; cdecl; external CSFMLAUDIO_DLL delayed;

procedure sfMusic_setLoopPoints(Music: PsfMusic; timePoints: TsfTimeSpan); cdecl; external CSFMLAUDIO_DLL delayed;
function  sfMusic_getLoopPoints(const Music: PsfMusic): TsfTimeSpan; cdecl; external CSFMLAUDIO_DLL delayed;

// SoundStream
function  sfSoundStream_create(OnGetData: TsfSoundStreamGetDataCallback; OnSeek: TsfSoundStreamSeekCallback; ChannelCount, SampleRate: Cardinal; UserData: Pointer): PsfSoundStream; cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSoundStream_destroy(SoundStream: PsfSoundStream); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSoundStream_play(SoundStream: PsfSoundStream); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSoundStream_pause(SoundStream: PsfSoundStream); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSoundStream_stop(SoundStream: PsfSoundStream); cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundStream_getStatus(const SoundStream: PsfSoundStream): TsfSoundStatus; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundStream_getChannelCount(const SoundStream: PsfSoundStream): Cardinal; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundStream_getSampleRate(const SoundStream: PsfSoundStream): Cardinal; cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSoundStream_setPitch(SoundStream: PsfSoundStream; Pitch: Single); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSoundStream_setVolume(SoundStream: PsfSoundStream; Volume: Single); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSoundStream_setPosition(SoundStream: PsfSoundStream; Position: TsfVector3f); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSoundStream_setRelativeToListener(SoundStream: PsfSoundStream; Relative: Integer); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSoundStream_setMinDistance(SoundStream: PsfSoundStream; Distance: Single); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSoundStream_setAttenuation(SoundStream: PsfSoundStream; Attenuation: Single); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSoundStream_setPlayingOffset(SoundStream: PsfSoundStream; TimeOffset: TsfTime); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSoundStream_setLoop(SoundStream: PsfSoundStream; Loop: Integer); cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundStream_getPitch(const SoundStream: PsfSoundStream): Single; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundStream_getVolume(const SoundStream: PsfSoundStream): Single; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundStream_getPosition(const SoundStream: PsfSoundStream): TsfVector3f; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundStream_isRelativeToListener(const SoundStream: PsfSoundStream): Integer; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundStream_getMinDistance(const SoundStream: PsfSoundStream): Single; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundStream_getAttenuation(const SoundStream: PsfSoundStream): Single; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundStream_getLoop(const SoundStream: PsfSoundStream): Integer; cdecl; external CSFMLAUDIO_DLL delayed;

// Sound
function  sfSound_create: PsfSound; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSound_copy(const Sound: PsfSound): PsfSound; cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSound_destroy(Sound: PsfSound); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSound_play(Sound: PsfSound); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSound_pause(Sound: PsfSound); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSound_stop(Sound: PsfSound); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSound_setBuffer(Sound: PsfSound; const Buffer: PsfSoundBuffer); cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSound_getBuffer(const Sound: PsfSound): PsfSoundBuffer; cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSound_setLoop(Sound: PsfSound; Loop: TsfBool); cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSound_getLoop(const Sound: PsfSound): Integer; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSound_getStatus(const Sound: PsfSound): TsfSoundStatus; cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSound_setPitch(Sound: PsfSound; Pitch: Single); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSound_setVolume(Sound: PsfSound; Volume: Single); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSound_setPosition(Sound: PsfSound; Position: TsfVector3f); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSound_setRelativeToListener(Sound: PsfSound; Relative: Integer); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSound_setMinDistance(Sound: PsfSound; Distance: Single); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSound_setAttenuation(Sound: PsfSound; Attenuation: Single); cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSound_setPlayingOffset(Sound: PsfSound; TimeOffset: TsfTime); cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSound_getPitch(const Sound: PsfSound): Single; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSound_getVolume(const Sound: PsfSound): Single; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSound_getPosition(const Sound: PsfSound): TsfVector3f; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSound_isRelativeToListener(const Sound: PsfSound): Integer; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSound_getMinDistance(const Sound: PsfSound): Single; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSound_getAttenuation(const Sound: PsfSound): Single; cdecl; external CSFMLAUDIO_DLL delayed;

// SoundBuffer
function  sfSoundBuffer_createFromFile(const FileName: PAnsiChar): PsfSoundBuffer; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundBuffer_createFromMemory(const Data: Pointer; SizeInBytes: NativeUInt): PsfSoundBuffer; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundBuffer_createFromStream(Stream: PsfInputStream): PsfSoundBuffer; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundBuffer_createFromSamples(const Samples: PSmallInt; SampleCount: UInt64; ChannelCount, SampleRate: Cardinal): PsfSoundBuffer; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundBuffer_copy(const SoundBuffer: PsfSoundBuffer): PsfSoundBuffer; cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSoundBuffer_destroy(SoundBuffer: PsfSoundBuffer); cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundBuffer_saveToFile(const SoundBuffer: PsfSoundBuffer; const FileName: PAnsiChar): Integer; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundBuffer_getSamples(const SoundBuffer: PsfSoundBuffer): PSmallInt; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundBuffer_getSampleCount(const SoundBuffer: PsfSoundBuffer): NativeUInt; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundBuffer_getSampleRate(const SoundBuffer: PsfSoundBuffer): Cardinal; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundBuffer_getChannelCount(const SoundBuffer: PsfSoundBuffer): Cardinal; cdecl; external CSFMLAUDIO_DLL delayed;

// SoundBufferRecorder
function  sfSoundBufferRecorder_create: PsfSoundBufferRecorder; cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSoundBufferRecorder_destroy(soundBufferRecorder: PsfSoundBufferRecorder); cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundBufferRecorder_start(soundBufferRecorder: PsfSoundBufferRecorder; SampleRate: Cardinal): Integer; cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSoundBufferRecorder_stop(soundBufferRecorder: PsfSoundBufferRecorder); cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundBufferRecorder_getSampleRate(const soundBufferRecorder: PsfSoundBufferRecorder): Cardinal; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundBufferRecorder_getBuffer(const soundBufferRecorder: PsfSoundBufferRecorder): PsfSoundBuffer; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundBufferRecorder_setDevice(SoundRecorder: PsfSoundBufferRecorder; const Name: PAnsiChar): Integer; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundBufferRecorder_getDevice(SoundRecorder: PsfSoundBufferRecorder): PAnsiChar; cdecl; external CSFMLAUDIO_DLL delayed;

// SoundRecorder
function  sfSoundRecorder_create(OnStart: TsfSoundRecorderStartCallback; OnProcess: TsfSoundRecorderProcessCallback; OnStop: TsfSoundRecorderStopCallback; UserData: Pointer): PsfSoundRecorder; cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSoundRecorder_destroy(SoundRecorder: PsfSoundRecorder); cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundRecorder_start(SoundRecorder: PsfSoundRecorder; SampleRate: Cardinal): Integer; cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSoundRecorder_stop(SoundRecorder: PsfSoundRecorder); cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundRecorder_getSampleRate(const SoundRecorder: PsfSoundRecorder): Cardinal; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundRecorder_isAvailable: Integer; cdecl; external CSFMLAUDIO_DLL delayed;
procedure sfSoundRecorder_setProcessingInterval(SoundRecorder: PsfSoundRecorder; Interval: TsfTime); cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundRecorder_getAvailableDevices(count: PNativeUInt): PPAnsiChar; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundRecorder_getDefaultDevice: PAnsiChar; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundRecorder_setDevice(SoundRecorder: PsfSoundRecorder; const Name: PAnsiChar): Integer; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundRecorder_getDevice(SoundRecorder: PsfSoundRecorder): PAnsiChar; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundRecorder_setChannelCount(SoundRecorder: PsfSoundRecorder; const ChannelCount: Cardinal): Integer; cdecl; external CSFMLAUDIO_DLL delayed;
function  sfSoundRecorder_getChannelCount(const SoundRecorder: PsfSoundRecorder): Cardinal; cdecl; external CSFMLAUDIO_DLL delayed;

function sfMusic_getDuration_(const Music: PsfMusic): TsfTime; cdecl; external CSFMLAUDIO_DLL delayed;
function sfMusic_getPlayingOffset_(const Music: PsfMusic): TsfTime; cdecl; external CSFMLAUDIO_DLL delayed;
function sfSoundStream_getPlayingOffset_(const SoundStream: PsfSoundStream): TsfTime; cdecl; external CSFMLAUDIO_DLL delayed;
function sfSound_getPlayingOffset_(const Sound: PsfSound): TsfTime; cdecl; external CSFMLAUDIO_DLL delayed;
function sfSoundBuffer_getDuration_(const SoundBuffer: PsfSoundBuffer): TsfTime; cdecl; external CSFMLAUDIO_DLL delayed;

implementation

end.
