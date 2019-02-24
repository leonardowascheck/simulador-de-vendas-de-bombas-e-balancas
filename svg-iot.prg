/*

=============================================================
Bem vindo ao SVG-IOT - Simulador de Vendas a Granel no Varejo 
=============================================================

This document Copyright (c) 2019-present Leonardo Wascheck

*/

func Main ()

   Init_Windows_Terminal ()

   // seta valores default para os campos de entrada pelo usuario
   cCENARIO_IAT            = '2' // cenario IAT mais comum encontrado no mercado
   nPrecoUnit              = 5.899 // 2.399 // 2.077 // 1.999 // 10.099
   nQTDE_DE                = 0.0      
   nQTDE_ATE               = 100
   nNumCasasDecimaisQtdIOT = 3  
   nNumCasasDecimaisQtdDfe = 3  

   ObtemEntradaDadosUsuario ()

   /////////////////////////////////////////////////////////////
   // prepara variaveis necessarias para emissao do relatorio //
   /////////////////////////////////////////////////////////////

   nIncrementaQtdIot = 1 / (10 ^ nNumCasasDecimaisQtdIOT) // incrementa a 2a, 3a ou 4a casa decimal da qtde para cada elemento de uma venda do equipamento IOT
   nIncrementaQtdDfe = 1 / (10 ^ nNumCasasDecimaisQtdDfe) // incrementa a 2a, 3a ou 4a casa decimal da qtde para cada elemento de uma venda de um documento fiscal eletronico (DF-e)

   if VAL (Str (nQTDE_DE, 10, 4)) = 0
      nQTDE_DE += nIncrementaQtdIot
   end

   if cCENARIO_IAT = '2'
      cIAT_IOT = 'A'        
      cIAT_DFE = 'T'
   else // cCENARIO_IAT = '3'
      cIAT_IOT = 'T'        
      cIAT_DFE = 'A'
   end

   nRequereramAjustes = 0
   nErroElementosNaoSolucionados = 0
   nContadorTotalElementos = 0 
   nNumMaiorIteracao = 0 
   nRequereramAjustesComMaisUmaIteracao = 0
   nContadorDifMaiorUmCentavos = 0 
   nContadorPossiveisDiferencasBD  = 0 

   private nARREDONDADO, nTRUNCADO, nARRED_NEW, nTRUNC_NEW

   // altd ()

   EmiteRelatorioVendasSimuladasIOT ()

   // Ufa!

   return


