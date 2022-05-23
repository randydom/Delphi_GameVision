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
------------------------------------------------------------------------------
Base on:
  ksStripe - Stripe Interface for Delphi
  https://github.com/gmurt/ksStripe
  Copyright 2020 Graham Murt
  email: graham@kernow-software.co.uk

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
   http://www.apache.org/licenses/LICENSE-2.0
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
============================================================================= }

unit GameVision.Stripe;

{$I GameVision.Defines.inc}

interface

uses
  System.Generics.Collections,
  System.Classes,
  GameVision.Json;

type
  { IGVStripeBaseObject }
  IGVStripeBaseObject = interface
  ['{AC396FFE-A89C-4811-8DDD-5A3A69546155}']
    function  GetID: string;
    function  GetObject: string;
    function  GetAsJson: string;
    procedure SetID(const Value: string);
    procedure Clear;
    procedure LoadFromJson(AJson: TGVJsonObject);
    property  ID: string read GetID write SetID;
    property  Obj: string read GetObject;
    property  AsJson: string read GetAsJson;
  end;

  { IGVStripeBaseObjectList }
  IGVStripeBaseObjectList<T> = interface
  ['{3FD36F72-3FF3-4377-AE0E-120A19C63354}']
    function  GetCount: integer;
    function  GetItem(index: integer): T;
    function  GetListID: string;
    procedure Clear;
    procedure LoadFromJson(AJson: TGVJsonObject);
    property  Count: integer read GetCount;
    property  Item[index: integer]: T read GetItem; default;
  end;

  { IGVStripeCard }
  IGVStripeCard = interface(IGVStripeBaseObject)
  ['{76652D56-42CE-4C2F-B0B2-1E6485D501AD}']
    function GetBrand: string;
    function GetLast4: string;
    function GetExpMonth: integer;
    function GetExpYear: integer;
    property Last4: string read GetLast4;
    property Brand: string read GetBrand;
    property ExpMonth: integer read GetExpMonth;
    property ExpYear: integer read GetExpYear;
  end;

  { IGVStripeCharge }
  IGVStripeCharge = interface(IGVStripeBaseObject)
  ['{197B9D1A-B4F1-4220-AFDC-22DE5031F1B4}']
    function GetCreated: TDatetime;
    function GetLiveMode: Boolean;
    function GetPaid: Boolean;
    function GetStatus: string;
    function GetAmountPence: integer;
    function GetCurrency: string;
    function GetRefunded: Boolean;
    function GetCard: IGVStripeCard;
    function GetCustomer: string;
    function GetDesc: string;
    property Created: TDateTime read GetCreated;
    property LiveMode: Boolean read GetLiveMode;
    property Paid: Boolean read GetPaid;
    property Status: string read GetStatus;
    property AmountPence: integer read GetAmountPence;
    property Currency: string read GetCurrency;
    property Refunded: Boolean read GetRefunded;
    property Customer: string read GetCustomer;
    property Card: IGVStripeCard read GetCard;
    property Desc: string read GetDesc;
  end;

  { IGVStripeChargeList }
  IGVStripeChargeList = interface(IGVStripeBaseObjectList<IGVStripeCharge>)
  ['{1A44D5B8-4355-4200-8295-A19D85F4D710}']
  end;

  { IGVStripePlan }
  IGVStripePlan = interface(IGVStripeBaseObject)
  ['{E37D8D42-0FDE-4108-BD58-56603955FDCC}']
    function GetAmountPence: integer;
    function GetCreated: TDateTime;
    function GetCurrency: string;
    function GetInterval: string;
    function GetIntervalCount: integer;
    function GetName: string;
    function GetStatementDescriptor: string;
    function GetTrialPeriodDays: integer;
    property Interval: string read GetInterval;
    property Name: string read GetName;
    property Created: TDateTime read GetCreated;
    property AmountPence: integer read GetAmountPence;
    property Currency: string read GetCurrency;
    property IntervalCount: integer read GetIntervalCount;
    property TrialPeriodDays: integer read GetTrialPeriodDays;
    property StatementDescriptor: string read GetStatementDescriptor;
  end;

  { IGVStripeSubscription }
  IGVStripeSubscription = interface(IGVStripeBaseObject)
  ['{3F2BE016-7483-4020-BEB6-F0A3B55E9753}']
    function GetCancelledAt: TDateTime;
    function GetCurrentPeriodEnd: TDateTime;
    function GetCurrentPeriodStart: TDateTime;
    function GetCustomer: string;
    function GetEndedAt: TDateTime;
    function GetPlan: IGVStripePlan;
    function GetQuantity: integer;
    function GetStart: TDateTime;
    function GetStatus: string;
    function GetTaxPercent: single;
    function GetTrialEnd: TDateTime;
    function GetTrialStart: TDateTime;
    property Plan: IGVStripePlan read GetPlan;
    property Start: TDateTime read GetStart;
    property Status: string read GetStatus;
    property Customer: string read GetCustomer;
    property CurrentPeriodStart: TDateTime read GetCurrentPeriodStart;
    property CurrentPeriodEnd: TDateTime read GetCurrentPeriodEnd;
    property EndedAt: TDateTime read GetEndedAt;
    property TrialStart: TDateTime read GetTrialStart;
    property TrialEnd: TDateTime read GetTrialEnd;
    property CancelledAt: TDateTime read GetCancelledAt;
    property Quantity: integer read GetQuantity;
    property TaxPercent: single read GetTaxPercent;
  end;

  { IGVStripeCustomer }
  IGVStripeCustomer = interface(IGVStripeBaseObject)
  ['{CFA07B51-F63C-4972-ACAB-FA51D6DF5779}']
    function  GetEmail: string;
    function  GetName: string;
    function  GetDescription: string;
    procedure SetName(const Value: string);
    procedure SetEmail(const Value: string);
    procedure Assign(ACustomer: IGVStripeCustomer);
    procedure SetDescription(const Value: string);
    property  Name: string read GetName write SetName;
    property  Email: string read GetEmail write SetEmail;
    property  Description: string read GetDescription write SetDescription;
  end;

  { IGVStripeCustomerList }
  IGVStripeCustomerList = interface(IGVStripeBaseObjectList<IGVStripeCustomer>)
  ['{A84D8E11-C142-4E4C-9698-A6DFBCE14742}']
  end;

  { IGVStripe }
  IGVStripe = interface
  ['{A00E2188-0DDB-469F-9C4A-0900DEEFD27B}']
    function  GetLastError: string;
    function  GetLastJsonResult: string;
    function  CreateToken(ACardNum: string; AExpMonth, AExpYear: integer; ACvc: string): string;
    function  ChargePaymentMethod(ACustID, APaymentMethod, ACurrency, ADesc: string; AAmountCents: integer; var AError: string): IGVStripeCharge;
    function  CreateCharge(AToken, ADescription: string; AAmountPence: string; AMetaData: TStrings; var AError: string; const ACurrency: string): IGVStripeCharge;
    function  GetCharge(AChargeID: string): IGVStripeCharge; overload;
    function  GetCharges: IGVStripeChargeList;
    procedure GetCharge(AChargeID: string; ACharge: TGVJsonObject); overload;
    function  GetCheckoutSession(ASessionID: string): TGVJsonObject;
    function  GetSetupIntent(ASetupIntentID: string): TGVJsonObject;
    function  CreateCard(ACustID, ACardToken: string; var AError: string): IGVStripeCard; overload;
    function  CreateCard(ACustID, ACardNum: string; AExpMonth, AExpYear: integer; ACvc: string; var AError: string): IGVStripeCard; overload;
    function  CreateSetupIntent(ACustID: string): string;
    function  CreatePaymentIntent(ACustID, ADescription: string; AAmountCents: integer; const AMetaData: TStrings = nil): string;
    function  DeleteCard(ACustID, ACardID: string): Boolean;
    function  UpdateDefaultSource(ACustID, ACardID: string): Boolean;
    function  CreateChargeForCustomer(ACustID, ADescription: string; AAmountPence: string; const ACurrency: string): IGVStripeCharge;
    function  RefundCharge(AChargeID: string): string;
    procedure GetCustomer(ACustID: string; AJson: TGVJsonObject); overload;
    function  GetCustomer(ACustID: string): IGVStripeCustomer; overload;
    function  CustomerExists(ACustID: string; ACustomer: IGVStripeCustomer): Boolean;
    function  GetAccount: string;
    procedure GetInvoice(AInvID: string; AJson: TGVJsonObject);
    function  GetPaymentMethod(APaymentMethodID: string): string;
    function  GetPaymentIntent(APaymentIntentID: string): string;
    function  GetSelfServiceUrl(ACustID, AReturnURL: string): string;
    function  GetCapabilities: string;
    function  GetPersons: string;
    function  GetCustomers(const ACreatedAfter: TDateTime=-1; const ACreatedBefore: TDateTime=-1; const ALimit: Integer=10): IGVStripeCustomerList;
    function  CreateCustomer(AName, AEmail, ADescription, APaymentMethod: string): IGVStripeCustomer;
    function  GetBalance: Extended;
    function  TestCredentials(var AError: string): Boolean;
    procedure UpdateCustomerValue(ACustID, AField, AValue: string);
    property  LastError: string read GetLastError;
    property  LastJsonResult: string read GetLastJsonResult;
  end;

