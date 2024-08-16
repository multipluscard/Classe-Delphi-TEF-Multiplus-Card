unit uprinc;

interface

uses
  ACBrPosPrinter,
  uMultiplusTEF,
  uMultiplusTypes,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Buttons,
  Vcl.StdCtrls,
  Vcl.Mask,
  Vcl.ExtCtrls;

type
  Tfrmprinc = class(TForm)
    btpgtoTEF: TSpeedButton;
    btcancelatef: TSpeedButton;
    edtNSU: TMaskEdit;
    Label1: TLabel;
    edtcupom: TMaskEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Shape1: TShape;
    Label7: TLabel;
    Label8: TLabel;
    Shape2: TShape;
    btatualizartabelas: TSpeedButton;
    btlimpartabelas: TSpeedButton;
    procedure btpgtoTEFClick(Sender: TObject);
    procedure btcancelatefClick(Sender: TObject);
    procedure btatualizartabelasClick(Sender: TObject);
    procedure btlimpartabelasClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmprinc: Tfrmprinc;

implementation

{$R *.dfm}


//------------------------------------------------------------------------------
//   Cancelamento Multiplus
//------------------------------------------------------------------------------
function SA_MultiplusLimparTabelas(ConfigTEFMPL : TConfigMultiplus):boolean;
var
   TEF_Multiplus : TMultiplusTEF;
begin
   if not DirectoryExists(GetCurrentDir+'\TEFMPL_log') then
      CreateDir(GetCurrentDir+'\TEFMPL_log');
   //---------------------------------------------------------------------------
   TEF_Multiplus                             := TMultiPlusTEF.Create;
   //---------------------------------------------------------------------------
   TEF_Multiplus.IComprovanteCliente         := ConfigTEFMPL.IComprovanteCliente;
   TEF_Multiplus.IComprovanteLoja            := ConfigTEFMPL.IComprovanteLoja;
   TEF_Multiplus.ComprovanteLojaSimplificado := ConfigTEFMPL.ComprovanteLojaSimplificado;
   TEF_Multiplus.CNPJ                        := ConfigTEFMPL.CNPJ;
   TEF_Multiplus.CodigoLoja                  := ConfigTEFMPL.CodigoLoja;
   TEF_Multiplus.Pdv                         := ConfigTEFMPL.Pdv;
   TEF_Multiplus.SalvarLog                   := ConfigTEFMPL.SalvarLog;
   //---------------------------------------------------------------------------
   //   Configurações do PINPAD
   //---------------------------------------------------------------------------
   TEF_Multiplus.ConfigPINPAD := TEF_Multiplus.ConfigPINPAD;   // Atribuindo o type inteiro à instância da classe
   //---------------------------------------------------------------------------
   //  Configurações da impressora
   //---------------------------------------------------------------------------
   TEF_Multiplus.ImpressoraPorta  := ConfigTEFMPL.Impressora.PortaImpressora;
   TEF_Multiplus.ImpressoraAvanco := ConfigTEFMPL.Impressora.AvancoImpressora;
   TEF_Multiplus.ImpressoraModelo := ConfigTEFMPL.Impressora.ModeloImpressoraACBR;
   //---------------------------------------------------------------------------
   //   Atualizar tabelas
   //---------------------------------------------------------------------------
   TEF_Multiplus.SA_LimparTabelas;    // Processar o cancelamento
   //---------------------------------------------------------------------------
   while TEF_Multiplus.Executando do
      begin
         sleep(10);
         Application.ProcessMessages;
      end;

   //---------------------------------------------------------------------------
   Result := TEF_Multiplus.LimpouTabelas;
   TEF_Multiplus.Free;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------
//   Cancelamento Multiplus
//------------------------------------------------------------------------------
function SA_MultiplusAtualizarTabelas(ConfigTEFMPL : TConfigMultiplus):boolean;
var
   TEF_Multiplus : TMultiplusTEF;
