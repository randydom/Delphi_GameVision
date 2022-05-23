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

unit GameVision.TreeMenu;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Base,
  GameVision.Form.TreeMenu;

type
  { TGVTreeMenu }
  TGVTreeMenu = class(TGVObject)
  protected
    FForm: TGVTreeMenuForm;
    FLastSelectedId: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
  public
    procedure SetTitle(const aTitle: string);
    procedure SetStatus(const aTitle: string);

    procedure Clear;
    function  First(aParent: Integer): Integer;

    function  AddItem(aParent: Integer; const aName: string; aId: Integer; aEnabled: Boolean): Integer;
    function  InsertItem(aSibling: Integer; const aName: string; aId: Integer; aEnabled: Boolean): Integer;

    procedure Sort(aParent: Integer);

    procedure SelItem(aId: Integer);
    procedure BoldItemId(aId: Integer; aValue: Boolean);
    procedure BoldItem(const aItem: string; aValue: Boolean);

    function  Show(aId: Integer): Integer;

    function  GetCount: Integer;
    function  GetLastSelectedId: Integer;
    function  GetSelectableCount: Integer;
  end;

implementation

uses
  System.Math,
  VCL.ComCtrls,
  GameVision.Common;

{ TGVTreeMenu }
constructor TGVTreeMenu.Create;
begin
  inherited;
  FForm := TGVTreeMenuForm.Create(nil);
  FForm.StatusBar.SimplePanel := True;
end;

destructor TGVTreeMenu.Destroy;
begin
  FreeAndNil(FForm);
  inherited;
end;

procedure TGVTreeMenu.SetTitle(const aTitle: string);
begin
  FForm.Caption := aTitle;
end;

procedure TGVTreeMenu.SetStatus(const aTitle: string);
begin
  FForm.StatusBar.SimpleText := aTitle;
end;

procedure TGVTreeMenu.Clear;
begin
  FForm.TreeView.Items.Clear;
end;

function  TGVTreeMenu.First(aParent: Integer): Integer;
var
  LNode: TTreeNode;
begin
  Result := GV_TREEMENU_NONE;
  if Pointer(aParent) = nil then
    LNode := FForm.TreeView.Items.GetFirstNode
  else
    LNode := TTreeNode(aParent);

  if LNode.Count > 0 then
  begin
    Result := LNode.getFirstChild.SelectedIndex;
  end;
end;

function  TGVTreeMenu.AddItem(aParent: Integer; const aName: string; aId: Integer; aEnabled: Boolean): Integer;
var
  LNode: TTreeNode;
begin
  LNode := FForm.TreeView.Items.AddChild(TTreeNode(aParent), aName);
  LNode.SelectedIndex := aId;
  if aId = GV_TREEMENU_NONE then BoldItem(aName, True);
  LNode.Enabled := aEnabled;
  Result := Integer(LNode);
end;

function  TGVTreeMenu.InsertItem(aSibling: Integer; const aName: string; aId: Integer; aEnabled: Boolean): Integer;
var
  LNode: TTreeNode;
begin
  LNode := FForm.TreeView.Items.Insert(TTreeNode(aSibling), aName);
  LNode.SelectedIndex := aId;
  if aId = GV_TREEMENU_NONE then BoldItem(aName, True);
  LNode.Enabled := aEnabled;
  Result := Integer(LNode);
end;

procedure TGVTreeMenu.Sort(aParent: Integer);
var
  LNode: TTreeNode;
begin
  LNode := TTreeNode(aParent);
  if LNode = nil then
    FForm.TreeView.AlphaSort(True)
  else
    LNode.CustomSort(nil, 0, False);
end;

procedure TGVTreeMenu.SelItem(aId: Integer);
begin
  FForm.SelMenu(aId);
end;

procedure TGVTreeMenu.BoldItemId(aId: Integer; aValue: Boolean);
begin
  FForm.BoldItemId(aId, aValue);
end;

procedure TGVTreeMenu.BoldItem(const aItem: string; aValue: Boolean);
begin
  FForm.BoldItem(aItem, aValue);
end;

function TGVTreeMenu.Show(aId: Integer): Integer;
begin
  if FForm.TreeView.Items.Count <= 0 then
  begin
    AddItem(0, 'You must add at lest one item', 0, False);
  end;

  FForm.SelMenu(aId);
  FForm.ShowModal;
  Result := FForm.SelId;
end;

function TGVTreeMenu.GetCount: Integer;
begin
  Result := FForm.TreeView.Items.Count;
  if Result < 0 then Result := 0;
end;

function  TGVTreeMenu.GetLastSelectedId: Integer;
begin
  Result := FForm.LastSelId;
end;

function  TGVTreeMenu.GetSelectableCount: Integer;
begin
  Result := FForm.Count;
end;

end.
