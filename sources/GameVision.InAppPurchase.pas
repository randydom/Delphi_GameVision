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

unit GameVision.InAppPurchase;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  GameVision.Base;

type

  { TGVInAppPurchase }
  TGVInAppPurchase = class;

  { TGVInAppPurchaseEvent }
  TGVInAppPurchaseEvent = procedure(aIAP: TGVInAppPurchase) of object;

  { TGVInAppPurchase }
  TGVInAppPurchase = class(TGVObject)
  protected
    FError: string;
    FStatus: string;
    FDescription: string;
    FId: string;
    FAmount: string;
    FCurrency: string;
    FBusy: Boolean;
  public
    property Error: string read FError;
    property Status: string read FStatus;
    property Description: string read FDescription;
    property Id: string read FId;
    property Amount: string read FAmount;
    property Currency: string read FCurrency;
    constructor Create; override;
    destructor Destroy; override;
    procedure Buy(const aKey: string; const aDescription: string;
      aAmount: Single; const aCurrency: string; const aCardNum: string;
      aExpMonth: Integer; aExpYear: Integer; aCvc: string;
      aEvent: TGVInAppPurchaseEvent);
  end;

implementation

uses
  System.Math,
  GameVision.Core,
  GameVision.Stripe;

{ TGVInAppPurchase }
constructor TGVInAppPurchase.Create;
begin
  inherited;
  FError := '';
  FStatus := '';
  FDescription := '';
  FId := '';
  FAmount := '';
  FCurrency := '';
end;

destructor TGVInAppPurchase.Destroy;
begin
  inherited;
end;

procedure TGVInAppPurchase.Buy(const aKey: string; const aDescription: string; aAmount: Single; const aCurrency: string; const aCardNum: string; aExpMonth: Integer; aExpYear: Integer; aCvc: string; aEvent: TGVInAppPurchaseEvent);
var
  LStripe: IGVStripe;
  LToken: string;
  LCharge: IGVStripeCharge;
  LAmount: Integer;
begin
  if FBusy then Exit;

  if aKey.IsEmpty then Exit;
  if aAmount < 0.50 then Exit;
  if aCurrency.IsEmpty then Exit;
  if aCardNum.IsEmpty then Exit;
  if not InRange(aExpMonth, 1, 12) then Exit;
  if aExpYear < CurrentYear then Exit;
  if aCvc.IsEmpty then Exit;

  GV.Async.Run(
    'TGVInAppPurchase',
    procedure
    begin
      FBusy := True;
      FStatus := '';
      FDescription := '';
      FId := '';
      FAmount := '';
      FCurrency := '';
      LAmount := Trunc(aAmount * 100);
      LStripe := GVCreateStripe(aKey);
      LToken := LStripe.CreateToken(aCardNum, aExpMonth, aExpYear, aCvc);
      LCharge := LStripe.CreateCharge(LToken, aDescription, LAmount.ToString, nil, FError, aCurrency);
    end,
    procedure
    begin
      FStatus := LCharge.Status;
      FDescription := LCharge.Desc;
      FId := LCharge.ID;
      FAmount := (LCharge.AmountPence / 100).ToString;
      FCurrency := LCharge.Currency;
      if Assigned(aEvent) then aEvent(Self);
      FBusy := False;
    end
  );

end;

end.
