unit uMultiplusTEF;

interface

uses
   ACBrPosPrinter,
   ACBrImage,
   acbrutil.Math,
   ACBrDelphiZXingQRCode,
   Vcl.Imaging.pngimage,
   uMultiplusTypes,
   uescpos,
   vcl.forms,
   Vcl.Graphics,
   System.Math,
   System.SysUtils,
   system.DateUtils,
   system.Classes,
   ACBrAbecsPinPad,
   ACBrDeviceSerial,
   uwebtefmp;

type
   //---------------------------------------------------------------------------
   TMultiplusTEF = class
      Private
         //---------------------------------------------------------------------
         LConfigPINPAD     : TConfigPINPAD;      // Configuração do PINPAD
         LImpressoraPorta  : string;
         LImpressoraAvanco : integer;
         LImpressoraModelo : TACBrPosPrinterModelo;
         //---------------------------------------------------------------------
         LSalvarLog            : boolean;
         LExecutando           : boolean;
         //---------------------------------------------------------------------
         LForma                       : string;            // Forma para ser apresentada na tela de apresentação
         LIComprovanteCliente         : TtpMPlImpressao;   // A impressão do comprovante do cliente é automática, pergunta ou não imprimir
         LIComprovanteLoja            : TtpMPlImpressao;   // A impressão do comprovante da loja é automática, pergunta ou não imprimir
         LComprovanteLojaSimplificado : boolean;           // Habilitar a impressão simplificada do comprovante da loja
         LTituloJanela                : string; // O título que a janela do TEF vai apresentar, se deixar vazio, assume o padrão "TEF Multipluscard"
         //---------------------------------------------------------------------
         //  Parâmetros para realizar a transação
         //---------------------------------------------------------------------
         LTpOperacaoTEF        : TTpMPlCartaoOperacaoTEF;
         LCNPJ                 : string;
         LParcela              : integer;
         LCupom                : integer;
         LValor                : real;
         LNSU                  : string;
         LPdv                  : string;
         LCodigoLoja           : string;
         LData                 : TDate;
         LHora                 : TTime;
         LDataHora             : TDateTime;
         //---------------------------------------------------------------------
         LRetornoTransacao     : TMultiplusRetornoTransacao;  // Retorno da transação
         //---------------------------------------------------------------------
         LAtualizouTabelas     : boolean;
         LLimpouTabelas        : boolean;
         //---------------------------------------------------------------------
         procedure SA_Salva_Arquivo_Incremental(linha,nome_arquivo:string);
         function untransform(palavra:string):real;
         function transform(valor:real):string;
         //---------------------------------------------------------------------
         procedure SA_SalvarLog(titulo,dado: string);
         function SA_TpCartaoOperacaoTEFtoINT(tipoCartao : TTpMPlCartaoOperacaoTEF):integer;
         function SA_TpCartaoOperacaoTEFtoSTR(tipoCartao: TTpMPlCartaoOperacaoTEF): string;
         function SA_RetornoErro(codigo:integer):string;
         procedure SA_Inicializar_ESCPOS;
         //---------------------------------------------------------------------
         //   Funções para tratar as respostas do TEF
         //---------------------------------------------------------------------
         function SA_MultiPlusTPRetorno(retorno:string):TPRetornoMultiPlus;
         function SA_SA_MultiPlusBuscarCampo(campo,retorno:string):string;
         function SA_SA_MultiPlusRetornoTransacao(retorno:string):TMultiPlusRetornoTransacao;
         function SA_SA_MultiPlusMensagemRetorno(retorno:string):string;
         function SA_SA_MultiPlusTipoDado(dado:string):TMultiPlusTTipoDado;
         function SA_SA_MultiPlusPerguntaRetorno(retorno:string):TMultiPlusPergunta;
         function SA_SA_MultiPlusOpcoesMenuRetorno(retorno:string):TMultiPlusMenu;
         function SA_PerguntarOpcoes(opcoes: TStringList;mensagem:string): integer;
         function SA_ValidarRespostaPergunta(Pergunta : TMultiPlusPergunta ; ValorColetado : string):boolean;
         function SA_FormatarRespostaPergunta(pergunta : TMultiPlusPergunta ; ValorColetado : string):string;
         function SA_GerarComprovanteSimplificado(Operacao : TpOperacaoMPL = tpOpVenda): TStringList;
         function SA_ExtrairDadosPIX(DadosPIX:string):TMultiPlusDadosPix;
         function SA_ExtraiCamporDadosPIX(Campo,  DadosPIX: string): string;
         Procedure SA_PintarPix(QRCode:string);
         Procedure SA_ConfigurarPinPad;
         function SA_PINPAD_MostrarImagem(imagem:TPngImage):boolean;
         procedure SA_MostrarLogoPINPAD;
         //---------------------------------------------------------------------
      Public
         //---------------------------------------------------------------------
         GerenciadorImpressao : TESCPos;
         PinPad               : TACBrAbecsPinPad;
         //---------------------------------------------------------------------
         constructor Create();
         destructor Destroy(); override;
         procedure SA_ProcessarPagamento;
         procedure SA_Cancelamento;
         procedure SA_AtualizarTabelas(LimparTabelasAntesdeAtualizar : boolean = false);
         procedure SA_LimparTabelas;
         //---------------------------------------------------------------------
         property SalvarLog            : boolean read LSalvarLog write LSalvarLog;
         property Executando           : boolean read LExecutando;
         //---------------------------------------------------------------------
         property ConfigPINPAD     : TConfigPINPAD read LConfigPINPAD write LConfigPINPAD;  // Configuração do Pinpad
         property ImpressoraPorta  : string read LImpressoraPorta write LImpressoraPorta;
         property ImpressoraAvanco : integer read LImpressoraAvanco write LImpressoraAvanco;
         property ImpressoraModelo : TACBrPosPrinterModelo read LImpressoraModelo write LImpressoraModelo;
         //---------------------------------------------------------------------
         property Forma                       : string          read LForma               write LForma;   // Forma para ser apresentada na tela de apresentação
         property IComprovanteCliente         : TtpMPlImpressao read LIComprovanteCliente write LIComprovanteCliente;   // A impressão do comprovante do cliente é automática, pergunta ou não imprimir
         property IComprovanteLoja            : TtpMPlImpressao read LIComprovanteLoja    write LIComprovanteLoja;   // A impressão do comprovante da loja é automática, pergunta ou não imprimir
         property ComprovanteLojaSimplificado : boolean         read LComprovanteLojaSimplificado write LComprovanteLojaSimplificado;           // Habilitar a impressão simplificada do comprovante da loja
         property TituloJanela                : string read LTituloJanela write LTituloJanela; // O título que a janela do TEF vai apresentar, se deixar vazio, assume o padrão "TEF Multipluscard"
         //---------------------------------------------------------------------
         //  Parâmetros para realizar a transação
         //---------------------------------------------------------------------
         property TpOperacaoTEF        : TTpMPlCartaoOperacaoTEF read LTpOperacaoTEF write LTpOperacaoTEF;
         property CNPJ                 : string                  read LCNPJ          write LCNPJ;
         property Parcela              : integer                 read LParcela       write LParcela;
         property Cupom                : integer                 read LCupom         write LCupom;
         property Valor                : real                    read LValor         write LValor;
         property NSU                  : string                  read LNSU           write LNSU;
         property Pdv                  : string                  read LPdv           write LPdv;
         property CodigoLoja           : string                  read LCodigoLoja    write LCodigoLoja;
         //---------------------------------------------------------------------
         property RetornoTransacao     : TMultiPlusRetornoTransacao read LRetornoTransacao write LRetornoTransacao;  // Para retornar a transação
         property AtualizouTabelas     : boolean                    read LAtualizouTabelas write LAtualizouTabelas;  // Atualização das tabelas ocorreu com sucesso
         property LimpouTabelas        : boolean                    read LLimpouTabelas    write LLimpouTabelas;     // Limpar as tabelas do Pinpad
         //---------------------------------------------------------------------
   end;
   //---------------------------------------------------------------------
   function IniciaFuncaoMCInterativo( iComando         : Integer;
                                      sCnpjCliente     : PAnsiChar;
                                      iParcela         : Integer;
                                      sCupom           : PAnsiChar;
                                      sValor           : PAnsiChar;
                                      sNsu             : PAnsiChar;
                                      sData            : PAnsiChar;
                                      sNumeroPDV       : PAnsiChar;
                                      sCodigoLoja      : PAnsiChar;
                                      sTipoComunicacao : Integer;
                                      sParametro       : PAnsiChar
                                      ): Integer; stdcall; external 'TefClientmc.dll';

function AguardaFuncaoMCInterativo(): PAnsiChar; stdcall; external 'TefClientmc.dll';

function ContinuaFuncaoMCInterativo(sInformacao: PAnsiChar): Integer; stdcall; external 'TefClientmc.dll';

function FinalizaFuncaoMCInterativo( iComando         : Integer;
                                     sCnpjCliente     : PAnsiChar;
                                     iParcela         : Integer;
                                     sCupom           : PAnsiChar;
                                     sValor           : PAnsiChar;
                                     sNsu             : PAnsiChar;
                                     sData            : PAnsiChar;
                                     sNumeroPDV       : PAnsiChar;
                                     sCodigoLoja      : PAnsiChar;
                                     sTipoComunicacao : Integer;
                                     sParametro       : PAnsiChar
                                     ): Integer; stdcall;  external 'TefClientmc.dll';

function CancelarFluxoMCInterativo(): Integer; stdcall;  external 'TefClientmc.dll';

function AtualizarTabelas (sCnpjCliente : string; sCodigoLoja : string ; sNumeroPDV:string; iLimpaTb : integer) : PAnsiChar; stdcall; external 'TefClientmc.dll';

function LimparTabelas(sCnpjCliente : string ; sCodigoLoja : string ; sNumeroPDV : string) : PAnsiChar; stdcall; external 'TefClientmc.dll';
   //---------------------------------------------------------------------------
implementation

{ TMultiPlusTEF }

constructor TMultiPlusTEF.Create;
begin
   //---------------------------------------------------------------------------
   LExecutando  := true;
   LData        := date;
   LHora        := Time;
   LDataHora    := now;
   //---------------------------------------------------------------------------
   SA_Inicializar_ESCPOS;

   PinPad := TACBrAbecsPinPad.Create(nil);
   //---------------------------------------------------------------------------
   inherited;
   //---------------------------------------------------------------------------
end;

destructor TMultiplusTEF.Destroy;
begin
   GerenciadorImpressao.Free;
   PinPad.Free;
   inherited;
end;

procedure TMultiplusTEF.SA_AtualizarTabelas(LimparTabelasAntesdeAtualizar : boolean = false);
var
   retorno       : string;
   LimparTabelas : integer;