begin
   if not DirectoryExists(GetCurrentDir+'\TEFMPL_log') then
      CreateDir(GetCurrentDir+'\TEFMPL_log');
   //---------------------------------------------------------------------------
   TEF_Multiplus                             := TMultiPlusTEF.Create;
   //---------------------------------------------------------------------------
   TEF_Multiplus.IComprovanteCliente         := ConfigTEFMPL.IComprovanteCliente;
   TEF_Multiplus.IComprovanteLoja            := ConfigTEFMPL.IComprovanteLoja;
   TEF_Multiplus.ComprovanteLojaSimplificado := ConfigTEFMPL.ComprovanteLojaSimplificado;
   TEF_Multiplus.CNPJ                        := ConfigTEFMPL.CNPJ;
   TEF_Multiplus.CodigoLoja                  := ConfigTEFMPL.CodigoLoja;
   TEF_Multiplus.Pdv                         := ConfigTEFMPL.Pdv;
   TEF_Multiplus.SalvarLog                   := ConfigTEFMPL.SalvarLog;
   //---------------------------------------------------------------------------
   //   Configurações do PINPAD
   //---------------------------------------------------------------------------
   TEF_Multiplus.ConfigPINPAD := TEF_Multiplus.ConfigPINPAD;   // Atribuindo o type inteiro à instância da classe
   //---------------------------------------------------------------------------
   //  Configurações da impressora
   //---------------------------------------------------------------------------
   TEF_Multiplus.ImpressoraPorta  := ConfigTEFMPL.Impressora.PortaImpressora;
   TEF_Multiplus.ImpressoraAvanco := ConfigTEFMPL.Impressora.AvancoImpressora;
   TEF_Multiplus.ImpressoraModelo := ConfigTEFMPL.Impressora.ModeloImpressoraACBR;
   //---------------------------------------------------------------------------
   //   Atualizar tabelas
   //---------------------------------------------------------------------------
   //  O parâmetro desta função define a forma de como as tabelas serão atualizadas
   //    True - Para limpar as tabelas do PINPAD antes de atualizar
   //    False - Para atualizar sem limpar as tabelas, esse modo somente atualiza as tabelas que estejam desatualizadas
   //
   //  TEF_Multiplus.SA_AtualizarTabelas(true);    // Limpar tabelas do PINPAD e Atualizar tabelas
   //---------------------------------------------------------------------------
   TEF_Multiplus.SA_AtualizarTabelas(false);    // Atualizar tabelas sem limpar
   //---------------------------------------------------------------------------
   while TEF_Multiplus.Executando do
      begin
         sleep(10);
         Application.ProcessMessages;
      end;

   //---------------------------------------------------------------------------
   Result := TEF_Multiplus.AtualizouTabelas;
   TEF_Multiplus.Free;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------
//   Cancelamento Multiplus
//------------------------------------------------------------------------------
function SA_MultiplusCancelarTEF(ConfigTEFMPL : TConfigMultiplus):TMultiplusRetornoTransacao;
var
   TEF_Multiplus : TMultiplusTEF;