{ Routines }
function GVCreateStripe(ASecretKey: string): IGVStripe;
function GVCreateStripeCustomer: IGVStripeCustomer;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  System.Net.URLClient,
  System.Net.HttpClient,
  System.Net.HttpClientComponent;

const
  C_ACCOUNT = 'account';
  C_CAPABILITIES = 'capabilities';
  C_BALANCE = 'balance';
  C_CARD = 'card';
  C_CARDS = 'cards';
  C_CHARGE = 'charge';
  C_CHARGES = 'charges';
  C_CUSTOMER = 'customer';
  C_CUSTOMERS = 'customers';
  C_INVOICES = 'invoices';
  C_TOKEN  = 'token';
  C_TOKENS = 'tokens';
  C_PERSONS = 'persons';
  C_PLAN = 'plan';
  C_PLANS = 'plans';
  C_SUBSCRIPTION = 'subscription';
  C_SUBSCRIPTIONS = 'subscriptions';
  C_SETUP_INTENTS = 'setup_intents';
  C_PAYMENT_INTENTS = 'payment_intents';
  C_PAYMENT_METHODS = 'payment_methods';

type
  { TStripeBaseObject }
  TStripeBaseObject = class(TInterfacedObject, IGVStripeBaseObject)
  strict private
    FJson: TGVJsonObject;
    FId: string;
  private
    procedure SetID(const Value: string);
    function GetAsJson: string;
  protected
    function GetID: string;
    function GetObject: string; virtual; abstract;
    procedure LoadFromJson(AJson: TGVJsonObject); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear; virtual;
    property ID: string read GetID write SetID;
    property AsJson: string read GetAsJson;
  end;

  { TStripeBaseObjectList }
  TStripeBaseObjectList<T> = class(TInterfacedObject, IGVStripeBaseObjectList<T>)
  strict private
    FItems: TList<T>;
  private
    function GetCount: integer;
  protected
    constructor Create; virtual;
    destructor Destroy; override;
    function CreateObject: T; virtual; abstract;
    function AddObject: T; virtual;
    function GetListID: string; virtual; abstract;
    procedure Clear;
    procedure LoadFromJson(AJson: TGVJsonObject); virtual; abstract;
    function GetItem(index: integer): T;
    property Count: integer read GetCount;
    property Item[index: integer]: T read GetItem; default;
  end;

  { TStripeCharge }
  TStripeCharge = class(TStripeBaseObject, IGVStripeCharge)
  strict private
    FCreated: TDateTime;
    FDesc: string;
    FLiveMode: Boolean;
    FPaid: Boolean;
    FStatus: string;
    FAmountPence: integer;
    FCurrency: string;
    FRefunded: Boolean;
    FCustomer: string;
    FCard: IGVStripeCard;
  private
    function GetCreated: TDatetime;
    function GetLiveMode: Boolean;
    function GetPaid: Boolean;
    function GetStatus: string;
    function GetAmountPence: integer;
    function GetCurrency: string;
    function GetRefunded: Boolean;
    function GetCustomer: string;
    function GetCard: IGVStripeCard;
    function GetDesc: string;
  protected
    function GetObject: string; override;
    procedure Clear; override;
    procedure LoadFromJson(AJson: TGVJsonObject); override;
    property Created: TDateTime read GetCreated;
    property LiveMode: Boolean read GetLiveMode;
    property Paid: Boolean read GetPaid;
    property Status: string read GetStatus;
    property AmountPence: integer read GetAmountPence;
    property Currency: string read GetCurrency;
    property Refunded: Boolean read GetRefunded;
    property Customer: string read GetCustomer;
    property Card: IGVStripeCard read GetCard;
    property Desc: string read GetDesc;
  public
    constructor Create; override;
  end;

  { TStripeChargeList }
  TStripeChargeList = class(TStripeBaseObjectList<IGVStripeCharge>, IGVStripeChargeList)
  protected
    function CreateObject: IGVStripeCharge; override;
    function GetListID: string; override;
    procedure LoadFromJson(AJson: TGVJsonObject); override;
  end;

  { TStripeCard }
  TStripeCard = class(TStripeBaseObject, IGVStripeCard)
  strict private
    FBrand: string;
    FLast4: string;
    FExpMonth: integer;
    FExpYear: integer;
  private
    function GetBrand: string;
    function GetLast4: string;
    function GetExpMonth: integer;
    function GetExpYear: integer;
  protected
    function GetObject: string; override;
    procedure Clear; override;
    procedure LoadFromJson(AJson: TGVJsonObject); override;
  public
    property Last4: string read GetLast4;
    property Brand: string read GetBrand;
    property ExpMonth: integer read GetExpMonth;
    property ExpYear: integer read GetExpYear;
  end;

  { TStripePlan }
  TStripePlan = class(TStripeBaseObject, IGVStripePlan)
  strict private
    FInterval: string;
    FName: string;
    FCreated: TDateTime;
    FAmountPence: integer;
    FCurrency: string;
    FIntervalCount: integer;
    FTrialPeriodDays: integer;
    FStatementDescriptor: string;
  private
    function GetAmountPence: integer;
    function GetCreated: TDateTime;
    function GetCurrency: string;
    function GetInterval: string;
    function GetIntervalCount: integer;
    function GetName: string;
    function GetStatementDescriptor: string;
    function GetTrialPeriodDays: integer;
  protected
    function GetObject: string; override;
    procedure LoadFromJson(AJson: TGVJsonObject); override;
    property Interval: string read GetInterval;
    property Name: string read GetName;
    property Created: TDateTime read GetCreated;
    property AmountPence: integer read GetAmountPence;
    property Currency: string read GetCurrency;
    property IntervalCount: integer read GetIntervalCount;
    property TrialPeriodDays: integer read GetTrialPeriodDays;
    property StatementDescriptor: string read GetStatementDescriptor;
  end;

  { TStripeSubscription }
  TStripeSubscription = class(TStripeBaseObject, IGVStripeSubscription)
  strict private
    FPlan: IGVStripePlan;
    FStart: TDateTime;
    FStatus: string;
    FCustomer: string;
    FCurrentPeriodStart: TDateTime;
    FCurrentPeriodEnd: TDateTime;
    FEndedAt: TDateTime;
    FTrialStart: TDateTime;
    FTrialEnd: TDateTime;
    FCancelledAt: TDateTime;
    FQuantity: integer;
    FTaxPercent: Single;
  private
    function GetCancelledAt: TDateTime;
    function GetCurrentPeriodEnd: TDateTime;
    function GetCurrentPeriodStart: TDateTime;
    function GetCustomer: string;
    function GetEndedAt: TDateTime;
    function GetPlan: IGVStripePlan;
    function GetQuantity: integer;
    function GetStart: TDateTime;
    function GetStatus: string;
    function GetTaxPercent: single;
    function GetTrialEnd: TDateTime;
    function GetTrialStart: TDateTime;
  protected
    function GetObject: string; override;
    procedure LoadFromJson(AJson: TGVJsonObject); override;
  public
    constructor Create; override;
    property Plan: IGVStripePlan read GetPlan;
    property Start: TDateTime read GetStart;
    property Status: string read GetStatus;
    property Customer: string read GetCustomer;
    property CurrentPeriodStart: TDateTime read GetCurrentPeriodStart;
    property CurrentPeriodEnd: TDateTime read GetCurrentPeriodEnd;
    property EndedAt: TDateTime read GetEndedAt;
    property TrialStart: TDateTime read GetTrialStart;
    property TrialEnd: TDateTime read GetTrialEnd;
    property CancelledAt: TDateTime read GetCancelledAt;
    property Quantity: integer read GetQuantity;
    property TaxPercent: single read GetTaxPercent;
  end;

  { TStripeCustomer }
  TStripeCustomer = class(TStripeBaseObject, IGVStripeCustomer)
  strict private
    FEmail: string;
    FName: string;
    FDescription: string;
  private
    function GetEmail: string;
    procedure SetEmail(const Value: string);
    function GetDescription: string;
    procedure SetDescription(const Value: string);
    function GetName: string;
    procedure SetName(const Value: string);
  protected
    function GetObject: string; override;
    procedure LoadFromJson(AJson: TGVJsonObject); override;
    property Name: string read GetName write SetName;
    property Email: string read GetEmail write SetEmail;
    property Description: string read GetDescription write SetDescription;
  public
    procedure Assign(ACustomer: IGVStripeCustomer);
    procedure Clear; override;
  end;

  { TStripeCustomerList }
  TStripeCustomerList = class(TStripeBaseObjectList<IGVStripeCustomer>, IGVStripeCustomerList)
  protected
    function CreateObject: IGVStripeCustomer; override;
    function GetListID: string; override;
    procedure LoadFromJson(AJson: TGVJsonObject); override;
  end;

  { TStripe }
  TStripe = class(TInterfacedObject, IGVStripe)
  strict private
    FSecretKey: string;
    FLastError: string;
    FLastJsonResult: string;
  private
    procedure CheckForError(AJson: TGVJsonObject);
    procedure NetHTTPClient1AuthEvent(const Sender: TObject;
                                      AnAuthTarget: TAuthTargetType;
                                      const ARealm, AURL: string; var AUserName,
                                      APassword: string; var AbortAuth: Boolean;
                                      var Persistence: TAuthPersistenceType);
    function CreateHttp: TNetHTTPClient;
    function GetHttp(AMethod: string; AParams: TStrings): string;
    function PostHttp(AToken, AMethod: string; AParams: TStrings): string;
    function DeleteHttp(AMethod: string): string;
    function GetLastError: string;
    function GetLastJsonResult: string;
  protected
    function CreateToken(ACardNum: string; AExpMonth, AExpYear: integer; ACvc: string): string;
    function ChargePaymentMethod(ACustID, APaymentMethod, ACurrency, ADesc: string; AAmountCents: integer; var AError: string): IGVStripeCharge;
    function CreateCharge(AToken, ADescription: string; AAmountPence: string; AMetaData: TStrings; var AError: string; const ACurrency: string): IGVStripeCharge;
    function GetCharge(AChargeID: string): IGVStripeCharge; overload;
    function GetCharges: IGVStripeChargeList;
    procedure GetCharge(AChargeID: string; ACharge: TGVJsonObject); overload;
    function GetCheckoutSession(ASessionID: string): TGVJsonObject;
    function GetSetupIntent(ASetupIntentID: string): TGVJsonObject;
    function RefundCharge(AChargeID: string): string;
    function CreateCard(ACustID, ACardToken: string; var AError: string): IGVStripeCard; overload;
    function CreateCard(ACustID, ACardNum: string; AExpMonth, AExpYear: integer; ACvc: string; var AError: string): IGVStripeCard; overload;
    function CreateSetupIntent(ACustID: string): string;
    function CreatePaymentIntent(ACustID, ADescription: string; AAmountCents: integer; const AMetaData: TStrings = nil): string;
    function DeleteCard(ACustID, ACardID: string): Boolean;
    function UpdateDefaultSource(ACustID, ACardID: string): Boolean;
    procedure UpdateCustomerValue(ACustID, AField, AValue: string);
    function CreateChargeForCustomer(ACustID, ADescription: string; AAmountPence: string; const ACurrency: string): IGVStripeCharge;
    function GetAccount: string;
    function GetCapabilities: string;
    function GetPersons: string;
    function GetPaymentMethod(APaymentMethodID: string): string;
    function GetPaymentIntent(APaymentIntentID: string): string;
    function GetSelfServiceUrl(ACustID, AReturnURL: string): string;
    function CustomerExists(ACustID: string; ACustomer: IGVStripeCustomer): Boolean;
    function GetCustomer(ACustID: string): IGVStripeCustomer; overload;
    procedure GetCustomer(ACustID: string; AJson: TGVJsonObject); overload;
    function GetCustomers(const ACreatedAfter: TDateTime  = -1;
                          const ACreatedBefore: TDateTime = -1;
                          const ALimit: Integer = 10): IGVStripeCustomerList;
    procedure GetInvoice(AInvID: string; AJson: TGVJsonObject);
    function GetBalance: Extended;
    function TestCredentials(var AError: string): Boolean;
    function CreateCustomer(AName, AEmail, ADescription, APaymentMethod: string): IGVStripeCustomer;
    property LastError: string read GetLastError;
    property LastJsonResult: string read GetLastJsonResult;
  public
    constructor Create(ASecretKey: string);
  end;

