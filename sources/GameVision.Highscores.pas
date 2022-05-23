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

unit GameVision.Highscores;

{$I GameVision.Defines.inc}

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  GameVision.Base,
  GameVision.Database;

type

  { TGVHighscores }
  TGVHighscores = class;

  { TGVHighscoreAction }
  TGVHighscoreAction = (haClear, haList, haPost, haRemove);

  { TGVHighscoreEvent }
  TGVHighscoreEvent = procedure(aHighscores: TGVHighscores; aAction: TGVHighscoreAction);

  { TGVHighscore }
  TGVHighscore = record
    Name: string;
    Level: Integer;
    Score: Cardinal;
    Skill: Integer;
    Duration: Cardinal;
    Location: string;
    class operator Equal(a, b: TGVHighscore): Boolean;
  end;

  { TGVHighscores }
  TGVHighscores = class(TGVObject)
  protected
    FBusy: Boolean;
    FScores: TList<TGVHighscore>;
    FDatabase: TGVDatabase;
    FMaxScores: Integer;
    FGameId: string;
    procedure CreateTable(const aGameId: string);
    procedure DropTable(const aGameId: string);
    procedure ClearScores(const aGameId: string);
    procedure AddScore(const aGameID: string; const aName: string; aLevel: Integer; aScore: Cardinal; aSkill: Integer; aDuration: Cardinal; const aLocation: string);
    procedure TopScores(const aGameId: string; aLevel: Integer; aSkill: Integer);
    procedure Prune(const aGameId: string; aLevel: Integer; aSkill: Integer);
    procedure DoEvent(aAction: TGVHighscoreAction);
  public
    property Database: TGVDatabase read FDatabase;
    constructor Create; override;
    destructor Destroy; override;
    function IsBusy: Boolean;
    function LastError: string;
    procedure Setup(aMaxScores: Integer; const aServer: string; const aDatabase: string; const aUsername: string; const aPassword: string;
      const aGameId: string; aPort: Integer=GV_DEFAULT_MYSQL_PORT);
    procedure Clear;
    procedure Remove(const aName: string);
    procedure List(aLevel: Integer; aSkill: Integer);
    procedure Post(const aName: string; aLevel: Integer; aScore: Cardinal; aSkill: Integer; aDuration: Cardinal; const aLocation: string); overload;
    procedure Post(aScore: TGVHighscore); overload;
    procedure ClearResults;
    function  GetResultCount: Integer;
    procedure GetResult(aIndex: Integer; var aScore: TGVHighscore);
  end;

implementation

uses
  System.Classes,
  FireDAC.Phys.MySQL,
  FireDAC.Phys.SQLite,
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  FireDAC.Stan.Param,
  FireDAC.Stan.Intf,
  Data.DB,
  GameVision.Deps,
  GameVision.Core;

const
  cCreateTableSQL = 'CREATE TABLE IF NOT EXISTS &gameid ( ' +
                    'name     VARCHAR(100)          NOT NULL DEFAULT "Anonymous" PRIMARY KEY, ' +
                    'level    INT          UNSIGNED NOT NULL DEFAULT "0", ' +
                    'score    BIGINT       UNSIGNED NOT NULL DEFAULT "0", ' +
                    'skill    INT          UNSIGNED NOT NULL DEFAULT "0", ' +
                    'duration BIGINT       UNSIGNED NOT NULL DEFAULT "0", ' +
                    'location VARCHAR(100)          NOT NULL DEFAULT "Anonymous");';


  cAddScoreSQL    = 'INSERT INTO &gameid (name,level,score,skill,duration,location) ' +
                    'VALUES(:name, :level, :score, :skill, :duration, :location) ' +
                    'ON DUPLICATE KEY UPDATE ' +
                    'level    = if (:score > score, :level,    level), ' +
                    'skill    = if (:score > score, :skill,    skill), ' +
                    'location = if (:score > score, :location, location), ' +
                    'duration = if (:score > score, :duration, duration), ' +
                    'score    = if (:score > score, :score,    score);';

  cTopScoresSQL   = 'SELECT * FROM &gameid WHERE level = :level AND skill = :skill ORDER by score DESC LIMIT :limit';

  cDropTableSQL   = 'DROP TABLE &gameid;';

  cClearTableSQL  = 'DELETE FROM &gameid;';

  cPruneScoresSQL = 'SELECT * FROM &gameid WHERE level = :level AND skill = :skill ORDER by score ASC';

  cRemoveNameSQL  = 'DELETE FROM &gameid WHERE name = :name;';