func ObtemEntradaDadosUsuario ()

   // restaura ultimos dados informados pelo usuario do arquivo SVG-IOT.INI
   CargaVar ('Cenario_IAT', @cCENARIO_IAT)
   CargaVar ('PrecoUnit', @nPrecoUnit)
   CargaVar ('NumCasasDecimaisQtdIOT', @nNumCasasDecimaisQtdIOT)
   CargaVar ('NumCasasDecimaisQtdDfe', @nNumCasasDecimaisQtdDfe)
   CargaVar ('Qtde_de', @nQTDE_DE)
   CargaVar ('Qtde_ate', @nQTDE_ATE)

   While (.t.)

      Clear
   
      @ 00,00 SAY 'SVG-IOT Ver 1.0.0  - Software de Dominio Publico - Autor: Leonardo Wascheck'
      @ 02,00 SAY 'CENARIO IAT         BOMBA/BALANCA          EQUIPAMENTO FISCAL/SEFAZ'
      @ 03,00 SAY '               (VENDA EQUIPAMENTO IOT)     (DOCUMENTO FISCAL DF-e)'
      @ 04,00 SAY '   2                  Arredondado                 Truncado'
      @ 05,00 SAY '   3                   Truncado                  Arredondado'
      
      @ 14,01 SAY '(Durante a geracao do relatorio das vendas simuladas, pressione'
      @ 15,01 SAY '<espaco> para pausar ou <Esc> para interromper a execucao e ir '
      @ 16,01 SAY 'para o resultado e analises)'
      
      @ 07,01 SAY 'Entre com o cenario IAT...............................: ' GET cCENARIO_IAT   PICT '9'
      @ 08,01 SAY 'Preco unitario........................................: ' GET nPrecoUnit     PICT '99.999'
      @ 09,01 SAY 'Numero Casas decimais da QTDE na venda Equipamento IOT: ' GET nNumCasasDecimaisQtdIOT  PICT '9'
      @ 10,01 SAY 'Numero Casas decimais da QTDE do documento fiscal DF-e: ' GET nNumCasasDecimaisQtdDfe PICT '9'
      @ 11,01 SAY 'Simular vendas DE  xxx litros ........................: ' GET nQTDE_DE       PICT '999.99'
      @ 12,01 SAY 'Simular vendas ATE xxx litros ........................: ' GET nQTDE_ATE      PICT '999.99'
      READ
   
      if LastKey () = 27
         Alert ('Aplicativo sera abortado.', { ' OK '} )
         quit
      end
   
      if nNumCasasDecimaisQtdIOT < 2 .or. nNumCasasDecimaisQtdIOT > 4
         Alert ('Numero de casas decimais para a QTDE da venda invalido. Deve ser 2, 3 ou 4.', { ' OK '} )
         loop
      end
   
      if nNumCasasDecimaisQtdDfe < 2 .or. nNumCasasDecimaisQtdDfe > 4
         Alert ( 'Numero de casas decimais para a QTDE do documento fiscal invalido. Deve ser 2, 3 ou 4.', { ' OK '} )
         loop
      end
   
      if nNumCasasDecimaisQtdDfe < nNumCasasDecimaisQtdIOT
         Alert ( 'Numero de casas decimais para a QTDE do documento fiscal DF-e deve ser maior ou igual a da QTDE da venda Equipamento IOT.', { ' OK '} )
         loop
      end
   
      if !(cCENARIO_IAT $ '23')
         Alert ('Cenario invalido ou nao atendido por este aplicativo.', { ' OK '} )
         loop
      end
   
      if Empty (nPrecoUnit)
         Alert ('Preco unitario nao pode ser ZERO.', { ' OK '} )
         loop
      end
   
      if nQTDE_DE < 0
         Alert ('Intervalo QTDE DE deve ser MAIOR QUE ZERO.', { ' OK '} )
         loop
      end
   
      if nQTDE_ATE < nQTDE_DE
         Alert ('Intervalo QTDE ATE nao pode ser menor que QTDE DE.', { ' OK '} )
         loop
      end
   
      exit // tudo ok
   
   ENDDO
   
   Keyboard ('') // limpa keyboard

   // grava parametros informados pelo usuario no arquivo SVG-IOT.INI
   GravaVar ('Cenario_IAT', cCENARIO_IAT)
   GravaVar ('PrecoUnit', nPrecoUnit)
   GravaVar ('NumCasasDecimaisQtdIOT', nNumCasasDecimaisQtdIOT)
   GravaVar ('NumCasasDecimaisQtdDfe', nNumCasasDecimaisQtdDfe)
   GravaVar ('Qtde_de', nQTDE_DE)
   GravaVar ('Qtde_ate', nQTDE_ATE)

   return