{ Routines }
function  GVCreateStripe(ASecretKey: string): IGVStripe;
begin
  Result := TStripe.Create(ASecretKey);
end;

function GVCreateStripeCustomer: IGVStripeCustomer;
begin
  Result := TStripeCustomer.Create;
end;

{ TStripe }
constructor TStripe.Create(ASecretKey: string);
begin
  inherited Create;
  FSecretKey := ASecretKey;
end;

procedure TStripe.CheckForError(AJson: TGVJsonObject);
var
  AError: TGVJsonObject;
begin
  FLastError := '';
  if AJson.Contains('error') then
  begin
    AError := AJson.O['error'] as TGVJsonObject;
    FLastError := AError.s['message'];
  end;
end;

function TStripe.CreateCard(ACustID, ACardToken: string; var AError: string): IGVStripeCard;
var
  AParams: TStrings;
  AResult: string;
  AJson: TGVJsonObject;
begin
  Result := TStripeCard.Create;
  AParams := TStringList.Create;
  try
    AParams.Values['source'] := ACardToken;
    AResult := PostHttp('', C_CUSTOMERS+'/'+ACustID+'/sources',AParams);
    AJson := TGVJsonObject.Parse(AResult) as TGVJsonObject;
    try
      CheckForError(AJson);
      AError := FLastError;
      if FLastError <> '' then
        Exit;
      Result.LoadFromJson(AJson);// := // AJson.Values['id'].Value;
    finally
      AJson.Free;
    end;
  finally
    AParams.Free;
  end;
