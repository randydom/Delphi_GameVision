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

unit GameVision.Twitter;

{$I GameVision.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  idGlobal,
  GameVision.Base;

type

  TGVHTTPCommand = (hcPost, hcPut, hcPostMultiPart, hcPostMultiPartRelated, hcPutMultiPart, hcPutNoHeader);

  TGVTwitter = class;

  { TGVTwitterEvent }
  TGVTwitterTweetEvent = procedure(const aMsg: string; const aFilename: string) of object;

  { TGVTwitterUploadProgressEvent }
  TGVTwitterUploadProgressEvent = procedure(const aFilename: string; aPosition: Int64; aTotal: int64) of object;

  { TGVTwitter }
  TGVTwitter = class(TGVObject)
  protected
    type
      { THeader}
      THeader = record
        header: String;
        value: String;
      end;
      { THeaders }
      THeaders = array of THeader;
  protected
    FConsumerKey: string;
    FConsumerSecret: string;
    FTokenKey: string;
    FTokenSecret: string;
    FAgent: string;
    FOnEvent: TGVTwitterTweetEvent;
    FRequestParams: TStringList;
    FBusy: Boolean;
    FLastError: Cardinal;
    FOnUploadProgress: TGVTwitterUploadProgressEvent;
    function GenerateTimeStamp: string;
    function GenerateNonce: string;
    procedure AddOAuthRequestParams(aAppKey, aAccessToken: string; var aTS, aNonce: string);
    function GetSignature(aURL: string; aAppSecret, aTokenSecret: string): string;
    function OAuthEncryptHMACSha1(const aValue, aKey: string): string;
    function Base64Encode(const aInput: TIdBytes): string;
    function EncryptHMACSha1(aInput, aKey: string): TIdBytes;
    function GetOAuthHeader(aAppKey, aAccessToken, aTS, aNonce, aSig: string): string;
    procedure AddHeader(var aHeaders: THeaders; aHeader: String; aValue: string);
    procedure RemoveOAuthRequestParams;
    function RemoveServer(aURL: string): string;
    function ExtractServer(aURL:string): string;
    function GetJSONProp(aObj: TJSONOBject; aID: string): string;
    function URLtoFile(aURL:string): string;
    function AddFileToDir(aDir, aFilename: string): string;
    function HttpError(aErrorCode: Cardinal): string;
    function HttpPost(const aServerName, aResource: string; aHeaders: THeaders; const aPostData: AnsiString; var aResponse: AnsiString): Integer;
    function HttpsPost(const aServerName, aResource, aUsername, aPassword: string; aHeaders: THeaders; const aPostData: AnsiString; var aResponse: AnsiString): Integer; overload;
    function HttpsPost(const aServerName, aResource: string; aHeaders: THeaders; const aPostData: AnsiString; var aResponse: AnsiString): Integer; overload;
    function HttpsPut(aURL, aTGTDir,aTGTFilename: string; aCustomHeaders: THeaders; aCustomData: AnsiString; aHttpCommand: TGVHTTPCommand): AnsiString;
    procedure DoUploadProgress(aFilename: string; aPosition, aTotal: Int64);
    procedure DoEvent(const aMsg: string; const aFilename: string);
    function DoTweet(const aMsg: string): string;
    function DoTweetMedia(const Msg: string; const FileName: string): string;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Setup(const aConsumerKey: string; const aConsumerSecret: string; const aTokenKey: string; const aTokenSecret: string; aEvent: TGVTwitterTweetEvent; aProgressEvent: TGVTwitterUploadProgressEvent);
    procedure Tweet(const aMsg: string);
    procedure TweetMedia(const aMsg: string; const aFilename: string);
  end;

implementation

uses
  System.DateUtils,
  System.IOUtils,
  WinApi.Windows,
  WinApi.WinInet,
  IdHash,
  IdHashMessageDigest,
  IdHMACSHA1,
  IdCoderMIME,
  GameVision.Util,
  GameVision.Core;

const
  READBUFFERSIZE = 4096;

{ TGVTwitter }
function TGVTwitter.GenerateTimeStamp: string;
begin
  Result := IntToStr(DateTimeToUnix(Now));
end;

function TGVTwitter.GenerateNonce: string;
var
  LMD5: TIdHashMessageDigest;
  LStr: string;
begin
  LStr := IntToStr(GetTickCount);
  LMD5 := TIdHashMessageDigest5.Create;
  Result := LMD5.HashStringAsHex(LStr);
  LMD5.Free;
end;

procedure TGVTwitter.AddOAuthRequestParams(aAppKey,aAccessToken: string; var aTS,aNonce: string);
begin
  aTS := GenerateTimeStamp;
  aNonce := GenerateNonce;
  FRequestParams.Clear;
  FRequestParams.Values['oauth_consumer_key'] := aAppKey;
  FRequestParams.Values['oauth_nonce'] := aNonce;
  FRequestParams.Values['oauth_signature_method'] := 'HMAC-SHA1';
  FRequestParams.Values['oauth_timestamp'] := aTS;
  FRequestParams.Values['oauth_token'] := aAccessToken;
  FRequestParams.Values['oauth_version'] := '1.0';
end;

function TGVTwitter.GetSignature(aURL: string; aAppSecret, aTokenSecret: string): string;
var
  LSignature: string;
  LConsec: string;
begin
  LConsec := TGVUtil.URLEncodeRFC3986(aAppSecret) + '&';

  if aTokenSecret <> '' then
    LConsec := LConsec + TGVUtil.URLEncodeRFC3986(aTokenSecret);

  LSignature := OAuthEncryptHMACSha1(aURL, LConsec);

  Result := LSignature;
end;

function TGVTwitter.OAuthEncryptHMACSha1(const aValue,aKey: string): string;
begin
  Result := Base64Encode(EncryptHMACSha1(aValue, aKey));
end;

function TGVTwitter.Base64Encode(const aInput: TIdBytes): string;
begin
  Result := TIdEncoderMIME.EncodeBytes(aInput)
end;

function TGVTwitter.EncryptHMACSha1(aInput, aKey: string): TIdBytes;
begin
  with TIdHMACSHA1.Create do
    try
      Key := ToBytes(aKey);
      Result := HashValue(ToBytes(aInput));
    finally
      Free;
    end;
end;

function TGVTwitter.GetOAuthHeader(aAppKey, aAccessToken, aTS, aNonce, aSig: string): string;
begin
  Result :=
    'oauth_consumer_key="'+ TGVUtil.URLEncode(aAppKey)+'",'
    + 'oauth_signature_method="HMAC-SHA1",'
    + 'oauth_timestamp="' + aTS +'",'
    + 'oauth_nonce="' + aNonce + '",'
    + 'oauth_signature="' + TGVUtil.UrlEncode(aSig) +'",'
    + 'oauth_version="1.0",'
    + 'oauth_token="' + TGVUtil.URLEncode(aAccessToken)+'"';

  Result := 'OAuth ' + Result + #13#10;
end;

procedure TGVTwitter.AddHeader(var aHeaders: THeaders; aHeader: String; aValue: String);
begin
  SetLength(aHeaders, Length(aHeaders) + 1);
  aHeaders[Length(aHeaders) - 1].header := aHeader;
  aHeaders[Length(aHeaders) - 1].value := aValue;
end;

procedure TGVTwitter.RemoveOAuthRequestParams;
var
  I: integer;
begin
  if FRequestParams.Count > 5 then
    for I := 0 to 5 do
      FRequestParams.Delete(0);
end;

function TGVTwitter.RemoveServer(aURL:string): string;
begin
  if Pos('://',UpperCase(aURL)) > 0 then
    Delete(aURL,1,Pos('://',aURL) + 2);

  if Pos('@',UpperCase(aURL)) > 0 then
    Delete(aURL,1,Pos('@',aURL) + 1);

  if Pos('/',aURL) > 0 then
    Delete(aURL,1,Pos('/',aURL)-1);

  Result := aURL;
end;

function TGVTwitter.HttpError(aErrorCode:Cardinal): string;
const
   cWinetDLLl = 'wininet.dll';
var
  LLen: Integer;
  LBuffer: PChar;
begin
  LLen := FormatMessage(
  FORMAT_MESSAGE_FROM_HMODULE or FORMAT_MESSAGE_FROM_SYSTEM or
  FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_IGNORE_INSERTS or  FORMAT_MESSAGE_ARGUMENT_ARRAY,
  Pointer(GetModuleHandle(cWinetDLLl)), aErrorCode, 0, @LBuffer, SizeOf(LBuffer), nil);
  try
    while (LLen > 0) and {$IFDEF UNICODE}(CharInSet(LBuffer[LLen - 1], [#0..#32, '.'])) {$ELSE}(Buffer[Len - 1] in [#0..#32, '.']) {$ENDIF} do Dec(LLen);
    SetString(Result, LBuffer, LLen);
  finally
    LocalFree(HLOCAL(LBuffer));
  end;
end;

function TGVTwitter.ExtractServer(aURL:string): string;
var
  LAtPos, LSlPos: Integer;
begin
  if Pos('://',UpperCase(aURL)) > 0 then
    Delete(aURL,1,Pos('://',aURL) + 2);

  LAtPos := Pos('@',UpperCase(aURL));
  LSlPos := Pos('/',UpperCase(aURL));

  if (LAtPos > 0) and (LAtPos < LSlPos) then
    Delete(aURL,1,Pos('@',aURL) + 1);

  if Pos('/',aURL) > 0 then
    aURL := Copy(aURL,1,Pos('/',aURL)-1);

  Result := aURL;
end;

function TGVTwitter.GetJSONProp(aObj: TJSONOBject; aID: string): string;
var
  LPair: TJSONPair;
begin
  Result := '';
  LPair := aObj.Get(aID);
  if Assigned(LPair) then
    Result := LPair.JsonValue.Value;
end;

function TGVTwitter.URLtoFile(aURL:string): string;
begin
  while Pos('/',aURL) > 0 do
    Delete(aURL,1,Pos('/',aURL));
  while Pos('\',aURL) > 0 do
   Delete(aURL,1,pos('\',aURL));
  Result := aURL;
end;

function TGVTwitter.AddFileToDir(aDir,aFilename:string):string;
begin
  if Length(aDir) > 0 then
  begin
    if aDir[Length(aDir)] = '\' then
      Result := aDir + aFilename
    else
      Result := aDir + '\' + aFilename;
  end
  else
    Result := aFilename;
end;

function TGVTwitter.HttpPost(const aServerName,aResource: String;aHeaders: THeaders;const  aPostData : AnsiString;Var aResponse:AnsiString): Integer;
const
  cBufferSize = 1024*64;
var
  LhInet: HINTERNET;
  LhConnect: HINTERNET;
  LhRequest: HINTERNET;
  LErrorCode: Integer;
  LlpdwBufferLength: DWORD;
  LlpdwReserved: DWORD;
  LdwBytesRead: DWORD;
  LFlags: DWORD;
  LBuffer: array[0..1024] of AnsiChar;
  LHeader: string;
  I: Integer;
begin
  LHeader := '';
  if Assigned(aHeaders) then
  begin
    for I := 0 to Length(aHeaders) - 1 do
      LHeader := LHeader + aHeaders[I].header + ': ' + aHeaders[I].value;
  end;

  GV.Logger.Log('HTTP POST: '+ aServerName + aResource, []);
  Result := 0;
  aResponse := '';
  LhInet := InternetOpen(PChar(FAgent), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);

  if LhInet = nil then
  begin
    LErrorCode := GetLastError;
    raise Exception.Create(Format('InternetOpen Error %d Description %s',[LErrorCode,HttpError(LErrorCode)]));
  end;

  try
    LhConnect := InternetConnect(LhInet, PChar(aServerName), INTERNET_DEFAULT_HTTP_PORT, nil, nil, INTERNET_SERVICE_HTTP, 0, 0);
    if LhConnect=nil then
    begin
      LErrorCode := GetLastError;
      raise Exception.Create(Format('InternetConnect Error %d Description %s',[LErrorCode,HttpError(LErrorCode)]));
    end;

    try
      LFlags := INTERNET_FLAG_RELOAD or INTERNET_FLAG_PRAGMA_NOCACHE;
      LFlags := LFlags or INTERNET_FLAG_KEEP_CONNECTION;
      LhRequest := HttpOpenRequest(LhConnect, 'POST', PChar(aResource), HTTP_VERSION, '', nil, LFlags, 0);

      if LhRequest = nil then
      begin
        LErrorCode := GetLastError;
        raise Exception.Create(Format('HttpOpenRequest Error %d Description %s',[LErrorCode,HttpError(LErrorCode)]));
      end;

      try
        //send the post request
        if not HTTPSendRequest(LhRequest, PChar(LHeader), Length(LHeader), @aPostData[1], Length(aPostData)) then
        begin
          LErrorCode := GetLastError;
          raise Exception.Create(Format('HttpSendRequest Error %d Description %s',[LErrorCode,HttpError(LErrorCode)]));
        end;

          LlpdwBufferLength := SizeOf(Result);
          LlpdwReserved := 0;
          //get the response code
          if not HttpQueryInfo(LhRequest, HTTP_QUERY_STATUS_CODE or HTTP_QUERY_FLAG_NUMBER, @Result, LlpdwBufferLength, LlpdwReserved) then
          begin
            LErrorCode := GetLastError;
            raise Exception.Create(Format('HttpQueryInfo Error %d Description %s',[LErrorCode,HttpError(LErrorCode)]));
          end;

         GV.Logger.Log('HTTP POST RES:'+IntToStr(Result), []);

         begin
           aResponse := '';
           LdwBytesRead := 0;
           FillChar(LBuffer, SizeOf(LBuffer), 0);
           repeat
             aResponse := aResponse + Copy(LBuffer, 1, LdwBytesRead);
             FillChar(LBuffer, SizeOf(LBuffer), 0);
             InternetReadFile(LhRequest, @LBuffer, SizeOf(LBuffer), LdwBytesRead);
           until LdwBytesRead = 0;
         end;
      finally
        InternetCloseHandle(LhRequest);
      end;
    finally
      InternetCloseHandle(LhConnect);
    end;
  finally
    InternetCloseHandle(LhInet);
  end;
end;

function TGVTwitter.HttpsPost(const aServerName, aResource,aUsername,aPassword: String;aHeaders: THeaders;const  aPostData : AnsiString;Var aResponse:AnsiString): Integer;
const
  cBufferSize = 1024*64;
var
  LhInet: HINTERNET;
  LhConnect: HINTERNET;
  LhRequest: HINTERNET;
  LErrorCode: Integer;
  LlpdwBufferLength: DWORD;
  LlpdwReserved: DWORD;
  LdwBytesRead: DWORD;
  LFlags: DWORD;
  LBuffer: array[0..1024] of AnsiChar;
  LHeader: string;
  I: Integer;
begin
  LHeader := '';
  if Assigned(aHeaders) then
  begin
    for I := 0 to Length(aHeaders) - 1 do
      LHeader := LHeader + aHeaders[I].header + ': ' + aHeaders[I].value;
  end;

  GV.Logger.Log('HTTPS POST: '+ aServerName + aResource, []);

  Result := 0;
  aResponse := '';
  LhInet := InternetOpen(PChar(FAgent), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);

  if LhInet = nil then
  begin
    LErrorCode := GetLastError;
    raise Exception.Create(Format('InternetOpen Error %d Description %s',[LErrorCode,HttpError(LErrorCode)]));
  end;

  try
    LhConnect := InternetConnect(LhInet, PChar(aServerName), INTERNET_DEFAULT_HTTPS_PORT, PChar(aUsername), Pchar(aPassword), INTERNET_SERVICE_HTTP, 0, 0);
    if LhConnect=nil then
    begin
      LErrorCode := GetLastError;
      raise Exception.Create(Format('InternetConnect Error %d Description %s',[LErrorCode,HttpError(LErrorCode)]));
    end;

    try
      LFlags := INTERNET_FLAG_SECURE;
      LFlags := LFlags or INTERNET_FLAG_PASSIVE;
      LFlags := LFlags or INTERNET_FLAG_KEEP_CONNECTION;
      LhRequest := HttpOpenRequest(LhConnect, 'POST', PChar(aResource), HTTP_VERSION, '', nil, LFlags, 0);
      if LhRequest=nil then
      begin
        LErrorCode := GetLastError;
        raise Exception.Create(Format('HttpOpenRequest Error %d Description %s',[LErrorCode,HttpError(LErrorCode)]));
      end;

      try
        //send the post request
        if not HTTPSendRequest(LhRequest, PChar(LHeader), Length(LHeader), @aPostData[1], Length(aPostData)) then
        begin
          LErrorCode := GetLastError;
          raise Exception.Create(Format('HttpSendRequest Error %d Description %s',[LErrorCode,HttpError(LErrorCode)]));
        end;

          LlpdwBufferLength := SizeOf(Result);
          LlpdwReserved := 0;
          //get the response code
          if not HttpQueryInfo(LhRequest, HTTP_QUERY_STATUS_CODE or HTTP_QUERY_FLAG_NUMBER, @Result, LlpdwBufferLength, LlpdwReserved) then
          begin
            LErrorCode := GetLastError;
            raise Exception.Create(Format('HttpQueryInfo Error %d Description %s',[LErrorCode,HttpError(LErrorCode)]));
          end;

         GV.Logger.Log('HTTPS POST RES:'+IntToStr(Result), []);
         //if the response code = 200 then get the body
         if (Result in [200,201]) or (Result = 400) or (Result = 401) or (Result = 403) then
         begin
           aResponse := '';
           LdwBytesRead := 0;
           FillChar(LBuffer, SizeOf(LBuffer), 0);
           repeat
             aResponse := aResponse + Copy(LBuffer, 1, LdwBytesRead);
             FillChar(LBuffer, SizeOf(LBuffer), 0);
             InternetReadFile(LhRequest, @LBuffer, SizeOf(LBuffer), LdwBytesRead);
           until LdwBytesRead = 0;
         end;

      finally
        InternetCloseHandle(LhRequest);
      end;
    finally
      InternetCloseHandle(LhConnect);
    end;
  finally
    InternetCloseHandle(LhInet);
  end;
end;

function TGVTwitter.HttpsPost(const aServerName, aResource: String;aHeaders: THeaders;const  aPostData : AnsiString;Var aResponse:AnsiString): Integer;
begin
  Result := HttpsPost(aServerName, aResource, '', '', aHeaders, aPostData, aResponse);
end;

procedure TGVTwitter.DoUploadProgress(aFilename: string; aPosition, aTotal: int64);
begin
  if Assigned(FOnUploadProgress) then
    FOnUploadProgress(aFilename,aPosition,aTotal);
  TGVUtil.ProcessMessages;
end;

function TGVTwitter.HttpsPut(aURL,aTGTDir,aTGTFilename: String;aCustomHeaders: THeaders; aCustomData: ansistring; aHttpCommand: TGVHTTPCommand): ansistring;
var
  LBuf: array[0..READBUFFERSIZE - 1] of char;
  LBuffer: array[0..READBUFFERSIZE - 1] of ansichar;
  LBufSize: DWORD;
  LLF: File;
  LFName, LFURL, LFSrvr: string;
  LFSize, LTotSize, LPosition: Int64;
  LHConnect: HINTERNET;
  LHIntfile: HINTERNET;
  LlpDWORD: DWORD;
  LBufferIn: INTERNET_BUFFERS;
  LBytesRead: DWORD;
  LFm: word;
  LFHinternet: HINTERNET;
  LHeader: string;
  LHdrs: string;
  LHead, LHeadBound: AnsiString;
  LTail: ansistring;
  LCustomHeader: string;
  I: Integer;
begin
  LCustomHeader := '';
  if Assigned(aCustomHeaders) then
  begin
    for I := 0 to Length(aCustomHeaders) - 1 do
      LCustomHeader := LCustomHeader + aCustomHeaders[I].header + ': ' + aCustomHeaders[I].value;
  end;

  GV.Logger.Log('HTTPS PUT: ' + aURL, []);

  Result := '';

  LHead := '';
  LTail := '';
  LHeadBound := '';

  LFURL := aURL;
  LFName := UrlToFile(aURL);

  if aTGTFilename <> '' then
    LFName := aTGTFilename
  else
    LFName := URLtoFile(aURL);

  LFName := AddFileToDir(aTGTDir,LFName);
  if not FileExists(LFName) then Exit;

  LFSrvr := ExtractServer(aURL);
  aURL := RemoveServer(aURL);
  LFHinternet := InternetOpen(PChar(FAgent), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  LHConnect := InternetConnect(LFHinternet,PChar(LFSrvr),INTERNET_DEFAULT_HTTPS_PORT,nil,nil,INTERNET_SERVICE_HTTP,0,0);

  if (aHttpCommand in [hcPost, hcPostMultiPart, hcPostMultiPartRelated]) then
    LHIntfile := HttpOpenRequest(LHConnect,'POST',PChar(aURL),'HTTP/1.1',nil,nil,INTERNET_FLAG_SECURE or INTERNET_FLAG_NO_CACHE_WRITE ,0)
  else
    LHIntfile := HttpOpenRequest(LHConnect,'PUT',PChar(aURL),'HTTP/1.1',nil,nil,INTERNET_FLAG_SECURE or INTERNET_FLAG_NO_CACHE_WRITE ,0);

  if LHIntfile = nil then Exit;

  LBufSize := READBUFFERSIZE;

  LFm := FileMode;
  FileMode := 0; // openread mode

  if LHIntfile <> nil then
  begin
    AssignFile(LLF,LFName);
    Reset(LLF,1);
    LTotSize := FileSize(LLF);

    // header stuff
    if aHttpCommand = hcPost then
    begin
      LHdrs := LCustomHeader;
      if LHdrs <> '' then
        HttpAddRequestHeaders(LHIntfile, pchar(LHdrs), length(LHdrs), HTTP_ADDREQ_FLAG_ADD);

      LHeader := 'Content-Length: '+ inttostr(LTotSize);
      HttpAddRequestHeaders(LHIntfile, pchar(LHeader), length(LHeader), HTTP_ADDREQ_FLAG_ADD or HTTP_ADDREQ_FLAG_REPLACE);

      LHeader := 'Content-Type: application/octet-stream';
      HttpAddRequestHeaders(LHIntfile, pchar(LHeader), length(LHeader), HTTP_ADDREQ_FLAG_ADD or HTTP_ADDREQ_FLAG_REPLACE);

      LHeader := 'Content-Transfer-Encoding: binary';
      HttpAddRequestHeaders(LHIntfile, pchar(LHeader), length(LHeader), HTTP_ADDREQ_FLAG_ADD or HTTP_ADDREQ_FLAG_REPLACE);
    end;

    if (aHttpCommand = hcPut)  then
    begin
      if LCustomHeader <> '' then
      begin
        LHdrs := LCustomHeader;
        HttpAddRequestHeaders(LHIntfile, pchar(LHdrs), length(LHdrs), HTTP_ADDREQ_FLAG_ADD );
      end;

      LHdrs := 'Content-Length: '+ inttostr(LTotSize);
      HttpAddRequestHeaders(LHIntfile, pchar(LHdrs), length(LHdrs), HTTP_ADDREQ_FLAG_ADD );

      LHdrs := 'Content-Type: application/octet-stream';
      HttpAddRequestHeaders(LHIntfile, pchar(LHdrs), length(LHdrs), HTTP_ADDREQ_FLAG_ADD );

      LHdrs := 'Content-Transfer-Encoding: binary';
      HttpAddRequestHeaders(LHIntfile, pchar(LHdrs), length(LHdrs), HTTP_ADDREQ_FLAG_ADD);
    end;

    if (aHttpCommand in [hcPostMultiPart, hcPutMultiPart]) then
    begin
      LHeadBound := '--AaB03x'#13#10;
      LTail := #13#10'--AaB03x--'#13#10;

      LHdrs := ''
          + LCustomHeader
          +'Content-Type: multipart/form-data; boundary=AaB03x'#13#10
          + #13#10;

      HttpAddRequestHeaders(LHIntfile, pchar(LHdrs), length(LHdrs), HTTP_ADDREQ_FLAG_ADD);
    end;

    if (aHttpCommand in [hcPostMultiPartRelated]) then
    begin
      LHeadBound := ''#13#10;
      LTail := #13#10'--AaB03x--'#13#10;

      LHdrs := ''
          + LCustomHeader
          +'Content-Type: multipart/related; boundary=AaB03x'#13#10
          + #13#10;

      HttpAddRequestHeaders(LHIntfile, pchar(LHdrs), length(LHdrs), HTTP_ADDREQ_FLAG_ADD);
    end;

    // data stuff
    FillChar(LBufferIn, SizeOf(LBufferIn),0);
    LBufferIn.dwStructSize := SizeOf(INTERNET_BUFFERS);
    LBufferIn.dwBufferTotal := length(LHeadBound) + length(aCustomData) + LTotSize + length(LTail);

    if not HttpSendRequestEx(LHIntfile,@LBufferIn,nil,HSR_INITIATE,0) then
    begin
      FLastError := GetLastError;
      CloseFile(LLF);
      InternetCloseHandle(LHIntfile);
      InternetCloseHandle(LHConnect);
      Exit;
    end;

    if (aHttpCommand in [hcPutMultiPart, hcPostMultiPart, hcPostMultiPartRelated]) and (LHeadBound <> '') then
      InternetWriteFile(LHIntfile,pansichar(@LHeadBound[1]),length(LHeadBound),LlpDWORD);

    if (aHttpCommand in [hcPutMultiPart, hcPostMultiPart, hcPostMultiPartRelated]) and (aCustomData <> '') then
      InternetWriteFile(LHIntfile,pansichar(@aCustomData[1]),length(aCustomData),LlpDWORD);

    LBufSize := READBUFFERSIZE;
    LFSize := 0;
    LPosition := 0;

    while (LBufSize = READBUFFERSIZE) do
    begin
      BlockRead(LLF,LBuf,READBUFFERSIZE,LBufSize);

      if not InternetWriteFile(LHIntfile,@LBuf,LBufSize,LlpDWORD) then
      begin
        FLastError := GetLastError;
        Break;
      end;

      LFSize := LFSize + LBufSize;
      LPosition := LPosition + LlpDWORD;
      DoUploadProgress(LFName,LPosition,LTotSize);
    end;

    if (aHttpCommand in [hcPutMultiPart, hcPostMultiPart, hcPostMultiPartRelated]) then
      InternetWriteFile(LHIntfile,pansichar(@LTail[1]),length(LTail),LlpDWORD);

    if not HttpEndRequest(LHIntfile,nil,0,0) then
    begin
      FLastError := GetLastError;
    end;

    CloseFile(LLF);

    // read response
    FillChar(LBuffer, SizeOf(LBuffer), 0);
    repeat
      Result := Result + LBuffer;
      FillChar(LBuffer, SizeOf(LBuffer), 0);
      InternetReadFile(LHIntfile, @LBuffer, SizeOf(LBuffer), LBytesRead);
    until LBytesRead = 0;

    InternetCloseHandle(LHIntfile);
    InternetCloseHandle(LHConnect);
    InternetCloseHandle(LFHinternet);

    FileMode := LFm;
  end;
end;


procedure TGVTwitter.DoEvent(const aMsg: string; const aFilename: string);
begin
  if Assigned(FOnEvent) then
    FOnEvent(aMsg, aFilename);
end;

function TGVTwitter.DoTweet(const aMsg: string): string;
var
  LURL, LSig, LSigBase, LTs, LNonce, LPostData: string;
  LHeaders: THeaders;
  LResDat: AnsiString;
  LJV: TJSONValue;
  LJO: TJSONObject;

begin
  Result := '';

  LURL := 'https://api.twitter.com/1.1/statuses/update.json';

  AddOAuthRequestParams(FConsumerKey, FTokenKey, LTs, LNonce);

  FRequestParams.Values['include_entities']:='true';
  FRequestParams.Values['status'] := aMsg;
  FRequestParams.Values['trim_user'] := 'true';

  LSigBase := 'POST&' + TGVUtil.UrlEncode(LURL) + '&'
    + string(TGVUtil.HTTPEncode(AnsiString(TGVUtil.encodeParams(FRequestParams, '&', false))));

  LSig := GetSignature(LSigBase, FConsumerSecret, FTokenSecret);

  AddHeader(LHeaders, 'Authorization', GetOAuthHeader(FConsumerKey, FTokenKey, LTs, LNonce, LSig));
  AddHeader(LHeaders, 'Content-Type', 'application/x-www-form-urlencoded');
  RemoveOAuthRequestParams;

  LPostData := TGVUtil.encodeParams(Frequestparams,'&',false);
  HttpsPost(Extractserver(LURL),Removeserver(LURL),LHeaders,ansistring(LPostData),LResDat);

  if LResDat <> '' then
  begin
    LJV := TJSONOBject.ParseJSONValue(string(LResDat));
    if Assigned(LJV) then
    begin
      try
        LJO := LJV as TJSONObject;
        Result := GetJSONProp(LJO,'id_str');
      finally
        LJV.Free;
      end;
    end;
  end;
end;

function TGVTwitter.DoTweetMedia(const Msg: string; const FileName: string): string;
var
  LHeaders: THeaders;
  LURL, LSig, LSigBase, LTs, LNonce: string;
  LResDat: AnsiString;
  LJV: TJSONValue;
  LJO: TJSONObject;
  LPostData: AnsiString;
begin
  Result := '';
  LURL := 'https://api.twitter.com/1.1/statuses/update_with_media.json';

  AddOAuthRequestParams(FConsumerKey, FTokenKey, LTs, LNonce);

  LSigBase := 'POST&' + TGVUtil.UrlEncode(LURL) + '&'
    + string(TGVUtil.HTTPEncode(AnsiString(TGVUtil.EncodeParams(FRequestParams, '&', false))));
  LSig := GetSignature(LSigBase, FConsumerSecret, FTokenSecret);

  AddHeader(LHeaders, 'Authorization', GetOAuthHeader(FConsumerKey, FTokenKey, LTs, LNonce, LSig));

  LPostData :=
    'Content-Disposition: form-data; name="status"'#13#10
    + #13#10
    + UTF8Encode(Msg) + #13#10
    + '--AaB03x'#13#10
    + 'Content-Disposition: form-data; name="media[]"; filename="' + ansistring(ExtractFileName(FileName)) + '"'#13#10
    + 'Content-Type: application/octet-stream'#13#10
    + #13#10;

  LResDat := HttpsPut(LURL,ExtractFilePath(FileName),ExtractFileName(FileName),LHeaders,LPostData,hcPostMultiPart);

  if (LResDat <> '') then
  begin
    LJV := TJSONOBject.ParseJSONValue(string(LResDat));
    if Assigned(LJV) then
    begin
      try
        LJO := LJV as TJSONObject;
        Result := GetJSONProp(LJO,'id_str');
      finally
        LJV.Free;
      end;
    end;
  end;
end;

constructor TGVTwitter.Create;
begin
  inherited;
  FAgent := 'Mozilla/5.001 (windows; U; NT4.0; en-US; rv:1.0) Gecko/25250101';
  FRequestParams := TStringList.Create;
end;

destructor TGVTwitter.Destroy;
begin
  FreeAndNil(FRequestParams);
  inherited;
end;

procedure TGVTwitter.Setup(const aConsumerKey: string; const aConsumerSecret: string; const aTokenKey: string; const aTokenSecret: string; aEvent: TGVTwitterTweetEvent; aProgressEvent: TGVTwitterUploadProgressEvent);
begin
  FConsumerKey := aConsumerKey;
  FConsumerSecret := aConsumerSecret;
  FTokenKey := aTokenKey;
  FTokenSecret := aTokenSecret;
  FOnEvent := aEvent;
  FBusy := False;
  FLastError := 0;
  FOnUploadProgress := aProgressEvent;
end;

procedure TGVTwitter.Tweet(const aMsg: string);
begin
  if FBusy then Exit;
  if aMsg.IsEmpty then Exit;

  GV.Async.Run(
    'TGVTwitter',
    procedure
    begin
      FBusy := True;
      DoTweet(aMsg);
    end,
    procedure
    begin
      DoEvent(aMsg, '');
      FBusy := False;
    end
  );
end;

procedure TGVTwitter.TweetMedia(const aMsg: string; const aFilename: string);
begin
  if FBusy then Exit;
  if aMsg.IsEmpty then Exit;
  if not TFile.Exists(aFilename) then Exit;

  GV.Async.Run(
    'TGVTwitter',
    procedure
    begin
      FBusy := True;
      DoTweetMedia(aMsg, aFilename);
    end,
    procedure
    begin
      DoEvent(aMsg, aFilename);
      FBusy := False;
    end
  );
end;

end.
