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

unit GameVision.Async;

{$I GameVision.Defines.inc}

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  System.SyncObjs,
  System.Classes,
  GameVision.Base;

type
  { TGVAsyncThread }
  TGVAsyncThread = class(TThread)
  protected
    FTask: TProc;
    FWait: TProc;
    FFinished: Boolean;
  public
    property TaskProc: TProc read FTask write FTask;
    property WaitProc: TProc read FWait write FWait;
    property Finished: Boolean read FFinished;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Execute; override;
  end;

  { TGVAsync }
  TGVAsync = class(TGVObject)
  protected
    type
      TBusyData = record
        Name: string;
        Thread: Pointer;
        Flag: Boolean;
      end;
  protected
    FCriticalSection: TCriticalSection;
    FQueue: TList<TGVAsyncThread>;
    FBusy: TDictionary<string, TBusyData>;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Process;
    procedure Run(const aName: string; aTask: TProc; aWait: TProc);
    function IsBusy(const aName: string): Boolean;
    procedure Enter;
    procedure Leave;
  end;

implementation

{ TGVAsyncThread }
constructor TGVAsyncThread.Create;
begin
  inherited Create(True);

  FTask := nil;
  FWait := nil;
  FFinished := False;
end;

destructor TGVAsyncThread.Destroy;
begin
  inherited;
end;

procedure TGVAsyncThread.Execute;
begin
  FFinished := False;

  if Assigned(FTask) then
  begin
    FTask();
  end;

  FFinished := True;
end;

{ TGVAsync }
procedure TGVAsync.Process;
var
  LAsyncThread: TGVAsyncThread;
  LIndex: TBusyData;
  LBusy: TBusyData;
begin
  Enter;

  if TThread.CurrentThread.ThreadID = MainThreadID then
  begin
    for LAsyncThread in FQueue do
    begin
      if Assigned(LAsyncThread) then
      begin
        if LAsyncThread.Finished then
        begin
          LAsyncThread.WaitFor;
          LAsyncThread.WaitProc();
          FQueue.Remove(LAsyncThread);
          for LIndex in FBusy.Values do
          begin
            if Lindex.Thread = LAsyncThread then
            begin
              LBusy := LIndex;
              LBusy.Flag := False;
              FBusy.AddOrSetValue(LBusy.Name, LBusy);
              Break;
            end;
          end;
          FreeAndNil(LAsyncThread);
        end;
      end;
    end;
    FQueue.Pack;
  end;

  Leave;
end;

constructor TGVAsync.Create;
begin
  inherited;
  FCriticalSection := TCriticalSection.Create;
  FQueue := TList<TGVAsyncThread>.Create;
  FBusy := TDictionary<string, TBusyData>.Create;
end;

destructor TGVAsync.Destroy;
begin
  FreeAndNil(FBusy);
  FreeAndNil(FQueue);
  FreeAndNil(FCriticalSection);
  inherited;
end;

procedure TGVAsync.Run(const aName: string; aTask: TProc; aWait: TProc);
var
  LAsyncThread: TGVAsyncThread;
  LBusy: TBusyData;
begin
  if not Assigned(aTask) then Exit;
  if not Assigned(aWait) then Exit;
  if aName.IsEmpty then Exit;
  if IsBusy(aName) then Exit;
  LAsyncThread := TGVAsyncThread.Create;
  LAsyncThread.TaskProc := aTask;
  LAsyncThread.WaitProc := aWait;
  FQueue.Add(LAsyncThread);
  Enter;
  LBusy.Name := aName;
  LBusy.Thread := LAsyncThread;
  LBusy.Flag := True;
  FBusy.AddOrSetValue(aName, LBusy);
  Leave;
  LAsyncThread.Start;
end;

function TGVAsync.IsBusy(const aName: string): Boolean;
var
  LBusy: TBusyData;
begin
  Result := False;
  if aName.IsEmpty then Exit;
  Enter;
  FBusy.TryGetValue(aName, LBusy);
  Leave;
  Result := LBusy.Flag;
end;

procedure TGVAsync.Enter;
begin
  FCriticalSection.Enter;
end;

procedure TGVAsync.Leave;
begin
  FCriticalSection.Leave;
end;

end.
