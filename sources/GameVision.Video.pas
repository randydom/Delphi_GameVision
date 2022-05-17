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

unit GameVision.Video;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Allegro,
  GameVision.Base,
  GameVision.Archive;

type
  { TGVVideo }
  TGVVideo = class(TGVObject)
  protected
    FVoice: PALLEGRO_VOICE;
    FMixer: PALLEGRO_MIXER;
    FHandle: PALLEGRO_VIDEO;
    FLoop: Boolean;
    FPlaying: Boolean;
    FPaused: Boolean;
    FFilename: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnFinished(aHandle: PALLEGRO_VIDEO);
    function  Load(aArchive: TGVArchive; const aFilename: string): Boolean;
    function  Unload: Boolean;
    function  GetPause: Boolean;
    procedure SetPause(aPause: Boolean);
    function  GetLooping:  Boolean;
    procedure Setooping(aLoop: Boolean);
    function  GetPlaying: Boolean;
    procedure SetPlaying(aPlay: Boolean);
    function  GetFilename: string;
    procedure Play(aArchive: TGVArchive; const aFilename: string; aLoop: Boolean; aVolume: Single); overload;
    procedure Play(aLoop: Boolean; aVolume: Single); overload;
    procedure Draw(aX: Single; aY: Single; aScale: Single);
    procedure GetSize(aWidth: System.PSingle; aHeight: System.PSingle);
    procedure Seek(aSeconds: Single);
    procedure Rewind;
  end;


implementation

uses
  System.IOUtils,
  WinApi.Windows,
  GameVision.Math,
  GameVision.Core;

{ TGVVideo }
procedure TGVVideo.OnFinished(aHandle: PALLEGRO_VIDEO);
begin
  if FHandle <> aHandle then Exit;

  Rewind;
  if FLoop then
    begin
      if not FPaused then
        SetPlaying(True);
    end
  else
    begin
      GV.Game.OnFinishedVideo(FFilename)
    end;
end;

constructor TGVVideo.Create;
begin
  inherited;
end;

destructor TGVVideo.Destroy;
begin
  Unload;
  inherited;
end;

function  TGVVideo.Load(aArchive: TGVArchive; const aFilename: string): Boolean;
var
  LMarshallar: TMarshaller;
  LFilename: string;
  LHandle: PALLEGRO_VIDEO;
begin
  Result := False;
  if aFilename.IsEmpty then Exit;

  if aArchive <> nil then
    begin
      if not aArchive.IsOpen then Exit;
      if not aArchive.FileExist(aFilename) then Exit;
      LFilename := string(aArchive.GetPasswordFilename(aFilename));
    end
  else
    begin
      if not TFile.Exists(aFilename) then Exit;
      LFilename := aFilename;
    end;

  if aArchive = nil then GV.SetFileSandBoxed(False);
  LHandle := al_open_video(LMarshallar.AsUtf8(LFilename).ToPointer);
  if aArchive = nil then GV.SetFileSandBoxed(True);

  if LHandle = nil then Exit;

  Unload;

  if al_is_audio_installed then
  begin
    if FVoice = nil then
    begin
      FVoice := al_create_voice(44100, ALLEGRO_AUDIO_DEPTH_INT16, ALLEGRO_CHANNEL_CONF_2);
      FMixer := al_create_mixer(44100, ALLEGRO_AUDIO_DEPTH_FLOAT32, ALLEGRO_CHANNEL_CONF_2);
      al_attach_mixer_to_voice(FMixer, FVoice);
    end;
  end;

  al_register_event_source(GV.Queue, al_get_video_event_source(LHandle));
  al_set_video_playing(LHandle, False);

  FHandle := LHandle;
  FFilename := aFilename;
  FLoop := False;
  FPlaying := False;
  FPaused := False;
  GV.Game.OnLoadVideo(FFilename);
  Result := True;
end;

function  TGVVideo.Unload: Boolean;
begin
  Result := False;
  if FHandle = nil then Exit;
  GV.Game.OnUnloadVideo(FFilename);
  al_set_video_playing(FHandle, False);
  al_unregister_event_source(GV.Queue, al_get_video_event_source(FHandle));
  al_close_video(FHandle);

  if al_is_audio_installed then
  begin
    al_detach_mixer(FMixer);
    al_destroy_mixer(FMixer);
    al_destroy_voice(FVoice);
  end;

  FHandle := nil;
  FFilename := '';
  FLoop := False;
  FPlaying := False;
  FPaused := False;