func EmiteRelatorioVendasSimuladasIOT ()

   Clear

   // cabecalho do relatorio de simulacao das vendas dos equipamentos IOT
   ? Replicate ('=', 158)
   ? PADC ('Elementos Vendas Simuladas-Equipamento IAT (IAT=' + cIAT_IOT + ')', 55) + '|' + ;
     PADC ('Elementos Vendas Ajustadas do DF-e (IAT=' + cIAT_DFE + ')', 101) 
   ? Replicate ('=', 158)
   ?
   
   y = Row () // prepara posicao para o relatorio 
   
   // relatorio dos elementos de vendas simuladas dos equipamentos IOT
   SimulaElementosVendasIotDfe ()
   
   cCol = SetColor ('W+')
   ? '------------- < < Parametros de Entrada Utilizado - Cenario Usuario > > ---------------'
   SetColor (cCol)
   ? 'Cenario do IAT........................................: "' + cCENARIO_IAT + '" (IAT IOT="' + cIAT_IOT + '", IAT DF-e="' + cIAT_DFE + '")'
   ? 'Preco unitario........................................: ' + Str (nPrecoUnit, 6, 3)
   ? 'Numero Casas decimais da QTDE na venda Equipamento IOT: ' + Str (nNumCasasDecimaisQtdIOT, 3)
   ? 'Numero Casas decimais da QTDE no documento fiscal DF-e: ' + Str (nNumCasasDecimaisQtdDfe, 3)
   ? 'Simular vendas DE  xxx litros ........................: ' + Str (nQTDE_DE, 3)
   ? 'Simular vendas ATE xxx litros ........................: ' + Str (nQTDE_ATE, 3)
     
   SetColor ('W+')
   ? '--------------- < < Resultado das Analises dos Elementos de vendas > > ----------------'
   SetColor (cCol)
   ? 'Numero de elementos que requereram ajustes na Qtde do DF-e.....................: ' + Str (nRequereramAjustes, 6)  
   ? 'Numero de elementos que nao requereram ajustes na Qtde do DF-e.................: ' + Str (nContadorTotalElementos - nRequereramAjustes, 6)  
   ?  '                                                                                 ------' 
   ? 'Total de elementos analisados..................................................: ' + Str (nContadorTotalElementos, 6) 
   ?
   ? 'Numero de elementos que requereram ajustes na Qtde Df-e com mais de 1 iteracao.: ' + Str (nRequereramAjustesComMaisUmaIteracao, 6)
   ? 'Numero da maior iteracao utilizada nos ajuestes da Qtde do Dfe.................: ' + Str (nNumMaiorIteracao, 6)
   
   SetColor ('W+')
   ? '------------------ < < Erros e Alertas encontrados na simulacao > > -------------------'
   SetColor ('GR+')
   ? 'ALERTA: Diferencas (arredondamento-truncamento) maior que 0,01.................: ' + Str (nContadorDifMaiorUmCentavos, 6)
   ? 'ALERTA: Numero elementos ajustados porem c/possiveis diferencas entre BD x DF-e: ' + Str (nContadorPossiveisDiferencasBD, 6) 
   SetColor ('R')
   ? 'ERRO*: Numero de elementos impossivel solucionar o ajuste da Qtde do DF-e......: ' + Str (nErroElementosNaoSolucionados, 6)   
   
   SetColor (cCol)
   ? '----------------------------------------------------------------'   
   ? 'NOTA*: Ocorre um erro quando o valor de uma venda realizada por uma bomba/balanca (IOT) é divergente do DF-e e a interpolacao nao consegue resolver.' 
   ? '       As consequencias destas diferencas sao desde travamento/cancelamento/rejeicao do documento fiscal ou possiveis reclamacoes'
   ? '       por parte do consumidor junto ao procon, uma vez que o valor do display da bomba/balanca nao bate com o documento fiscal.'
   ?
   ? 'Pressione qualquer tecla para sair...'
   Inkey (0)
   
   return


func SimulaElementosVendasIotDfe () 
private nQTDE := nQTDE_DE, nCol

   While (VAL (Str (nQTDE, 10, 4)) <= nQTDE_ATE)
   
      if TrataEventosTeclado ()
         exit
      end
      
      // pega os valores totais da venda do equipamento IOT pelos metodos arredondado e truncado
      GetValoresIAT (nQTDE, nNumCasasDecimaisQtdIOT, nPrecoUnit, @nARREDONDADO, @nTRUNCADO)
                                     
      nSaldoInterpolacao = val (str (IF (cIAT_IOT = 'A', nArredondado - nTruncado, nTruncado - nArredondado), 12, 2))
      
      if Abs (nSaldoInterpolacao) > 0 // ha diferencas de valores entre os metodos IAT a serem ajustadas ?

         // altd ()
         nRequereramAjustes++

         ImprimeElementosVendasIOT ()
         
         if Abs (nSaldoInterpolacao) > 0.01
            nContadorDifMaiorUmCentavos++
         end

         ImprimeElementosDasIteracoesDfe (nARREDONDADO, nTRUNCADO, Sign (nSaldoInterpolacao)) // retorna -1 se negativo, 0 para zero, e +1 para numetos positivos

      end
   
      nQTDE += nIncrementaQtdIot
      nContadorTotalElementos++
   
   ENDDO
   
return


