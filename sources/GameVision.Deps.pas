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

unit GameVision.Deps;

{$I GameVision.Defines.inc}

interface

type

  { TGVDeps }
  TGVDeps = record
  private
    class var
      FExportPath: string;
    class procedure FatalAbort; static;
    class function Validate(const aPath: string): Boolean; static;
  public
    class constructor Create;
    class destructor Destroy;
    class function GetExportPath: string; static;
    class function GetMySQLPath: string; static;
    class procedure Load; static;
  end;

implementation

{$R GameVision.Deps.res}

uses
  System.Types,
  System.SysUtils,
  System.Classes,
  System.Zip,
  System.IOUtils,
  WinApi.Windows,
  GameVision.Util;

const
  cDllResName = 'c34a79db34c34648b0bd0ba42d26df98';
  cDllNames: array [0..8] of string = (
    'allegro_monolith-5.2.dll',
    'csfml-audio-2.dll',
    'libcrypto-1_1-x64.dll',
    'libmysql.dll',
    'libssl-1_1-x64.dll',
    'Nuklear.dll',
    'openal32.dll',
    'ssleay32.dll',
    'zlib.dll'
  );

{ TGVDeps }
class procedure TGVDeps.FatalAbort;
begin
  MessageBox(0, 'Unable to initialize GameVision Dependencies, terminating!', 'Fatal Error', MB_ICONERROR);
  Halt;
end;

class function TGVDeps.Validate(const aPath: string): Boolean;
var
  LFilename: string;
  LDllPath: string;
begin
  Result := False;
  for LFilename in cDllNames do
  begin
    LDllPath := TPath.Combine(aPath, LFilename);
    if not TFile.Exists(LDllPath) then Exit;
  end;
  Result := True;
end;

class function TGVDeps.GetExportPath: string;
begin
  Result := FExportPath;
end;

class function TGVDeps.GetMySQLPath: string;
begin
  Result := TPath.Combine(FExportPath, 'libmysql.dll');
end;

class constructor TGVDeps.Create;
begin
  ReportMemoryLeaksOnShutdown := True;
  FExportPath := '';
end;

class destructor TGVDeps.Destroy;
begin
  FExportPath := '';
end;

class procedure TGVDeps.Load;
var
  LZipFile: TZipFile;
  LResStream: TResourceStream;
  LPath: string;
  LDirs: TStringDynArray;
  LDir: string;
begin

  // check if dlls resource exist
  if not TGVUtil.ResourceExists(HInstance, cDLLResName) then FatalAbort;

  // extract dlls
  LResStream := TResourceStream.Create(HInstance, cDLLResName, RT_RCDATA);
  try
    if not TZipFile.IsValid(LResStream) then FatalAbort;
    LZipFile := TZipFile.Create;
    try
      LResStream.Position := 0;
      LZipFile.Open(LResStream, zmRead);
      try
        // get GV temp path
        LPath := TPath.Combine(TPath.GetTempPath, 'GameVision\');

        // remove old dll extraction dirs
        LDirs := TDirectory.GetDirectories(LPath);
        for LDir in LDirs do
        begin
          try
            // del dir and all files inside
            TDirectory.Delete(LDir, True);
          except
            // TODO: property error handling
          end;
        end;

        // get temp dll extraction path in GV temp path
        LPath := LPath + TPath.GetGUIDFileName.ToLower + '\';
        TDirectory.CreateDirectory(LPath);
        if not TDirectory.Exists(LPath) then FatalAbort;
        LZipFile.ExtractAll(LPath);
        if not Validate(LPath) then FatalAbort;
        FExportPath := LPath;

        // add export path to this process environment
        LPath := TGVUtil.GetEnvVarValue('PATH');
        LPath := FExportPath + ';' + LPath;
        TGVUtil.SetEnvVarValue('PATH', LPath);
      finally
        LZipFile.Close;
      end;
    finally
      FreeAndNil(LZipFile);
    end;
  finally
    FreeAndNil(LResStream);
  end;
end;

end.