begin
   //---------------------------------------------------------------------------
   //   Iniciando a tela de TEF
   //---------------------------------------------------------------------------
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TituloJanela     := LTituloJanela;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LForma;
   frmwebtef.lbvalor.Caption  := transform(LValor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.TituloJanela     := LTituloJanela;
   frmwebtef.Show;
   //---------------------------------------------------------------------------
   TThread.CreateAnonymousThread(procedure
      begin
         //---------------------------------------------------------------------
         TThread.Synchronize(TThread.CurrentThread,
         procedure
            begin
               frmwebtef.mensagem := 'Atualizando tabelas...';
               SA_Mostrar_Mensagem(true);
            end);
         //---------------------------------------------------------------------
         LimparTabelas := 1;  // Definir a variável para atualizar as tabelas sem limpar
         if LimparTabelasAntesdeAtualizar then  // Foi definido que deve limpar as tabelas antes de atualizar
            LimparTabelas := 0;
         SA_SalvarLog('ATUALIZAR TABELAS','AtualizarTabelas');  // Salvar LOG - Se ativado
         retorno := string(AtualizarTabelas (LCNPJ,LCodigoLoja,LPdv,LimparTabelas));
         SA_SalvarLog('RETORNO ATUALIZAR TABELAS',retorno);  // Salvar LOG - Se ativado
         if retorno<>'' then
            LAtualizouTabelas := pos('SUCESSO',retorno)>0
         else
            LAtualizouTabelas := false;
         //---------------------------------------------------------------------
         //   Fechando a janela do TEF
         //---------------------------------------------------------------------
         SA_MostrarLogoPINPAD;   // Mostrando a imagem de LOGO na tela do PINPAD
         frmwebtef.Close;
         frmwebtef.Release;
         lExecutando := false;
         //---------------------------------------------------------------------
      end).Start;
end;

procedure TMultiPlusTEF.SA_Cancelamento;
var
   //---------------------------------------------------------------------------
   vlTransformado : string;
   IRetorno       : integer;
   CRetorno       : integer;
   SRetorno       : WideString;
   sair           : boolean;
   //---------------------------------------------------------------------------
   acao     : TPRetornoMultiPlus;
   Menu     : TMultiPlusMenu;
   Pergunta : TMultiPlusPergunta;
   //---------------------------------------------------------------------------
   opcaoColeta             : integer;    //  Quando selecionar uma opção do menu
   ImprimirComprovante     : boolean;    // Para sinalizar se o comprovante será impresso ou não
   ConteudoInicial         : string;
   Resposta_pergunta       : string;
   Leitura_pergunta        : boolean;
   finalizado              : boolean;
   qtdetentativasfinalizar : integer;
   SairLoopImpressao       : boolean;
   //---------------------------------------------------------------------------
begin
   //---------------------------------------------------------------------------
   //   Iniciando a tela de TEF
   //---------------------------------------------------------------------------
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.TituloJanela     := LTituloJanela;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LForma;
   frmwebtef.lbvalor.Caption  := transform(LValor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.TituloJanela     := LTituloJanela;
   frmwebtef.Show;
   //---------------------------------------------------------------------------
   TThread.CreateAnonymousThread(procedure
   begin
      //------------------------------------------------------------------------
      //   Cancelamento de operação
      //------------------------------------------------------------------------
      //   Inicializar TEF
      //------------------------------------------------------------------------
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
         frmwebtef.mensagem := 'Inicializando TEF...';
         SA_Mostrar_Mensagem(true);
      end);
      //------------------------------------------------------------------------
      vlTransformado := trim(FormatFloat('#####0.00',LValor));   // Formatando o valor para TEF
      vlTransformado := StringReplace(vlTransformado,'.',',',[]); // Substituindo o ponto decimal por vírgula
      if LParcela=0 then // Se a qtde parcelas for zero, transfromar para 1
         LParcela := 1;
      //------------------------------------------------------------------------
      SA_SalvarLog('REALIZAR CANCELAMENTO','R$:'+vlTransformado+' FORMA Pgto.:'+LForma+' NSU:'+LNSU+' Cupom Nr.:'+LCupom.ToString+' Tipo Cartao:'+SA_TpCartaoOperacaoTEFtoSTR(LTpOperacaoTEF)+' Parcelas:'+LParcela.ToString);
      IRetorno := IniciaFuncaoMCInterativo(5,
                                           PAnsiChar(AnsiString(LCNPJ)),
                                           LParcela,
                                           PAnsiChar(AnsiString(LCupom.ToString)),
                                           PAnsiChar(AnsiString(vlTransformado)),
                                           PAnsiChar(AnsiString(LNSU)),
                                           PAnsiChar(AnsiString(formatdatetime('yyyyMMdd',LData))),
                                           PAnsiChar(AnsiString(LPdv)),
                                           PAnsiChar(AnsiString(LCodigoLoja)),
                                           0,
                                           '');
      //------------------------------------------------------------------------
      if IRetorno=0 then
         begin
            //------------------------------------------------------------------
            //  Sem ocorrência de erros, continuar o processo
            //------------------------------------------------------------------
            sair    := false;
            while not sair do
               begin
                  //------------------------------------------------------------
                  //   Fazer fluxo de consulta do TEF
                  //------------------------------------------------------------
                  SRetorno := widestring(AguardaFuncaoMCInterativo());
                  if SRetorno<>'' then   // Se o retorno não é vazio, verificar que tipo de retorno
                     begin
                        //------------------------------------------------------
                        //  acao = TPRetornoMultiPlus e de acordo com o retorno deverá ser executado um processo
                        // TPRetornoMultiPlus = (TPMultiPlusMENU , TPMultiPlusMSG , TPMultiPlusPERGUNTA , TPMultiPlusRETORNO , TPMultiPlusERROABORTAR , TPMultiPlusERRODISPLAY,TPMultiPlusINDEFINIDO);
                        //------------------------------------------------------
                        SA_SalvarLog('RESPOSTA AguardaFuncaoMCInterativo',SRetorno);  // Salvar LOG - Se ativado
                        //------------------------------------------------------
                        acao     := SA_MultiplusTPRetorno(SRetorno);
                        //------------------------------------------------------
                        if acao=TPMultiPlusMSG then // Somente mostrar uma mensagem na tela
                           begin
                              //------------------------------------------------
                              //  Mostrar a mensagem na tela
                              //------------------------------------------------
                              frmwebtef.mensagem := SA_SA_MultiPlusMensagemRetorno(SRetorno);
                              TThread.Synchronize(TThread.CurrentThread,
                                 procedure
                                    begin
                                       SA_Mostrar_Mensagem(true);
                                    end);
                              //------------------------------------------------
                           end
                        else if (acao=TPMultiPlusERROABORTAR) or (acao=TPMultiPlusERRODISPLAY) then // Somente mostrar uma mensagem na tela e encerrar o processo
                           begin
                              //------------------------------------------------
                              //   Ocorreu um evento que provocou o encerramento do processo
                              //------------------------------------------------
                              frmwebtef.mensagem := SA_SA_MultiPlusMensagemRetorno(SRetorno);
                              TThread.Synchronize(TThread.CurrentThread,
                                 procedure
                                    begin
                                       SA_Mostrar_Mensagem(true);
                                    end);
                              //------------------------------------------------
                              SA_AtivarBTCancelar;   // Ativar o botão cancelar na tela de TEF
                              while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                 begin
                                    sleep(50);
                                 end;
                              sair := true;   // Ativar a saída do LOOP
                              //------------------------------------------------
                           end
                        else if acao=TPMultiPlusMENU then  // Deverá ser apresentado um menu de opções
                           begin
                              //------------------------------------------------
                              //  Criar um menu de opções para o operador escolher
                              //------------------------------------------------
                              Menu     := SA_SA_MultiPlusOpcoesMenuRetorno(SRetorno);
                              SRetorno := '';
                              acao     := TPMultiPlusINDEFINIDO;
                              //------------------------------------------------
                              frmwebtef.mensagem := menu.Titulo;
                              frmwebtef.opcoes   := menu.Opcoes;
                              frmwebtef.opcao    := -1;
                              frmwebtef.tecla    := '';
                              frmwebtef.Cancelar := false;
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,procedure
                                 begin
                                    SA_Criar_Menu(true);
                                    SA_AtivarBTCancelar;
                                 end);
                              //------------------------------------------------
                              application.ProcessMessages;
                              opcaoColeta  := SA_PerguntarOpcoes(menu.Opcoes,menu.Titulo);
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,procedure
                                 begin
                                    SA_Criar_Menu(false);
                                    frmwebtef.btcancelar.free;
                                 end);
                              //------------------------------------------------
                              if opcaoColeta<>-1 then
                                 begin
                                    //------------------------------------------
                                    //   Enviar a coleta do item do menu para a DLL
                                    //------------------------------------------
                                    SA_SalvarLog('ENVIAR OPCAO MENU ContinuaFuncaoMCInterativo',pergunta.Titulo+' = '+opcaoColeta.ToString);  // Salvar LOG - Se ativado
                                    CRetorno := ContinuaFuncaoMCInterativo(PAnsiChar(AnsiString(opcaoColeta.ToString)));
                                    if CRetorno<>0 then // Houve um erro ao enviar o dado
                                       begin
                                          //------------------------------------
                                          frmwebtef.mensagem := SA_RetornoErro(CRetorno);
                                          SA_SalvarLog('ERRO ENVIAR OPCAO MENU ContinuaFuncaoMCInterativo',CRetorno.ToString+' '+frmwebtef.mensagem);  // Salvar LOG - Se ativado
                                          TThread.Synchronize(TThread.CurrentThread,
                                             procedure
                                                begin
                                                   SA_Mostrar_Mensagem(true);
                                                end);
                                          //------------------------------------
                                          SA_AtivarBTCancelar;   // Ativar o botão cancelar na tela de TEF
                                          while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                             begin
                                                sleep(50);
                                             end;
                                          sair := true;   // Ativar a saída do LOOP
                                          //------------------------------------
                                       end;
                                    //------------------------------------------
                                 end
                              else
                                 sair := true;   // Ativar a saída do LOOP, o operador desistiu de responder e cancelou a operação
                              //------------------------------------------------
                           end
                        else if acao=TPMultiPlusPERGUNTA then  // Deverá ser perguntado algo
                           begin
                              //------------------------------------------------
                              //  Fazer uma pergunta ao operador
                              //------------------------------------------------
                              Pergunta := SA_SA_MultiPlusPerguntaRetorno(SRetorno);
                              //---------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,
                               procedure
                                  begin
                                     if pergunta.Tipo=TtpDATE then  // Se o tipo é data, o valor inicial é adata atual
                                        ConteudoInicial := FormatDateTime('dd/mm/yyyy',date);
                                     SA_ColetarValor(pergunta.Titulo,pergunta.mascara,false,ConteudoInicial);
                                  end);
                              //------------------------------------------------
                              SA_AtivarBTCancelar;
                              frmwebtef.dado_digitado := '';
                              frmwebtef.Cancelar      := false;
                              Resposta_pergunta       := '';
                              Leitura_pergunta        := true;
                              //------------------------------------------------
                              while Leitura_pergunta do
                                 begin
                                    //------------------------------------------
                                    sleep(10);
                                    //------------------------------------------
                                    if (frmwebtef.dado_digitado<>'') and (not frmwebtef.Cancelar) then
                                       begin
                                          Resposta_pergunta := frmwebtef.dado_digitado;
                                          Leitura_pergunta  := not SA_ValidarRespostaPergunta(pergunta,Resposta_pergunta);
                                       end;


                                    if (frmwebtef.dado_digitado<>'') and (not SA_ValidarRespostaPergunta(pergunta,frmwebtef.dado_digitado)) then
                                       begin
                                          frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                                          frmwebtef.pnalerta.Color        := clRed;
                                          frmwebtef.pnalerta.Font.Color   := clYellow;
                                          frmwebtef.dado_digitado         := '';
                                       end;
                                    //------------------------------------------
                                 end;
                              //------------------------------------------------
                              frmwebtef.pncaptura.Visible := false;
                              frmwebtef.edtdado.Enabled   := false;
                              frmwebtef.btcancelar.free;
                              //------------------------------------------------
                              if not frmwebtef.Cancelar then
                                 begin
                                    pergunta.ValorColetado := SA_FormatarRespostaPergunta(pergunta,frmwebtef.dado_digitado);  // Formatar o dado coletado para enviar para a DLL
                                    SA_SalvarLog('ENVIAR DADO DA PERGUNTA ContinuaFuncaoMCInterativo',pergunta.Titulo+' = '+frmwebtef.dado_digitado);  // Salvar LOG - Se ativado
                                    CRetorno := ContinuaFuncaoMCInterativo(PAnsiChar(AnsiString(pergunta.ValorColetado))); // Enviar o dado coletado
                                    if CRetorno<>0 then // Houve um erro ao enviar o dado
                                       begin
                                          //------------------------------------
                                          frmwebtef.mensagem := SA_RetornoErro(CRetorno);
                                          SA_SalvarLog('ERRO ENVIAR DADO DA PERGUNTA ContinuaFuncaoMCInterativo',pergunta.Titulo+' = '+frmwebtef.dado_digitado + ' ' + frmwebtef.mensagem);  // Salvar LOG - Se ativado
                                          TThread.Synchronize(TThread.CurrentThread,
                                             procedure
                                                begin
                                                   SA_Mostrar_Mensagem(true);
                                                end);
                                          //------------------------------------
                                          SA_AtivarBTCancelar;   // Ativar o botão cancelar na tela de TEF
                                          while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                             begin
                                                sleep(50);
                                             end;
                                          sair := true;   // Ativar a saída do LOOP
                                          //------------------------------------
                                       end;
                                    //------------------------------------------
                                 end
                               else
                                 sair := true;  // Coleta foi cancelado pelo operador, cancelar o TEF
                              //------------------------------------------------
                           end
                        else if acao=TPMultiPlusRETORNO then
                           begin
                              //------------------------------------------------
                              //   Confirmar a transação
                              //------------------------------------------------
                              RetornoTransacao := SA_SA_MultiPlusRetornoTransacao(SRetorno);
                              //------------------------------------------------
                              //   Fazer 3 tentativas de confirmação
                              //------------------------------------------------
                              finalizado              := false;
                              qtdetentativasfinalizar := 0;
                              while not finalizado do
                                 begin
                                    //------------------------------------------
                                    inc(qtdetentativasfinalizar);
                                    //------------------------------------------
                                    SA_SalvarLog('ENVIAR CONFIRMACAO CANCELAMENTO FinalizaFuncaoMCInterativo','NSU:'+RetornoTransacao.NSU+
                                                                                                 ' R$:'+vlTransformado+
                                                                                                 ' Parcela:'+LParcela.ToString+
                                                                                                 ' Cupom:'+LCupom.ToString+
                                                                                                 ' Data:'+formatdatetime('yyyyMMdd',date)+
                                                                                                 ' PDV:'+LPdv+
                                                                                                 ' Cod.Loja:'+LCodigoLoja+
                                                                                                 ' CNPJ:'+LCNPJ+' Tentativa Nr. '+qtdetentativasfinalizar.tostring);  // Salvar LOG - Se ativado
                                    try
                                        //--------------------------------------------
                                        // Enviando a confirmação da transação
                                        //--------------------------------------------
                                        CRetorno := FinalizaFuncaoMCInterativo(98,
                                                                               PAnsiChar(AnsiString(LCNPJ)),
                                                                               LParcela,
                                                                               PAnsiChar(AnsiString(LCupom.ToString)),
                                                                               PAnsiChar(AnsiString(vlTransformado)),
                                                                               PAnsiChar(AnsiString(RetornoTransacao.NSU)),
                                                                               PAnsiChar(AnsiString(formatdatetime('yyyyMMdd',LData))),
                                                                               PAnsiChar(AnsiString(LPdv)),
                                                                               PAnsiChar(AnsiString(LCodigoLoja)),
                                                                               0,
                                                                               '');
                                        //--------------------------------------------
                                        SA_SalvarLog('RETORNO ENVIAR CONFIRMACAO CANCELAMENTO FinalizaFuncaoMCInterativo',cretorno.ToString+' Retorno OK (função foi executada sem erros)');
                                        //--------------------------------------------
                                    except on e:exception do
                                       begin
                                          SA_SalvarLog('ERRO ENVIAR CONFIRMACAO FinalizaFuncaoMCInterativo',e.Message);
                                       end;
                                    end;
                                    //------------------------------------------
                                    if (qtdetentativasfinalizar=3) or (CRetorno<>33) then
                                       finalizado := true;
                                    //------------------------------------------
                                 end;
                              //                              CRetorno := 0;
                              //------------------------------------------------
                              if CRetorno=0 then   // A confirmação da transação foi realizada com sucesso
                                 begin
                                    //------------------------------------------
                                    sair := true;
                                    //------------------------------------------
                                    //   Imprimir comprovante, processar a finalização do processo
                                    //------------------------------------------
                                    if RetornoTransacao.COMPROVANTE.Count>0 then // Existe comprovante a ser impresso
                                       begin
                                          //------------------------------------
                                          //******************************************
                                          //   Impressão do comprovante do cliente
                                          //******************************************
                                          //------------------------------------
                                          if LIComprovanteCliente=tpiMPlImprimir then  // Imprimir o comprovante automaticamente
                                             ImprimirComprovante := true
                                          else if LIComprovanteCliente=tpiMPlPerguntar then  // Perguntar se quer imprimir o comprovante
                                             begin
                                                //------------------------------
                                                //   Perguntar se quer imprimir
                                                //------------------------------
                                                frmwebtef.mensagem := 'Imprimir o comprovante do CLIENTE ?';
                                                frmwebtef.opcoes   := TStringList.Create;
                                                frmwebtef.opcoes.Clear;
                                                frmwebtef.opcoes.Add('Imprimir');
                                                frmwebtef.opcoes.Add('Não Imprimir');
                                                frmwebtef.opcao    := -1;
                                                frmwebtef.tecla    := '';
                                                frmwebtef.Cancelar := false;
                                                //------------------------------
                                                TThread.Synchronize(TThread.CurrentThread,
                                                procedure
                                                   begin
                                                      SA_Criar_Menu(true);
                                                   end);
                                                //------------------------------
                                                ImprimirComprovante := false;
                                                SairLoopImpressao   := false;
                                                while (not SairLoopImpressao) do  // Aguardando o operador confirmar ou cancelar a impressão
                                                   begin
                                                     if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                                        begin
                                                           ImprimirComprovante := true;
                                                           SairLoopImpressao   := true;
                                                        end
                                                     else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) or (frmwebtef.Cancelar) then
                                                        begin
                                                           ImprimirComprovante := false;
                                                           SairLoopImpressao   := true;
                                                        end;
                                                      //------------------------
                                                      sleep(50);
                                                   end;
                                                //------------------------------
                                                frmwebtef.Cancelar := false;
                                                //------------------------------
                                             end;
                                          //------------------------------------
                                          if ImprimirComprovante then
                                             begin
                                                GerenciadorImpressao.Corpo.Text  := RetornoTransacao.COMPROVANTE.Text;
                                                GerenciadorImpressao.SA_Imprimir(1);
                                             end;
                                          //------------------------------------
                                          //******************************************
                                          //   Impressão do comprovante da loja
                                          //******************************************
                                          //------------------------------------
                                          if LComprovanteLojaSimplificado then   // Criar um comprovante simplificado para imprimir no lugar daquele recebido da DLL
                                             RetornoTransacao.ComprovanteLoja.Text := SA_GerarComprovanteSimplificado(tpOpCancelamentoVenda).Text;  // Gerando o comprovante simplificado
                                          if LIComprovanteCliente=tpiMPlImprimir then  // Imprimir o comprovante automaticamente
                                             ImprimirComprovante := true
                                          else if LIComprovanteCliente=tpiMPlPerguntar then  // Perguntar se quer imprimir o comprovante
                                             begin
                                                //------------------------------
                                                //   Perguntar se quer imprimir
                                                //------------------------------
                                                frmwebtef.mensagem := 'Imprimir o comprovante da LOJA ?';
                                                frmwebtef.opcoes   := TStringList.Create;
                                                frmwebtef.opcoes.Clear;
                                                frmwebtef.opcoes.Add('Imprimir');
                                                frmwebtef.opcoes.Add('Não Imprimir');
                                                frmwebtef.opcao    := -1;
                                                frmwebtef.tecla    := '';
                                                frmwebtef.Cancelar := false;
                                                //------------------------------
                                                TThread.Synchronize(TThread.CurrentThread,
                                                procedure
                                                   begin
                                                      SA_Criar_Menu(true);
                                                   end);
                                                //------------------------------
                                                ImprimirComprovante := false;
                                                SairLoopImpressao   := false;
                                                while (not SairLoopImpressao) do  // Esperando o operador confirmar ou cancelar a impressão
                                                   begin
                                                     if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                                        begin
                                                           ImprimirComprovante := true;
                                                           SairLoopImpressao   := true;
                                                        end
                                                     else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) or (frmwebtef.Cancelar) then
                                                        begin
                                                           ImprimirComprovante := false;
                                                           SairLoopImpressao   := true;
                                                        end;
                                                      //------------------------
                                                      sleep(50);
                                                   end;
                                                //------------------------------
                                                frmwebtef.Cancelar := false;
                                                //------------------------------
                                             end;
                                          //------------------------------------
                                          if ImprimirComprovante then
                                             begin
                                                GerenciadorImpressao.Corpo.Text  := RetornoTransacao.ComprovanteLoja.Text;
                                                GerenciadorImpressao.SA_Imprimir(1);
                                             end
                                          //------------------------------------

                                       end;
                                 end
                              else   // Ocorreu um erro ao confirmar a transação
                                 begin
                                    //------------------------------------------
                                    //   Tratar a falha da confirmação
                                    //------------------------------------------
                                    frmwebtef.mensagem := SA_RetornoErro(CRetorno);
                                    SA_SalvarLog('ERRO ENVIAR CONFIRMACAO FinalizaFuncaoMCInterativo',CRetorno.ToString+' '+SA_RetornoErro(CRetorno));  // Salvar LOG - Se ativado
                                    TThread.Synchronize(TThread.CurrentThread,
                                       procedure
                                          begin
                                             SA_Mostrar_Mensagem(true);
                                          end);
                                    //------------------------------------
                                    SA_AtivarBTCancelar;   // Ativar o botão cancelar na tela de TEF
                                    while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                       begin
                                          sleep(50);
                                       end;
                                    sair := true;   // Ativar a saída do LOOP
                                    //------------------------------------------
                                 end;
                              //------------------------------------------------
                           end;
                        //------------------------------------------------------
                     end;
                  //------------------------------------------------------------
               end;
            //------------------------------------------------------------------
         end
      else
         begin
            //------------------------------------------------------------------
            //  Ocorreu um erro
            //------------------------------------------------------------------
            CancelarFluxoMCInterativo;
            SA_SalvarLog('RESPOSTA REALIZAR CANCELAMENTO',SA_RetornoErro(IRetorno));
            frmwebtef.mensagem := SA_RetornoErro(IRetorno);
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
               SA_Mostrar_Mensagem(true);
            end);
            //------------------------------------------------------------------
            SA_AtivarBTCancelar;
            while not frmwebtef.Cancelar do
               begin
                  sleep(50);
               end;
            //------------------------------------------------------------------
         end;
      //------------------------------------------------------------------------
      //   Fechando a janela do TEF
      //------------------------------------------------------------------------
      SA_MostrarLogoPINPAD;   // Mostrando a imagem de LOGO na tela do PINPAD
      frmwebtef.Close;
      frmwebtef.Release;
      lExecutando := false;
      //------------------------------------------------------------------------


      //------------------------------------------------------------------------
   end).Start;
   //---------------------------------------------------------------------------
