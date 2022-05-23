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
    FConn: TFDConnection;
    FQuery: TFDQuery;
    FLastError: string;
    procedure Shutdown;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure SetupMySQL(const aServer: string; aPort: Integer; const aDatabase: string; const aUserName: string; const aPassword: string);
    procedure SetupSQLite(const aDatabase: string; aPassword: string);
    procedure ClearSQLText;
    procedure AddSQLText(const aText: string; const aArgs: array of const);
    function  GetSQLText: string;
    procedure SetSQLText(const aText: string);
    procedure Open;
    procedure Close;
    function  Connected: Boolean;
    procedure Execute;
    procedure ExecuteSQL(const aText: string);
    function  GetLastError: string;
    function  GetMacro(const aName: string): string;
    procedure SetMacro(const aName: string; const aValue: string);
    function  GetParam(const aName: string): string;
    procedure SetParam(const aName: string; const aValue: string);
    function  GetField(const aName: string): string;
    procedure SetField(const aName: string; const aValue: string);
    function  Bof: Boolean;
    function  Eof: Boolean;
    procedure First;
    procedure Last;
    procedure Prior;
    procedure Next;
    function FieldCount: Integer;
    function RecordCount: Integer;
    function RecordNo: Integer;
    procedure Delete;
  end;

implementation

uses
  System.Variants,
  System.IOUtils,
  GameVision.Deps;

{ TGVDatabase }
procedure TGVDatabase.Shutdown;
begin
  if FQuery = nil then Exit;
  FreeAndNil(FQuery);
  FreeAndNil(FConn);
  if FMySQLDriver <> nil then FreeAndNil(FMySQLDriver);
  if FSQLiteDriver <> nil then FreeAndNil(FSQLiteDriver);
end;

constructor TGVDatabase.Create;
begin
  inherited;
  FMySQLDriver := nil;
  FSQLiteDriver := nil;
  FConn := nil;
  FQuery := nil;
end;

destructor TGVDatabase.Destroy;
begin
  Shutdown;
  inherited;
end;

procedure TGVDatabase.SetupMySQL(const aServer: string; aPort: Integer; const aDatabase: string; const aUserName: string; const aPassword: string);
begin
  if aServer.IsEmpty then Exit;
  if aDatabase.IsEmpty then Exit;
  if aUserName.IsEmpty then Exit;

  Shutdown;

  FMySQLDriver := TFDPhysMySQLDriverLink.Create(nil);
  FMySQLDriver.VendorLib := TGVDeps.GetMySQLPath;
  FConn := TFDConnection.Create(nil);
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FConn;

  FConn.Params.Clear;
  FConn.Params.Add('DriverID=MySQL');
  FConn.Params.Add(Format('Server=%s', [aServer]));
  FConn.Params.Add(Format('Port=%d', [aPort]));
  FConn.Params.Add(Format('Database=%s', [aDatabase]));
  FConn.Params.Add(Format('User_Name=%s', [aUserName]));
  FConn.Params.Add(Format('Password=%s', [aPassword]));
  FConn.Params.Add('UseSSL=True');
  FConn.Params.Add('CharacterSet=utf8');
  FLastError := '';
end;

 procedure TGVDatabase.SetupSQLite(const aDatabase: string; aPassword: string);
begin
  if aDatabase.IsEmpty then Exit;

  Shutdown;

  FSQLiteDriver := TFDPhysSQLiteDriverLink.Create(nil);
  FConn := TFDConnection.Create(nil);
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FConn;

  FConn.Params.Clear;
  FConn.Params.Add('DriverID=SQLite');
  FConn.Params.Add('Synchronous=Full');
  FConn.Params.Add('OpenMode=CreateUTF16');
  FConn.Params.Add(Format('Database=%s', [aDatabase]));
  FConn.Params.Add(Format('Password=aes-256:%s', [aPassword]));
  FLastError := '';

end;

procedure TGVDatabase.ClearSQLText;
begin
  FQuery.SQL.Clear;
end;