begin
   if not DirectoryExists(GetCurrentDir+'\TEFMPL_log') then
      CreateDir(GetCurrentDir+'\TEFMPL_log');
   //---------------------------------------------------------------------------
   TEF_Multiplus                             := TMultiPlusTEF.Create;
   //---------------------------------------------------------------------------
   TEF_Multiplus.IComprovanteCliente         := ConfigTEFMPL.IComprovanteCliente;
   TEF_Multiplus.IComprovanteLoja            := ConfigTEFMPL.IComprovanteLoja;
   TEF_Multiplus.ComprovanteLojaSimplificado := ConfigTEFMPL.ComprovanteLojaSimplificado;
   TEF_Multiplus.CNPJ                        := ConfigTEFMPL.CNPJ;
   TEF_Multiplus.CodigoLoja                  := ConfigTEFMPL.CodigoLoja;
   TEF_Multiplus.Pdv                         := ConfigTEFMPL.Pdv;
   TEF_Multiplus.SalvarLog                   := ConfigTEFMPL.SalvarLog;
   //---------------------------------------------------------------------------
   //   Configurações do PINPAD
   //---------------------------------------------------------------------------
   TEF_Multiplus.ConfigPINPAD := TEF_Multiplus.ConfigPINPAD;   // Atribuindo o type inteiro à instância da classe
   //---------------------------------------------------------------------------
   //  Configurações da impressora
   //---------------------------------------------------------------------------
   TEF_Multiplus.ImpressoraPorta  := ConfigTEFMPL.Impressora.PortaImpressora;
   TEF_Multiplus.ImpressoraAvanco := ConfigTEFMPL.Impressora.AvancoImpressora;
   TEF_Multiplus.ImpressoraModelo := ConfigTEFMPL.Impressora.ModeloImpressoraACBR;
   //---------------------------------------------------------------------------
   //   Pagamento
   //---------------------------------------------------------------------------
   TEF_Multiplus.Valor           := ConfigTEFMPL.Pagamento.ValorPgto;
   TEF_Multiplus.forma           := ConfigTEFMPL.Pagamento.FormaPgtoAplicacao;
   TEF_Multiplus.Cupom           := StrToIntDef(ConfigTEFMPL.Pagamento.Documento,0);
   TEF_Multiplus.NSU             := ConfigTEFMPL.Pagamento.NSUCancelamento;
   TEF_Multiplus.TpOperacaoTEF   := ConfigTEFMPL.Pagamento.TipoPgtoCartaoPIX;
   TEF_Multiplus.Parcela         := ConfigTEFMPL.Pagamento.QtdeParcelas;
   //---------------------------------------------------------------------------
   TEF_Multiplus.SA_Cancelamento;    // Processar o cancelamento
   //---------------------------------------------------------------------------
   while TEF_Multiplus.Executando do
      begin
         sleep(10);
         Application.ProcessMessages;
      end;
   //---------------------------------------------------------------------------
   Result := TEF_Multiplus.RetornoTransacao;
   //---------------------------------------------------------------------------
   TEF_Multiplus.Free;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------
//   Pagamento Multiplus
//------------------------------------------------------------------------------
function SA_MultiplusPagarTEF(ConfigTEFMPL : TConfigMultiplus):TMultiplusRetornoTransacao;
var
   TEF_Multiplus : TMultiplusTEF;
begin
   //---------------------------------------------------------------------------
   if not DirectoryExists(GetCurrentDir+'\TEFMPL_log') then
      CreateDir(GetCurrentDir+'\TEFMPL_log');
   //---------------------------------------------------------------------------
   TEF_Multiplus                             := TMultiplusTEF.Create;
   TEF_Multiplus.IComprovanteCliente         := ConfigTEFMPL.IComprovanteCliente;
   TEF_Multiplus.IComprovanteLoja            := ConfigTEFMPL.IComprovanteLoja;
   TEF_Multiplus.ComprovanteLojaSimplificado := ConfigTEFMPL.ComprovanteLojaSimplificado;
   TEF_Multiplus.CNPJ                        := ConfigTEFMPL.CNPJ;
   TEF_Multiplus.CodigoLoja                  := ConfigTEFMPL.CodigoLoja;
   TEF_Multiplus.Pdv                         := ConfigTEFMPL.Pdv;
   TEF_Multiplus.SalvarLog                   := ConfigTEFMPL.SalvarLog;
   TEF_Multiplus.TituloJanela                := ConfigTEFMPL.TituloJanela;
   //---------------------------------------------------------------------------
   TEF_Multiplus.ConfigPINPAD := ConfigTEFMPL.PINPAD; // Atribuindo o type inteiro à instância da classe
   //---------------------------------------------------------------------------
   //  Configurações da impressora
   //---------------------------------------------------------------------------
   TEF_Multiplus.ImpressoraPorta  := ConfigTEFMPL.Impressora.PortaImpressora;
   TEF_Multiplus.ImpressoraAvanco := ConfigTEFMPL.Impressora.AvancoImpressora;
   TEF_Multiplus.ImpressoraModelo := ConfigTEFMPL.Impressora.ModeloImpressoraACBR;
   //---------------------------------------------------------------------------
   TEF_Multiplus.Valor           := ConfigTEFMPL.Pagamento.ValorPgto;
   TEF_Multiplus.forma           := ConfigTEFMPL.Pagamento.FormaPgtoAplicacao;
   TEF_Multiplus.Cupom           := StrToIntDef(ConfigTEFMPL.Pagamento.Documento,0);
   TEF_Multiplus.NSU             := ConfigTEFMPL.Pagamento.Documento;
   TEF_Multiplus.TpOperacaoTEF   := ConfigTEFMPL.Pagamento.TipoPgtoCartaoPIX;
   TEF_Multiplus.Parcela         := ConfigTEFMPL.Pagamento.QtdeParcelas;
   //---------------------------------------------------------------------------
   TEF_Multiplus.SA_ProcessarPagamento;    // Efetuar o pagamento
   //---------------------------------------------------------------------------
   while TEF_Multiplus.Executando do
      begin
         sleep(10);
         Application.ProcessMessages;
      end;
   //---------------------------------------------------------------------------
   Result := TEF_Multiplus.RetornoTransacao;
   //---------------------------------------------------------------------------
   TEF_Multiplus.Free;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------