end;

procedure TMultiPlusTEF.SA_ConfigurarPinPad;
begin
   //---------------------------------------------------------------------------
   PinPad.IsEnabled   := false;
   //---------------------------------------------------------------------------
   PinPad.LogFile     := getcurrentdir+'\TEFMPL_log\pinpadlog.txt';
   PinPad.LogLevel    := 0;
   PinPad.Port        := LConfigPINPAD.PINPAD_Porta;
   PinPad.MsgAlign    := alCenter;
   PinPad.MsgWordWrap := true;
   //---------------------------------------------------------------------------
   case LConfigPINPAD.PINPAD_Baud of
     b300    :PinPad.Device.Baud := 300;
     b600    :PinPad.Device.Baud := 600;
     b1200   :PinPad.Device.Baud := 1200;
     b2400   :PinPad.Device.Baud := 2400;
     b4800   :PinPad.Device.Baud := 4800;
     b9600   :PinPad.Device.Baud := 9600;
     b14400  :PinPad.Device.Baud := 14400;
     b19200  :PinPad.Device.Baud := 19200;
     b38400  :PinPad.Device.Baud := 38400;
     b56000  :PinPad.Device.Baud := 56000;
     b57600  :PinPad.Device.Baud := 57600;
     b115200 :PinPad.Device.Baud := 115200;
   end;
   //---------------------------------------------------------------------------
   case LConfigPINPAD.PINPAD_DataBits of
      0:PinPad.Device.Data := 5;
      1:PinPad.Device.Data := 6;
      2:PinPad.Device.Data := 7;
      3:PinPad.Device.Data := 8;
   end;
   //---------------------------------------------------------------------------
   case LConfigPINPAD.PINPAD_StopBit of
     ts1      : PinPad.Device.Stop := s1;
     ts1emeio : PinPad.Device.Stop := s1eMeio;
     ts2      : PinPad.Device.Stop := s2;
   end;
   //---------------------------------------------------------------------------
   case LConfigPINPAD.PINPAD_Parity of
     tpNone  : PinPad.Device.Parity := pNone;
     tpOdd   : PinPad.Device.Parity := pOdd;
     tpEven  : PinPad.Device.Parity := pEven;
     tpMark  : PinPad.Device.Parity := pMark;
     tpSpace : PinPad.Device.Parity := pSpace;
   end;
   //---------------------------------------------------------------------------
   case LConfigPINPAD.PINPAD_HandShaking of
     thsNenhum   : PinPad.Device.HandShake := hsNenhum;
     thsXON_XOFF : PinPad.Device.HandShake := hsXON_XOFF;
     thsRTS_CTS  : PinPad.Device.HandShake := hsRTS_CTS;
     thsDTR_DSR  : PinPad.Device.HandShake := hsDTR_DSR;
   end;
   //---------------------------------------------------------------------------
   PinPad.Device.SoftFlow := LConfigPINPAD.PINPAD_SoftFlow;
   PinPad.Device.HardFlow := LConfigPINPAD.PINPAD_HardFlow;
   //---------------------------------------------------------------------------
end;

//------------------------------------------------------------------------------
//   Extrair um campo de dentro da string do PIX com delimitador "|"
//------------------------------------------------------------------------------
function TMultiPlusTEF.SA_ExtraiCamporDadosPIX(Campo,  DadosPIX: string): string;
var
   posicao : integer;