end;

function TStripe.CreateCharge(AToken, ADescription: string; AAmountPence: string; AMetaData: TStrings; var AError: string; const ACurrency: string): IGVStripeCharge;
var
  AParams: TStrings;
  AResult: string;
  AJson: TGVJsonObject;
  ICount: integer;
begin
  Result := TStripeCharge.Create;
  AParams := TStringList.Create;
  try
    AParams.Values['amount'] := AAmountPence;
    AParams.Values['currency'] := ACurrency;
    AParams.Values['description'] := ADescription;
    if AMetaData <> nil then
    begin
      for ICount := 0 to AMetaData.Count-1 do
        AParams.Values['metadata['+AMetaData.Names[ICount]+']'] := AMetaData.ValueFromIndex[ICount];
    end;
    AResult := PostHttp(AToken, C_CHARGES, AParams);
    AJson := TGVJsonObject.Parse(AResult) as TGVJsonObject;
   //   ALog := 5;
    try
      CheckForError(AJson);
 //   ALog := 6;
      AError := FLastError;
  //  ALog := 7;
      Result.LoadFromJson(AJson);
 //   ALog := 8;
    finally
      AJson.Free;
    end;
  finally
    AParams.Free;
  end;
end;

function TStripe.CreateChargeForCustomer(ACustID, ADescription: string; AAmountPence: string; const ACurrency: string): IGVStripeCharge;
begin
  // TODO:
  Result := nil;
end;

function TStripe.CreateHttp: TNetHTTPClient;
begin
  Result := TNetHTTPClient.Create(nil);
  Result.OnAuthEvent := NetHTTPClient1AuthEvent;
end;

function TStripe.CreatePaymentIntent(ACustID, ADescription: string; AAmountCents: integer; const AMetaData: TStrings = nil): string;
var
  AParams: TStrings;
  AResult: string;
  AJson: TGVJsonObject;
  ICount: integer;
begin
  AParams := TStringList.Create;
  try
    AParams.Values['payment_method_types[]'] := 'card';
    AParams.Values['customer'] := ACustID;
    AParams.Values['currency'] := 'usd';
    AParams.Values['description'] := ADescription;
    AParams.Values['amount'] := AAmountCents.ToString;
    if AMetaData <> nil then
    begin
      for ICount := 0 to AMetaData.Count-1 do
        AParams.Values['metadata['+AMetaData.Names[ICount]+']'] := AMetaData.ValueFromIndex[ICount];
    end;
    AResult := PostHttp('', C_PAYMENT_INTENTS, AParams);
    AJson := TGVJsonObject.Parse(AResult) as TGVJsonObject;
    CheckForError(AJson);
    try
      Result := AJson.Values['client_secret'].Value;
    finally
      AJson.Free;
    end;
  finally
    AParams.Free;
  end;
end;

function TStripe.ChargePaymentMethod(ACustID, APaymentMethod, ACurrency, ADesc: string; AAmountCents: integer; var AError: string): IGVStripeCharge;
var
  AParams: TStrings;
  AResult: string;
  AJson: TGVJsonObject;
