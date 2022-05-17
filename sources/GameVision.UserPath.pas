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

unit GameVision.UserPath;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Base;

type
  { TGVUserPath }
  TGVUserPath = class(TGVObject)
  protected
    FOrgName: string;
    FAppId: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Reset;
    procedure SetOrgName(const aName: string);
    function  GetOrgName: string;
    procedure SetAppId(const aId: string);
    function  GetAppId: string;
    function  GetAppIdPath: string;
    function  GetPath: string; overload;
    function  GetPath(const aPath: string): string; overload;
    function  CreateDirs: Boolean;
    function  GetConfigFilename: string;
    function  GetLogFilename: string;
  end;

implementation

uses
  System.IOUtils,
  GameVision.Common,
  GameVision.Util;

constructor TGVUserPath.Create;
begin
  inherited;
  Reset;
end;

destructor TGVUserPath.Destroy;
begin
  inherited;
end;

procedure TGVUserPath.Reset;
begin
  FOrgName := '';
  FAppId := '';
end;

procedure TGVUserPath.SetOrgName(const aName: string);
begin
  FOrgName := aName;
end;

function  TGVUserPath.GetOrgName: string;
begin
  Result := FOrgName;
end;

procedure TGVUserPath.SetAppId(const aId: string);
begin
  FAppId := aId;
end;

function  TGVUserPath.GetAppId: string;
begin
  Result := FAppId;
end;

function  TGVUserPath.GetAppIdPath: string;
begin
  Result := TPath.Combine(TPath.GetHomePath, FOrgName);
  Result := TPath.Combine(Result, FAppId);
end;

function  TGVUserPath.GetPath: string;
begin
  Result := TPath.Combine(TPath.GetHomePath, FOrgName);
  Result := TPath.Combine(Result, FAppId);
  Result := TPath.Combine(Result, TPath.GetFileNameWithoutExtension(ParamStr(0)));
end;

function  TGVUserPath.GetPath(const aPath: string): string;
begin
  Result := TPath.Combine(GetPath, aPath);
end;

function  TGVUserPath.CreateDirs: Boolean;
begin
  Result := TGVUtil.CreateDirsInPath(GetPath('temp.dat'));
end;

function  TGVUserPath.GetConfigFilename: string;
begin
  Result := TPath.GetFileName(ParamStr(0));
  Result := TPath.ChangeExtension(Result, GV_FILEEXT_INI);
  Result := GetPath(Result);
end;

function  TGVUserPath.GetLogFilename: string;
begin
  Result := TPath.GetFileName(ParamStr(0));
  Result := TPath.ChangeExtension(Result, GV_FILEEXT_LOG);
  Result := GetPath(Result);
end;

end.