begin
   //---------------------------------------------------------------------------
   // #NSU=000000000|ORIGEM=GERENCIANET|VALOR=1,25|QRCODE=00020101021226830014BR.GOV.BCB.PIX2561qrcodespix.sejaefi.com.br/v2/644a50911e914d8db93eec75d9bffdd75204000053039865802BR5905EFISA6008SAOPAULO62070503***63046283
   //   inicio=6 / fim = 15 => fim-inicio = 9
   //---------------------------------------------------------------------------
   DadosPIX := DadosPIX +'|';  // Incluindo um delimitador no final da string;
   //---------------------------------------------------------------------------
   Result := '';
   posicao := pos(campo+'=',DadosPIX)+length(campo);
   if posicao>0 then
      delete(DadosPIX,1,posicao);
   //---------------------------------------------------------------------------
   posicao := pos('|',DadosPIX)-1;
   if posicao>0 then
      Result := copy(DadosPIX,1,posicao);
   //---------------------------------------------------------------------------
end;

function TMultiPlusTEF.SA_ExtrairDadosPIX(DadosPIX: string): TMultiPlusDadosPix;
begin
   Result.NSU    := SA_ExtraiCamporDadosPIX('NSU',DadosPIX);
   Result.ORIGEM := SA_ExtraiCamporDadosPIX('ORIGEM',DadosPIX);
   Result.VALOR  := untransform(SA_ExtraiCamporDadosPIX('VALOR',DadosPIX));
   Result.QRCODE := SA_ExtraiCamporDadosPIX('QRCODE',DadosPIX);
end;

function TMultiPlusTEF.SA_FormatarRespostaPergunta(pergunta: TMultiPlusPergunta;  ValorColetado: string): string;
var
   VlInt     : integer;
   VlString  : string;
   VlDecimal : real;
   VlData    : TDate;
begin
   //---------------------------------------------------------------------------
   VlInt     := 0;
   VlString  := '';
   VlDecimal := 0;
   VlData    := strtodate('01/01/1800');
   //---------------------------------------------------------------------------
   // TMultiPlusTTipoDado = (TtpINT, TtpSTRING, TtpDECIMAL, TtpDATE , TtpINDEFINIDO);
   //---------------------------------------------------------------------------
   try
      case pergunta.Tipo of
        TtpINT        : VlInt     := strtoint(trim(ValorColetado));
        TtpSTRING     : VlString  := trim(ValorColetado);
        TtpDECIMAL    : VlDecimal := untransform(trim(ValorColetado));
        TtpDATE       : VlData    := StrToDate(trim(ValorColetado));
      end;
   except
      Result := '';
      exit;
   end;
   //---------------------------------------------------------------------------
   if pergunta.Tipo=TtpINT then
      Result := VlInt.ToString
   else if pergunta.Tipo=TtpSTRING then
      Result := VlString
   else if pergunta.Tipo=TtpDECIMAL then
      Result := FormatFloat('#####0,00',VlDecimal)
   else if pergunta.Tipo=TtpDATE then
      Result := formatdatetime('DD/MM/YY',VlData)
   else
      Result := ValorColetado;
   //---------------------------------------------------------------------------
end;

function TMultiPlusTEF.SA_GerarComprovanteSimplificado(Operacao : TpOperacaoMPL = tpOpVenda): TStringList;
begin
   Result := TStringList.Create;
   Result.Add('</ce>COMPROVANTE TEF - Via Lojista');
   Result.Add('</ae>');
   if Operacao=tpOpCancelamentoVenda then
      begin
         Result.Add('   CANCELAMENTO DE PAGAMENTO');
         Result.Add('   ');
      end;
   Result.Add('   Realizada em   '+formatdatetime('dd/mm/yyyy hh:mm:ss',now));
   Result.Add('       Valor R$   '+transform(LRetornoTransacao.VALOR));
   Result.Add('     Forma Pgto   '+LForma);
   Result.Add('            NSU   '+LRetornoTransacao.NSU);
   Result.Add('        Cod.Aut.  '+LRetornoTransacao.COD_AUTORIZACAO);
   Result.Add('       Bandeira   '+LRetornoTransacao.NOME_BANDEIRA);
end;

procedure TMultiPlusTEF.SA_Inicializar_ESCPOS;
var
   linhas_escpos : TStringList;
   d             : integer;
begin
   //---------------------------------------------------------------------------
   GerenciadorImpressao                      := TESCPos.Create;
   GerenciadorImpressao.PortaImpressora      := LImpressoraPorta;
   GerenciadorImpressao.ImprimirCabecalho    := true;
   GerenciadorImpressao.Avanco               := LImpressoraAvanco;
   GerenciadorImpressao.ModeloImpressoraACBR := LImpressoraModelo;
   GerenciadorImpressao.Cabecalho.Text       := '';
   //---------------------------------------------------------------------------
   linhas_escpos := TStringList.Create;
   linhas_escpos.Add(StringOfChar('=',GerenciadorImpressao.MLNormal));
   linhas_escpos.Add('');
   for d := 1 to GerenciadorImpressao.Avanco do
      linhas_escpos.Add('');
   linhas_escpos.Add(GerenciadorImpressao.MGuilhotina);
   GerenciadorImpressao.Rodape.Text := linhas_escpos.Text;
   linhas_escpos.Free;
   //---------------------------------------------------------------------------
end;

procedure TMultiplusTEF.SA_LimparTabelas;
var
   IRetorno   : integer;
   sair       : boolean;
   SRetorno   : widestring;
   acao       : TPRetornoMultiPlus;
   RetornoMsg : string;   // Para processar a mensagem em caso de ser PIX
begin
   //---------------------------------------------------------------------------
   //   Iniciando a tela de TEF
   //---------------------------------------------------------------------------
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LForma;
   frmwebtef.lbvalor.Caption  := transform(LValor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.TituloJanela     := LTituloJanela;
   frmwebtef.Show;
   //---------------------------------------------------------------------------
   TThread.CreateAnonymousThread(procedure
   begin
      //------------------------------------------------------------------------
      //   Inicializar TEF
      //------------------------------------------------------------------------
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
         frmwebtef.mensagem := 'Limpando tabelas...';
         SA_Mostrar_Mensagem(true);
      end);
      //------------------------------------------------------------------------
      SA_SalvarLog('CHAMADA LIMPAR TABELAS','Limpar tabelas');
      IRetorno := IniciaFuncaoMCInterativo(110,
                                           PAnsiChar(AnsiString(LCNPJ)),
                                           1,
                                           PAnsiChar(AnsiString(LCupom.ToString)),
                                           PAnsiChar(AnsiString(trim(FormatFloat('#####0.00',1)))),
                                           PAnsiChar(AnsiString(LNSU)),
                                           PAnsiChar(AnsiString(formatdatetime('yyyyMMdd',LData))),
                                           PAnsiChar(AnsiString(LPdv)),
                                           PAnsiChar(AnsiString(LCodigoLoja)),
                                           0,
                                           '');
      //------------------------------------------------------------------------
      if IRetorno=0 then
         begin
            //------------------------------------------------------------------
            //  Sem ocorrência de erros, continuar o processo
            //------------------------------------------------------------------
            sair    := false;
            while not sair do
               begin
                  //------------------------------------------------------------
                  //   Fazer fluxo de consulta do TEF
                  //------------------------------------------------------------
                  try
                     SRetorno := widestring(AguardaFuncaoMCInterativo());
                  except on e:exception do
                     begin
                        LLimpouTabelas := false;
                        SA_SalvarLog('ERRO AguardaFuncaoMCInterativo',e.Message);  // Salvar LOG - Se ativado
                     end;
                  end;
                  if SRetorno<>'' then   // Se o retorno não é vazio, verificar que tipo de retorno
                     begin
                        //------------------------------------------------------
                        //  acao = TPRetornoMultiPlus e de acordo com o retorno deverá ser executado um processo
                        // TPRetornoMultiPlus = (TPMultiPlusMENU , TPMultiPlusMSG , TPMultiPlusPERGUNTA , TPMultiPlusRETORNO , TPMultiPlusERROABORTAR , TPMultiPlusERRODISPLAY,TPMultiPlusINDEFINIDO);
                        //------------------------------------------------------
                        SA_SalvarLog('RESPOSTA AguardaFuncaoMCInterativo',SRetorno);  // Salvar LOG - Se ativado
                        //------------------------------------------------------
                        acao     := SA_MultiPlusTPRetorno(SRetorno);
                        //------------------------------------------------------
                        if acao=TPMultiPlusMSG then // Somente mostrar uma mensagem na tela
                           begin
                              //------------------------------------------------
                              //  Mostrar a mensagem na tela
                              //------------------------------------------------
                              RetornoMsg := SA_SA_MultiPlusMensagemRetorno(SRetorno);
                              frmwebtef.mensagem := RetornoMsg;
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,
                                 procedure
                                    begin
                                       SA_Mostrar_Mensagem(true);
                                    end);
                              //------------------------------------------------
                           end
                        else if (acao=TPMultiPlusERROABORTAR) or (acao=TPMultiPlusERRODISPLAY) then // Somente mostrar uma mensagem na tela e encerrar o processo
                           begin
                              //------------------------------------------------
                              //   Ocorreu um evento que provocou o encerramento do processo
                              //------------------------------------------------
                              frmwebtef.mensagem := SA_SA_MultiPlusMensagemRetorno(SRetorno);
                              TThread.Synchronize(TThread.CurrentThread,
                                 procedure
                                    begin
                                       SA_Mostrar_Mensagem(true);
                                    end);
                              //------------------------------------------------
                              SA_AtivarBTCancelar;   // Ativar o botão cancelar na tela de TEF
                              while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                 begin
                                    sleep(50);
                                 end;
                              LLimpouTabelas := false;
                              sair           := true;   // Ativar a saída do LOOP
                              //------------------------------------------------
                           end
                        else if acao=TPMultiPlusRETORNO then
                           begin
                              LLimpouTabelas := true;
                              sair           := true;   // Ativar a saída do LOOP
                           end;


                     end;



               end;
            //------------------------------------------------------------------
         end
      else
         begin
            //------------------------------------------------------------------
            //  Ocorreu um erro
            //------------------------------------------------------------------
            CancelarFluxoMCInterativo;
            SA_SalvarLog('RESPOSTA ATUALIZAR TABELAS',SA_RetornoErro(IRetorno));
            frmwebtef.mensagem := SA_RetornoErro(IRetorno);
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
               SA_Mostrar_Mensagem(true);
            end);
            //------------------------------------------------------------------
            SA_AtivarBTCancelar;
            while not frmwebtef.Cancelar do
               begin
                  sleep(50);
               end;
            //------------------------------------------------------------------
         end;


      //------------------------------------------------------------------------
      //   Fechando a janela do TEF
      //------------------------------------------------------------------------
      SA_MostrarLogoPINPAD;   // Mostrando a imagem de LOGO na tela do PINPAD
      frmwebtef.Close;
      frmwebtef.Release;
      lExecutando := false;
      //------------------------------------------------------------------------
   end).Start;
end;

//------------------------------------------------------------------------------
//  Desmontar o retorno do MULTIPLUS
//------------------------------------------------------------------------------
procedure TMultiPlusTEF.SA_MostrarLogoPINPAD;
var
    png : TPngImage;
begin
   if FileExists(ConfigPINPAD.PINPAD_Imagem) then
      begin
         SA_ConfigurarPinPad;
         png := TPngImage.Create;
         png.LoadFromFile(ConfigPINPAD.PINPAD_Imagem);
         SA_PINPAD_MostrarImagem(png);
         png.Free;
     end;
end;

function TMultiPlusTEF.SA_MultiPlusTPRetorno( retorno: string): TPRetornoMultiPlus;
var
   fim     : integer;
   comando : string;
begin
   Result := TPMultiPlusINDEFINIDO;
   //---------------------------------------------------------------------------
   // [MENU]#MODO#1-MAGNETICO|2-DIGITADO
   // [MSG]#AGUARDE A SENHA
   // [PERGUNTA]#INFORME O NSU#INT#0#0#0,00#0,00#0
   // [RETORNO]#CAMPO0160=CUPOM#CAMPO0002=VALOR#CAMPO0132=COD BANDEIRA...
   // [ERROABORTAR]#CANCELADO PELO OPERADOR
   // [ERRODISPLAY]#T14-CARTAO INVALIDO
   //
   //  TPRetornoMultiPlus = (TPMultiPlusMENU , TPMultiPlusMSG , TPMultiPlusPERGUNTA , TPMultiPlusRETORNO , TPMultiPlusERROABORTAR , TPMultiPlusERRODISPLAY,TPMultiPlusINDEFINIDO);
   //---------------------------------------------------------------------------
   fim     := pos(']',retorno);
   comando := copy(retorno,1,fim);
   if comando='[MENU]' then
      Result := TPMultiPlusMENU
   else if comando='[MSG]' then
      Result := TPMultiPlusMSG
   else if comando='[PERGUNTA]' then
      Result := TPMultiPlusPERGUNTA
   else if comando='[RETORNO]' then
      Result := TPMultiPlusRETORNO
   else if comando='[ERROABORTAR]' then
      Result := TPMultiPlusERROABORTAR
   else if comando='[ERRODISPLAY]' then
      Result := TPMultiPlusERRODISPLAY;
   //---------------------------------------------------------------------------