func ImprimeElementosDasIteracoesDfe (nARREDONDADO, nTRUNCADO, nSinal)

   // altd ()
   
   nNumIteracao = 0
   nQTDE_NEW = nQTDE
   lRequerAjuste = .f.
   
   While (nNumIteracao < 10 * 10 ^ (nNumCasasDecimaisQtdDfe - 3) .and. !lRequerAjuste)   // realiza 1, 10 ou 100 iteracoes dependendo da precisao de nNumCasasDecimaisQtdIOT
      nNumIteracao++
      cn = PadR (Alltrim (Str (nNumIteracao, 2)), 2)
      // incrementa ou decrementa uma unidade na ultima casa decimal informada pelo usuario  
      nQTDE_NEW += (nIncrementaQtdDfe * nSinal) 
      // pega os valores totais das iteracoes ajustadas do DF-e pelos metodos arredondado e truncado
      GetValoresIAT (nQTDE_NEW, nNumCasasDecimaisQtdDfe, nPrecoUnit, @nARRED_NEW, @nTRUNC_NEW)
      if (cIAT_DFE = 'T' .and. nARREDONDADO = nTRUNC_NEW) .or. ;
         (cIAT_DFE = 'A' .and. nTRUNCADO = nARRED_NEW)
         lRequerAjuste = .t.
         cIteracao = ' | achou' + cn
         if nNumIteracao > 1
            nRequereramAjustesComMaisUmaIteracao++
         end
      else
         cIteracao = ' | ' + PadL (cn, 4) + '   '
      end
      // exibe o elemento de venda ajustado do DF-e, destando o valor entre [] correspodente ao metodo IAT
      if cIAT_DFE = 'T'
         @ y,COL () say cIteracao + ' qt'    + cn + '=' + Alltrim (Str (nQTDE_NEW,   9, nNumCasasDecimaisQtdDfe)) + ;
                                    ' arred' + cn + '=' + Alltrim (Str (nARRED_NEW, 12, 2)) + ;
                                    '[trunc' + cn + '=' + Alltrim (Str (nTRUNC_NEW, 12, 2)) + ;
                                    ']d'     + cn + '=' + Alltrim (Str (nARRED_NEW - nTRUNC_NEW, 12, 2))
      else
         @ y,COL () say cIteracao + ' qt'    + cn + '=' + Alltrim (Str (nQTDE_NEW,   9, nNumCasasDecimaisQtdDfe)) + ;
                                    '[arred' + cn + '=' + Alltrim (Str (nARRED_NEW, 12, 2)) + ;
                                    ']trunc' + cn + '=' + Alltrim (Str (nTRUNC_NEW, 12, 2)) + ;
                                    ' d'     + cn + '=' + Alltrim (Str (nARRED_NEW - nTRUNC_NEW, 12, 2))
      end 
      
      if (cIAT_DFE = 'T' .and. nTRUNC_NEW > nARREDONDADO) .or. ;
         (cIAT_DFE = 'A' .and. nARRED_NEW < nTRUNCADO)
         // estourou valor, nao sera possivel realizar proximas iteracoes para este metodo
         exit
      end
      if !lRequerAjuste
         ?
         y = row ()
         @ y,00 SAY Space (nCol)
      end
   ENDDO

   if nNumIteracao > nNumMaiorIteracao
      nNumMaiorIteracao = nNumIteracao
   end

   if !lRequerAjuste
      // nao foi possivel soucionar os valores totais da venda do Equipamento IOT com o DF-e, mesmo apos as iteracoes
      SetColor ('R')
      @ y,COL () say ' Erro, sem solucao apos "' + Alltrim (cn) + '" iteracao(oes)'
      SetColor ('W')
      nErroElementosNaoSolucionados++
   else
      if nTRUNC_NEW <> nARRED_NEW
         @ y,COL () say ' Ajustado, porem com diferenca entre: BD x DF-e'
         nContadorPossiveisDiferencasBD++
      else
         @ y,COL () say ' Ajustado OK'  
      end
   end
   ?
   y = row ()

return
  

func GetValoresIAT (nQTDE, nNumCasasDecimaisQtd, nPrecoUnit, nARREDONDADO, nTRUNCADO)
local nFixRound := (1 / (10 ^ (nNumCasasDecimaisQtd + 1))) * 5 // nNumCasasDecimais=2 -> nFixRound = 0.005, nNumCasasDecimais=3 -> nFixRound = 0.0005, nNumCasasDecimais=4 -> nFixRound = 0.00005

   // trunca com duas casas decimais (ignorando as demais casas)
   nTRUNCADO = VAL (Left (Str ((nQTDE * nPrecoUnit) + 0.00005, 13, 6), 9) )

   // contorna o problema do "floating point trap" do harbour retornando o valor correto
   // ex. 0.575 * 13.40 = 7.70 (retornado pelo harbour) e nao 7.71 (valor correto)
   nARREDONDADO = VAL (Str ((nQTDE * nPrecoUnit) + nFixRound, 12, 2))
  
