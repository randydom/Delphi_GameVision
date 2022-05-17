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

unit GameVision.Speech;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  GameVision.SpeechLib,
  GameVision.Base;

type
  { TGVSpeechVoiceAttribute }
  TGVSpeechVoiceAttribute = (Description, Name, Vendor, Age, Gender, Language, Id);

  { TGVSpeech }
  TGVSpeech = class(TGVObject)
  protected
    FSpVoice: TSpVoice;
    FVoiceList: TInterfaceList;
    FVoiceDescList: TStringList;
    FPaused: Boolean;
    FText: string;
    FWord: string;
    FVoice: Integer;
    procedure OnWord(aSender: TObject; aStreamNumber: Integer; aStreamPosition: OleVariant; aCharacterPosition, aLength: Integer);
    //procedure OnStartStream(aSender: TObject; aStreamNumber: Integer; aStreamPosition: OleVariant);
    procedure DoSpeak(aText: string; aFlags: Integer);
    procedure EnumVoices;
    procedure FreeVoices;
    procedure Setup;
    procedure Shutdown;
  public
    constructor Create; override;
    destructor Destroy; override;
    function  GetVoiceCount: Integer;
    function  GetVoiceAttribute(aIndex: Integer; aAttribute: TGVSpeechVoiceAttribute): WideString;
    procedure ChangeVoice(aIndex: Integer);
    function  GetVoice: Integer;
    procedure SetVolume(aVolume: Single);
    function  GetVolume: Single;
    procedure SetRate(aRate: Single);
    function  GetRate: Single;
    procedure Clear;
    procedure Say(const aText: WideString; aPurge: Boolean);
    procedure SayXML(const aText: WideString; aPurge: Boolean);
    function  Active: Boolean;
    procedure Pause;
    procedure Resume;
    procedure Reset;
  end;

implementation

uses
  GameVision.Core;

{  TGVSpeech }
procedure TGVSpeech.OnWord(aSender: TObject; aStreamNumber: Integer; aStreamPosition: OleVariant; aCharacterPosition, aLength: Integer);
begin
  if FText.IsEmpty then Exit;
  FWord := FText.Substring(aCharacterPosition, aLength);
  GV.Game.OnSpeechWord(FWord, FText);
end;

//procedure Speech.OnStartStream(aSender: TObject; aStreamNumber: Integer; aStreamPosition: OleVariant);
//begin
//end;

procedure TGVSpeech.DoSpeak(aText: string; aFlags: Integer);
begin
  if FSpVoice = nil then Exit;
  if aText.IsEmpty then Exit;
  if FPaused then Resume;
  FSpVoice.Speak(aText, aFlags);
  FText := aText;
end;

procedure TGVSpeech.EnumVoices;
var
  LI: Integer;
  LSOToken: ISpeechObjectToken;
  LSOTokens: ISpeechObjectTokens;
begin
  FVoiceList := TInterfaceList.Create;
  FVoiceDescList := TStringList.Create;
  LSOTokens := FSpVoice.GetVoices('', '');
  for LI := 0 to LSOTokens.Count - 1 do
  begin
    LSOToken := LSOTokens.Item(LI);
    FVoiceDescList.Add(LSOToken.GetDescription(0));
    FVoiceList.Add(LSOToken);
  end;
end;

procedure TGVSpeech.FreeVoices;
begin
  FreeAndNil(FVoiceDescList);
  FreeAndNil(FVoiceList);
end;

procedure TGVSpeech.Setup;
begin
  FPaused := False;
  FText := '';
  FWord := '';
  FVoice := 0;
  FSpVoice := TSpVoice.Create(nil);
  FSpVoice.EventInterests := SVEAllEvents;
  EnumVoices;
  //FSpVoice.OnStartStream := OnStartStream;
  FSpVoice.OnWord := OnWord;
  GV.Logger.Log('Initialized %s Subsystem', ['Speech']);
end;

procedure TGVSpeech.Shutdown;
begin
  FreeVoices;
  FSpVoice.OnWord := nil;
  FSpVoice.Free;

  GV.Logger.Log('Shutdown %s Subsystem', ['Speech']);
end;

constructor TGVSpeech.Create;
begin
  inherited;
  Setup;
end;

destructor TGVSpeech.Destroy;
begin
  Shutdown;
  inherited;
end;

function TGVSpeech.GetVoiceCount: Integer;
begin
  Result := FVoiceList.Count;
end;

function TGVSpeech.GetVoiceAttribute(aIndex: Integer; aAttribute: TGVSpeechVoiceAttribute): WideString;
var
  LSOToken: ISpeechObjectToken;

  function GetAttr(aItem: string): string;
  begin
    if aItem = 'Id' then
      Result := LSOToken.Id
    else
      Result := LSOToken.GetAttribute(aItem);
  end;