end;

function TMultiPlusTEF.SA_PerguntarOpcoes(opcoes: TStringList;  mensagem: string): integer;
var
   sair : boolean;
begin
   Result             := -1;
   frmwebtef.opcao    := 0;
   frmwebtef.tecla    := '';
   frmwebtef.Cancelar := false;
   sair               := false;
   while not sair do
      begin
         //---------------------------------------------------------------------
         if frmwebtef.Cancelar then
            begin
               Result := -1;
               sair := true;
            end;

         if (frmwebtef.opcao<>0) then
            begin
               Result := frmwebtef.opcao;
               sair   := true;
            end;

         if (strtointdef(frmwebtef.tecla,256)<=opcoes.Count) and (strtointdef(frmwebtef.tecla,256)<>0) then
           begin
              Result := strtointdef(frmwebtef.tecla,-1);
              sair   := true;
           end;

         //---------------------------------------------------------------------
         if not sair then
            sleep(50);
         //---------------------------------------------------------------------
      end;
   //---------------------------------------------------------------------------
end;

function TMultiPlusTEF.SA_PINPAD_MostrarImagem(imagem: TPngImage): boolean;
var
   ms : TMemoryStream;
begin
   ms := TMemoryStream.Create;
   //---------------------------------------------------------------------------
   try
      //------------------------------------------------------------------------
      PinPad.IsEnabled   := true;
      imagem.SaveToStream(ms);
      //------------------------------------------------------------------------
      PinPad.OPN;
      PinPad.LoadMedia( 'LOGO', ms, mtPNG);
      PinPad.DSI('LOGO');
      PinPad.CLO;
      //------------------------------------------------------------------------
      PinPad.IsEnabled   := false;
      Result := true;
   except
      Result := false;
   end;
   //---------------------------------------------------------------------------
   ms.Free;
   //---------------------------------------------------------------------------
end;

procedure TMultiPlusTEF.SA_PintarPix(QRCode: string);
var
   png    : TPngImage;
   qrsize : Integer;
begin
   //---------------------------------------------------------------------------
   try
      PintarQRCode(QRCode, frmwebtef.logomp.Picture.Bitmap, qrUTF8BOM);
   except on e:exception do
      begin
         SA_SalvarLog('ERRO PINTAR PIX NA TELA',e.Message);
      end
   end;
   //---------------------------------------------------------------------------
   if LConfigPINPAD.PINPAD_usar then
      begin
         try
            SA_ConfigurarPinPad;
            PinPad.IsEnabled   := true;
            qrsize := min( PinPad.PinPadCapabilities.DisplayGraphicPixels.Cols,
                           PinPad.PinPadCapabilities.DisplayGraphicPixels.Rows) - 20;
            pinpad.IsEnabled   := false;
            png := TPngImage.Create;
            png.Assign(frmwebtef.logomp.Picture.Bitmap);
            png.Resize(qrsize, qrsize);
            png.Canvas.StretchDraw(png.Canvas.ClipRect, frmwebtef.logomp.Picture.Bitmap);
            SA_PINPAD_MostrarImagem(png);
            PinPad.IsEnabled   := false;
         except on e:exception do
            begin
               SA_SalvarLog('ERRO PINTAR PIX NA NO PINPAD',e.Message);
            end

         end;
      end;
   //---------------------------------------------------------------------------
end;

procedure TMultiPlusTEF.SA_ProcessarPagamento;
var
   //---------------------------------------------------------------------------
   IRetorno            : integer;    // Retorno da função que inicializa o TEF
   SRetorno            : widestring; // Retorno da função que faz a transação com o TEF
   FRetorno            : integer;    // Retorno para monitorar o encerramento do modo interativo
   CRetorno            : integer;    // Retorno da função que envia um dado para a DLL durante o processo de coleta
   opcaoColeta         : integer;    //  Quando selecionar uma opção do menu
   ImprimirComprovante : boolean;    // Para sinalizar se o comprovante será impresso ou não
   //---------------------------------------------------------------------------
   acao     : TPRetornoMultiPlus;
   Menu     : TMultiPlusMenu;
   Pergunta : TMultiPlusPergunta;
   //---------------------------------------------------------------------------
   sair                    : boolean;
   ConteudoInicial         : string;
   //---------------------------------------------------------------------------
   vlTransformado          : string;
   finalizado              : boolean;
   qtdetentativasfinalizar : integer;
   Resposta_pergunta       : string;
   Leitura_pergunta        : boolean;
   SairLoopImpressao       : boolean;
   //---------------------------------------------------------------------------
   RetornoMsg : string;   // Para processar a mensagem em caso de ser PIX
   DadosPix   : TMultiPlusDadosPix;
   //---------------------------------------------------------------------------
begin
   //---------------------------------------------------------------------------
   //   Iniciando a tela de TEF
   //---------------------------------------------------------------------------
   Application.CreateForm(Tfrmwebtef, frmwebtef);
   frmwebtef.DoubleBuffered   := true;
   frmwebtef.Cancelar         := false;
   frmwebtef.lbforma.Caption  := LForma;
   frmwebtef.lbvalor.Caption  := transform(LValor);
   frmwebtef.lb_tempo.Caption := '';
   frmwebtef.TituloJanela     := LTituloJanela;
   frmwebtef.Show;
   //---------------------------------------------------------------------------
   TThread.CreateAnonymousThread(procedure
   begin
      //------------------------------------------------------------------------
      //   Inicializar TEF
      //------------------------------------------------------------------------
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
         frmwebtef.mensagem := 'Inicializando TEF...';
         SA_Mostrar_Mensagem(true);
      end);
      //------------------------------------------------------------------------
      vlTransformado := trim(FormatFloat('#####0.00',LValor));   // Formatando o valor para TEF
      vlTransformado := StringReplace(vlTransformado,'.',',',[]); // Substituindo o ponto decimal por vírgula
      if LParcela=0 then // Se a qtde parcelas for zero, transfromar para 1
         LParcela := 1;
      //------------------------------------------------------------------------
      SA_SalvarLog('REALIZAR PAGAMENTO',
                                        'R$:'+vlTransformado+
                                        ' FORMA Pgto.:'+LForma+
                                        ' NSU:'+LNSU+
                                        ' Cupom Nr.:'+LCupom.ToString+
                                        ' Tipo Cartao:'+SA_TpCartaoOperacaoTEFtoSTR(LTpOperacaoTEF)+
                                        ' Parcelas:'+LParcela.ToString);

      IRetorno := IniciaFuncaoMCInterativo(SA_TpCartaoOperacaoTEFtoINT(LTpOperacaoTEF),
                                           PAnsiChar(AnsiString(LCNPJ)),
                                           LParcela,
                                           PAnsiChar(AnsiString(LCupom.ToString)),
                                           PAnsiChar(AnsiString(vlTransformado)),
                                           PAnsiChar(AnsiString(LNSU)),
                                           PAnsiChar(AnsiString(formatdatetime('yyyyMMdd',LData))),
                                           PAnsiChar(AnsiString(LPdv)),
                                           PAnsiChar(AnsiString(LCodigoLoja)),
                                           0,
                                           '');
      //------------------------------------------------------------------------
      if IRetorno=0 then
         begin
            //------------------------------------------------------------------
            //  Sem ocorrência de erros, continuar o processo
            //------------------------------------------------------------------
            sair    := false;
            while not sair do
               begin
                  //------------------------------------------------------------
                  // Verificar se o operador cancelou a operação
                  //------------------------------------------------------------
                  if (frmwebtef.Cancelar) and (LTpOperacaoTEF in[tpMPlPIX, tpMPlPIXMercadoPago,tpMPlPIXPicPay]) then
                     begin
                        //------------------------------------------------------
                        TThread.Synchronize(TThread.CurrentThread,
                           procedure
                              begin
                                 frmwebtef.logomp.Picture.LoadFromFile(GetCurrentDir+'\icones\tef_mplpay.bmp');
                                 frmwebtef.logomp.Repaint;
                                 Application.ProcessMessages;
                                 SA_MostrarLogoPINPAD;   // Mostrando a imagem de LOGO na tela do PINPAD
                              end);

                        //------------------------------------------------------
                        SA_SalvarLog('REMOVER PAGAMENTO PIX',
                                                          'R$:'+vlTransformado+
                                                          ' FORMA Pgto.:'+LForma+
                                                          ' NSU:'+DadosPix.NSU+
                                                          ' Cupom Nr.:'+LCupom.ToString+
                                                          ' Tipo Cartao:'+SA_TpCartaoOperacaoTEFtoSTR(LTpOperacaoTEF)+
                                                          ' Parcelas:'+LParcela.ToString);
                        //------------------------------------------------------
                        FinalizaFuncaoMCInterativo(55,
                                                   PAnsiChar(AnsiString(LCNPJ)),
                                                   LParcela,
                                                   PAnsiChar(AnsiString(LCupom.ToString)),
                                                   PAnsiChar(AnsiString(vlTransformado)),
                                                   PAnsiChar(AnsiString(DadosPix.NSU)),
                                                   PAnsiChar(AnsiString(formatdatetime('yyyyMMdd',LData))),
                                                   PAnsiChar(AnsiString(LPdv)),
                                                   PAnsiChar(AnsiString(LCodigoLoja)),
                                                   0,
                                                   '');
                        //------------------------------------------------------
                     end;
                  //------------------------------------------------------------
                  //   Fazer fluxo de consulta do TEF
                  //------------------------------------------------------------
                  try
                     SRetorno := widestring(AguardaFuncaoMCInterativo());
                  except on e:exception do
                     begin
                        SA_SalvarLog('ERRO AguardaFuncaoMCInterativo',e.Message);  // Salvar LOG - Se ativado
                     end;
                  end;
                  if SRetorno<>'' then   // Se o retorno não é vazio, verificar que tipo de retorno
                     begin
                        //------------------------------------------------------
                        //  acao = TPRetornoMultiPlus e de acordo com o retorno deverá ser executado um processo
                        // TPRetornoMultiPlus = (TPMultiPlusMENU , TPMultiPlusMSG , TPMultiPlusPERGUNTA , TPMultiPlusRETORNO , TPMultiPlusERROABORTAR , TPMultiPlusERRODISPLAY,TPMultiPlusINDEFINIDO);
                        //------------------------------------------------------
                        SA_SalvarLog('RESPOSTA AguardaFuncaoMCInterativo',SRetorno);  // Salvar LOG - Se ativado
                        //------------------------------------------------------
                        acao     := SA_MultiPlusTPRetorno(SRetorno);
                        //------------------------------------------------------
                        if acao=TPMultiPlusMSG then // Somente mostrar uma mensagem na tela
                           begin
                              //------------------------------------------------
                              //  Mostrar a mensagem na tela
                              //------------------------------------------------
                              RetornoMsg := SA_SA_MultiPlusMensagemRetorno(SRetorno);
                              if (pos('NSU=',RetornoMsg)>0) and (pos('|ORIGEM=',RetornoMsg)>0) and (pos('|QRCODE=',RetornoMsg)>0) then
                                 begin
                                    DadosPix := SA_ExtrairDadosPIX(RetornoMsg);
                                    SA_SalvarLog('QRCODE OBTIDO',DadosPix.QRCODE);  // Salvar LOG - Se ativado
                                    SA_AtivarBTCancelar;   // Ativar o botão cancelar na tela de TEF
                                    TThread.Synchronize(TThread.CurrentThread,
                                       procedure
                                          begin
                                             frmwebtef.logomp.Stretch      := true;
                                             frmwebtef.logomp.Proportional := true;
                                             SA_PintarPix(DadosPix.QRCODE);
                                          end);
                                    frmwebtef.mensagem := 'PIX => NSU: '+DadosPix.NSU+' ORIGEM:'+DadosPix.ORIGEM+' Valor:'+trim(transform(DadosPix.VALOR));
                                 end
                              else
                                 frmwebtef.mensagem := RetornoMsg;
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,
                                 procedure
                                    begin
                                       SA_Mostrar_Mensagem(true);
                                    end);
                              //------------------------------------------------
                           end
                        else if (acao=TPMultiPlusERROABORTAR) or (acao=TPMultiPlusERRODISPLAY) then // Somente mostrar uma mensagem na tela e encerrar o processo
                           begin
                              //------------------------------------------------
                              //   Ocorreu um evento que provocou o encerramento do processo
                              //------------------------------------------------
                              frmwebtef.mensagem := SA_SA_MultiPlusMensagemRetorno(SRetorno);
                              TThread.Synchronize(TThread.CurrentThread,
                                 procedure
                                    begin
                                       SA_Mostrar_Mensagem(true);
                                    end);
                              //------------------------------------------------
                              SA_AtivarBTCancelar;   // Ativar o botão cancelar na tela de TEF
                              while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                 begin
                                    sleep(50);
                                 end;
                              sair := true;   // Ativar a saída do LOOP
                              //------------------------------------------------
                           end
                        else if acao=TPMultiPlusMENU then  // Deverá ser apresentado um menu de opções
                           begin
                              //------------------------------------------------
                              //  Criar um menu de opções para o operador escolher
                              //------------------------------------------------
                              Menu     := SA_SA_MultiPlusOpcoesMenuRetorno(SRetorno);
                              SRetorno := '';
                              acao     := TPMultiPlusINDEFINIDO;
                              //------------------------------------------------
                              frmwebtef.mensagem := menu.Titulo;
                              frmwebtef.opcoes   := menu.Opcoes;
                              frmwebtef.opcao    := -1;
                              frmwebtef.tecla    := '';
                              frmwebtef.Cancelar := false;
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,procedure
                                 begin
                                    SA_Criar_Menu(true);
                                    SA_AtivarBTCancelar;
                                 end);
                              //------------------------------------------------
                              application.ProcessMessages;
                              opcaoColeta  := SA_PerguntarOpcoes(menu.Opcoes,menu.Titulo);
                              //------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,procedure
                                 begin
                                    SA_Criar_Menu(false);
                                    frmwebtef.btcancelar.free;
                                 end);
                              //------------------------------------------------
                              if opcaoColeta<>-1 then
                                 begin
                                    //------------------------------------------
                                    //   Enviar a coleta do item do menu para a DLL
                                    //------------------------------------------
                                    SA_SalvarLog('ENVIAR OPCAO MENU ContinuaFuncaoMCInterativo',pergunta.Titulo+' = '+opcaoColeta.ToString);  // Salvar LOG - Se ativado
                                    CRetorno := ContinuaFuncaoMCInterativo(PAnsiChar(AnsiString(opcaoColeta.ToString)));
                                    if CRetorno<>0 then // Houve um erro ao enviar o dado
                                       begin
                                          //------------------------------------
                                          frmwebtef.mensagem := SA_RetornoErro(CRetorno);
                                          SA_SalvarLog('ERRO ENVIAR OPCAO MENU ContinuaFuncaoMCInterativo',CRetorno.ToString+' '+frmwebtef.mensagem);  // Salvar LOG - Se ativado
                                          TThread.Synchronize(TThread.CurrentThread,
                                             procedure
                                                begin
                                                   SA_Mostrar_Mensagem(true);
                                                end);
                                          //------------------------------------
                                          SA_AtivarBTCancelar;   // Ativar o botão cancelar na tela de TEF
                                          while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                             begin
                                                sleep(50);
                                             end;
                                          sair := true;   // Ativar a saída do LOOP
                                          //------------------------------------
                                       end;
                                    //------------------------------------------
                                 end
                              else
                                 begin
                                    sair := true;   // Ativar a saída do LOOP, o operador desistiu de responder e cancelou a operação

                                 end;
                              //------------------------------------------------
                           end
                        else if acao=TPMultiPlusPERGUNTA then  // Deverá ser perguntado algo
                           begin
                              //------------------------------------------------
                              //  Fazer uma pergunta ao operador
                              //------------------------------------------------
                              Pergunta := SA_SA_MultiPlusPerguntaRetorno(SRetorno);
                              //---------------------------------------------------
                              TThread.Synchronize(TThread.CurrentThread,
                               procedure
                                  begin
                                     if pergunta.Tipo=TtpDATE then  // Se o tipo é data, o valor inicial é adata atual
                                        ConteudoInicial := FormatDateTime('dd/mm/yyyy',date);
                                     SA_ColetarValor(pergunta.Titulo,pergunta.mascara,false,ConteudoInicial);
                                  end);
                              //------------------------------------------------
                              SA_AtivarBTCancelar;
                              frmwebtef.dado_digitado := '';
                              frmwebtef.Cancelar      := false;
                              Resposta_pergunta       := '';
                              Leitura_pergunta        := true;
                              //------------------------------------------------
                              while Leitura_pergunta do
                                 begin
                                    //------------------------------------------
                                    sleep(10);
                                    //------------------------------------------
                                    if (frmwebtef.dado_digitado<>'') and (not frmwebtef.Cancelar) then
                                       begin
                                          Resposta_pergunta := frmwebtef.dado_digitado;
                                          Leitura_pergunta  := not SA_ValidarRespostaPergunta(pergunta,Resposta_pergunta);
                                       end
                                    else if frmwebtef.Cancelar then
                                       begin
                                         Leitura_pergunta  := false;
                                         Resposta_pergunta := '';
                                       end;
                                    if (frmwebtef.dado_digitado<>'') and (not SA_ValidarRespostaPergunta(pergunta,frmwebtef.dado_digitado)) then
                                       begin
                                          frmwebtef.pnalerta.Caption      := 'Valor inválido !';
                                          frmwebtef.pnalerta.Color        := clRed;
                                          frmwebtef.pnalerta.Font.Color   := clYellow;
                                          frmwebtef.dado_digitado         := '';
                                       end;
                                    //------------------------------------------
                                 end;
                              //------------------------------------------------
                              frmwebtef.pncaptura.Visible := false;
                              frmwebtef.edtdado.Enabled   := false;
                              frmwebtef.btcancelar.free;
                              //------------------------------------------------
                              if not frmwebtef.Cancelar then
                                 begin
                                    pergunta.ValorColetado := SA_FormatarRespostaPergunta(pergunta,Resposta_pergunta);  // Formatar o dado coletado para enviar para a DLL
                                    SA_SalvarLog('ENVIAR DADO DA PERGUNTA ContinuaFuncaoMCInterativo',pergunta.Titulo+' = '+pergunta.ValorColetado);  // Salvar LOG - Se ativado
                                    CRetorno := ContinuaFuncaoMCInterativo(PAnsiChar(AnsiString(pergunta.ValorColetado))); // Enviar o dado coletado
                                    if CRetorno<>0 then // Houve um erro ao enviar o dado
                                       begin
                                          //------------------------------------
                                          frmwebtef.mensagem := SA_RetornoErro(CRetorno);
                                          SA_SalvarLog('ERRO ENVIAR DADO DA PERGUNTA ContinuaFuncaoMCInterativo',pergunta.Titulo+' = '+frmwebtef.dado_digitado + ' ' + frmwebtef.mensagem);  // Salvar LOG - Se ativado
                                          TThread.Synchronize(TThread.CurrentThread,
                                             procedure
                                                begin
                                                   SA_Mostrar_Mensagem(true);
                                                end);
                                          //------------------------------------
                                          SA_AtivarBTCancelar;   // Ativar o botão cancelar na tela de TEF
                                          while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                             begin
                                                sleep(50);
                                             end;
                                          sair := true;   // Ativar a saída do LOOP
                                          //------------------------------------
                                       end;
                                    //------------------------------------------
                                 end
                               else
                                 sair := true;  // Coleta foi cancelado pelo operador, cancelar o TEF
                              //------------------------------------------------
                           end
