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

unit GameVision.ZLib;

interface

{$I GameVision.Defines.inc}
{$MINENUMSIZE 4}
{$WARN SYMBOL_PLATFORM OFF}

const
  ZLIB_DLL = 'zlib.dll';
  _PU = '';

const
  Z_DEFLATED = 8;
  Z_DEFAULT_STRATEGY = 0;
  APPEND_STATUS_CREATE = 0;
  Z_OK = 0;

type
  // Forward declarations
  Ptm_zip_s = ^tm_zip_s;
  Pzip_fileinfo = ^zip_fileinfo;

  tm_zip_s = record
    tm_sec: Integer;
    tm_min: Integer;
    tm_hour: Integer;
    tm_mday: Integer;
    tm_mon: Integer;
    tm_year: Integer;
  end;

  tm_zip = tm_zip_s;

  zip_fileinfo = record
    tmz_date: tm_zip;
    dosDate: Cardinal;
    internal_fa: Cardinal;
    external_fa: Cardinal;
  end;

  zipFile = Pointer;

  function crc32(crc: Cardinal; const buf: PByte; len: Cardinal): Cardinal; cdecl;
    external ZLIB_DLL name _PU + 'crc32' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function zipOpen(const pathname: PUTF8Char; append: Integer): zipFile; cdecl;
    external ZLIB_DLL name _PU + 'zipOpen' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function zipOpenNewFileInZip3(file_: zipFile; const filename: PUTF8Char; const zipfi: Pzip_fileinfo; const extrafield_local: Pointer; intsize_extrafield_local: Cardinal; const extrafield_global: Pointer; intsize_extrafield_global: Cardinal; const comment: PUTF8Char; method: Integer; level: Integer; raw: Integer; windowBits: Integer; memLevel: Integer; strategy: Integer; const password: PUTF8Char; crcForCrypting: Cardinal): Integer; cdecl;
    external ZLIB_DLL name _PU + 'zipOpenNewFileInZip3' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function zipWriteInFileInZip(file_: zipFile; const buf: Pointer; len: Cardinal): Integer; cdecl;
    external ZLIB_DLL name _PU + 'zipWriteInFileInZip' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function zipCloseFileInZip(file_: zipFile): Integer; cdecl;
    external ZLIB_DLL name _PU + 'zipCloseFileInZip' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  function zipClose(file_: zipFile; const global_comment: PUTF8Char): Integer; cdecl;
    external ZLIB_DLL name _PU + 'zipClose' {$IFDEF MSWINDOWS}delayed{$ENDIF};

  implementation

  end.