return


func TrataEventosTeclado ()

   nKey = Inkey ()

   if nKey = 27
      Alert ('<<<Analise abortada pelo usuario>>>', { ' OK '} )
      return (.t.) // exit
   elseif nKey = 32
      Inkey (0)  // pausa
   end
   
   return (.f.) // ok


func ImprimeElementosVendasIOT ()
         
   // exibe o elemento de venda simulado do equipamento IOT, destacando o valor entre [] correspondente ao metodo IAT
   if cIAT_IOT = 'A'
      @ y,00 say 'prcuni=' + Alltrim (Str (nPrecoUnit, 6, 3)) + ;
               ' qt='    + Alltrim (Str (nQTDE, 7, nNumCasasDecimaisQtdIOT)) + ;
               '[arred=' + Alltrim (Str (nARREDONDADO, 12, 2)) + ;
               ']trunc=' + Alltrim (Str (nTRUNCADO,    12, 2)) + ;
               ' d='     + Alltrim (Str (nARREDONDADO - nTRUNCADO, 12, 2))
   else
      @ y,00 say 'prcuni=' + Alltrim (Str (nPrecoUnit, 6, 3)) + ;
               ' qt='    + Alltrim (Str (nQTDE, 7, nNumCasasDecimaisQtdIOT)) + ;
               ' arred=' + Alltrim (Str (nARREDONDADO, 12, 2)) + ;
               '[trunc=' + Alltrim (Str (nTRUNCADO,    12, 2)) + ;
               ']d='     + Alltrim (Str (nARREDONDADO - nTRUNCADO, 12, 2))
   end
   
   nCol = col () // guardar a ultima coluna, sera usado posteriormente 

   return


func GetPType (cSECTION, cVAR, cSTR, lUpper) // GetProtoTypeFile, trata secoes e campos no formato .INI
   local nIni, nFim, LF := Chr (13) + Chr (10), cStr_ := cStr
   
      if lUpper == nil
         lUpper = .t.
      end
   
      cStr := Upper (cStr); cVAR := Upper (cVAR); cSECTION := Upper (cSECTION)
   
      if Empty (nINI := AT (cSECTION, cSTR))
         return ('') // secao nao encontrada
      end
   
      if lUpper
         cStr := SubStr (cStr, nIni + Len (cSECTION))
      else
         cStr := SubStr (cStr_, nIni + Len (cSECTION))
      end
   
      if !Empty (nFIM := AT (']', cStr))
         cStr := SubStr (cStr, 1, nFim)
      end
   
      // ate aqui a string contem apenas a secao desejada
   
      cVAR = LF + cVAR + '=' // novo
   
      if Empty (nIni := AT (cVAR, Upper (cStr)))
         return ('') // variable not found
      end
   
      cStr := SubStr (cStr, nIni + Len (cVAR) )
   
   
      if !Empty (nIni := AT (LF, cStr)) // procure por fim de linha
         cStr = SubStr (cStr, 1, nIni - 1)
      end
   
