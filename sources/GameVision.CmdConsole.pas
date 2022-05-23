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

unit GameVision.CmdConsole;

{$I GameVision.Defines.inc}

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  System.Classes,
  GameVision.Base,
  GameVision.Math,
  GameVision.Font,
  GameVision.Archive;

type
  { TGVCmdConsoleActionEvent }
  TGVCmdConsoleActionEvent = procedure of object;
  { TGVCmdConsole }
  TGVCmdConsole = class(TGVObject)
  protected
    type
      { TCmdConsoleState }
      TCmdConsoleState = (ccsInactive, ccsSlideDown, ccsSlideUp);

      { TCmdConsoleAction }
      TCmdConsoleAction = record
        Name: string;
        Discription: string;
        Handler: TGVCmdConsoleActionEvent;
      end;
  protected
    FEnabled: Boolean;
    FActive: Boolean;
    FSize: TGVRectangle;
    FPos: TGVVector;
    FSlider: Double;
    FState: TCmdConsoleState;
    FFont: TGVFont;
    FFontHeight: Single;
    FToggleKey: Integer;
    FSlideSpeed: Single;
    FCmdLine: string;
    FCmdCurPos: Integer;
    FCurFlashTimer: Single;
    FCurFlash: Boolean;
    FTextLines: TStringList;
    FCmdHistory: TStringList;
    FCmdHistoryIndex: Integer;
    FMaxCmdHistoryCount: Integer;
    FMaxTextLinesCount: Integer;
    FCmdActionList: TList<TCmdConsoleAction>;
    FCmdParams: TStringList;
    FLastChar: Integer;
    function ProcessCmd(aName: string; var aWasInternalCmd: Boolean): Boolean;
    procedure Setup;
    procedure Shutdown;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Render;
    procedure Update(aDeltaTime: Double);
  public
    function  GetActive: Boolean;
    procedure LoadFont(aArchive: TGVArchive; aSize: Cardinal; const aFilename: string);
    procedure Open;
    procedure Close;
    function  Toggle: Boolean;
    procedure SetToggleKey(aKey: Integer);
    procedure SetSlideSpeed(aSpeed: Single);
    procedure ClearCommands;
    procedure AddCommand(const aName: string; const aDiscription: string; aAction: TGVCmdConsoleActionEvent);
    procedure Enable(aEnable: Boolean);
    function  ParamCount: Integer;
    function  ParamStr(aIndex: Integer): string;
    procedure AddTextLine(const aMsg: string; const aArgs: array of const);
  end;

implementation

uses
  System.Math,
  GameVision.Util,
  GameVision.Common,
  GameVision.Input,
  GameVision.Color,
  GameVision.Core;

const
  cDefaultSlideSpeed = 60 * 4;
  cDefaultFrameWidth = 2;
  cDefaultMargins = 2;
  cDefaultMaxCmdHistoryCount = 20;
  cDefaultMaxTextLinesCount = 1080;

{ CmdConsole }
function TGVCmdConsole.ProcessCmd(aName: string; var aWasInternalCmd: Boolean): Boolean;
var
  LRec: TCmdConsoleAction;
  LMaxLen: Integer;
  I: Integer;
 LList: TStringList;
