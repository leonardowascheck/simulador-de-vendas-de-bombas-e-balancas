# Gera planilha Excel das vendas simuladas pelo SVG-IOT

from tkinter import messagebox
import os
import xlwt

class XlSvg ():

    def montaPlanilha (self, master, imagem):

        self.ezxf = xlwt.easyxf
        self.book = xlwt.Workbook()

        self.formataXFS (imagem)

        self.planilhaVendas (master, imagem)
        self.planilhaResultado (master, imagem)

        self.salvaXLS()

    def planilhaVendas (self, master, imagem):

        self.ws_vendas = self.book.add_sheet(self.SHEET_VENDAS)

        cols = self.HEADINGS_ELEMENTOS_IOT + self.HEADINGS_ELEMENTOS_SEP  + self.HEADINGS_ELEMENTOS_DFE

        rowx = 0 # inicia na primeira linha da planilha

        # grava cabecalhos principal - elementos iot
        self.ws_vendas.write_merge(rowx, rowx, 0, len (self.HEADINGS_ELEMENTOS_IOT) - 1, 'Elementos Vendas Simuladas-Equipamento IOT',
                          self.HEADINGS_TITULO_ELEMENTOS_XFS) # sheet.write_merge(top_row, bottom_row, left_column, right_column, 'Long Cell')
        # grava cabecalhos principal - elementos dfe
        self.ws_vendas.write_merge(rowx, rowx, len (self.HEADINGS_ELEMENTOS_IOT) + len (self.HEADINGS_ELEMENTOS_SEP), len (cols) - 1,
                          'Elementos Vendas Ajustados no DF-e',
                          self.HEADINGS_TITULO_ELEMENTOS_XFS) # sheet.write_merge(top_row, bottom_row, left_column, right_column, 'Long Cell')
        rowx += 1

        # grava cabecamentos das colunas IOT e DF-e (concatenadas em cols)
        for colx, value in enumerate(cols):
            # Define a largura da coluna de acordo com o tamanho do cabecalho + 2
            self.ws_vendas.col(colx).width = 256 * (45 if (colx == (len (cols) - 1)) else (len (value) + 2))
            self.ws_vendas.write(rowx, colx, value, self.ezxf () if value.strip() == '' else self.HEADINGS_COLS_ELEMENTOS_XFS)

        rowx += 1

        for elementos_iot in imagem.elementos_vendas_iot:  # elementos (qtde, arred, trunc)

            imagem.contadorBarra += 1
            master.update_barra_progresso_imagem (imagem)
            #print (imagem.contadorTotalElementosIot)
            #if imagem.contadorTotalElementosIot == 4919:
            #    _a = 0

            diferenca = imagem.roundSVG (elementos_iot [1] - elementos_iot[2], 2)
            cols_iot = [imagem.preco_unit] + [elementos_iot [0]] + [imagem.iat_iot] + [elementos_iot [1]] + [elementos_iot [2]] + [diferenca]

            # imprime a coluna do elementos IOT
            for colx_iot, value in enumerate(cols_iot):
                self.ws_vendas.write(rowx, colx_iot, value, self.elemento_iot_xfs [colx_iot])

            # imprime as colunas dos elementos DF-e
            for elementos_dfe in elementos_iot [3]:  # elementos[3] = (iteracao, qtde, arred, trunc)

                diferenca = imagem.roundSVG (elementos_dfe [2] - elementos_dfe [3], 2)
                cols_dfe = [elementos_dfe[0]] + [elementos_dfe[1]] + [imagem.iat_dfe] + [elementos_dfe[2]] + [elementos_dfe[3]] + [diferenca] + [elementos_dfe[4]]

                # imprime as colunas dos elementos DF-e
                for colx_dfe, value in enumerate (cols_dfe):
                    self.ws_vendas.write(rowx, colx_iot + len (self.HEADINGS_ELEMENTOS_SEP) + colx_dfe + 1, value,
                                         self.erro_xfs if type (value) is str and 'erro' in value.lower() else self.elemento_dfe_xfs[colx_dfe])

                rowx += 1

        master.msg_barra_progresso('Salvando arquivo "' + self.FILE_NAME_XL + '"...')

        #print ('salvando arquivo....')


    def salvaXLS (self):

        try:
            self.book.save(self.FILE_NAME_XL)
            os.system('start excel.exe ' + self.FILE_NAME_XL)
        except PermissionError as erro:
            print(type(erro))  # instancia da excecao
            print(type(erro.args))
            print(erro.args)  # os argumentos ou seja, as mensagens da excecao
            print(erro)  # __str__ mensagem
            messagebox.showerror('Erro:',
                                 'O arquivo "' + self.FILE_NAME_XL + '" esta em uso pelo Excel ou por outro processo.')
        else:
            print('arquivo excel gerado com sucesso!')  # se chegou ate aqui entao nao houve excecao


    def imprime_linhas (self, linhas, titulo):

        self.ws_resultado.write_merge(self.rowx, self.rowx, 0, 1, titulo,
                          self.HEADINGS_TITULO_ELEMENTOS_XFS)
        self.rowx += 1

        # grava as linhas dos alertas e erros
        for value in linhas:
            for colx, cols in enumerate (value):
                if 'alerta' in cols.lower ():
                    text_xfs = self.ezxf (self.tipo_xfs ['alerta'])
                elif 'erro' in cols.lower ():
                    text_xfs = self.ezxf (self.tipo_xfs ['erro'])
                else:
                    text_xfs = self.text_normal_xfs [colx]
                self.ws_resultado.write(self.rowx, colx, cols, text_xfs)
            self.rowx += 1


    def planilhaResultado (self, master, imagem):

        self.ws_resultado = self.book.add_sheet(self.SHEET_RESULTADO )

        self.text_normal_xfs = [self.ezxf (self.tipo_xfs ['mensagem']),
                                self.ezxf (self.tipo_xfs ['normal']),
                                self.ezxf ()]

        self.ws_resultado.col(0).width = 256 * 73

        self.rowx = 0 # inicia na primeira linha da planilha

        linhas = [['Cenario do IAT: ',
                  imagem.cenario_iat, '(IAT IOT="' + imagem.iat_iot + '", IAT DF-e="' + imagem.iat_dfe + '")'],
        ['Preco unitario: ', '{:7.3f}'.format(imagem.preco_unit)],
        ['Numero Casas decimais da QTDE na venda Equipamento IOT: ', str (imagem.numCasasDecimaisQtdIot)],
        ['Numero Casas decimais da QTDE no documento fiscal DF-e: ', str (imagem.numCasasDecimaisQtdDfe)],
        ['Simular vendas DE  xxx litros: ', '{:6.2f}'.format(imagem.qtde_de)],
        ['Simular vendas ATE xxx litros: ', '{:6.2f}'.format(imagem.qtde_ate)]]

        self.imprime_linhas(linhas, 'Parametros de Entrada - Cenario do Usuario')

        linhas = [['Numero de elementos vendas IOT que requereram ajustes na Qtde do DF-e: ', str(imagem.requereramAjustes)],
        ['Numero de elementos vendas IOT que nao requereram ajustes na Qtde do DF-e: ', str(imagem.contadorTotalElementosIot - imagem.requereramAjustes)],
        ['', '------'],
        ['Total de elementos vendas IOT analisados: ', str(imagem.contadorTotalElementosIot)],
        ['', ''],
        ['Numero de iteracoes analisadas para verificacao de ajustes na Qtde Df-e: ', str(imagem.contadorTotalIteracoesDfe)],
        ['Numero de elementos que requereram ajustes na Qtde Df-e com mais de 1 iteracao: ', str(imagem.requereramAjustesComMaisUmaIteracao)],
        ['Numero da maior iteracao utilizada nos ajuestes da Qtde do Dfe: ', str(imagem.numMaiorIteracao)]]

        self.imprime_linhas(linhas, 'Resultado das Analises dos Elementos de vendas')

        linhas = [['ALERTA: Diferencas (arredondamento-truncamento) maior que 0,01: ', str(imagem.contadorDifMaiorUmCentavos)],
        ['ALERTA: Numero elementos ajustados porem c/possiveis diferencas entre BD x DF-e: ', str(imagem.contadorPossiveisDiferencasBD)],
        ['ERRO*: Numero de elementos impossivel solucionar o ajuste da Qtde do DF-e: ', str(imagem.erroElementosNaoSolucionados)]]

        self.imprime_linhas(linhas, 'Erros e Alertas encontrados na simulacao')


    def formataXFS (self, imagem):

        self.tipo_xfs = {
            'normal':   'align: wrap on, vert centre, horiz center',
            'selected': 'pattern: pattern solid, fore-colour light_yellow; align: wrap on, vert centre, horiz center',
            'mensagem': 'align: wrap on, vert centre',
            'erro':     'font: color_index red; align: wrap on, vert centre',
            'alerta':   'font: color_index light_orange; align: wrap on, vert centre',
        }                                   #yellow

        self.tipo_num_format_str = {
            'dec2': '#,##0.00',
            'dec3': '#,##0.000',
            'dec4': '#,##0.0000',
        }

        self.erro_xfs = self.ezxf(self.tipo_xfs['erro'])

        self.HEADINGS_TITULO_ELEMENTOS_XFS = self.ezxf('font: bold on; align: wrap on, vert centre, horiz center; pattern: pattern solid, fore-colour gray_ega')
        self.HEADINGS_COLS_ELEMENTOS_XFS = self.ezxf('font: bold on; align: wrap on, vert centre, horiz center; pattern: pattern solid, fore-colour gray25')

        xfs_arred = '   selected   ' if (imagem.iat_iot == 'A') else '   normal   '
        xfs_trunc = '   selected   ' if (imagem.iat_iot == 'T') else '   normal   '
        n = str(imagem.numCasasDecimaisQtdIot)

        self.elemento_iot_xfs = (
                '    normal               normal            normal     ' + xfs_arred + xfs_trunc + '   normal    ').split()
        self.elemento_iot_num = (
                '    dec3                 dec' + n + '    text             dec2               dec2              dec2     ').split()
        for x, value in enumerate(self.elemento_iot_xfs):
            try:
                self.elemento_iot_xfs[x] = self.ezxf(self.tipo_xfs[value],
                                num_format_str=self.tipo_num_format_str[self.elemento_iot_num[x]])
            except KeyError:
                self.elemento_iot_xfs[x] = self.ezxf(self.tipo_xfs[value])

        xfs_arred = '   selected   ' if (imagem.iat_dfe == 'A') else '   normal   '
        xfs_trunc = '   selected   ' if (imagem.iat_dfe == 'T') else '   normal   '
        n = str(imagem.numCasasDecimaisQtdDfe)

        self.elemento_dfe_xfs = (
                '  normal     normal            normal     ' + xfs_arred + xfs_trunc + '   normal    mensagem ').split()
        self.elemento_dfe_num = (
                '   text       dec' + n + '    text             dec2         dec2           dec2     text     ').split()
        for x, value in enumerate(self.elemento_dfe_xfs):
            try:
                self.elemento_dfe_xfs[x] = self.ezxf(self.tipo_xfs[value],
                                num_format_str=self.tipo_num_format_str[self.elemento_dfe_num[x]])
            except KeyError:
                self.elemento_dfe_xfs[x] = self.ezxf(self.tipo_xfs[value])

    def __init__(self, master=None, imagem=None):

        self.FILE_NAME_XL = 'vendas_simuladas_svg-iot.xls'

        self.HEADINGS_ELEMENTOS_IOT = ['Preco_Unit', 'Qtd_Iot', 'IAT_Iot', 'Arredondado', 'Truncado', 'Dif']
        self.HEADINGS_ELEMENTOS_SEP = ['']
        self.HEADINGS_ELEMENTOS_DFE = ['Iteracao',   'Qtd_Dfe', 'IAT_Dfe', 'Arredondado', 'Truncado', 'Dif', 'Mensagem']

        self.SHEET_VENDAS = 'Vendas Simuladas'
        self.SHEET_RESULTADO = 'Resultado Analises'

        imagem.contadorBarra = 0 # contador da evolucao da barra de progresso
        imagem.previsao_total_barra = imagem.requereramAjustes  # só serao gerados celulas que requereram ajustes

        self.montaPlanilha (master, imagem)