return (Alltrim (cStr))
   
   
func SetPType (cSECTION, cVAR, cVALOR, cFILE) // SetProtoType, trata secoes e campos no formato .INI
   local cStr := MemoRead (cFILE), cSTR_TMP, LF := Chr (13) + Chr (10)
   local nIni, nFim, cStr_ := cStr, cVAR_ := cVAR, cSECTION_ := cSECTION
   
      // altd ()
   
      cStr := Upper (cStr); cVAR := Upper (cVAR); cSECTION := Upper (cSECTION)
   
      if Empty (nINI := AT (cSECTION, cSTR))
         // section not found
         // precisamos criar a secao e a variavel de configuracao
         cStr = cSECTION_ + LF + cVAR_ + '=' + cVALOR + LF + LF + cSTR_
         MemoWrit (cFILE, cStr)
         return (cStr)
      end
   
      nINI += LEN (cSECTION) // antes + 2 // nao considerar o LF
   
      cStr_TMP := SubStr (cStr, nIni)
   
      if Empty (nFIM := AT ('[', cStr_TMP))
         nFIM = Len (cStr)
      end
   
      // ate aqui a string contem apenas a secao desejada
      cSTR_SECAO = SUBSTR (cSTR, nINI, nFIM)
   
      cVAR = LF + cVAR + '=' // novo
   
      if Empty (nIni_VAR := AT (cVAR, cStr_SECAO))
         // variable not found                // lf=novo
         cSTR = SubStr (cStr_, 1, nINI - 1) + LF + cVAR_ + '=' + cVALOR + LF + ;
                SubStr (cStr_, nINI + 2) // +2 indica retirar o LF do inicio
         MemoWrit (cFILE, cStr)
         return ('')
      end
   
      // valor em maiusculo
      cStr_VALOR := SubStr (cStr,  nIni + nINI_VAR + Len (cVAR) - 1)  // 1="="
      
      // valor original (maiuscula e minuscula diferenciada)
      cStr_VALOR_:= SubStr (cStr_, nIni + nINI_VAR + Len (cVAR) - 1)  // 1="="
      
      cOLDLINE   := SubStr (cStr_, nINI + nINI_VAR - 1) // ate fim do arquivo
   
      // procure por fim de linha (LF)
      if !Empty (nIni_VALOR := AT (LF, SubStr (cOLDLINE, 2)))
         cStr_VALOR = SubStr (cStr_VALOR, 1,                   nIni_VALOR - (Len (cVAR)) ) // retira o LF, 1="="
         cStr_VALOR_= SubStr (cStr_VALOR_,1,                   nIni_VALOR - (Len (cVAR)) ) // retira o LF, 1="="
         cOLDLINE   = SubStr (cStr_,      nINI + nINI_VAR - 1, nINI_VALOR)                  // retira o LF
      end
   
      cNEWLINE = LF + cVAR_ + '=' + cVALOR
   
      if Empty (cValor)
         cNewLine = ''
      end
   
      cStr_ = Stuff (cStr_, nINI + nINI_VAR - 1, Len (cOldLine), cNewLine)
   
      if !(cStr_VALOR_ == cVALOR)
         MemoWrit (cFILE, cStr_)
      end
   
return (cStr_)
   

func GravaVar (cCampo, xDado)
   local cDado

   if VALTYPE (xDado) = 'N'
      cDado = Str (xDado, 14, 4)
   elseif VALTYPE (xDado) = 'D'
      cDado = DTOC (xDado)
   else
      cDado = xDado
   end
   SetPType ('[GERAL]', cCampo, Alltrim (cDado) + ',' + VALTYPE (xDado), 'SVG-IOT.INI')

return (nil)


func CargaVar (cCampo, xDado)
local xData_

   xData_ = GetPType ('[GERAL]', cCampo, MemoRead ('SVG-IOT.INI'))
   
   if Empty (xData_)
      return
   end

   xDado = xData_
   
   if (nPOS := AT (',', xDado)) <> 0
      cType = SubStr (xDado, nPOS + 1)
      xDado = SubStr (xDado, 1, nPOS - 1)
      if cType == 'N'
         xDado = Val (xDado)
      elseif cType == 'D'
         xDado = CTOD (xDado)
      end
   end

return (nil)

func Init_Windows_Terminal ()

   #include "wvtwin.ch"
   #include "hbgtinfo.ch"
   #include "hbgtwvg.ch"

   ****parametros iniciais do windows terminal
   REQUEST HB_GT_WVT
   REQUEST HB_GT_WVT_DEFAULT

   // request HB_GT_WIN
   REQUEST HB_LANG_PT
   REQUEST HB_CODEPAGE_PT850
      
   ***** CONFIGURACAO DE AMBIENTE DE TRABALHO
   HB_LANGSELECT ("PT")

   WVT_SETONTOP ()
   WVT_SetCodePage (255)

   *hb_gtInfo( HB_GTI_FONTNAME , "Lucida Console" )
   hb_gtInfo( HB_GTI_WINTITLE , "SVG-IOT - Simulador Vendas a Granel" )
   hb_gtInfo( HB_GTI_ALTENTER, .t.) // allow alt-enter for full screen
   hb_gtInfo( HB_GTI_CLOSABLE, .F. )
   hb_gtInfo( HB_GTI_MAXIMIZED, .t.)    // Get/Set Window's Maximized status (supported by: GTWVT)

   SET SCOREBOARD OFF

   SETMODE (43, 160)

   return 