//                        else if (acao=TPMultiPlusRETORNO) and (not (LTpOperacaoTEF in[tpMPlPIX, tpMPlPIXMercadoPago,tpMPlPIXPicPay]))  then
                        else if (acao=TPMultiPlusRETORNO) and (not (LTpOperacaoTEF in[tpMPlPIX, tpMPlPIXMercadoPago,tpMPlPIXPicPay])) or ((LTpOperacaoTEF in[tpMPlPIX, tpMPlPIXMercadoPago,tpMPlPIXPicPay]) and (pos('|STATUS=REMOVIDA',string(SRetorno))=0) )  then
                           begin
                              //------------------------------------------------
                              //   Confirmar a transação
                              //------------------------------------------------
                              RetornoTransacao := SA_SA_MultiPlusRetornoTransacao(SRetorno);
                              //------------------------------------------------
                              //   Fazer 3 tentativas de confirmação
                              //------------------------------------------------
                              finalizado              := false;
                              qtdetentativasfinalizar := 0;
                              while not finalizado do
                                 begin
                                    //------------------------------------------
                                    inc(qtdetentativasfinalizar);
                                    //------------------------------------------
                                    SA_SalvarLog('ENVIAR CONFIRMACAO FinalizaFuncaoMCInterativo','NSU:'+RetornoTransacao.NSU+
                                                                                                 ' R$:'+vlTransformado+
                                                                                                 ' Parcela:'+LParcela.ToString+
                                                                                                 ' Cupom:'+LCupom.ToString+
                                                                                                 ' Data:'+formatdatetime('yyyyMMdd',date)+
                                                                                                 ' PDV:'+LPdv+
                                                                                                 ' Cod.Loja:'+LCodigoLoja+
                                                                                                 ' CNPJ:'+LCNPJ+' Tentativa Nr. '+qtdetentativasfinalizar.tostring);  // Salvar LOG - Se ativado
                                    try
                                        //--------------------------------------------
                                        // Enviando a confirmação da transação
                                        //--------------------------------------------
                                        CRetorno := FinalizaFuncaoMCInterativo(98,                                                        // iComando: Integer;
                                                                               PAnsiChar(AnsiString(LCNPJ)),
                                                                               LParcela,
                                                                               PAnsiChar(AnsiString(LCupom.ToString)),
                                                                               PAnsiChar(AnsiString(vlTransformado)),
                                                                               PAnsiChar(AnsiString(RetornoTransacao.NSU)),
                                                                               PAnsiChar(AnsiString(formatdatetime('yyyyMMdd',LData))),
                                                                               PAnsiChar(AnsiString(LPdv)),
                                                                               PAnsiChar(AnsiString(LCodigoLoja)),
                                                                               0,
                                                                               '');
                                        //--------------------------------------------
                                        SA_SalvarLog('RETORNO ENVIAR CONFIRMACAO FinalizaFuncaoMCInterativo',cretorno.ToString+' Retorno OK (função foi executada sem erros)');
                                        //--------------------------------------------
                                    except on e:exception do
                                       begin
                                          SA_SalvarLog('ERRO ENVIAR CONFIRMACAO FinalizaFuncaoMCInterativo',e.Message);
                                       end;
                                    end;
                                    //------------------------------------------
                                    if (qtdetentativasfinalizar=3) or (CRetorno<>33) then
                                       finalizado := true;

                                    //------------------------------------------
                                 end;
                              //                              CRetorno := 0;
                              //------------------------------------------------
                              if CRetorno=0 then   // A confirmação da transação foi realizada com sucesso
                                 begin
                                    //------------------------------------------
                                    sair := true;
                                    //------------------------------------------
                                    //   Imprimir comprovante, processar a finalização do processo
                                    //------------------------------------------
                                    if RetornoTransacao.COMPROVANTE.Count>0 then // Existe comprovante a ser impresso
                                       begin
                                          //------------------------------------
                                          //******************************************
                                          //   Impressão do comprovante do cliente
                                          //******************************************
                                          //------------------------------------
                                          if LIComprovanteCliente=tpiMPlImprimir then  // Imprimir o comprovante automaticamente
                                             ImprimirComprovante := true
                                          else if LIComprovanteCliente=tpiMPlPerguntar then  // Perguntar se quer imprimir o comprovante
                                             begin
                                                //------------------------------
                                                //   Perguntar se quer imprimir
                                                //------------------------------
                                                frmwebtef.mensagem := 'Imprimir o comprovante do CLIENTE ?';
                                                frmwebtef.opcoes   := TStringList.Create;
                                                frmwebtef.opcoes.Clear;
                                                frmwebtef.opcoes.Add('Imprimir');
                                                frmwebtef.opcoes.Add('Não Imprimir');
                                                frmwebtef.opcao    := -1;
                                                frmwebtef.tecla    := '';
                                                frmwebtef.Cancelar := false;
                                                //------------------------------
                                                TThread.Synchronize(TThread.CurrentThread,
                                                procedure
                                                   begin
                                                      SA_Criar_Menu(true);
                                                   end);
                                                //------------------------------
                                                ImprimirComprovante := false;
                                                SairLoopImpressao   := false;
                                                while (not SairLoopImpressao) do  // Aguardando o operador confirmar ou cancelar a impressão
                                                   begin
                                                     if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                                        begin
                                                           ImprimirComprovante := true;
                                                           SairLoopImpressao   := true;
                                                        end
                                                     else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) or (frmwebtef.Cancelar) then
                                                        begin
                                                           ImprimirComprovante := false;
                                                           SairLoopImpressao   := true;
                                                        end;
                                                      //------------------------
                                                      sleep(50);
                                                   end;
                                                //------------------------------
                                                frmwebtef.Cancelar := false;
                                                //------------------------------
                                             end;
                                          //------------------------------------
                                          if ImprimirComprovante then
                                             begin
                                                GerenciadorImpressao.Corpo.Text           := RetornoTransacao.COMPROVANTE.Text;
                                                GerenciadorImpressao.PortaImpressora      := LImpressoraPorta;
                                                GerenciadorImpressao.Avanco               := LImpressoraAvanco;
                                                GerenciadorImpressao.ModeloImpressoraACBR := LImpressoraModelo;

                                                GerenciadorImpressao.SA_Imprimir(1);
                                             end;
                                          //------------------------------------
                                          //******************************************
                                          //   Impressão do comprovante da loja
                                          //******************************************
                                          //------------------------------------
                                          if LComprovanteLojaSimplificado then   // Criar um comprovante simplificado para imprimir no lugar daquele recebido da DLL
                                             RetornoTransacao.ComprovanteLoja.Text := SA_GerarComprovanteSimplificado.Text;  // Gerando o comprovante simplificado
                                          if LIComprovanteCliente=tpiMPlImprimir then  // Imprimir o comprovante automaticamente
                                             ImprimirComprovante := true
                                          else if LIComprovanteCliente=tpiMPlPerguntar then  // Perguntar se quer imprimir o comprovante
                                             begin
                                                //------------------------------
                                                //   Perguntar se quer imprimir
                                                //------------------------------
                                                frmwebtef.mensagem := 'Imprimir o comprovante da LOJA ?';
                                                frmwebtef.opcoes   := TStringList.Create;
                                                frmwebtef.opcoes.Clear;
                                                frmwebtef.opcoes.Add('Imprimir');
                                                frmwebtef.opcoes.Add('Não Imprimir');
                                                frmwebtef.opcao    := -1;
                                                frmwebtef.tecla    := '';
                                                frmwebtef.Cancelar := false;
                                                //------------------------------
                                                TThread.Synchronize(TThread.CurrentThread,
                                                procedure
                                                   begin
                                                      SA_Criar_Menu(true);
                                                   end);
                                                //------------------------------
                                                ImprimirComprovante := false;
                                                SairLoopImpressao   := false;
                                                while (not SairLoopImpressao) do  // Esperando o operador confirmar ou cancelar a impressão
                                                   begin
                                                     if (frmwebtef.tecla='1') or (frmwebtef.opcao=1) then
                                                        begin
                                                           ImprimirComprovante := true;
                                                           SairLoopImpressao   := true;
                                                        end
                                                     else if (frmwebtef.tecla='2') or (frmwebtef.opcao=2) or (frmwebtef.Cancelar) then
                                                        begin
                                                           ImprimirComprovante := false;
                                                           SairLoopImpressao   := true;
                                                        end;
                                                      //------------------------
                                                      sleep(50);
                                                   end;
                                                //------------------------------
                                                frmwebtef.Cancelar := false;
                                                //------------------------------
                                             end;
                                          //------------------------------------
                                          if ImprimirComprovante then
                                             begin
                                                GerenciadorImpressao.Corpo.Text  := RetornoTransacao.ComprovanteLoja.Text;
                                                GerenciadorImpressao.SA_Imprimir(1);
                                             end
                                          //------------------------------------

                                       end;
                                 end
                              else   // Ocorreu um erro ao confirmar a transação
                                 begin
                                    //------------------------------------------
                                    //   Tratar a falha da confirmação
                                    //------------------------------------------
                                    frmwebtef.mensagem := SA_RetornoErro(CRetorno);
                                    SA_SalvarLog('ERRO ENVIAR CONFIRMACAO FinalizaFuncaoMCInterativo',CRetorno.ToString+' '+SA_RetornoErro(CRetorno));  // Salvar LOG - Se ativado
                                    TThread.Synchronize(TThread.CurrentThread,
                                       procedure
                                          begin
                                             SA_Mostrar_Mensagem(true);
                                          end);
                                    //------------------------------------
                                    SA_AtivarBTCancelar;   // Ativar o botão cancelar na tela de TEF
                                    while not frmwebtef.Cancelar do   // Esperando que o operador pressione o botão de cancelar
                                       begin
                                          sleep(50);
                                       end;
                                    sair := true;   // Ativar a saída do LOOP
                                    //------------------------------------------
                                 end;
                              //------------------------------------------------
                              //------------------------------------------------
                           end
                        else if (acao=TPMultiPlusRETORNO) and ((LTpOperacaoTEF in[tpMPlPIX, tpMPlPIXMercadoPago,tpMPlPIXPicPay]))  then
                           begin
                              sair := true;   // Ativar a saída do LOOP
                           end;
                        //------------------------------------------------------
                     end;
                  //------------------------------------------------------------
               end;
            //------------------------------------------------------------------
            // Executar as funções que são necessárias após o processo ser encerrado
            //------------------------------------------------------------------
            if (acao=TPMultiPlusERROABORTAR) or (acao=TPMultiPlusERRODISPLAY) or ((acao=TPMultiPlusMENU) and (opcaoColeta=-1)) or ((acao=TPMultiPlusPERGUNTA) and (Resposta_pergunta='')) then
               begin
                  FRetorno := CancelarFluxoMCInterativo;
                  SA_SalvarLog('RESPOSTA CancelarFluxoMCInterativo',FRetorno.ToString+' = '+SA_RetornoErro(FRetorno));
               end;

            //------------------------------------------------------------------
         end
      else
         begin
            //------------------------------------------------------------------
            //  Ocorreu um erro
            //------------------------------------------------------------------
            CancelarFluxoMCInterativo;
            SA_SalvarLog('RESPOSTA REALIZAR PAGAMENTO',SA_RetornoErro(IRetorno));
            frmwebtef.mensagem := SA_RetornoErro(IRetorno);
            //------------------------------------------------------------------
            TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
               SA_Mostrar_Mensagem(true);
            end);
            //------------------------------------------------------------------
            SA_AtivarBTCancelar;
            while not frmwebtef.Cancelar do
               begin
                  sleep(50);
               end;
            //------------------------------------------------------------------
         end;
      //------------------------------------------------------------------------
      //   Fechando a janela do TEF
      //------------------------------------------------------------------------
      SA_MostrarLogoPINPAD;   // Mostrando a imagem de LOGO na tela do PINPAD
      frmwebtef.Close;
      frmwebtef.Release;
      lExecutando := false;
      //------------------------------------------------------------------------

   end).Start;
   //---------------------------------------------------------------------------

