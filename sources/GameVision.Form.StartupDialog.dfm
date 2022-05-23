object GVStartupDialogForm: TGVStartupDialogForm
  Left = 337
  Top = 343
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Startup Dialog'
  ClientHeight = 554
  ClientWidth = 798
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 144
  TextHeight = 23
  object LogoImage: TImage
    Left = 50
    Top = 18
    Width = 691
    Height = 90
    Cursor = crHandPoint
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Stretch = True
    OnClick = LogoImageClick
    OnDblClick = LogoImageDblClick
  end
  object Bevel: TBevel
    Left = 15
    Top = 473
    Width = 764
    Height = 13
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Shape = bsBottomLine
  end
  object MoreButton: TButton
    Left = 389
    Top = 495
    Width = 112
    Height = 38
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = '&More...'
    TabOrder = 0
    OnClick = MoreButtonClick
  end
  object RunButton: TButton
    Left = 507
    Top = 495
    Width = 113
    Height = 38
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = '&Run'
    TabOrder = 1
    OnClick = RunButtonClick
  end
  object QuitButton: TButton
    Left = 629
    Top = 495
    Width = 112
    Height = 38
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = '&Quit'
    TabOrder = 2
    OnClick = QuitButtonClick
  end
  object RelTypePanel: TPanel
    Left = 12
    Top = 495
    Width = 326
    Height = 38
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    BevelOuter = bvLowered
    Caption = 'Full Version'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object PageControl: TPageControl
    Left = 12
    Top = 126
    Width = 767
    Height = 338
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ActivePage = tbReadme
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    object tbReadme: TTabSheet
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Caption = 'Readme'
      ImageIndex = 1
      object ReadmeMemo: TRichEdit
        Left = 0
        Top = 0
        Width = 759
        Height = 300
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alClient
        Color = 12189695
        EnableURLs = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Consolas'
        Font.Style = []
        HideScrollBars = False
        Lines.Strings = (
          'README.TXT was found or could not be read!')
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        ShowURLHint = True
        SpellChecking = True
        TabOrder = 0
        OnLinkClick = ReadmeMemoLinkClick
      end
    end
    object tbLicense: TTabSheet
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Caption = 'License'
      object LicenseMemo: TRichEdit
        Left = 0
        Top = 0
        Width = 759
        Height = 300
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alClient
        Color = 12189695
        EnableURLs = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Consolas'
        Font.Style = []
        HideScrollBars = False
        Lines.Strings = (
          'LICENSE.TXT was found or could not be read!')
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        ShowURLHint = True
        TabOrder = 0
        OnLinkClick = LicenseMemoLinkClick
      end
    end
    object tbConfig: TTabSheet
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Caption = 'Configuration'
      ImageIndex = 2
      object StringGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 755
        Height = 296
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alClient
        Color = 12189695
        ColCount = 2
        DefaultColWidth = 144
        DefaultRowHeight = 36
        DoubleBuffered = True
        DrawingStyle = gdsClassic
        FixedCols = 0
        RowCount = 8
        FixedRows = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Segoe UI'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSizing, goColSizing, goFixedRowDefAlign]
        ParentDoubleBuffered = False
        ParentFont = False
        TabOrder = 0
        ColWidths = (
          144
          968)
      end
    end
  end
end