begin
  Result := TStripeCharge.Create;
  AParams := TStringList.Create;
  try
    AParams.Values['amount'] := AAmountCents.ToString;
    AParams.Values['currency'] := ACurrency;
    if ACustID <> '' then
      AParams.Values['customer'] := ACustID;
    if APaymentMethod <> '' then
    begin
      AParams.Values['payment_method'] := APaymentMethod;
      AParams.Values['description'] := ADesc;
      AParams.Values['off_session'] := 'true';
      AParams.Values['confirm'] := 'true';
    end;
    AResult := PostHttp('', C_PAYMENT_INTENTS, AParams);
    AJson := TGVJsonObject.Parse(AResult) as TGVJsonObject;
    try
      if AJson.Contains('error') then
      begin
        AError := AJson.O['error'].S['message'];
        Exit;
      end;
      Result := GetCharge(AJson.O['charges'].A['data'][0].S['id']);
      CheckForError(AJson);
        //Result := AJson.Values['client_secret'].Value;
    finally
      AJson.Free;
    end;
  finally
    AParams.Free;
  end;
end;

function TStripe.CreateSetupIntent(ACustID: string): string;
var
  AParams: TStrings;
  AResult: string;
  AJson: TGVJsonObject;
begin
  AParams := TStringList.Create;
  try
    AParams.Values['payment_method_types[]'] := 'card';
    if ACustID <> '' then
      AParams.Values['customer'] := ACustID;
    AParams.Values['usage'] := 'off_session';
    AResult := PostHttp('', C_SETUP_INTENTS, AParams);
    AJson := TGVJsonObject.Parse(AResult) as TGVJsonObject;
    CheckForError(AJson);
    try
      Result := AJson.Values['client_secret'].Value;
    finally
      AJson.Free;
    end;
  finally
    AParams.Free;
  end;
end;

function TStripe.CreateToken(ACardNum: string; AExpMonth, AExpYear: integer;
  ACvc: string): string;
var
  AParams: TStrings;
  AResult: string;
  AJson: TGVJsonObject;
begin
  AParams := TStringList.Create;
  try
    AParams.Values['card[number]'] := ACardNum;
    AParams.Values['card[exp_month]'] := IntToStr(AExpMonth);
    AParams.Values['card[exp_year]'] := IntToStr(AExpYear);
    AParams.Values['card[cvc]'] := ACvc;
    AResult := PostHttp('', C_TOKENS,AParams);
    AJson := TGVJsonObject.Parse(AResult) as TGVJsonObject;
    CheckForError(AJson);
    try
      Result := AJson.Values['id'].Value;
    finally
      AJson.Free;
    end;
  finally
    AParams.Free;
  end;
end;

function TStripe.CreateCard(ACustID, ACardNum: string; AExpMonth, AExpYear: integer;
  ACvc: string; var AError: string): IGVStripeCard;
var
  AParams: TStrings;
  AResult: string;
  AJson: TGVJsonObject;
begin
  Result := TStripeCard.Create;
  AParams := TStringList.Create;
  try
    AParams.Values['source[object]'] := 'card';
    AParams.Values['source[number]'] := ACardNum;
    AParams.Values['source[exp_month]'] := IntToStr(AExpMonth);
    AParams.Values['source[exp_year]'] := IntToStr(AExpYear);
    AParams.Values['source[cvc]'] := ACvc;
    AResult := PostHttp('', C_CUSTOMERS+'/'+ACustID+'/sources',AParams);
    AJson := TGVJsonObject.Parse(AResult) as TGVJsonObject;
    try
      CheckForError(AJson);
      AError := FLastError;
      if FLastError <> '' then
        Exit;
      Result.LoadFromJson(AJson);
    finally
      AJson.Free;
    end;
  finally
    AParams.Free;
  end;
end;

function TStripe.CustomerExists(ACustID: string; ACustomer: IGVStripeCustomer): Boolean;
var
  ACust: IGVStripeCustomer;
begin
  ACust := GetCustomer(ACustID);
  Result := ACust.ID <> '';
  if (Result) and (ACustomer <> nil) then
    ACustomer.Assign(ACust);
end;

function TStripe.DeleteCard(ACustID, ACardID: string): Boolean;
var
  AResult: string;
begin
  AResult := DeleteHttp('customers/'+ACustID+'/sources/'+ACardID);
  Result := True;
end;

function TStripe.GetAccount: string;
begin
  Result := GetHttp(C_ACCOUNT, nil);
end;

function TStripe.GetBalance: Extended;
var
  AResult: string;
  //AJson: TJsonObject;
begin
  Result := 0;
  AResult := GetHttp(C_BALANCE, nil);
  if True then
end;

function TStripe.GetCapabilities: string;
begin
  Result := GetHttp('accounts/acct_1Ei2lxJ9jnzBMBPN/capabilities', nil);
end;
function TStripe.GetCharge(AChargeID: string): IGVStripeCharge;
var
  AData: string;
  AJson: TGVJsonObject;
begin
  Result := TStripeCharge.Create;
  AData := GetHttp(C_CHARGES+'/'+AChargeID, nil);
  AJson := TGVJsonObject.Parse(AData) as TGVJsonObject;
  try
    Result.LoadFromJson(AJson);
  finally
    AJson.Free;
  end;
end;

procedure TStripe.GetCharge(AChargeID: string; ACharge: TGVJsonObject);
begin
  ACharge.FromJSON(GetHttp(C_CHARGES+'/'+AChargeID, nil));
end;
function TStripe.GetCharges: IGVStripeChargeList;
var
  AResult: string;
  AJson: TGVJsonObject;
  AParams: TStrings;
begin
  Result := TStripeChargeList.Create;
  AParams := TStringList.Create;
  try
    AParams.Values['limit'] := IntToStr(100);
    //AParams.Values['created[lt]'] := DateTimeToUnix(EncodeDate(2021,10,22)).ToString;
    AResult := GetHttp(C_CHARGES, AParams);
    AJson := TGVJsonObject.Parse(AResult) as TGVJsonObject;
    try
      Result.LoadFromJson(AJson);
    finally
      AJson.Free;
    end;
  finally
    AParams.Free;
  end;
end;

function TStripe.GetCheckoutSession(ASessionID: string): TGVJsonObject;
var
  AData: string;
begin
  AData := GetHttp('checkout/sessions/'+ASessionID, nil);
  Result := TGVJsonObject.Parse(AData) as TGVJsonObject;
end;

function TStripe.GetCustomer(ACustID: string): IGVStripeCustomer;
var
  AResult: string;
  AJson: TGVJsonObject;