end;

function TMultiPlusTEF.SA_RetornoErro(codigo: integer): string;
begin
   case codigo of
      01:Result := 'Erro genérico na execução';
      30:Result := 'Não foi encontrado o caminho do ClientD.exe';
      31:Result := 'ConfigMC.ini está vazio';
      32:Result := 'ClientD.exe não encontrado';
      33:Result := 'ClientD.exe não está em execução';
      34:Result := 'Erro ao iniciar ClientD.exe';
      35:Result := 'Erro interno do ClientD.exe';
      36:Result := 'Erro interno do ClientD.exe';
      37:Result := 'Erro na leitura do arquivo ConfigMC.ini';
      38:Result := 'Valor da transação com formato incorreto';
      39:Result := 'Executável de envio de transações não encontrado';
      40:Result := 'CNPJ Inválido ou no formato incorreto';
      41:Result := 'ClientD.exe está em processo de atualização';
      42:Result := 'A automação não está sendo executada no modo administrador';
      43:Result := 'ClientD.exe está em execução devido a uma transação anterior';
      44:Result := 'Parâmetros ausentes em operação que utiliza o sParametro';
      45:Result := 'Parâmetros no formato incorreto em operação que utiliza o sParametro';
      46:Result := 'Erro ao identificar localização da DLL';
      47:Result := 'Não Foi encontrada a localização da DLL';
      48:Result := 'Não houve confirmação da conclusão da execução do ClientD';
      49:Result := 'Número de parcelas inválido';
   end;
end;

procedure TMultiPlusTEF.SA_SalvarLog(titulo, dado: string);
begin
   if LSalvarLog then
      SA_Salva_Arquivo_Incremental(titulo + ' ' +
                                   formatdatetime('dd/mm/yyyy hh:mm:ss',now)+#13+dado,
                                   GetCurrentDir+'\TEFMPL_log\logTEFMPL'+formatdatetime('yyyymmdd',date)+'.txt');
end;

procedure TMultiPlusTEF.SA_Salva_Arquivo_Incremental(linha,  nome_arquivo: string);
var
   arquivo      : TextFile;
begin
   AssignFile(arquivo,Nome_arquivo);
   if not FileExists(Nome_arquivo) then
      Rewrite(arquivo)
   else
      Append(arquivo);
   Writeln(arquivo,linha);
   CloseFile(arquivo);

end;

//------------------------------------------------------------------------------
//   Buscar um campo dentro da TAG
//------------------------------------------------------------------------------
function TMultiPlusTEF.SA_SA_MultiPlusBuscarCampo(campo,  retorno: string): string;
var
   posicao : integer;
begin
   //---------------------------------------------------------------------------
   posicao := pos(campo,retorno)+10;
   //---------------------------------------------------------------------------
   if posicao=0 then
      begin
         Result := '';
         exit;
      end;
   //---------------------------------------------------------------------------
   while (retorno[posicao]<>'#') and (posicao<length(retorno)) do
      begin
         Result := Result + retorno[posicao];
         inc(posicao);
      end;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------
//   Buscar a mensagem do retorno
//------------------------------------------------------------------------------
function TMultiPlusTEF.SA_SA_MultiPlusMensagemRetorno(retorno: string): string;
var
   inicio : integer;
begin
   //---------------------------------------------------------------------------
   // [MSG]#AGUARDE A SENHA
   // [ERROABORTAR]#CANCELADO PELO OPERADOR
   // [ERRODISPLAY]#T14-CARTAO INVALIDO
   //---------------------------------------------------------------------------
   inicio := pos(']#',retorno);
   delete(retorno,1,inicio+1);
   Result := trim(retorno);
end;

//------------------------------------------------------------------------------
//   Desmontar itens para o MENU MULTIPLUS
//------------------------------------------------------------------------------
function TMultiPlusTEF.SA_SA_MultiPlusOpcoesMenuRetorno(retorno: string): TMultiPlusMenu;
var
   inicio : integer;
   opcao  : string;
begin
   //---------------------------------------------------------------------------
   // [MENU]#MODO#1-MAGNETICO|2-DIGITADO
   //---------------------------------------------------------------------------
   Result.Titulo := 'Selecione a Opção';
   Result.Opcoes := TStringList.Create;
   inicio  := pos('#',retorno);
   retorno := copy(retorno,inicio+1,length(retorno)-inicio);
   inicio  := pos('#',retorno);
   Result.Titulo := copy(retorno,1,inicio-1);
   retorno := copy(retorno,inicio+1,length(retorno)-inicio);
   //---------------------------------------------------------------------------
   while pos('|',retorno)>0 do
      begin
         inicio := pos('|',retorno);
         opcao  := copy(retorno,1,inicio-1);;
         if trim(opcao)<>'' then
            begin
               Result.Opcoes.Add(opcao);
               opcao := '';
               retorno := copy(retorno,inicio+1,length(retorno)-inicio);
            end;
      end;
   if trim(retorno)<>'' then
      Result.Opcoes.Add(trim(retorno));
   //---------------------------------------------------------------------------
end;

//------------------------------------------------------------------------------
//   Desmontar o retorno para o tipo PERGUNTA
//------------------------------------------------------------------------------
function TMultiPlusTEF.SA_SA_MultiPlusPerguntaRetorno( retorno: string): TMultiPlusPergunta;
var
   inicio     : integer;
   informacao : string;
