object frmprinc: Tfrmprinc
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Rotina TEF Multiplus Card'
  ClientHeight = 611
  ClientWidth = 848
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poDesktopCenter
  TextHeight = 13
  object Shape1: TShape
    Left = 40
    Top = 199
    Width = 769
    Height = 394
    Brush.Color = clMoneyGreen
  end
  object btpgtoTEF: TSpeedButton
    Left = 180
    Top = 218
    Width = 549
    Height = 58
    Caption = 'Efetuar Pagamento '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = btpgtoTEFClick
  end
  object btcancelatef: TSpeedButton
    Left = 181
    Top = 371
    Width = 549
    Height = 58
    Caption = 'Efetuar Cancelamento'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = btcancelatefClick
  end
  object Label1: TLabel
    Left = 416
    Top = 316
    Width = 167
    Height = 25
    Caption = 'NSU da transa'#231#227'o'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 181
    Top = 316
    Width = 66
    Height = 25
    Caption = 'Cupom'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 20
    Top = 22
    Width = 492
    Height = 29
    Caption = 'Para a aplica'#231#227'o funcionar corretamente:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 68
    Top = 60
    Width = 412
    Height = 25
    Caption = 'Deve estar rodando como ADMINISTRADOR'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 68
    Top = 91
    Width = 625
    Height = 25
    Caption = 
      'A DLL " TefClientmc.dll "  deve estar na mesma pasta da aplica'#231#227 +
      'o'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 68
    Top = 122
    Width = 633
    Height = 25
    Caption = 
      'O arquivo " ConfigMC.ini " deve estar na mesma pasta da aplica'#231#227 +
      'o'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 180
    Top = 279
    Width = 499
    Height = 25
    Caption = 'N'#227'o precisa digitar os valores abaixo, ser'#227'o gerados .'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 68
    Top = 165
    Width = 661
    Height = 29
    Caption = 'Esta classe tem depend'#234'ncia da ACBR para funcionar !!!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Shape2: TShape
    Left = 184
    Top = 437
    Width = 545
    Height = 9
  end
  object btatualizartabelas: TSpeedButton
    Left = 180
    Top = 452
    Width = 549
    Height = 58
    Caption = 'Atualizar tabelas'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = btatualizartabelasClick
  end
  object btlimpartabelas: TSpeedButton
    Left = 181
    Top = 516
    Width = 549
    Height = 58
    Caption = 'Limpar tabelas'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = btlimpartabelasClick
  end
  object edtNSU: TMaskEdit
    Left = 588
    Top = 311
    Width = 141
    Height = 35
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    Text = ''
  end
  object edtcupom: TMaskEdit
    Left = 252
    Top = 311
    Width = 149
    Height = 35
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
    Text = ''
  end
end
