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

unit uGVArc;

interface

uses
  System.SysUtils,
  System.IOUtils,
  GameVision.CustomGame;

type

  { TGVArc }
  TGVArc = class(TGVCustomGame)
  protected
    procedure ShowHeader;
    procedure ShowUsage;
    procedure OnProgress(const aFilename: string; aProgress: Integer; aNewFile: Boolean);
  public
    procedure OnRun; override;
  end;

implementation

uses
  GameVision.Common,
  GameVision.Archive,
  GameVision.Core;

{ TGVArc }
procedure TGVArc.ShowHeader;
begin
  PrintLn;
  PrintLn('GVArc™ Archive Utilty v%s', [GV_VERSION]);
  PrintLn('Copyright © 2022 tinyBigGAMES™', []);
  PrintLn('All Rights Reserved.', []);
end;

procedure TGVArc.ShowUsage;
begin
  PrintLn;
  PrintLn('Usage: GVArc [password] archivename[.zip] directoryname', []);
  PrintLn('  password      - make archive password protected', []);
  PrintLn('  archivename   - compressed archive name', []);
  PrintLn('  directoryname - directory to archive', []);
end;

procedure TGVArc.OnProgress(const aFilename: string; aProgress: Integer; aNewFile: Boolean);
begin
  if aNewFile then GV.Console.PrintLn;
  Print(GV_CR+'Adding "%s" (%d%s)...', [aFilename, aProgress, '%']);
end;

procedure TGVArc.OnRun;
var
  LPassword: string;
  LArchiveFilename: string;
  LDirectoryName: string;
  LArchive: TGVArchive;
begin
  // init local vars
  LPassword := '';
  LArchiveFilename := '';
  LDirectoryName := '';

  // display header
  ShowHeader;

  // check for password, archive, directory
  if GV.CmdLine.ParamCount = 3 then
    begin
      LPassword := GV.CmdLine.ParamStr(1);
      LArchiveFilename := GV.CmdLine.ParamStr(2);
      LDirectoryName := GV.CmdLine.ParamStr(3);
      LPassword := GV.Util.RemoveQuotes(LPassword);
      LArchiveFilename := GV.Util.RemoveQuotes(LArchiveFilename);
      LDirectoryName := GV.Util.RemoveQuotes(LDirectoryName);
    end
  // check for archive directory
  else if GV.CmdLine.ParamCount = 2 then
    begin
      LArchiveFilename := GV.CmdLine.ParamStr(1);
      LDirectoryName := GV.CmdLine.ParamStr(2);
      LArchiveFilename := GV.Util.RemoveQuotes(LArchiveFilename);
      LDirectoryName := GV.Util.RemoveQuotes(LDirectoryName);
    end
  else
    begin
      // show usage
      ShowUsage;
      Exit;
    end;

  // init archive filename
  //LArchiveFilename :=  TPath.ChangeExtension(LArchiveFilename, 'zip');

  // check if directory exist
  if not TDirectory.Exists(LDirectoryName) then
    begin
      PrintLn;
      PrintLn('Directory was not found: %s', [LDirectoryName]);
      ShowUsage;
      Exit;
    end;

  // display params
  PrintLn;
  if LPassword = '' then
    PrintLn('Password : NONE', [])
  else
    PrintLn('Password : %s', [LPassword]);
  PrintLn('Archive  : %s', [LArchiveFilename]);
  PrintLn('Directory: %s', [LDirectoryName]);

  // try to build archive
  LArchive := TGVArchive.Create;
  try
  if LArchive.Build(LPassword, LArchiveFilename, LDirectoryName, OnProgress) then
    PrintLn(GV_LF+'Success!', [])
  else
    PrintLn(GV_LF+'Failed!', []);
  finally
    FreeAndNil(LArchive);
  end;
end;

end.