procedure Tfrmprinc.btatualizartabelasClick(Sender: TObject);
var
   //---------------------------------------------------------------------------
   ConfigTEFMPL : TConfigMultiPlus;   // Configuração gerais do TEF
   //---------------------------------------------------------------------------
begin
   //---------------------------------------------------------------------------
   //   Configurações básicas do TEF - Pode usar uma variável pública global
   //---------------------------------------------------------------------------
   ConfigTEFMPL.IComprovanteCliente         := tpiMPlPerguntar;
   ConfigTEFMPL.IComprovanteLoja            := tpiMPlPerguntar;
   ConfigTEFMPL.ComprovanteLojaSimplificado := true;
   ConfigTEFMPL.CNPJ                        := '60177876000130';
   ConfigTEFMPL.CodigoLoja                  := '167';
   ConfigTEFMPL.Pdv                         := '001';
   ConfigTEFMPL.SalvarLog                   := true;
   //---------------------------------------------------------------------------
   ConfigTEFMPL.Impressora.PortaImpressora      := 'RAW:TECTOYIP';
   ConfigTEFMPL.Impressora.AvancoImpressora     := 5;
   ConfigTEFMPL.Impressora.ModeloImpressoraACBR := ppEscPosEpson;
   //---------------------------------------------------------------------------
   //   Configurações do PINPAD
   //---------------------------------------------------------------------------
   ConfigTEFMPL.PINPAD.PINPAD_usar         := true;    // Habilitar o uso do PINPAD para apresentar o logo definido na imagem
   ConfigTEFMPL.PINPAD.PINPAD_Porta        := 'COM16';  // Porta em que o PINPAD está conectado
   ConfigTEFMPL.PINPAD.PINPAD_Baud         := b9600;
   ConfigTEFMPL.PINPAD.PINPAD_DataBits     := 8;
   ConfigTEFMPL.PINPAD.PINPAD_StopBit      := ts1;
   ConfigTEFMPL.PINPAD.PINPAD_Parity       := tpNone;
   ConfigTEFMPL.PINPAD.PINPAD_HandShaking  := thsNenhum;
   ConfigTEFMPL.PINPAD.PINPAD_SoftFlow     := false;
   ConfigTEFMPL.PINPAD.PINPAD_HardFlow     := false;
   ConfigTEFMPL.PINPAD.PINPAD_Imagem       := GetCurrentDir+'\icones\logo_cabecalho.png';     // Arquivo PNG, não use uma imagem muito grande
   //---------------------------------------------------------------------------
   //   Atualizar tabelas
   //---------------------------------------------------------------------------
   if SA_MultiplusAtualizarTabelas(ConfigTEFMPL) then
      begin
         beep;
         ShowMessage('Operação executada');
      end
