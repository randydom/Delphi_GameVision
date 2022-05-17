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

unit GameVision.Common;

{$I GameVision.Defines.inc}

interface

const
  // GameVision Constants
  GV_VERSION_MAJOR = '0';
  GV_VERSION_MINOR = '1';
  GV_VERSION_PATCH = '0';
  GV_VERSION       = GV_VERSION_MAJOR + '.' + GV_VERSION_MINOR + '.' + GV_VERSION_PATCH;

  // File Extentions Constatns
  GV_FILEEXT_LOG = 'log';
  GV_FILEEXT_INI = 'ini';
  GV_FILEEXT_PNG = 'png';

  // Common Character
  GV_CR = #13;  // carrage return
  GV_LF = #10;  // line feed

  // Display Constants
  GV_DISPLAY_DEFAULT_DPI = 96;

  // ID Constants
  GV_ID_NIL = -1;

  // Degree/Radian conversion
  GV_RAD2DEG = 180.0 / PI;
  GV_DEG2RAD = PI / 180.0;

  { Misc }
  GV_EPSILON = 0.00001;

type

  { TGVPrintEvent }
  TGVPrintEvent = procedure(const aMsg: string; const aArgs: array of const) of object;

  { TGVSeekOperation }
  TGVSeekOperation = (soStart, soCurrent, soEnd);

  { TGVHAlign }
  TGVHAlign = (haLeft, haCenter, haRight);

  { TGVVAlign }
  TGVVAlign = (vaTop, vaCenter, vaBottom);

implementation

end.
