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

unit GameVision.Form.TreeMenu;

{$I GameVision.Defines.inc }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, VCL.Graphics, VCL.Controls, VCL.Forms,
  VCL.Dialogs, VCL.ComCtrls, VCL.StdCtrls, CommCtrl, Vcl.Menus, GameVision.Common;

type


{ TTreeMenuForm }
  TGVTreeMenuForm = class(TForm)
    TreeView: TTreeView;
    OkButton: TButton;
    QuitButton: TButton;
    StatusBar: TStatusBar;
    procedure TreeViewClick(Sender: TObject);
    procedure QuitButtonClick(Sender: TObject);
    procedure TreeViewDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure TreeViewChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
  private
    type
      { TQuitState }
      TQuitState = (qsNone, qsOk, qsQuit, qsDblClick);
  private
    { Private declarations }
    FQuit: Boolean;
    FQuitState: TQuitState;
  public
    { Public declarations }
    SelId: Integer;
    LastSelId: Integer;
    procedure SelMenu(aId: Integer);
    procedure BoldItemId(aId: Integer; aValue: Boolean);
    procedure BoldItem(aItem: string; aValue: Boolean);
    function  Count: Integer;
    //property TreeView: TTreeView read TreeView;
  end;


var
  GVTreeMenuForm: TGVTreeMenuForm;

implementation

uses
  Winapi.Uxtheme,
  VCL.Themes;

{$R *.dfm}

function  TGVTreeMenuForm.Count: Integer;
var
  LNode: TTreeNode;
begin
  Result := 0;
  if TreeView.Items.Count = 0 then Exit;
  LNode := TreeView.Items[0];
  while LNode <> nil do
  begin
    if LNode.SelectedIndex <> GV_TREEMENU_NONE then
    begin
      if LNode.Enabled then
      begin
        Inc(Result);
      end;
    end;
    LNode := LNode.GetNext;
  end;
end;

procedure TGVTreeMenuForm.SelMenu(aId: Integer);
var
  LNode: TTreeNode;
begin
  SelId := GV_TREEMENU_NONE;
  if TreeView.Items.Count = 0 then Exit;
  TreeView.HideSelection := False;
  LNode := TreeView.Items[0];
  while LNode <> nil do
  begin
    if LNode.SelectedIndex = aId then
    begin
      LNode.Selected := True;
      LNode.MakeVisible;
      SelId := aId;
      Break;
    end;
    LNode := LNode.GetNext;
  end;
  if SelId = GV_TREEMENU_NONE then
  begin
    LNode := TreeView.Items[0];
    while LNode <> nil do
    begin
      if LNode.SelectedIndex <> GV_TREEMENU_NONE then
      begin
        LNode.Selected := True;
        LNode.MakeVisible;
        SelId := LNode.SelectedIndex;
        Break;
      end;
      LNode := LNode.GetNext;
    end;
  end;
  FQuitState := qsNone;
  FQuit := False;
end;

procedure TGVTreeMenuForm.BoldItemId(aId: Integer; aValue: Boolean);
var
  LNode: TTreeNode;
  LTreeItem: TTVItem;
begin
  SelId := aId;
  if TreeView.Items.Count = 0 then Exit;
  TreeView.HideSelection := False;
  LNode := TreeView.Items[0];
  while LNode <> nil do
  begin
    if LNode.SelectedIndex = aId then
    begin
      with LTreeItem do
      begin
        hItem := LNode.ItemId;
        stateMask := TVIS_BOLD;
        mask := TVIF_HANDLE or TVIF_STATE;
        if aValue then
          state := TVIS_BOLD
        else
          state := 0;
        end;
        TreeView_SetItem(LNode.Handle, LTreeItem) ;
      Break;
    end;
    LNode := LNode.GetNext;
  end;
end;

procedure TGVTreeMenuForm.BoldItem(aItem: string; aValue: Boolean);
var
  LNode: TTreeNode;
  LTreeItem: TTVItem;
begin
  if TreeView.Items.Count = 0 then Exit;
  TreeView.HideSelection := False;
  LNode := TreeView.Items[0];
  while LNode <> nil do
  begin
    if LNode.Text = aItem then
    begin
      with LTreeItem do
      begin
        hItem := LNode.ItemId;
        stateMask := TVIS_BOLD;
        mask := TVIF_HANDLE or TVIF_STATE;
        if aValue then
          state := TVIS_BOLD
        else
          state := 0;
        end;
        TreeView_SetItem(LNode.Handle, LTreeItem);
      Break;
    end;
    LNode := LNode.GetNext;
  end;
end;

procedure TGVTreeMenuForm.OkButtonClick(Sender: TObject);
begin
  if TreeView.Selected.Enabled then
  begin
    if SelId <> GV_TREEMENU_NONE then
    begin
      FQuitState := qsOk;
      FQuit := True;
      Close;
    end;
  end;
end;

procedure TGVTreeMenuForm.QuitButtonClick(Sender: TObject);
begin
  SelId := GV_TREEMENU_QUIT;
  FQuitState := qsQuit;
  FQuit := True;
  Close;
end;

procedure TGVTreeMenuForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (SelId = GV_TREEMENU_NONE) or (FQuit = False)  then
  begin
    SelId := GV_TREEMENU_QUIT;
  end;
end;

procedure TGVTreeMenuForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  //
end;

procedure TGVTreeMenuForm.FormCreate(Sender: TObject);
begin
  FQuitState := qsNone;
  FQuit := False;
  SelId := GV_TREEMENU_NONE;
  LastSelId := SelId;
  Scaled := False;

  //LoadDefaultIcon(Handle);

  if (not (Screen.PixelsPerInch = PixelsPerInch)) then
  begin
    ScaleBy(Screen.PixelsPerInch, PixelsPerInch);
  end;

  // remove style servers for tree views so the default check
  // check/min selectors will show
  if StyleServices.Enabled and CheckWin32Version(6, 0) then
  begin
    SetWindowTheme(TreeView.Handle, nil, nil);
  end;

end;

procedure TGVTreeMenuForm.FormShow(Sender: TObject);
begin
  TreeView.SetFocus;
end;

procedure TGVTreeMenuForm.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  //
  if TreeView.Selected.Enabled then
  begin
    SelId := TreeView.Selected.SelectedIndex;
    LastSelId := SelId;
  end;
end;

procedure TGVTreeMenuForm.TreeViewChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
begin
  //
  //AllowChange := Node.Enabled;
end;

procedure TGVTreeMenuForm.TreeViewClick(Sender: TObject);
begin
  //
  if TreeView.Selected.Enabled then
  begin
    SelId := TreeView.Selected.SelectedIndex;
    LastSelId := SelId;
  end;
end;

procedure TGVTreeMenuForm.TreeViewDblClick(Sender: TObject);
begin
  //
  if TreeView.Selected.Enabled then
  begin
    SelId := TreeView.Selected.SelectedIndex;
    if SelId <> GV_TREEMENU_NONE then
    begin
      LastSelId := SelId;
      FQuitState := qsDblClick;
      FQuit := True;
      Close;
    end;
  end;
end;

end.