begin
  Result := TStripeCustomer.Create;
  AResult := GetHttp(C_CUSTOMERS+'/'+ACustID, nil);
  AJson := TGVJsonObject.Parse(AResult) as TGVJsonObject;
  try
    CheckForError(AJson);
    if FLastError <> '' then
    begin
      Result.Clear;
      Exit;
    end;
    if AJson.S['deleted'] = 'true' then
    begin
      Result.Clear;
      Exit;
    end;
    Result.LoadFromJson(AJson);
  finally
    AJson.Free;
  end;
end;

procedure TStripe.GetCustomer(ACustID: string; AJson: TGVJsonObject);
var
  AData: string;
begin
  AData := GetHttp(C_CUSTOMERS+'/'+ACustID, nil);
  AJson.FromJSON(AData);
end;
function TStripe.GetCustomers(const ACreatedAfter: TDateTime = -1;
                              const ACreatedBefore: TDateTime = -1;
                              const ALimit: Integer = 10): IGVStripeCustomerList;
var
  AResult: string;
  AJson: TGVJsonObject;
  AParams: TStrings;
begin
  AParams := TStringList.Create;
  try
    if ACreatedAfter > -1 then AParams.Values['created[gt]'] := IntToStr(DateTimeToUnix(ACreatedAfter));
    if ACreatedBefore > -1 then AParams.Values['created[lt]'] := IntToStr(DateTimeToUnix(ACreatedBefore));
    AParams.Values['limit'] := IntToStr(ALimit);
    Result := TStripeCustomerList.Create;
    AResult := GetHttp(C_CUSTOMERS, AParams);
    AJson := TGVJsonObject.Parse(AResult) as TGVJsonObject;
    try
      Result.LoadFromJson(AJson);
    finally
      AJson.Free;
    end;
  finally
    AParams.Free;
  end;
end;

function TStripe.GetHttp(AMethod: string; AParams: TStrings): string;
  function ParamsToUrl(AStrings: TStrings): string;
  var
    ICount: integer;
  begin
    Result := '';
    for ICount := 0 to AStrings.Count-1 do
    begin
      Result := Result + AStrings[ICount];
      if ICount < AStrings.Count-1 then
        Result := Result + '&';
    end;
  end;
var
  AHttp: TNetHTTPClient;
  AResponse: IHTTPResponse;
  AUrl: string;
begin
  AHttp := CreateHttp;
  try
    AUrl := 'https://api.stripe.com/v1/'+AMethod;
    if AParams <> nil then
    begin
      if AParams.Count > 0 then
        AUrl := AUrl + '?'+ParamsToUrl(AParams);
    end;
    AHttp.CustomHeaders['Authorization'] := 'Bearer '+FSecretKey;
    AResponse := AHttp.Get(AUrl);
    Result := AResponse.ContentAsString;
    FLastJsonResult := Result;
  finally
    AHttp.Free;
  end;
end;

procedure TStripe.GetInvoice(AInvID: string; AJson: TGVJsonObject);
var
  AData: string;
begin
  AData := GetHttp(C_INVOICES+'/'+AInvID, nil);
  AJson.FromJSON(AData);
end;

function TStripe.GetLastError: string;
begin
  Result := FLastError;
end;

function TStripe.GetLastJsonResult: string;
begin
  Result := FLastJsonResult;
end;

function TStripe.GetPaymentIntent(APaymentIntentID: string): string;
begin
 Result := GetHttp('payment_intents/'+APaymentIntentID, nil);
end;

function TStripe.GetPaymentMethod(APaymentMethodID: string): string;
begin
 Result := GetHttp('payment_methods/'+APaymentMethodID, nil);
end;

function TStripe.GetPersons: string;
begin
 Result := GetHttp('accounts/acct_1Ehfk3C0L5u7blDo/persons', nil);
end;

function TStripe.GetSelfServiceUrl(ACustID, AReturnURL: string): string;
var
  AParams: TStrings;
begin
  AParams := TStringList.Create;
  try
    AParams.Values['customer'] := ACustID;
    AParams.Values['return_url'] := AReturnURL;
    Result := PostHttp('', 'billing_portal/sessions', AParams);
  finally
    AParams.Free;
  end;
end;

function TStripe.GetSetupIntent(ASetupIntentID: string): TGVJsonObject;
var
  AData: string;
begin
  AData := GetHttp('setup_intents/'+ASetupIntentID, nil);
  Result := TGVJsonObject.Parse(AData) as TGVJsonObject;
end;

function TStripe.PostHttp(AToken, AMethod: string; AParams: TStrings): string;
var
  AHttp: TNetHTTPClient;
  AResponse: IHTTPResponse;
begin
  AHttp := CreateHttp;
  try
    if AToken <> '' then
    begin
      if Pos('pm_', AToken) = 1 then AParams.Values['source'] := AToken;
      if Pos('tok_', AToken) = 1 then AParams.Values['source'] := AToken;
      if Pos('cus_', AToken) = 1 then AParams.Values['customer'] := AToken;
    end;
    AHttp.CustomHeaders['Authorization'] := 'Bearer '+FSecretKey;
    AResponse := AHttp.Post('https://api.stripe.com/v1/'+AMethod, AParams);
    Result := AResponse.ContentAsString;
    FLastJsonResult := Result;
  finally
    AHttp.Free;
  end;
end;

function TStripe.RefundCharge(AChargeID: string): string;
var
  AParams: TStrings;
begin
  try
    AParams := TStringList.Create;
    try
      if Pos('ch_', AChargeID.ToLower) = 1 then AParams.Values['charge'] := AChargeID;
      if Pos('pi_', AChargeID.ToLower) = 1 then AParams.Values['payment_intent'] := AChargeID;
      Result := PostHttp('', 'refunds', AParams);
    finally
      AParams.Free;
    end;
  except
    on E:Exception do
      Result := E.Message;
  end;
end;

function TStripe.TestCredentials(var AError: string): Boolean;
var
  AData: string;
  AJson: TGVJsonObject;
begin
  Result := True;
  try
    AError := '';
    AData := GetHttp(C_BALANCE, nil);
    AJson := TGVJsonObject.Parse(AData) as TGVJsonObject;
    try
      if AJson.Contains('error') then
      begin
        Result := False;
        AError := AJson.O['error'].s['message'];
      end
    finally
      AJson.Free;
    end;
  except
    on E:Exception do
    begin
      AError := e.Message;
      Result := False;
    end;
  end;
end;

procedure TStripe.UpdateCustomerValue(ACustID, AField, AValue: string);
var
  AParams: TStrings;
  AResult: string;
  AJson: TGVJsonObject;