end;

procedure Tfrmprinc.btcancelatefClick(Sender: TObject);
var
   //---------------------------------------------------------------------------
   ConfigTEFMPL : TConfigMultiPlus;   // Configuração gerais do TEF
   //---------------------------------------------------------------------------
   RetornoTEF : TMultiplusRetornoTransacao; // Contém o retorno da operação TEF
   //---------------------------------------------------------------------------
begin
   //---------------------------------------------------------------------------
   //   Configurações básicas do TEF - Pode usar uma variável pública global
   //---------------------------------------------------------------------------
   ConfigTEFMPL.IComprovanteCliente         := tpiMPlPerguntar;
   ConfigTEFMPL.IComprovanteLoja            := tpiMPlPerguntar;
   ConfigTEFMPL.ComprovanteLojaSimplificado := true;
   ConfigTEFMPL.CNPJ                        := '60177876000130';
   ConfigTEFMPL.CodigoLoja                  := '167';
   ConfigTEFMPL.Pdv                         := '001';
   ConfigTEFMPL.SalvarLog                   := true;
   //---------------------------------------------------------------------------
   ConfigTEFMPL.Impressora.PortaImpressora      := 'RAW:TECTOYIP';
   ConfigTEFMPL.Impressora.AvancoImpressora     := 5;
   ConfigTEFMPL.Impressora.ModeloImpressoraACBR := ppEscPosEpson;
   //---------------------------------------------------------------------------
   //   Configurações do PINPAD
   //---------------------------------------------------------------------------
   ConfigTEFMPL.PINPAD.PINPAD_usar         := true;    // Habilitar o uso do PINPAD para apresentar o logo definido na imagem
   ConfigTEFMPL.PINPAD.PINPAD_Porta        := 'COM3';  // Porta em que o PINPAD está conectado
   ConfigTEFMPL.PINPAD.PINPAD_Baud         := b9600;
   ConfigTEFMPL.PINPAD.PINPAD_DataBits     := 8;
   ConfigTEFMPL.PINPAD.PINPAD_StopBit      := ts1;
   ConfigTEFMPL.PINPAD.PINPAD_Parity       := tpNone;
   ConfigTEFMPL.PINPAD.PINPAD_HandShaking  := thsNenhum;
   ConfigTEFMPL.PINPAD.PINPAD_SoftFlow     := false;
   ConfigTEFMPL.PINPAD.PINPAD_HardFlow     := false;
   ConfigTEFMPL.PINPAD.PINPAD_Imagem       := GetCurrentDir+'\icones\logo_cabecalho.png';     // Arquivo PNG, não use uma imagem muito grande
   //---------------------------------------------------------------------------
   //   Pagamento
   //---------------------------------------------------------------------------
   ConfigTEFMPL.Pagamento.FormaPgtoAplicacao := 'CARTAO DE CREDITO'; // Forma de pagamento descritiva a ser apresentada na tela
   ConfigTEFMPL.Pagamento.ValorPgto          := 5.32; // Valor a ser transacionado
   ConfigTEFMPL.Pagamento.Documento          := edtcupom.Text; // Numero do cupom  - Obtido da operação anterior
   ConfigTEFMPL.Pagamento.NSUCancelamento    := edtNSU.Text;   // Dado obtido do retorno da operação anterior
   ConfigTEFMPL.Pagamento.TipoPgtoCartaoPIX  := tpMPlCreditoVista;
   ConfigTEFMPL.Pagamento.QtdeParcelas       := 1;
   //---------------------------------------------------------------------------
   RetornoTEF := SA_MultiplusCancelarTEF(ConfigTEFMPL);

   if (edtNSU.Text<>'') or (edtcupom.Text<>'') then
      begin
         beep;
         ShowMessage(RetornoTEF.COMPROVANTE.Text);
      end