begin
  Result := False;

  FCmdParams.Clear;

  ExtractStrings([#32], [#32], PChar(aName), FCmdParams);

  // check internal commands
  if SameText('cls', FCmdParams[0]) then
    begin
      FTextLines.Clear;
      aWasInternalCmd := True;
      Result := True;
      Exit;
    end
  else
  if SameText('help', FCmdParams[0]) then
    begin
      AddTextLine('', []);
      AddTextLine('Options:', []);
      LList := TStringList.Create;
      try
        LList.Sorted := True;
        LList.AddPair('up/down', 'Console history');
        LList.AddPair('cls', 'Clear console window');
        LList.AddPair('help', 'Display list of commands');
        for LRec in FCmdActionList do
        begin
          LList.AddPair(LRec.Name, LRec.Discription);
        end;

        LMaxLen := 0;
        for I := 0 to LList.Count-1 do
        begin
          if LList.KeyNames[i].Length > LMaxLen then
            LMaxLen := LList.KeyNames[i].Length;
        end;

        for I := 0 to LList.Count-1 do
        begin
          AddTextLine('  %s - %s', [LList.KeyNames[i].PadRight(LMaxLen), LList.ValueFromIndex[i]])
        end;

      finally
        FreeAndNil(LList);
      end;
      aWasInternalCmd := True;
      Result := True;
      Exit;
    end;

  // check external commands
  for LRec in FCmdActionList do
  begin
    if SameText(FCmdParams[0], LRec.Name) then
    begin
      if Assigned(LRec.Handler) then
      begin
        FCmdParams.Delete(0);
        LRec.Handler;
        FCmdParams.Clear;
        Result := True;
      end;
      Break;
    end;
  end;
end;

procedure TGVCmdConsole.AddTextLine(const aMsg: string; const aArgs: array of const);
begin
  if aMsg = '' then Exit;

  FMaxTextLinesCount := Round(FSize.Height / FFontHeight);
  if FTextLines.Count = FMaxTextLinesCount then
  begin
    FTextLines.Delete(0);
  end;

  FTextLines.Add(Format(aMsg, aArgs));;
end;

procedure TGVCmdConsole.Setup;
begin
  FActive := False;
  FState := ccsInactive;
  FEnabled := False;
  FTextLines := TStringList.Create;
  FCmdHistory := TStringList.Create;
  FCmdParams := TStringList.Create;
  FCmdActionList := TList<TCmdConsoleAction>.Create;
  GV.Logger.Log('Initialized %s Subsystem', ['CmdConsole']);
end;

procedure TGVCmdConsole.Shutdown;
begin
  Close;
  FreeAndNil(FCmdActionList);
  FreeAndNil(FCmdParams);
  FreeAndNil(FCmdHistory);
  FreeAndNil(FTextLines);
  GV.Logger.Log('Shutdown %s Subsystem', ['CmdConsole']);
end;

procedure TGVCmdConsole.Open;
begin
  FActive := False;
  FState := ccsInactive;
  FFont := TGVFont.Create;
  FFont.LoadDefault(16);
  FFontHeight := FFont.GetLineHeight;
  FToggleKey :=  KEY_TILDE;
  FSlideSpeed := cDefaultSlideSpeed;
  FCmdLine := '';
  FLastChar := 0;
  FCmdCurPos := 0;
  FCurFlashTimer := 0;
  FCurFlash := True;
  FTextLines.Clear;
  FCmdHistory.Clear;
  FCmdParams.Clear;
  FCmdHistoryIndex := 0;
  FMaxCmdHistoryCount := cDefaultMaxCmdHistoryCount;
  FMaxTextLinesCount := cDefaultMaxTextLinesCount;
  FEnabled := True;
  FSlider := 1;
end;

procedure TGVCmdConsole.Close;
begin
  FreeAndNil(FFont);
  FTextLines.Clear;
  FCmdHistory.Clear;
  FCmdParams.Clear;
  FCmdActionList.Clear;
  FActive := False;
  FState := ccsInactive;
  FEnabled := False;
end;

procedure TGVCmdConsole.Render;
var
  LPos: TGVVector;
  LFormat: string;
  LIndex: Integer;
begin
  //if not FActive then Exit;
  if not FEnabled then Exit;
  if FState = ccsInactive then Exit;

  GV.Primitive.FilledRectangle(FPos.X, FPos.Y, FSize.Width, FSize.Height, OVERLAY1);
  GV.Primitive.Rectangle(FPos.X, FPos.Y, FSize.Width, FSize.Height, cDefaultFrameWidth, DIMGRAY);
  GV.Primitive.FilledRectangle(FPos.X+(cDefaultFrameWidth div 2), (FPos.Y+(cDefaultFrameWidth div 2)), FSize.Width-cDefaultFrameWidth, FFontHeight, DIMWHITE);
  FFont.PrintText(FSize.Width/2, (FPos.Y+(cDefaultFrameWidth div 2)-cDefaultMargins), YELLOW, haCenter, '*** Command Console ***', []);
  GV.Primitive.FilledRectangle(FPos.X+(cDefaultFrameWidth div 2), (FPos.Y+FSize.Height)-FFontHeight+(cDefaultFrameWidth div 2), FSize.Width-cDefaultFrameWidth, FFontHeight, DIMWHITE);

  // draw input
  LFormat := '>%s';
  LPos.X := FPos.X+(cDefaultFrameWidth div 2) + cDefaultMargins;
  LPos.Y := (FPos.Y+FSize.Height)-FFontHeight+(cDefaultFrameWidth div 2)-2;
  FFont.PrintText(LPos.X, LPos.Y, WHITE, haLeft, LFormat, [FCmdLine]);
  LPos.X := LPos.X + FFont.GetTextWidth(LFormat, [FCmdLine]) + cDefaultMargins;
  if GV.Game.FrameElapsed(FCurFlashTimer, 15) then FCurFlash := not FCurFlash;
  if FCurFlash then GV.Primitive.FilledRectangle(LPos.X, LPos.Y+4, 2, FFontHeight-6, WHITE);

  // draw text line
  LPos.X := FPos.X+(cDefaultFrameWidth div 2) + cDefaultMargins;
  LPos.Y := LPos.Y - FFontHeight;
  for LIndex := FTextLines.Count-1 downto 0 do
  begin
    if LPos.Y < (FPos.Y+(cDefaultFrameWidth div 2)+FFontHeight) then continue;
    FFont.PrintText(LPos.X, LPos.Y, WHITE, haLeft, FTextLines[LIndex], []);
    LPos.Y := LPos.Y - FFontHeight;
  end;

end;

function TGVCmdConsole.Toggle: Boolean;
begin
  Result := False;
  if FState = ccsInactive then
  begin
    GV.Window.GetViewportSize(FSize);
    FPos.X := FSize.X;
    FPos.Y := FSize.Y - FSize.Height;
    FState := ccsSlideDown;
    FSlider := 1;
    Result := True;
  end
  else
  if FState = ccsSlideDown then
  begin
    FState := ccsSlideUp;
    FSlider := 1;
    GV.Window.GetViewportSize(FSize);
    Result := True;
  end;

  if Result then
  begin
    GV.Input.Clear;
  end;
end;

procedure TGVCmdConsole.Update(aDeltaTime: Double);
var
  LChar: Integer;
  LWasInternalCmd: Boolean;
begin
  if not FEnabled then Exit;

  if GV.Input.KeyPressed(FToggleKey) then
  begin
    if Toggle then Exit;
  end;

  if FState = ccsInactive then Exit;
  FSlider := GV.Util.EasePosition(1, 100, FSlider, etLinearTween);
  if FState = ccsSlideDown then
    begin
      FPos.Y := (FSize.Y - FSize.Height) + (FSize.Height*(FSlider/100.00));
      if FPos.Y >= FSize.Y then
      begin
        FPos.Y := FSize.Y;
        //if not FActive then GV.EmitCmdConActiveEvent;
        FActive := True;
      end;
    end
  else
  if FState = ccsSlideUp then
  begin
    FPos.Y := FSize.Y - (FSize.Height*(FSlider/100.00));
    if FPos.Y <= (FSize.Y - FSize.Height) then
    begin
      FState := ccsInactive;
      FActive := False;
      //GV.EmitCmdConInactiveEvent;
      Exit;
    end;
  end;
  FSlider := FSlider + (FSlideSpeed * aDeltaTime);

  // process input
  LChar := GV.Input.KeyCode;
  if not GV.Input.KeyCodeRepeat then
  begin
    if LChar <> FLastChar then
      FLastChar := LChar
    else
      LChar := 0;
  end;

  // process input
  if (LChar = 8) then
    begin
      if FCmdLine.Length >= 1 then
      begin
        FCmdLine := FCmdLine.Remove(FCmdLine.Length-1, 1);
        FCurFlash := True;
      end;
    end
  else
  if (LChar = 13) then
    begin
      FCmdLine := FCmdLine.Trim;

      if not FCmdLine.IsEmpty then
      begin
        AddTextLine(FCmdLine, []);
        LWasInternalCmd := False;
        if ProcessCmd(FCmdLine, LWasInternalCmd) then
        begin

          // check to trim to maxium allowed
          if FCmdHistory.Count = FMaxCmdHistoryCount then
          begin
            FCmdHistory.Delete(0);
          end;
          FCmdHistory.Add(FCmdLine);
        end
        else
        begin
          FTextLines.Add('Error: Unknown command!');
        end;

        FCmdLine := '';
        FCurFlash := True;
      end;

    end
  else
  //ascii char
  if (LChar >= 32) and
     (LChar <= 127) then
    begin
      FCmdLine := FCmdLine + Chr(LChar);
      FCurFlash := True;
    end
  else
  begin
    // process extended keys
    if GV.Input.KeyPressed(KEY_UP) then
      begin
        if FCmdHistoryIndex > 0 then
        begin
          Dec(FCmdHistoryIndex);
          FCmdLine := FCmdHistory[FCmdHistoryIndex];
          FCurFlash := True;
        end;
      end
    else
    if GV.Input.KeyPressed(KEY_DOWN) then
    begin
      if FCmdHistoryIndex < FCmdHistory.Count-1 then
      begin
        Inc(FCmdHistoryIndex);
        FCmdLine := FCmdHistory[FCmdHistoryIndex];
        FCurFlash := True;
      end;

    end;
  end;
end;

constructor TGVCmdConsole.Create;
begin
  inherited;

  Setup;
end;

destructor TGVCmdConsole.Destroy;
begin
  Shutdown;

  inherited;
end;

function  TGVCmdConsole.GetActive: Boolean;
begin
  Result := FActive;
end;

procedure TGVCmdConsole.LoadFont(aArchive: TGVArchive; aSize: Cardinal; const aFilename: string);
begin
  FFont.Load(aArchive, aSize, aFilename);
  FFontHeight := FFont.GetLineHeight;
end;

procedure TGVCmdConsole.SetToggleKey(aKey: Integer);
begin
  FToggleKey := aKey;
  if (FToggleKey < KEY_A) and
     (FToggleKey >= KEY_MAX) then
    FToggleKey := KEY_TILDE;
end;

procedure TGVCmdConsole.SetSlideSpeed(aSpeed: Single);
begin
  FSlideSpeed := aSpeed;
  if (FSlideSpeed < 0) then
    FSlideSpeed := cDefaultSlideSpeed;
end;

procedure TGVCmdConsole.ClearCommands;
begin
  FCmdActionList.Clear;
end;

procedure TGVCmdConsole.AddCommand(const aName: string; const aDiscription: string; aAction: TGVCmdConsoleActionEvent);
var
  LRec: TCmdConsoleAction;
begin
  if aName = '' then Exit;
  if not Assigned(aAction) then Exit;

  for LRec in FCmdActionList do
  begin
    if SameText(aName, LRec.Name) then Exit;
  end;

  LRec.Name := aName;
  LRec.Discription := aDiscription;
  LRec.Handler := aAction;
  FCmdActionList.Add(LRec);
end;

procedure TGVCmdConsole.Enable(aEnable: Boolean);
begin
  FEnabled := aEnable;
end;

function  TGVCmdConsole.ParamCount: Integer;
begin
  Result := FCmdParams.Count;
end;

function  TGVCmdConsole.ParamStr(aIndex: Integer): string;
begin
  Result := '';
  if (aIndex < 0) then Exit;
  if (aIndex > FCmdParams.Count-1) then Exit;
  Result := FCmdParams[aIndex];
end;

end.
