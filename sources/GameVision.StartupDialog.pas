{==============================================================================
        _____
___________(_)____________
___  __ \_  /__  ___/  __ \
__  /_/ /  / _  /   / /_/ /
_  .___//_/  /_/    \____/
/_/    Game Toolkit™

Copyright © 2021 tinyBigGAMES™ LLC
All Rights Reserved.

Website: https://tinybiggames.com
Email  : support@tinybiggames.com
============================================================================== }

unit GameVision.StartupDialog;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Common,
  GameVision.Base,
  GameVision.Form.StartupDialog,
  GameVision.Archive;

type

  { TGVStartupDialog }
  TGVStartupDialog = class(TGVObject)
  protected
    FDialog: TGVStartupDialogForm;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure SetCaption(const aCaption: string);
    procedure SetIcon(aArchive: TGVArchive; const aFilename: string);
    procedure SetLogo(aArchive: TGVArchive; const aFilename: string);
    procedure SetLogoClickUrl(const aURL: string);
    procedure SetReadme(aArchive: TGVArchive; const aFilename: string);
    procedure SetReadmeText(const aText: string);
    procedure SetLicense(aArchive: TGVArchive; const aFilename: string);
    procedure SetLicenseText(const aText: string);
    procedure SetReleaseInfo(const aReleaseInfo: string);
    procedure SetWordWrap(aWrap: Boolean);
    function  Show: TGVStartupDialogState;
    procedure Hide;
  end;

implementation

uses
  System.IOUtils,
  System.Classes,
  GameVision.Util,
  GameVision.Core;

{ TGVStartupDialog }
constructor TGVStartupDialog.Create;
begin
  inherited;
  FDialog := TGVStartupDialogForm.Create(nil);
  FDialog.Enabled := True;
  GV.Logger.Log('Initialized %s Subsystem', ['StartupDialog']);
end;

destructor TGVStartupDialog.Destroy;
begin
  FreeAndNil(FDialog);
  GV.Logger.Log('Shutdown %s Subsystem', ['StartupDialog']);
  inherited;
end;

procedure TGVStartupDialog.SetCaption(const aCaption: string);
begin
  if FDialog = nil then Exit;
  FDialog.SetCaption(aCaption);
end;

procedure TGVStartupDialog.SetIcon(aArchive: TGVArchive; const aFilename: string);
var
  LStream: TStream;
begin
  if FDialog = nil then Exit;
  if aFilename.IsEmpty then

  if aArchive <> nil then
    begin
      if not aArchive.IsOpen then Exit;
      if not aArchive.FileExist(aFilename) then Exit;
      LStream := aArchive.ExtractToStream(aFilename);
      LStream.Position := 0;
      FDialog.SetIcon(LStream);
      FreeAndNil(LStream);
    end
  else
    begin
      if not TFile.Exists(aFilename) then Exit;
      FDialog.SetIcon(aFilename);
    end;
end;

procedure TGVStartupDialog.SetLogo(aArchive: TGVArchive; const aFilename: string);
var
  LStream: TStream;
begin
  if FDialog = nil then Exit;
  if aFilename.IsEmpty then Exit;
  if aArchive <> nil then
    begin
      if not aArchive.IsOpen then Exit;
      if not aArchive.FileExist(aFilename) then Exit;
      LStream := aArchive.ExtractToStream(aFilename);
      LStream.Position := 0;
      FDialog.SetLogo(LStream);
      FreeAndNil(LStream);
    end
  else
    begin
      if not TFile.Exists(aFilename) then Exit;
      FDialog.SetLogo(aFilename);
    end;
end;

procedure TGVStartupDialog.SetLogoClickUrl(const aURL: string);
begin
  if FDialog = nil then Exit;
  FDialog.SetLogoClickUrl(aURL);
end;

procedure TGVStartupDialog.SetReadme(aArchive: TGVArchive; const aFilename: string);
var
  LStream: TStream;
begin
  if FDialog = nil then Exit;
  if aFilename.IsEmpty then Exit;
  if aArchive <> nil then
    begin
      if not aArchive.IsOpen then Exit;
      if not aArchive.FileExist(aFilename) then Exit;
      LStream := aArchive.ExtractToStream(aFilename);
      LStream.Position := 0;
      FDialog.SetReadme(LStream);
      FreeAndNil(LStream);
    end
  else
    begin
      if not TFile.Exists(aFilename) then Exit;
      FDialog.SetReadme(aFilename);
    end;
end;

procedure TGVStartupDialog.SetReadmeText(const aText: string);
begin
  if FDialog = nil then Exit;
  FDialog.SetReadme(aText);
end;

procedure TGVStartupDialog.SetLicense(aArchive: TGVArchive; const aFilename: string);
var
  LStream: TStream;
begin
  if FDialog = nil then Exit;
  if aFilename.IsEmpty then Exit;
  if aArchive <> nil then
    begin
      if not aArchive.IsOpen then Exit;
      if not aArchive.FileExist(aFilename) then Exit;
      LStream := aArchive.ExtractToStream(aFilename);
      LStream.Position := 0;
      FDialog.SetLicense(LStream);
      FreeAndNil(LStream);
    end
  else
    begin
      if not TFile.Exists(aFilename) then Exit;
      FDialog.SetLicense(aFilename);
    end;
end;

procedure TGVStartupDialog.SetLicenseText(const aText: string);
begin
  if FDialog = nil then Exit;
  FDialog.SetLicense(aText);
end;

procedure TGVStartupDialog.SetReleaseInfo(const aReleaseInfo: string);
begin
  if FDialog = nil then Exit;
  FDialog.SetReleaseInfo(aReleaseInfo);
end;

procedure TGVStartupDialog.SetWordWrap(aWrap: Boolean);
begin
  if FDialog = nil then Exit;
  FDialog.SetWordWrap(aWrap);
end;

function TGVStartupDialog.Show: TGVStartupDialogState;
begin
  Result := sdsQuit;
  if FDialog = nil then Exit;
  FDialog.State := sdsQuit;

  FDialog.PageControl.ActivePageIndex := 0;
  TGVUtil.ProcessMessages;
  FDialog.ShowModal;
  try
    Result := FDialog.State;
  finally
    FDialog.Hide;
  end;
end;

procedure TGVStartupDialog.Hide;
begin
  if FDialog = nil then Exit;
  FDialog.Hide;
end;

end.