begin
  AParams := TStringList.Create;
  try
    AParams.Values[AField] := AValue;
    AResult := PostHttp('', C_CUSTOMERS+'/'+ACustID, AParams);
    AJson := TGVJsonObject.Parse(AResult) as TGVJsonObject;
    try
      CheckForError(AJson);
    finally
      AJson.Free;
    end;
  finally
    AParams.Free;
  end;
end;

function TStripe.UpdateDefaultSource(ACustID, ACardID: string): Boolean;
var
  AParams: TStrings;
begin
  try
    AParams := TStringList.Create;
    try
      AParams.Values['default_source'] := ACardID;
      PostHttp('', 'customers/'+ACustID, AParams);
      Result := True;
    finally
      AParams.Free;
    end;
  except
    Result := False;
  end;
end;

function TStripe.DeleteHttp(AMethod: string): string;
var
  AHttp: TNetHTTPClient;
  AResponse: IHTTPResponse;
begin
  AHttp := CreateHttp;
  try
    AHttp.CustomHeaders['Authorization'] := 'Bearer '+FSecretKey;
    AResponse := AHttp.Delete('https://api.stripe.com/v1/'+AMethod);
    Result := AResponse.ContentAsString
  finally
    AHttp.Free;
  end;
end;

function TStripe.CreateCustomer(AName, AEmail, ADescription, APaymentMethod: string): IGVStripeCustomer;
var
  AParams: TStrings;
  AResult: string;
  AJson: TGVJsonObject;
begin
  Result := TStripeCustomer.Create;
  AParams := TStringList.Create;
  try
    if AName <> '' then AParams.Values['name'] := AName;
    if AEmail <> '' then AParams.Values['email'] := AEmail;
    if ADescription <> '' then AParams.Values['description'] := ADescription;
    if APaymentMethod <> '' then AParams.Values['payment_method'] := APaymentMethod;
    AResult := PostHttp('', C_CUSTOMERS, AParams);
    AJson := TGVJsonObject.Parse(AResult) as TGVJsonObject;
    try
      CheckForError(AJson);
      Result.LoadFromJson(AJson);
    finally
      AJson.Free;
    end;
  finally
    AParams.Free;
  end;
end;

procedure TStripe.NetHTTPClient1AuthEvent(const Sender: TObject;
  AnAuthTarget: TAuthTargetType; const ARealm, AURL: string; var AUserName,
  APassword: string; var AbortAuth: Boolean;
  var Persistence: TAuthPersistenceType);
begin
  if AnAuthTarget = TAuthTargetType.Server then
  begin
    AUserName := FSecretKey;
    APassword := '';
  end;
end;

{ TStripeCard }
procedure TStripeCard.Clear;
begin
  inherited;
  FBrand := '';
  FLast4 := '';
  FExpMonth := 0;
  FExpYear := 0;
end;

function TStripeCard.GetBrand: string;
begin
  Result := FBrand;
end;

function TStripeCard.GetExpMonth: integer;
begin
  Result :=FExpMonth;
end;

function TStripeCard.GetExpYear: integer;
begin
  Result := FExpYear;
end;

function TStripeCard.GetLast4: string;
begin
  Result := FLast4;
end;

function TStripeCard.GetObject: string;
begin
  Result := C_CARD;
end;

procedure TStripeCard.LoadFromJson(AJson: TGVJsonObject);
begin
  inherited;
  FBrand := AJson.S['brand'];
  FLast4 := AJson.S['last4'];
  FExpMonth := AJson.I['exp_month'];
  FExpYear := AJson.I['exp_year'];
end;

{ TStripeBaseObject }
procedure TStripeBaseObject.Clear;
begin
  // overridden in descendant objects.
end;

constructor TStripeBaseObject.Create;
begin
  FJson := TGVJsonObject.Create;
  FId := '';
end;

destructor TStripeBaseObject.Destroy;
begin
  FJson.Free;
  inherited;
end;

function TStripeBaseObject.GetAsJson: string;
begin
  Result := FJson.ToJSON;
end;

function TStripeBaseObject.GetID: string;
begin
  Result := FId;
end;

procedure TStripeBaseObject.LoadFromJson(AJson: TGVJsonObject);
begin
  FJson.Assign(AJson);
  FId := FJson.S['id'];
end;

 procedure TStripeBaseObject.SetID(const Value: string);
begin
  FId := Value;
end;

{ TStripeCustomer }
procedure TStripeCustomer.Assign(ACustomer: IGVStripeCustomer);
begin
  inherited;
  ID := ACustomer.ID;
  Description := ACustomer.Description;
  Email := ACustomer.Email;
end;

procedure TStripeCustomer.Clear;
begin
  inherited;
  FEmail := '';
  FDescription := '';
  FName := '';
end;

function TStripeCustomer.GetDescription: string;
begin
  Result := FDescription;
end;

function TStripeCustomer.GetEmail: string;
begin
  Result := FEmail;
end;

function TStripeCustomer.GetName: string;
begin
  Result := FName;
end;

function TStripeCustomer.GetObject: string;
begin
  Result := C_CUSTOMER;
end;

procedure TStripeCustomer.LoadFromJson(AJson: TGVJsonObject);
begin
  inherited;
  Clear;
  if AJson.Types['description'] <> jdtObject then FDescription := AJson.S['description'];
  if AJson.Types['email'] <> jdtObject then FEmail := AJson.S['email'];
  if AJson.Types['name'] <> jdtObject then FName := AJson.S['name'];
end;

procedure TStripeCustomer.SetDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TStripeCustomer.SetEmail(const Value: string);
begin
  FEmail := Value;
end;

procedure TStripeCustomer.SetName(const Value: string);
begin
  FName := Value;
end;

{ TStripePlan }
function TStripePlan.GetAmountPence: integer;
begin
  Result := FAmountPence;
end;

function TStripePlan.GetCreated: TDateTime;
begin
  Result := FCreated;
end;

function TStripePlan.GetCurrency: string;
begin
  Result := FCurrency;
end;

function TStripePlan.GetInterval: string;
begin
  Result := FInterval;
end;

function TStripePlan.GetIntervalCount: integer;
begin
  Result := FIntervalCount;
end;

function TStripePlan.GetName: string;
begin
  Result := FName;
end;

function TStripePlan.GetObject: string;
begin
  Result := C_PLAN;
end;

function TStripePlan.GetStatementDescriptor: string;
begin
  Result := FStatementDescriptor;
end;

function TStripePlan.GetTrialPeriodDays: integer;
begin
  Result := FTrialPeriodDays;
end;