begin
   //---------------------------------------------------------------------------
   // [PERGUNTA]#INFORME O NSU#INT#0#0#0,00#0,00#0
   // [PERGUNTA]#TITULO#TIPO DE DADO#TAMANHO MINIMO#TAMANHO MAXIMO#VALOR MINIMO#VALOR MAXIMO#CASAS DECIMAIS
   //---------------------------------------------------------------------------
   //   Título
   //---------------------------------------------------------------------------
   delete(retorno,1,11);
   inicio        := pos('#',retorno);
   Result.Titulo := copy(retorno,1,inicio-1);  // Pegando o título da pergunta
   delete(retorno,1,inicio);
   //---------------------------------------------------------------------------
   //   Tipo de dado
   //---------------------------------------------------------------------------
   inicio        := pos('#',retorno);
   informacao    := copy(retorno,1,inicio-1);
   Result.Tipo   := SA_SA_MultiPlusTipoDado(informacao); // Tipo de dado
   delete(retorno,1,inicio);
   //---------------------------------------------------------------------------
   //   Tamanho mínimo
   //---------------------------------------------------------------------------
   inicio               := pos('#',retorno);
   informacao           := copy(retorno,1,inicio-1);
   Result.TamanhoMinimo := strtointdef(informacao,1);  // Tamanho mínimo
   delete(retorno,1,inicio);
   //---------------------------------------------------------------------------
   //  Tamanho máximo
   //---------------------------------------------------------------------------
   inicio               := pos('#',retorno);
   informacao           := copy(retorno,1,inicio-1);
   Result.TamanhoMaximo := strtointdef(informacao,50);
   delete(retorno,1,inicio);
   //---------------------------------------------------------------------------
   //  Valor minimo
   //---------------------------------------------------------------------------
   inicio               := pos('#',retorno);
   informacao           := copy(retorno,1,inicio-1);
   Result.VlMinimo      := trim(informacao);
   delete(retorno,1,inicio);
   //---------------------------------------------------------------------------
   //  Valor máximo
   //---------------------------------------------------------------------------
   inicio               := pos('#',retorno);
   informacao           := copy(retorno,1,inicio-1);
   Result.VlMaximo      := trim(informacao);
   delete(retorno,1,inicio);
   //---------------------------------------------------------------------------
   //   Casas decimais
   //---------------------------------------------------------------------------
   Result.CasasDecimais      := strtointdef(retorno,2);
   //---------------------------------------------------------------------------
   case Result.Tipo of
     TtpINT        : Result.Mascara := StringofChar('9', Result.TamanhoMaximo );
     TtpSTRING     : Result.Mascara := StringofChar('a', Result.TamanhoMaximo );
     TtpDECIMAL    : Result.Mascara := '####0,'+StringofChar('0', Result.CasasDecimais );
     TtpDATE       : Result.Mascara := '99/99/9999' ;
     TtpINDEFINIDO : Result.Mascara := '';
   end;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------
//   Buscar a mensagem do retorno
//------------------------------------------------------------------------------
function TMultiPlusTEF.SA_SA_MultiPlusRetornoTransacao(  retorno: string): TMultiPlusRetornoTransacao;
var
   comprovante : string;
begin
   //---------------------------------------------------------------------------
   Result.OperacaoExecutada  := false;
   Result.COMPROVANTE        := TStringList.Create;
   Result.ComprovanteLoja    := TStringList.Create;
   if retorno='' then
      exit;
   //---------------------------------------------------------------------------
   //  Número Cupom
   //---------------------------------------------------------------------------
   Result.CUPOM               := SA_SA_MultiPlusBuscarCampo('CAMPO0160',retorno);                //  Número Cupom
   Result.VALOR               := untransform(SA_SA_MultiPlusBuscarCampo('CAMPO0002',retorno));   //  Valor da operação
   Result.COD_BANDEIRA        := SA_SA_MultiPlusBuscarCampo('CAMPO0132',retorno);                //  Código da bandeira
   Result.COD_REDE            := SA_SA_MultiPlusBuscarCampo('CAMPO0131',retorno);                //  Código da rede
   Result.COD_AUTORIZACAO     := SA_SA_MultiPlusBuscarCampo('CAMPO0135',retorno);                //  Código de autorização
   Result.NSU                 := SA_SA_MultiPlusBuscarCampo('CAMPO0133',retorno);                //  NSU
   Result.QTDE_PARCELAS       := strtointdef(SA_SA_MultiPlusBuscarCampo('CAMPO0505',retorno),1); //  Qtde de Parcelas
   Result.TAXA_SERVICO        := untransform(SA_SA_MultiPlusBuscarCampo('CAMPO0504',retorno));   //  Taxa de serviço
   Result.BIN_CARTAO          := SA_SA_MultiPlusBuscarCampo('CAMPO0136',retorno);                //  BIN do cartão
   Result.ULT_DIGITOS_CARTAO  := SA_SA_MultiPlusBuscarCampo('CAMPO1190',retorno);                //  Ultimos dígitos do cartão
   Result.CNPJ_AUTORIZADORA   := SA_SA_MultiPlusBuscarCampo('CAMPO0950',retorno);                //  CNPJ da autorizadora
   Result.NOME_CLIENTE        := SA_SA_MultiPlusBuscarCampo('CAMPO1003',retorno);                //  Nome do cliente
   Result.NSU_REDE            := SA_SA_MultiPlusBuscarCampo('CAMPO0134',retorno);                //  NSU da Rede
   Result.VENCTO_CARTAO       := SA_SA_MultiPlusBuscarCampo('CAMPO0513',retorno);                //  Vencimento do cartão
   comprovante                := SA_SA_MultiPlusBuscarCampo('CAMPO122',retorno);                 //  Comprovante
   Result.VIAS_COMPROVANTE    := strtointdef(SA_SA_MultiPlusBuscarCampo('CAMPO0003',retorno),1); // Qtde vias comprovante
   Result.NOME_BANDEIRA       := SA_SA_MultiPlusBuscarCampo('CAMPO9999',retorno);                // Nome da bandeira
   Result.NOME_REDE           := SA_SA_MultiPlusBuscarCampo('CAMPO9998',retorno);                // Nome da Rede
   if SA_SA_MultiPlusBuscarCampo('CAMPO4221',retorno)='S' then                                   // Cartão pré pago
      Result.CARTAO_PRE_PAGO  := true
   else
      Result.CARTAO_PRE_PAGO  := false;
   Result.COD_TIPO_TRANSACAO  := SA_SA_MultiPlusBuscarCampo('CAMPO0100',retorno);                // Código do tipo de transação
   Result.DESC_TRANSACAO      := SA_SA_MultiPlusBuscarCampo('CAMPO0101',retorno);                // Descrição do tipo da transação
   Result.E2E                 := SA_SA_MultiPlusBuscarCampo('CAMPO2620',retorno);                // Identificacao da transação PIX (E2E), utilizado para NFCe
   Result.Data                := LData;
   Result.Hora                := LHora;
   //---------------------------------------------------------------------------
   if comprovante<>'' then
      begin
         Result.OperacaoExecutada    := true;
         comprovante                 := StringReplace(comprovante,'CORTAR','| |',[rfReplaceAll, rfIgnoreCase]);
         Result.COMPROVANTE.Text     := StringReplace(comprovante,'|',#13,[rfReplaceAll, rfIgnoreCase]);
         Result.ComprovanteLoja.Text := Result.COMPROVANTE.Text;
      end;
   //---------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------
//   Retornar qual o tipo de dado
//------------------------------------------------------------------------------
function TMultiPlusTEF.SA_SA_MultiPlusTipoDado(  dado: string): TMultiPlusTTipoDado;
begin
   //---------------------------------------------------------------------------
   Result := TtpINDEFINIDO;
   if trim(dado)='' then   // Se o tipo de dado é vazio
      exit;
   //---------------------------------------------------------------------------
   // TMultiPlusTTipoDado = (TtpINT, TtpSTRING, TtpDECIMAL, TtpDATE , TtpINDEFINIDO);
   // ('INT', 'STRING', 'DECIMAL', 'DATE');
   //---------------------------------------------------------------------------
   if uppercase(dado)='INT' then
      Result := TtpINT
   else if uppercase(dado)='STRING' then
      Result := TtpSTRING
   else if uppercase(dado)='DECIMAL' then
      Result := TtpDECIMAL
   else if uppercase(dado)='DATE' then
      Result := TtpDATE;
   //---------------------------------------------------------------------------
end;


function TMultiPlusTEF.SA_TpCartaoOperacaoTEFtoINT(tipoCartao: TTpMPlCartaoOperacaoTEF): integer;
begin
   //---------------------------------------------------------------------------
   //  Tipos de operação com ccartões TEF
   //   0 - Crédito a vista / 1 - Credito / 2 - Crédito parcelado Loja / 3 - Crédito parcelado ADM / 4 - Débito
   //   11 - Frota / 18 - Voucher
   //   20 - Débito a vista
   //   51 - PIX PSP cliente / 52 - PIX Mercado Pago / 53 - PIX PicPay
   //---------------------------------------------------------------------------
   Result := 99;
   case tipoCartao of
     tpMPlCreditoVista          : Result := 0;
     tpMPlCredito               : Result := 1;
     tpMPlCreditoaParceladoLoja : Result := 2;
     tpMPlCreditoParceladoADM   : Result := 3;
     tpMPlDebito                : Result := 4;
     tpMPlFrota                 : Result := 11;
     tpMPlDebitoVista           : Result := 20;
     tpMPlVoucher               : Result := 18;
     tpMPlPIX                   : Result := 51;
     tpMPlPIXMercadoPago        : Result := 52;
     tpMPlPIXPicPay             : Result := 53;
   end;
   //---------------------------------------------------------------------------
end;

function TMultiPlusTEF.SA_TpCartaoOperacaoTEFtoSTR(tipoCartao: TTpMPlCartaoOperacaoTEF): string;
begin
   case tipoCartao of
     tpMPlCreditoVista          : Result := 'Credito a vista';
     tpMPlCredito               : Result := 'Credito';
     tpMPlCreditoaParceladoLoja : Result := 'Credito Parcelado Lojista';
     tpMPlCreditoParceladoADM   : Result := 'Credito Parcelado Administradora';
     tpMPlDebito                : Result := 'Debito';
     tpMPlFrota                 : Result := 'Frota';
     tpMPlDebitoVista           : Result := 'Debito a Vista';
     tpMPlVoucher               : Result := 'Voucher';
     tpMPlPIX                   : Result := 'PIX';
     tpMPlPIXMercadoPago        : Result := 'PIX Mercado Pago';
     tpMPlPIXPicPay             : Result := 'Pic Pay';
   end;
end;


function TMultiPlusTEF.SA_ValidarRespostaPergunta(Pergunta: TMultiPlusPergunta;  ValorColetado: string): boolean;
var
   VlInt     : integer;
   VlString  : string;
   VlDecimal : real;
//   VlData    : TDate;
begin
   //---------------------------------------------------------------------------
   VlInt     := 0;
   VlString  := '';
   VlDecimal := 0;
//   VlData    := strtodate('01/01/1800');
   //---------------------------------------------------------------------------
   // TMultiPlusTTipoDado = (TtpINT, TtpSTRING, TtpDECIMAL, TtpDATE , TtpINDEFINIDO);
   //---------------------------------------------------------------------------
   try
      case pergunta.Tipo of
        TtpINT        : VlInt     := strtoint(trim(ValorColetado));
        TtpSTRING     : VlString  := trim(ValorColetado);
        TtpDECIMAL    : VlDecimal := untransform(trim(ValorColetado));
//        TtpDATE       : VlData    := StrToDate(trim(ValorColetado));
      end;
   except
      Result := false;
      exit;
   end;
   //---------------------------------------------------------------------------
   try
      if pergunta.Tipo=TtpINT then
         Result := (VlInt>=untransform(Pergunta.VlMinimo)) and (VlInt<=untransform(Pergunta.VlMaximo))
      else if pergunta.Tipo=TtpSTRING then
         Result := (length(VlString)>=Pergunta.TamanhoMinimo) and (length(VlString)<=Pergunta.TamanhoMaximo)
      else if pergunta.Tipo=TtpDECIMAL then
         Result := (VlDecimal>=untransform(Pergunta.VlMinimo)) and (VlDecimal<=untransform(Pergunta.VlMaximo))
      else if pergunta.Tipo=TtpDATE then
         Result := true // (VlData>=strtodate(Pergunta.VlMinimo)) and (VlData<=strtodate(Pergunta.VlMaximo))
      else
         Result := true;
   except on e:exception do
      begin
         Result := false;
         SA_SalvarLog('ERRO VALIDACAO DO TIPO DE DADO',e.Message);
      end;
   end;
   //---------------------------------------------------------------------------
end;

function TMultiPlusTEF.transform(valor: real): string;
begin
   Result := '          '+formatfloat('###,###,##0.00',RoundABNT(valor,2));
   Result := copy(Result,length(Result)-13,14);
end;

function TMultiPlusTEF.untransform(palavra: string): real;
var
   txt   : string;
   d     : integer;
begin
   txt:='';
   if palavra='' then
      palavra:='0,00';
   for d:=1 to length(palavra) do
      begin
         if CharInSet(palavra[d],['0'..'9',',','-']) then
            txt:=txt+palavra[d];
      end;
   //---------------------------------------------------------------------------
   try
      Result  := strtofloat(txt);
   except
      Result  := 0;
   end;
   //---------------------------------------------------------------------------
end;

end.
