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

unit GameVision.RenderTarget;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Base,
  GameVision.Math,
  GameVision.Texture;

type
  { TGVRenderTarget }
  TGVRenderTarget = class(TGVObject)
  protected
    FTexture: TGVTexture;
    FPosition: TGVVector;
    FRegion: TGVRectangle;
    FActive: Boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Init(aWidth: Integer; aHeight: Integer);
    procedure SetActive(aActive: Boolean);
    function  GetActive: Boolean;
    procedure SetPosition(aX: Single; aY: Single);
    procedure GetPosition(var aPosition: TGVVector);
    procedure GetSize(var aSize: TGVRectangle);
    procedure SetRegion(aX: Single; aY: Single; aWidth: Single; aHeight: Single);
    procedure GetRegion(var aRegion: TGVRectangle);
    procedure Show;
  end;

implementation

uses
  GameVision.Allegro,
  GameVision.Core,
  GameVision.Color;

{ TGVRenderTarget }
constructor TGVRenderTarget.Create;
begin
  inherited;
  FTexture := TGVTexture.Create;
end;

destructor TGVRenderTarget.Destroy;
begin
  FreeAndNil(FTexture);
  inherited;
end;

procedure TGVRenderTarget.Init(aWidth: Integer; aHeight: Integer);
begin
  FTexture.Allocate(aWidth, aHeight);
  FPosition.Assign(0, 0);
  FRegion.Assign(0, 0, FTexture.Width, FTexture.Height);
end;

function  TGVRenderTarget.GetActive: Boolean;
begin
  Result := FActive;
end;

procedure TGVRenderTarget.SetActive(aActive: Boolean);
begin
  if FTexture.Handle = nil then Exit;
  if aActive then
    begin
      al_set_target_bitmap(FTexture.Handle);
      GV.Window.SetRenderTarget(Self);
      FActive := True;
    end
  else
    begin
      al_set_target_backbuffer(GV.Window.Handle);
      GV.Window.SetRenderTarget(nil);
      FActive := False;
    end;
end;

procedure TGVRenderTarget.SetPosition(aX: Single; aY: Single);
begin
  FPosition.Assign(aX, aY);
end;

procedure TGVRenderTarget.GetPosition(var aPosition: TGVVector);
begin
  FPosition.Assign(0, 0);
  if FTexture.Handle = nil then Exit;
  aPosition := FPosition;
end;

procedure TGVRenderTarget.GetSize(var aSize: TGVRectangle);
begin
  aSize.Assign(0, 0, 0, 0);
  if FTexture.Handle = nil then Exit;
  aSize.Assign(FPosition.X, FPosition.Y, FTexture.Width, FTexture.Height);
end;

procedure TGVRenderTarget.SetRegion(aX: Single; aY: Single; aWidth: Single; aHeight: Single);
begin
  if FTexture.Handle = nil then Exit;
  FRegion.Assign(aX, aY, aWidth, aHeight);
end;

procedure TGVRenderTarget.GetRegion(var aRegion: TGVRectangle);
begin
  aRegion.Assign(0, 0, 0, 0);
  if FTexture.Handle = nil then Exit;
  aRegion := FRegion;
end;

procedure TGVRenderTarget.Show;
begin
  if FActive then
    al_set_target_backbuffer(GV.Window.Handle);
  FTexture.Draw(FPosition.X, FPosition.Y, @FRegion, nil, nil, 0, WHITE);
  if FActive then
    al_set_target_bitmap(FTexture.Handle);
end;

end.