{ TGVHighscore }
class operator TGVHighscore.Equal(a, b: TGVHighscore): Boolean;
begin
  if (a.Name = b.Name) and
     (a.Level = b.Level) and
     (a.Score = b.Score) and
     (a.Skill = b.Skill) and
     (a.Duration = b.Duration) and
     (a.Location = b.Location) then
    Result := True
  else
    Result := False;
end;

{ TGVHighscores }
procedure TGVHighscores.CreateTable(const aGameId: string);
begin
  FDatabase.SetSQLText(cCreateTableSQL);
  FDatabase.SetMacro('gameid', aGameId);
  FDatabase.Execute;
end;

procedure TGVHighscores.DropTable(const aGameId: string);
begin
  FDatabase.SetSQLText(cDropTableSQL);
  FDatabase.SetMacro('gameid', aGameId);
  FDatabase.Execute;
  Clear;
end;

procedure TGVHighscores.ClearScores(const aGameId: string);
begin
  FDatabase.SetSQLText(cClearTableSQL);
  FDatabase.SetMacro('gameid', aGameId);
  FDatabase.Execute;
  Clear;
end;

procedure TGVHighscores.AddScore(const aGameId: string; const aName: string; aLevel: Integer; aScore: Cardinal; aSkill: Integer; aDuration: Cardinal; const aLocation: string);
begin
  FDatabase.SetSQLText(cAddScoreSQL);
  FDatabase.SetMacro('gameid', aGameId);
  FDatabase.SetParam('name', aName);
  FDatabase.SetParam('level', aLevel.ToString);
  FDatabase.SetParam('score', aScore.ToString);
  FDatabase.SetParam('skill', aSkill.ToString);
  FDatabase.SetParam('duration', aDuration.ToString);
  FDatabase.SetParam('location', aLocation);
  FDatabase.Execute;
end;

procedure TGVHighscores.TopScores(const aGameId: string; aLevel: Integer; aSkill: Integer);
var
  LScore: TGVHighscore;
begin
  FDatabase.SetSQLText(cTopScoresSQL);
  FDatabase.SetMacro('gameid', aGameId);
  FDatabase.SetParam('level', aLevel.ToString);
  FDatabase.SetParam('skill', aSkill.ToString);
  FDatabase.SetParam('limit', FMaxScores.ToString);

  FDatabase.Open;

  FScores.Clear;
  while not FDatabase.Eof do
  begin
    LScore.Name := FDatabase.GetField('name');
    LScore.Level := FDatabase.GetField('level').ToInteger;
    LScore.Score := FDatabase.GetField('score').ToInt64;
    LScore.Skill := FDatabase.GetField('skill').ToInteger;
    LScore.Location := FDatabase.GetField('location');
    LScore.Duration := FDatabase.GetField('duration').ToInt64;
    FScores.Add(LScore);
    FDatabase.Next;
  end;

  FDatabase.Close;
end;

procedure TGVHighscores.Prune(const aGameId: string; aLevel: Integer; aSkill: Integer);
begin
  FDatabase.SetSQLText(cPruneScoresSQL);
  FDatabase.SetMacro('gameid', aGameId);
  FDatabase.SetParam('level', aLevel.ToString);
  FDatabase.SetParam('skill', aSkill.ToString);

  FDatabase.Open;

  while FDatabase.RecordCount > FMaxScores do
  begin
    FDatabase.Delete;
  end;

  FDatabase.Close;

end;