end;

function  TGVVideo.GetPause: Boolean;
begin
  Result := False;
  if FHandle = nil then Exit;
  Result := FPaused;
end;

procedure TGVVideo.SetPause(aPause: Boolean);
begin
  if FHandle = nil then Exit;

  // if trying to pause and video is not playing, just exit
  if (aPause = True) then
  begin
    if not al_is_video_playing(FHandle) then
    Exit;
  end;

  // if trying to unpause without first being paused, just exit
  if (aPause = False) then
  begin
    if FPaused = False then
      Exit;
  end;

  al_set_video_playing(FHandle, not aPause);
  FPaused := aPause;
end;

function  TGVVideo.GetLooping:  Boolean;
begin
  Result := False;
  if FHandle = nil then Exit;
  Result := FLoop;
end;

procedure TGVVideo.Setooping(aLoop: Boolean);
begin
  if FHandle = nil then Exit;
  FLoop := aLoop;
end;

function  TGVVideo.GetPlaying: Boolean;
begin
  Result := False;
  if FHandle = nil then Exit;
  Result := al_is_video_playing(FHandle);
end;

procedure TGVVideo.SetPlaying(aPlay: Boolean);
begin
  if FHandle = nil then Exit;
  if FPaused then Exit;
  al_set_video_playing(FHandle, aPlay);
  FPlaying := aPlay;
  FPaused := False;
end;

function  TGVVideo.GetFilename: string;
begin
  Result := '';
  if FHandle = nil then Exit;
  Result := FFilename;
end;

procedure TGVVideo.Play(aArchive: TGVArchive; const aFilename: string; aLoop: Boolean; aVolume: Single);
begin
  if not Load(aArchive, aFilename) then Exit;
  Play(aLoop, aVolume);
end;

procedure TGVVideo.Play(aLoop: Boolean; aVolume: Single);
begin
  if FHandle = nil then Exit;
  al_start_video(FHandle, GV.Mixer);
  al_set_mixer_gain(FMixer, aVolume);
  al_set_video_playing(FHandle, True);
  FLoop := aLoop;
  FPlaying := True;
  FPaused := False;
end;

procedure TGVVideo.Draw(aX: Single; aY: Single; aScale: Single);
var
  LFrame: PALLEGRO_BITMAP;
  LSize: TGVVector;
  LScaled: TGVVector;
  LViewportSize: TGVRectangle;
  LScale: Single;
begin
  if FHandle = nil then Exit;
  if aScale <= 0 then Exit;
  LScale := aScale;

  if (not GetPlaying) and (not FPaused) then Exit;

  LFrame := al_get_video_frame(FHandle);
  if LFrame <> nil then
  begin

    GV.Window.GetViewportSize(LViewportSize);
    LSize.X := al_get_bitmap_width(LFrame);
    LSize.Y := al_get_bitmap_height(LFrame);
    LScaled.X := al_get_video_scaled_width(FHandle);
    LScaled.Y := al_get_video_scaled_height(FHandle);

    al_draw_scaled_bitmap(LFrame, 0, 0,
      LSize.X,
      LSize.Y,
      aX, aY,
      LScaled.X*LScale,
      LScaled.Y*LScale,
      0);
  end;
end;

procedure TGVVideo.GetSize(aWidth: System.PSingle; aHeight: System.PSingle);
begin
  if FHandle = nil then
  begin
    if aWidth <> nil then
      aWidth^ := 0;
    if aHeight <> nil then
      aHeight^ := 0;
    Exit;
  end;
  if aWidth <> nil then
    aWidth^ := al_get_video_scaled_width(FHandle);
  if aHeight <> nil then
    aHeight^ := al_get_video_scaled_height(FHandle);
end;

procedure TGVVideo.Seek(aSeconds: Single);
begin
  if FHandle = nil then Exit;
  al_seek_video(FHandle, aSeconds);
end;

procedure TGVVideo.Rewind;
begin
  if FHandle = nil then Exit;
  al_seek_video(FHandle, 0);
end;

end.