end;

procedure Tfrmprinc.btlimpartabelasClick(Sender: TObject);
var
   //---------------------------------------------------------------------------
   ConfigTEFMPL : TConfigMultiPlus;   // Configuração gerais do TEF
   //---------------------------------------------------------------------------
begin
   //---------------------------------------------------------------------------
   //   Configurações básicas do TEF - Pode usar uma variável pública global
   //---------------------------------------------------------------------------
   ConfigTEFMPL.IComprovanteCliente         := tpiMPlPerguntar;
   ConfigTEFMPL.IComprovanteLoja            := tpiMPlPerguntar;
   ConfigTEFMPL.ComprovanteLojaSimplificado := true;
   ConfigTEFMPL.CNPJ                        := '60177876000130';
   ConfigTEFMPL.CodigoLoja                  := '167';
   ConfigTEFMPL.Pdv                         := '001';
   ConfigTEFMPL.SalvarLog                   := true;
   //---------------------------------------------------------------------------
   //   Configurações do PINPAD
   //---------------------------------------------------------------------------
   ConfigTEFMPL.PINPAD.PINPAD_usar         := true;    // Habilitar o uso do PINPAD para apresentar o logo definido na imagem
   ConfigTEFMPL.PINPAD.PINPAD_Porta        := 'COM16';  // Porta em que o PINPAD está conectado
   ConfigTEFMPL.PINPAD.PINPAD_Baud         := b9600;
   ConfigTEFMPL.PINPAD.PINPAD_DataBits     := 8;
   ConfigTEFMPL.PINPAD.PINPAD_StopBit      := ts1;
   ConfigTEFMPL.PINPAD.PINPAD_Parity       := tpNone;
   ConfigTEFMPL.PINPAD.PINPAD_HandShaking  := thsNenhum;
   ConfigTEFMPL.PINPAD.PINPAD_SoftFlow     := false;
   ConfigTEFMPL.PINPAD.PINPAD_HardFlow     := false;
   ConfigTEFMPL.PINPAD.PINPAD_Imagem       := GetCurrentDir+'\icones\logo_cabecalho.png';     // Arquivo PNG, não use uma imagem muito grande
   //---------------------------------------------------------------------------
   //   Atualizar tabelas
   //---------------------------------------------------------------------------
   if SA_MultiplusLimparTabelas(ConfigTEFMPL) then
      begin
         beep;
         ShowMessage('Operação executada');
      end
end;

procedure Tfrmprinc.btpgtoTEFClick(Sender: TObject);
var
   ConfigTEFMPL : TConfigMultiplus;   // Configuração gerais do TEF
   RetornoTEF   : TMultiplusRetornoTransacao; // Contém o retorno da operação TEF
   //---------------------------------------------------------------------------