begin
  Result := '';
  if (aIndex < 0) or (aIndex > FVoiceList.Count - 1) then
    Exit;
  LSOToken := ISpeechObjectToken(FVoiceList.Items[aIndex]);
  case aAttribute of
    TGVSpeechVoiceAttribute.Description:
      Result := FVoiceDescList[aIndex];
    TGVSpeechVoiceAttribute.Name:
      Result := GetAttr('Name');
    TGVSpeechVoiceAttribute.Vendor:
      Result := GetAttr('Vendor');
    TGVSpeechVoiceAttribute.Age:
      Result := GetAttr('Age');
    TGVSpeechVoiceAttribute.Gender:
      Result := GetAttr('Gender');
    TGVSpeechVoiceAttribute.Language:
      Result := GetAttr('Language');
    TGVSpeechVoiceAttribute.Id:
      Result := GetAttr('Id');
  end;
end;

procedure TGVSpeech.ChangeVoice(aIndex: Integer);
var
  LSOToken: ISpeechObjectToken;
begin
  if (aIndex < 0) or (aIndex > FVoiceList.Count - 1) then Exit;
  if aIndex = FVoice then Exit;
  LSOToken := ISpeechObjectToken(FVoiceList.Items[aIndex]);
  FSpVoice.Voice := LSOToken;
  FVoice := aIndex;
end;

function TGVSpeech.GetVoice: Integer;
begin
  Result := FVoice;
end;

procedure TGVSpeech.SetVolume(aVolume: Single);
var
  LVolume: Integer;
begin
  if aVolume < 0 then
    aVolume := 0
  else if aVolume > 1 then
    aVolume := 1;

  LVolume := Round(100.0 * aVolume);

  if FSpVoice = nil then
    Exit;
  FSpVoice.Volume := LVolume;
end;

function TGVSpeech.GetVolume: Single;
begin
  Result := 0;
  if FSpVoice = nil then Exit;
  Result := FSpVoice.Volume / 100.0;
end;

procedure TGVSpeech.SetRate(aRate: Single);
var
  LVolume: Integer;
begin
  if aRate < 0 then
    aRate := 0
  else if aRate > 1 then
    aRate := 1;

  LVolume := Round(20.0 * aRate) - 10;

  if LVolume < -10 then
    LVolume := -10
  else if LVolume > 10 then
    LVolume := 10;

  if FSpVoice = nil then
    Exit;
  FSpVoice.Rate := LVolume;
end;

function TGVSpeech.GetRate: Single;
begin
  Result := 0;
  if FSpVoice = nil then Exit;
  Result := (FSpVoice.Rate + 10.0) / 20.0;
end;

procedure TGVSpeech.Say(const aText: WideString; aPurge: Boolean);
var
  LFlag: Integer;
  LText: string;
begin
  LFlag := SVSFlagsAsync;
  LText := aText;
  if aPurge then
    LFlag := LFlag or SVSFPurgeBeforeSpeak;
  DoSpeak(LText, LFlag);
end;

procedure TGVSpeech.SayXML(const aText: WideString; aPurge: Boolean);
var
  LFlag: Integer;
  LText: string;
begin
  LFlag := SVSFlagsAsync or SVSFIsXML;
  if aPurge then
    LFlag := LFlag or SVSFPurgeBeforeSpeak;
  LText := aText;
  DoSpeak(aText, LFlag);
end;

procedure TGVSpeech.Clear;
begin
  if FSpVoice = nil then Exit;
  if Active then
  begin
    FSpVoice.Skip('Sentence', MaxInt);
    Say(' ', True);
  end;
  FText := '';
end;

function TGVSpeech.Active: Boolean;
begin
  Result := False;
  if FSpVoice = nil then Exit;
  Result := Boolean(FSpVoice.Status.RunningState <> SRSEDone);
end;

procedure TGVSpeech.Pause;
begin
  if FSpVoice = nil then Exit;
  FSpVoice.Pause;
  FPaused := True;
end;

procedure TGVSpeech.Resume;
begin
  if FSpVoice = nil then Exit;
  FSpVoice.Resume;
  FPaused := False;
end;

procedure TGVSpeech.Reset;
begin
  Clear;
  FreeAndNil(FSpVoice);
  FPaused := False;
  FText := '';
  FWord := '';
  FSpVoice := TSpVoice.Create(nil);
  FSpVoice.EventInterests := SVEAllEvents;
  EnumVoices;
  //FSpVoice.OnStartStream := OnStartStream;
  FSpVoice.OnWord := OnWord;
end;

end.