procedure TStripePlan.LoadFromJson(AJson: TGVJsonObject);
begin
  inherited;
  FInterval := AJson.S['interval'];
  FName := AJson.S['name'];
  FCreated := UnixToDateTime(StrToInt(AJson.S['created']));
  FAmountPence := StrToIntDef(AJson.S['amount'], 0);
  FCurrency :=  AJson.S['currency'];
  FIntervalCount := StrToIntDef(AJson.S['interval_count'], 0);
  FTrialPeriodDays := StrToIntDef(AJson.S['trial_period_days'], 0);
  FStatementDescriptor := AJson.S['statement_descriptor'];
end;

{ TStripeSubscription }
constructor TStripeSubscription.Create;
begin
  inherited;
  FPlan := TStripePlan.Create;
end;

function TStripeSubscription.GetCancelledAt: TDateTime;
begin
  Result := FCancelledAt;
end;

function TStripeSubscription.GetCurrentPeriodEnd: TDateTime;
begin
  Result := FCurrentPeriodEnd;
end;

function TStripeSubscription.GetCurrentPeriodStart: TDateTime;
begin
  Result := FCurrentPeriodStart;
end;

function TStripeSubscription.GetCustomer: string;
begin
  Result := FCustomer;
end;

function TStripeSubscription.GetEndedAt: TDateTime;
begin
  Result := FEndedAt;
end;

function TStripeSubscription.GetObject: string;
begin
  Result := C_SUBSCRIPTION;
end;

function TStripeSubscription.GetPlan: IGVStripePlan;
begin
  Result := FPlan;
end;

function TStripeSubscription.GetQuantity: integer;
begin
  Result := FQuantity;
end;

function TStripeSubscription.GetStart: TDateTime;
begin
  Result := FStart;
end;

function TStripeSubscription.GetStatus: string;
begin
  Result := FStatus;
end;

function TStripeSubscription.GetTaxPercent: single;
begin
  Result := FTaxPercent;
end;

function TStripeSubscription.GetTrialEnd: TDateTime;
begin
  Result := FTrialEnd;
end;

function TStripeSubscription.GetTrialStart: TDateTime;
begin
  Result := FTrialStart;
end;

procedure TStripeSubscription.LoadFromJson(AJson: TGVJsonObject);
begin
  inherited;
  FPlan.LoadFromJson(AJson.O['plan']);
  FStatus := AJson.S['status'];
end;

{ TStripeBaseObjectList<T> }
function TStripeBaseObjectList<T>.AddObject: T;
begin
  Result := CreateObject;
  FItems.Add(Result);
end;

procedure TStripeBaseObjectList<T>.Clear;
begin
  FItems.Clear;
end;

constructor TStripeBaseObjectList<T>.Create;
begin
  FItems := TList<T>.Create;
end;

destructor TStripeBaseObjectList<T>.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TStripeBaseObjectList<T>.GetCount: integer;
begin
  Result := FItems.Count;
end;

function TStripeBaseObjectList<T>.GetItem(index: integer): T;
begin
  Result := FItems[index];
end;

{ TStripeCustomerList }
function TStripeCustomerList.CreateObject: IGVStripeCustomer;
begin
  Result := TStripeCustomer.Create;
end;

function TStripeCustomerList.GetListID: string;
begin
  Result := C_CUSTOMERS;
end;

procedure TStripeCustomerList.LoadFromJson(AJson: TGVJsonObject);
var
  AArray: TGVJsonArray;
  ICount: integer;
begin
  Clear;
  if AJson = nil then
    Exit;
  AArray := AJson.A['data'];
  for ICount := 0 to AArray.Count-1 do
  begin
    AddObject.LoadFromJson(AArray.O[ICount]);
  end;
end;

{ TStripeCharge }
procedure TStripeCharge.Clear;
begin
  inherited;
  FCreated := 0;
  FDesc := '';
  FLiveMode := False;
  FPaid := False;
  FStatus := '';
  FAmountPence := 0;
  FCurrency := 'USD';
  FRefunded := False;
  FCustomer := '';
  FCard.Clear;
end;

constructor TStripeCharge.Create;
begin
  inherited;
  FCard := TStripeCard.Create;
end;

function TStripeCharge.GetAmountPence: integer;
begin
  Result := FAmountPence;
end;

function TStripeCharge.GetCurrency: string;
begin
  Result := FCurrency;
end;

function TStripeCharge.GetCustomer: string;
begin
  Result := FCustomer;
end;

function TStripeCharge.GetDesc: string;
begin
  Result := FDesc;
end;

function TStripeCharge.GetCard: IGVStripeCard;
begin
  Result := FCard;
end;

function TStripeCharge.GetCreated: TDatetime;
begin
  Result := FCreated;
end;

function TStripeCharge.GetLiveMode: Boolean;
begin
  Result := FLiveMode;
end;

function TStripeCharge.GetObject: string;
begin
  Result := C_CHARGE;
end;

function TStripeCharge.GetPaid: Boolean;
begin
  Result := FPaid;
end;

function TStripeCharge.GetRefunded: Boolean;
begin
  Result := FRefunded;
end;

function TStripeCharge.GetStatus: string;
begin
  Result := FStatus;
end;

procedure TStripeCharge.LoadFromJson(AJson: TGVJsonObject);
begin
  inherited;
  Clear;
  FCard := TStripeCard.Create;
  FCreated := UnixToDateTime(AJson.I['created']);
  FLiveMode := AJson.S['livemode'] = 'true';
  FPaid := AJson.S['paid'] = 'true';
  FStatus := AJson.S['status'];
  FAmountPence := StrToIntDef(AJson.S['amount'], 0);
  FCurrency := AJson.S['currency'];
  FRefunded := AJson.S['refunded'] = 'true';
  if not AJson.IsNull('customer') then
    FCustomer := AJson.S['customer']
  else
    FCustomer := '';
  if AJson.Types['description'] = jdtString then FDesc := AJson.S['description'];
  if AJson.O['payment_method_details'] <> nil then
  begin
    if AJson.O['payment_method_details'].O['card'] <> nil then
      FCard.LoadFromJson(AJson.O['payment_method_details'].O['card']);
  end;
end;

{ TStripeChargeList }
function TStripeChargeList.CreateObject: IGVStripeCharge;
begin
  Result := TStripeCharge.Create;
end;

function TStripeChargeList.GetListID: string;
begin
  Result := C_CHARGES;
end;

procedure TStripeChargeList.LoadFromJson(AJson: TGVJsonObject);
var
  AArray: TGVJsonArray;
  ICount: integer;
begin
  Clear;
  if AJson = nil then
    Exit;
  AArray := AJson.A['data'];
  for ICount := 0 to AArray.Count-1 do
  begin
    AddObject.LoadFromJson(AArray.O[ICount]);
  end;
end;

end.