procedure TGVDatabase.AddSQLText(const aText: string; const aArgs: array of const);
begin
  FQuery.SQL.Add(Format(aText, aArgs));
end;

function  TGVDatabase.GetSQLText: string;
begin
  Result := '';
  if FQuery = nil then Exit;
  Result := FQuery.SQL.Text;
end;

procedure TGVDatabase.SetSQLText(const aText: string);
begin
  if FQuery = nil then Exit;
  FQuery.SQL.Text := aText;
end;

procedure TGVDatabase.Open;
begin
  if FQuery = nil then Exit;
  if FQuery.SQL.Text.IsEmpty then Exit;
  FQuery.Open;
  FQuery.Open
end;

procedure TGVDatabase.Close;
begin
  if FQuery = nil then Exit;
  FQuery.Close;
end;

function  TGVDatabase.Connected: Boolean;
begin
  Result := False;
  if FConn = nil then Exit;
  Result := FConn.Connected
end;

procedure TGVDatabase.Execute;
begin
  if FQuery = nil then Exit;
  try
    FQuery.Execute;
  except
    on E: Exception do
    begin
      FLastError := E.Message;
    end;
  end;
end;

procedure TGVDatabase.ExecuteSQL(const aText: string);
begin
  SetSQLText(aText);
  Execute;
end;

function  TGVDatabase.GetLastError: string;
begin
  Result := FLastError;
end;

function  TGVDatabase.GetMacro(const aName: string): string;
begin
  Result := '';
  if FQuery = nil then Exit;
  Result := FQuery.MacroByName(aName).Value;
end;

procedure TGVDatabase.SetMacro(const aName: string; const aValue: string);
begin
  if FQuery = nil then Exit;
  FQuery.MacroByName(aName).AsRaw := aValue;
end;

function  TGVDatabase.GetParam(const aName: string): string;
begin
  Result := '';
  if FQuery = nil then Exit;
  Result := FQuery.ParamByName(aName).AsString;
end;

procedure TGVDatabase.SetParam(const aName: string; const aValue: string);
begin
  if FQuery = nil then Exit;
  FQuery.ParamByName(aName).AsString := aValue;
end;

function  TGVDatabase.GetField(const aName: string): string;
begin
  Result := '';
  if FQuery = nil then Exit;
  Result := FQuery.FieldByName(aName).AsString;
end;

procedure TGVDatabase.SetField(const aName: string; const aValue: string);
begin
  if FQuery = nil then Exit;
  FQuery.FieldByName(aName).AsString := aValue;
end;

function  TGVDatabase.Bof: Boolean;
begin
  Result := False;
  if FQuery = nil then Exit;
  Result := FQuery.Bof;
end;

function  TGVDatabase.Eof: Boolean;
begin
  Result := False;
  if FQuery = nil then Exit;
  Result := FQuery.Eof;
end;

procedure TGVDatabase.First;
begin
  if FQuery = nil then Exit;
  FQuery.First;
end;

procedure TGVDatabase.Last;
begin
  if FQuery = nil then Exit;
  FQuery.Last;
end;

procedure TGVDatabase.Prior;
begin
  if FQuery = nil then Exit;
  FQuery.Prior;
end;

procedure TGVDatabase.Next;
begin
  if FQuery = nil then Exit;
  FQuery.Next;
end;

function TGVDatabase.RecordCount: Integer;
begin
  Result := 0;
  if FQuery = nil then Exit;
  Result := FQuery.RecordCount;
end;

function TGVDatabase.RecordNo: Integer;
begin
  Result := 0;
  if FQuery = nil then Exit;
  Result := FQuery.RecNo;
end;

function TGVDatabase.FieldCount: Integer;
begin
  Result := 0;
  if FQuery = nil then Exit;
  Result := FQuery.FieldCount;
end;

procedure TGVDatabase.Delete;
begin
  if FQuery = nil then Exit;
  FQuery.Delete;
  if FQuery.UpdatesPending then FQuery.ApplyUpdates;
end;


end.