procedure TGVHighscores.DoEvent(aAction: TGVHighscoreAction);
begin
  GV.Game.OnHighscoreAction(Self, aAction);
  FBusy := False;
end;

constructor TGVHighscores.Create;
begin
  inherited;
  FScores := TList<TGVHighscore>.Create;
  FDatabase := nil;
  FMaxScores := 10;
  FBusy := False;
end;

destructor TGVHighscores.Destroy;
begin
  if FDatabase <> nil then FreeAndNil(FDatabase);
  FreeAndNil(FScores);
  inherited;
end;

function TGVHighscores.IsBusy: Boolean;
begin
  Result := FBusy;
  if not FBusy then
  begin
    FBusy := True;
  end;
end;

function TGVHighscores.LastError: string;
begin
  Result := '';
  if FDatabase = nil then Exit;
  Result := FDatabase.GetLastError;
end;

procedure TGVHighscores.Setup(aMaxScores: Integer; const aServer: string; const aDatabase: string; const aUsername: string; const aPassword: string; const aGameId: string; aPort: Integer=GV_DEFAULT_MYSQL_PORT);
begin
  if aServer.IsEmpty then Exit;
  if aDatabase.IsEmpty then Exit;
  if aUsername.IsEmpty then Exit;
  if aGameId.IsEmpty then Exit;

  if FDatabase <> nil then FreeAndNil(FDatabase);

  FDatabase := TGVDatabase.Create;
  FDatabase.SetupMySQL(aServer, aPort, aDatabase, aUsername, aPassword);
  FGameId := aGameId;
end;

procedure TGVHighscores.Clear;
begin
  if IsBusy then Exit;

  GV.Async.Run(
    'TGVHighscores',
    procedure begin
      DropTable(FGameId);
      CreateTable(FGameId);
      ClearResults;
    end,
    procedure begin
      DoEvent(haClear);
    end
  );
end;

procedure TGVHighscores.Remove(const aName: string);
begin
  //TODO:
end;

procedure TGVHighscores.List(aLevel: Integer; aSkill: Integer);
begin
  if IsBusy then Exit;

  GV.Async.Run(
    'TGVHighscores',
    procedure begin
      CreateTable(FGameId);
      TopScores(FGameId, aLevel, aSkill);
    end,
      procedure begin
      DoEvent(haList);
    end
  );
end;

procedure TGVHighscores.Post(const aName: string; aLevel: Integer; aScore: Cardinal; aSkill: Integer; aDuration: Cardinal; const aLocation: string);
begin
  if IsBusy then Exit;

  GV.Async.Run(
    'TGVHighscores',
    procedure
    begin
      CreateTable(FGameId);
      AddScore(FGameId, aName, aLevel, aScore, aSkill, aDuration, aLocation);
      Prune(FGameId, aLevel, aSkill);
      TopScores(FGameId, aLevel, aSkill);
    end,
    procedure
    begin
      DoEvent(haPost);
    end
  );
end;

procedure TGVHighscores.Post(aScore: TGVHighscore);
begin
  Post(aScore.Name, aScore.Level, aScore.Score, aScore.Skill, aScore.Duration, aScore.Location);
end;

procedure TGVHighscores.ClearResults;
begin
  FScores.Clear;
end;

function  TGVHighscores.GetResultCount: Integer;
begin
  Result := FScores.Count;
end;

procedure TGVHighscores.GetResult(aIndex: Integer; var aScore: TGVHighscore);
var
  LScore: TGVHighscore;
begin
  aScore.Name := '';
  aScore.Level := -1;
  aScore.Score := 0;
  aScore.Skill := -1;
  aScore.Duration := 0;
  aScore.Location := '';

  if (aIndex < 0) or (aIndex > FScores.Count-1) then Exit;

  LScore := FScores.Items[aIndex];
  aScore.Name := LScore.Name;
  aScore.Level := LScore.Level;
  aScore.Score := LScore.Score;
  aScore.Skill := LScore.Skill;
  aScore.Duration := LScore.Duration;
  aScore.Location := LScore.Location;
end;


end.
