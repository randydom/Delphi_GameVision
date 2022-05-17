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

unit GameVision.Database;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Comp.Client,
  FireDAC.DApt,
  FireDAC.Phys.MySQL,
  FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLite,
  FireDAC.Stan.Error,
  FireDAC.VCLUI.Wait,
  FireDAC.ConsoleUI.Wait,
  Data.DB,
  GameVision.Base;

const
  GV_DEFAULT_MYSQL_PORT = 3306;

type
  { TGVDatabase }
  TGVDatabase = class(TGVObject)
  protected
    FMySQLDriver: TFDPhysMySQLDriverLink;
    FSQLiteDriver: TFDPhysSQLiteDriverLink;
    FConnection: TFDConnection;
    FDataSet: TDataSet;
    FLastError: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure SetupMySQL(const aServer: string; aPort: Integer; const aDatabase: string; const aUserName: string; const aPassword: string);
    procedure SetupSQLite(const aDatabase: string; aPassword: string);
    procedure Open;
    procedure Close;
    function Connected: Boolean;
    function ExecSQL(const aSQL: string; const aParams: array of const): LongInt;
    function ExecSQLScalar(const aSQL: string; const aParams: array of const): string;
    function Query(const aSQL: string; const aParams: array of const): LongInt;
    function QueryFieldCount: Integer;
    function QueryRecordCount: Integer;
    function QueryBOF: Boolean;
    function QueryEOF: Boolean;
    procedure QueryNext;
    procedure QueryPrev;
    procedure QueryLast;
    procedure QueryFirst;
    function QueryField(const aName: string): string;
    function LastError: string;
  end;

implementation

uses
  System.Variants,
  System.IOUtils,
  GameVision.Deps;

{ TGVDatabase }
constructor TGVDatabase.Create;
begin
  inherited;
  FMySQLDriver := TFDPhysMySQLDriverLink.Create(nil);
  FMySQLDriver.VendorLib := TGVDeps.GetMySQLPath;
  FSQLiteDriver := TFDPhysSQLiteDriverLink.Create(nil);
  FConnection := TFDConnection.Create(nil);
  FDataSet := nil;
end;

destructor TGVDatabase.Destroy;
begin
  Close;
  FreeAndNil(FConnection);
  FreeAndNil(FSQLiteDriver);
  FreeAndNil(FMySQLDriver);
  inherited;
end;

procedure TGVDatabase.SetupMySQL(const aServer: string; aPort: Integer; const aDatabase: string; const aUserName: string; const aPassword: string);
begin
  Close;
  FConnection.Params.Clear;
  FConnection.Params.Add('DriverID=MySQL');
  FConnection.Params.Add(Format('Server=%s', [aServer]));
  FConnection.Params.Add(Format('Port=%d', [aPort]));
  FConnection.Params.Add(Format('Database=%s', [aDatabase]));
  FConnection.Params.Add(Format('User_Name=%s', [aUserName]));
  FConnection.Params.Add(Format('Password=%s', [aPassword]));
  FConnection.Params.Add('UseSSL=True');
  FConnection.Params.Add('CharacterSet=utf8');
  FLastError := '';
end;

procedure TGVDatabase.SetupSQLite(const aDatabase: string; aPassword: string);
begin
  Close;
  FConnection.Params.Clear;
  FConnection.Params.Add('DriverID=SQLite');
  FConnection.Params.Add('Synchronous=Full');
  FConnection.Params.Add('OpenMode=CreateUTF16');
  FConnection.Params.Add(Format('Database=%s', [aDatabase]));
  FConnection.Params.Add(Format('Password=aes-256:%s', [aPassword]));
  FLastError := '';
end;

procedure TGVDatabase.Open;
begin
  if FConnection.Connected then Exit;
  try
    FConnection.Open;
  except
    on E: EFDDBEngineException do
      FLastError := E.Message;
  end;
end;

procedure TGVDatabase.Close;
begin
  if not FConnection.Connected then Exit;
  if FDataSet <> nil then FreeAndNil(FDataSet);
  try
    FConnection.Close;
  except
    on E: EFDDBEngineException do
      FLastError := E.Message;
  end;
end;

function TGVDatabase.Connected: Boolean;
begin
  Result := FConnection.Connected;
end;

function TGVDatabase.ExecSQL(const aSQL: string; const aParams: array of const): LongInt;
begin
  Result := 0;
  if not FConnection.Connected then Exit;
  try
    Result := FConnection.ExecSQL(Format(aSQL, aParams));
  except
    on E: EFDDBEngineException do
      FLastError := E.Message;
  end;
end;

function TGVDatabase.ExecSQLScalar(const aSQL: string; const aParams: array of const): string;
begin
  Result := '';
  if not FConnection.Connected then Exit;
  try
    Result := VarToStr(FConnection.ExecSQLScalar(Format(aSQL, aParams)))
  except
    on E: EFDDBEngineException do
      FLastError := E.Message;
  end;
end;

function TGVDatabase.Query(const aSQL: string; const aParams: array of const): LongInt;
begin
  Result := 0;
  if not FConnection.Connected then Exit;
  if FDataSet <> nil then FreeAndNil(FDataSet);
  try
    Result := FConnection.ExecSQL(Format(aSQL, aParams), FDataSet);
  except
    on E: EFDDBEngineException do
      FLastError := E.Message;
  end;
end;

function TGVDatabase.QueryFieldCount: Integer;
begin
  Result := 0;
  if FDataSet = nil then Exit;
  if not FConnection.Connected then Exit;
  Result := FDataSet.FieldCount;
end;

function TGVDatabase.QueryRecordCount: Integer;
begin
  Result := 0;
  if FDataSet = nil then Exit;
  if not FConnection.Connected then Exit;
  Result := FDataSet.RecordCount;
end;

function TGVDatabase.QueryBOF: Boolean;
begin
  Result := True;
  if FDataSet = nil then Exit;
  if not FConnection.Connected then Exit;
  Result := FDataSet.Bof;
end;

function TGVDatabase.QueryEOF: Boolean;
begin
  Result := True;
  if FDataSet = nil then Exit;
  if not FConnection.Connected then Exit;
  Result := FDataSet.Eof;
end;

procedure TGVDatabase.QueryNext;
begin
  if FDataSet = nil then Exit;
  if not FConnection.Connected then Exit;
  FDataSet.Next;
end;

procedure TGVDatabase.QueryPrev;
begin
  if FDataSet = nil then Exit;
  if not FConnection.Connected then Exit;
  FDataSet.Prior;
end;

procedure TGVDatabase.QueryLast;
begin
  if FDataSet = nil then Exit;
  if not FConnection.Connected then Exit;
  FDataSet.Last;
end;

procedure TGVDatabase.QueryFirst;
begin
  if FDataSet = nil then Exit;
  if not FConnection.Connected then Exit;
  FDataSet.First;
end;

function TGVDatabase.QueryField(const aName: string): string;
begin
  Result := '';
  if FDataSet = nil then Exit;
  if not FConnection.Connected then Exit;
  if aName.IsEmpty then Exit;
  Result := FDataSet.FieldByName(aName).AsString;
end;

function TGVDatabase.LastError: string;
begin
  Result := FLastError;
  FLastError := '';
end;

end.