begin
   //---------------------------------------------------------------------------
   //   Configurações básicas do TEF - Pode usar uma variável pública global
   //---------------------------------------------------------------------------
   ConfigTEFMPL.IComprovanteCliente         := tpiMPlPerguntar;  // Podemos configurar a impressão do comprovante do cliente sempre, perguntar ou não imprimir
   ConfigTEFMPL.IComprovanteLoja            := tpiMPlPerguntar;  // Podemos configurar a impressão do comprovante do cliente sempre, perguntar ou não imprimir
   ConfigTEFMPL.ComprovanteLojaSimplificado := true;             // Esta configuração permite a impresão do comprovante da loja ser reduzido, apenas para conferência de caixa
   ConfigTEFMPL.CNPJ                        := '60177876000130'; // Atribua o CNPJ da empresa cadastrada no portal da MULTIPLUS
   ConfigTEFMPL.CodigoLoja                  := '167'; // Atribuir a este parâmetro o código da loja informado pela MULTPLUS
   ConfigTEFMPL.Pdv                         := '001'; // Atribua a esta variável o código do PDV fornecido pela MULTIPLUS
   ConfigTEFMPL.SalvarLog                   := true;  // Este parâmetro habilita que o LOG da automação seja guardado na pasta GetCurrentDir+'\TEFMPL_log' criada automaticamente
   ConfigTEFMPL.TituloJanela                := 'TEF Multipluscard'; // Título da janela a ser apresentado
   //---------------------------------------------------------------------------
   ConfigTEFMPL.Impressora.PortaImpressora      := 'RAW:TECTOYIP';  // Nome da impressora a ser utilizada pora imprimir os comprovantes - Usar o padrão ACBRPosPrinte
   ConfigTEFMPL.Impressora.AvancoImpressora     := 5; // Defina quantas linhas é o avanço da impressora
   ConfigTEFMPL.Impressora.ModeloImpressoraACBR := ppEscPosEpson;  // Utilize este parâmetro para definir o modelo de impressora, a grande maioria é EPSON, use o padrão ACBRPosPrinter
   //---------------------------------------------------------------------------
   //   Configurações do PINPAD
   //---------------------------------------------------------------------------
   ConfigTEFMPL.PINPAD.PINPAD_usar         := true;    // Habilitar o uso do PINPAD para apresentar o logo definido na imagem
   ConfigTEFMPL.PINPAD.PINPAD_Porta        := 'COM3';  // Porta em que o PINPAD está conectado
   ConfigTEFMPL.PINPAD.PINPAD_Baud         := b9600;   // Velocidade da porta - Pode ser 19200
   ConfigTEFMPL.PINPAD.PINPAD_DataBits     := 8;
   ConfigTEFMPL.PINPAD.PINPAD_StopBit      := ts1;
   ConfigTEFMPL.PINPAD.PINPAD_Parity       := tpNone;
   ConfigTEFMPL.PINPAD.PINPAD_HandShaking  := thsNenhum;
   ConfigTEFMPL.PINPAD.PINPAD_SoftFlow     := false;
   ConfigTEFMPL.PINPAD.PINPAD_HardFlow     := false;
   ConfigTEFMPL.PINPAD.PINPAD_Imagem       := GetCurrentDir+'\icones\logo_cabecalho.png';     // Arquivo PNG, não use uma imagem muito grande - Tamanho recomendado é 144 x 73 que permite um bom ddesempenho e boa visibilidade
   //---------------------------------------------------------------------------
   //   Pagamento
   //---------------------------------------------------------------------------
   ConfigTEFMPL.Pagamento.FormaPgtoAplicacao := 'PIX'; // Forma de pagamento descritiva a ser apresentada na tela
   ConfigTEFMPL.Pagamento.ValorPgto          := 5.32; // Valor a ser transacionado
   ConfigTEFMPL.Pagamento.Documento          := formatdatetime('hhmmss',now); // Numero do cupom
   ConfigTEFMPL.Pagamento.TipoPgtoCartaoPIX  := tpMPlCreditoVista; // Informar qual tipo de cartão ou PIX vai transacionar, verifique quais os tipos disponíveis no arquivo uMultiplusTypes.pas
   ConfigTEFMPL.Pagamento.QtdeParcelas       := 1;  // Informar quantas parcelas é a transação, para cartão de debito ou crédito a vista informar 1
   //---------------------------------------------------------------------------
   RetornoTEF := SA_MultiplusPagarTEF(ConfigTEFMPL);  // Chamar a função com a variável composta de entrada definida acima
   //---------------------------------------------------------------------------
   if RetornoTEF.NSU<>'' then // A variável RetornoTEF é uma variável composta que contém todas as informações retornadas pelo TEF
      begin
         ShowMessage(RetornoTEF.COMPROVANTE.Text);
         frmprinc.edtcupom.Text := RetornoTEF.CUPOM; //
         frmprinc.edtNSU.Text   := RetornoTEF.NSU;  // Este código deverá ser utilizado para cancelamento
         //---------------------------------------------------------------------
      end;

end;

end.
