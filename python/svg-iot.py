# tkMessageBox → tkinter.messagebox
# tkColorChooser → tkinter.colorchooser
# tkFileDialog → tkinter.filedialog
# tkCommonDialog → tkinter.commondialog
# tkSimpleDialog → tkinter.simpledialog
# tkFont → tkinter.font
# Tkdnd → tkinter.dnd

from decimal import *
from tkinter import ttk
import Pmw
from tkinter.simpledialog import * # mesmo que: from tkSimpleDialog import *
import json
from imagemsvg import *
from xlsvg import *

class Application:

    def __init__(self, master=None):

        # master.title ('SVG-IOT - Simulador de Vendas a Granel - MIT License - by Leonardo Wascheck')   ctrl-/ comenta/descomenta um bloco

        self.fontePadrao = ('arial', '10')
        self.fonteBold = ('arial', '10', 'bold')
        self.fontePequena = ('arial', '8')

        line_pady = 4

        #################
        # Painel Titulo #
        #################

        self.quadro_titulo=Frame(master, borderwidth=1, relief=GROOVE, takefocus=0)
        self.linha_titulo=Frame(self.quadro_titulo, borderwidth=1, takefocus=0)
        Label(self.linha_titulo, text='Cenario do Estabelecimento Comercial', font=self.fonteBold).pack(side=LEFT, expand=YES)
        self.linha_titulo.pack(side=TOP, expand=YES, fill=BOTH, padx=8) # , pady=6)
        self.quadro_titulo.pack(side=TOP, expand=YES, fill=BOTH, padx=8, pady=6)

        ############################
        # Painel Entrada dos Dados #
        ############################

        self.quadro_dados=Frame(master, borderwidth=1, relief=GROOVE, takefocus=0, highlightthickness=2)

        # cenario IAT
        self.linha_cenario=Frame(self.quadro_dados, borderwidth=1, takefocus=1)
        Label(self.linha_cenario, text='Cenario IAT  ', width=50, anchor=W).pack(side=LEFT, expand=NO, fill=BOTH)
        self.cenario = Pmw.Counter(self.linha_cenario, autorepeat=0, buttonaspect=1, datatype='integer',
                                   increment=1, orient=HORIZONTAL, entryfield_value=2, entry_width=2,
                                   entryfield_validate={'validator': 'integer', 'min': 2, 'max': 3})
        self.cenario.focus_set()
        self.cenario.pack (side=LEFT)
        self.linha_cenario.pack(side=TOP, expand=YES, fill=BOTH, padx=8, pady=line_pady)

        # preco unitario
        self.linha_prc_unitario=Frame(self.quadro_dados, borderwidth=1)
        Label(self.linha_prc_unitario, text='Preço Unitario ', width=50, anchor=W).pack(side=LEFT, expand=NO, fill=BOTH)
        self.prc_unitario = Pmw.EntryField(self.linha_prc_unitario, labelpos='w', value='5.899', entry_width=6,
                                           label_text='',
                                           validate={'validator': 'real', 'min': 0.01, 'max': 200, 'minstrict': 1} ) # , modifiedcommand=self.valueChanged)
        self.prc_unitario.pack (side=LEFT)
        self.linha_prc_unitario.pack(side=TOP, expand=YES, fill=BOTH, padx=8, pady=line_pady)

        # Num Casas decimais Qtde IOT
        self.linha_qtde_iot=Frame(self.quadro_dados, borderwidth=1)
        Label(self.linha_qtde_iot, text='Numero Casas decimais da QTDE na venda Equipamento IOT', width=50, anchor=W).pack(side=LEFT, expand=NO, fill=BOTH)
        self.qtde_iot = Pmw.Counter(self.linha_qtde_iot, autorepeat=0, buttonaspect=1, datatype='integer',
                                    increment=1, orient=HORIZONTAL, entryfield_value=3, entry_width=2,
                                    entryfield_validate={'validator': 'integer', 'min': 2, 'max': 4})
        self.qtde_iot.pack (side=LEFT)
        self.linha_qtde_iot.pack(side=TOP, expand=YES, fill=BOTH, padx=8, pady=line_pady)

        # Num Casas decimais Qtde DFE
        self.linha_qtde_dfe=Frame(self.quadro_dados, borderwidth=1)
        Label(self.linha_qtde_dfe, text='Numero Casas decimais da QTDE do documento fiscal DF-e', width=50, anchor=W).pack(side=LEFT, expand=NO, fill=BOTH)
        self.qtde_dfe = Pmw.Counter(self.linha_qtde_dfe, autorepeat=0, buttonaspect=1, datatype='integer',
                                    increment=1, orient=HORIZONTAL, entryfield_value=3, entry_width=2,
                                    entryfield_validate={'validator': 'integer', 'min': 2, 'max': 4})
        self.qtde_dfe.pack (side=LEFT)
        self.linha_qtde_dfe.pack(side=TOP, expand=YES, fill=BOTH, padx=8, pady=line_pady)

        # Simular vendas DE  xxx litros
        self.linha_vendas_de=Frame(self.quadro_dados, borderwidth=1)
        Label(self.linha_vendas_de, text='Simular vendas DE  xxx litros  ', width=50, anchor=W).pack(side=LEFT, expand=NO, fill=BOTH)
        self.vendas_de = Pmw.EntryField(self.linha_vendas_de, labelpos='w', value='0.00', entry_width=6,
                                        label_text='',
                                        validate={'validator': 'real', 'min': 0.00, 'max': 200, 'minstrict': 0} ) # , modifiedcommand=self.valueChanged)
        self.vendas_de.pack (side=LEFT)
        self.linha_vendas_de.pack(side=TOP, expand=YES, fill=BOTH, padx=8, pady=line_pady)

        # Simular vendas ATE  xxx litros
        self.linha_vendas_ate=Frame(self.quadro_dados, borderwidth=1)
        Label(self.linha_vendas_ate, text='Simular vendas DE  xxx litros  ', width=50, anchor=W).pack(side=LEFT, expand=NO, fill=BOTH)
        self.vendas_ate = Pmw.EntryField(self.linha_vendas_ate, labelpos='w', value='100.00', entry_width=6,
                                         label_text='',
                                         validate={'validator': 'real', 'min': 0.01, 'max': 200, 'minstrict': 0} ) # , modifiedcommand=self.valueChanged)
        self.vendas_ate.pack (side=LEFT)
        self.linha_vendas_ate.pack(side=TOP, expand=YES, fill=BOTH, padx=8, pady=line_pady)

        # fecha painel Entrada de dados do usuario
        self.quadro_dados.pack(side=TOP, expand=YES, fill=BOTH, padx=8, pady=6)


        #################
        # Painel Botoes #
        #################

        self.quadro_botoes=Frame(master, borderwidth=1, relief=GROOVE)

        self.linha_botoes=Frame(self.quadro_botoes, borderwidth=1)

        self.simular_vendas = Button(self.linha_botoes, text='Simular Vendas', font=('calibri', '9'), width=18)
        #self.simular_vendas['text'] = 'Simular Vendas'
        #self.simular_vendas['font'] = ('calibri', '9')
        #self.simular_vendas['width'] = 18
        self.simular_vendas['command'] = self.simulaVendas
        self.simular_vendas.pack(side=LEFT, pady=line_pady, padx=10)

        self.sair = Button(self.linha_botoes, text='Cancelar', font=('calibri', '9'), width=12)
        #self.sair['text'] = 'Cancelar'
        #self.sair['font'] = ('calibri', '9')
        #self.sair['width'] = 12
        self.sair['command'] = self.quadro_botoes.quit
        self.sair.pack(side=LEFT, pady=line_pady, padx=10)

        self.linha_botoes.pack(padx=8, pady=line_pady)

        # fecha painel botoes
        self.quadro_botoes.pack(side=TOP, expand=YES, fill=BOTH, padx=8, pady=8) # side=TOP, expand=YES, fill=BOTH)


        ##########################
        # Painel Barra Progresso #
        ##########################

        self.quadro_barra=Frame(master, borderwidth=1, relief=GROOVE)

        self.linha_status_barra=Frame(self.quadro_barra, borderwidth=1)
                                                                # Salvando arquivo de vendas em planilha Excel...
        self.status_barra = Label (self.linha_status_barra, text='', font=self.fontePequena)
        self.status_barra.pack(side=LEFT)
        self.linha_status_barra.pack(side = TOP, expand = YES, fill = BOTH, padx = 8) # , pady = line_pady)

        self.linha_barra =Frame(self.quadro_barra, borderwidth=1)
        self.barraProgresso= ttk.Progressbar(self.linha_barra, variable=barra, maximum=100)
        self.barraProgresso.pack(side=LEFT, expand = YES, fill = BOTH)
        self.linha_barra.pack(side=LEFT, expand = YES, fill = BOTH, padx=8, pady=line_pady)

        # fecha painel barra
        self.quadro_barra.pack(side=TOP, expand=YES, fill=BOTH, padx=8, pady=line_pady) # side=TOP, expand=YES, fill=BOTH)

        self.resetaBarraProgresso ()

        self.carregaDados ()

    # reseta barra de progresso
    def resetaBarraProgresso (self):
        self.status_barra['text'] = ''
        barra.set(0)
        root.update()
        self.cenario.focus_set()

    def msg_barra_progresso (self, msg):
        self.status_barra['text'] = msg
        root.update()

    def update_barra_progresso_imagem (self, imagem):
        barra.set((100 * imagem.contadorBarra) / imagem.previsao_total_barra) # o numero tem de ser de 0 a 100
        if imagem.contadorBarra % imagem.fator_update_barra == 0:
            root.update()


    def is_valor_not_ok (self, valor, dec):
        return ('.' in valor and len (valor.split ('.')[1].rstrip ('0')) > dec) # rstrip retira os zeros a direita


    def validaDados (self):

        if self.is_valor_not_ok (self.prc_unitario.get (), 3):
            messagebox.showwarning("Aviso!", "Campo Preço unitario deve conter no maximo tres casas decimais.")
            return (True) # validou com erro

        if self.is_valor_not_ok (self.vendas_de.get(), 2):
            messagebox.showwarning("Aviso!", "Campo Simular Vendas DE deve conter no maximo duas casas decimais.")
            return (True) # validou com erro

        if self.is_valor_not_ok (self.vendas_ate.get(), 2):
            messagebox.showwarning("Aviso!", "Campo Simular Vendas ATE deve conter no maximo duas casas decimais.")
            return (True) # validou com erro

        if Decimal (self.vendas_ate.get()) < Decimal (self.vendas_de.get()):
            messagebox.showwarning("Aviso!", "Intervalo Vendas ATE nao pode ser menor que Vendas DE.")
            return (True) # validou com erro

        if Decimal (self.qtde_dfe.get()) < Decimal (self.qtde_iot.get()):
            messagebox.showwarning("Aviso!", "Numero de casas decimais para a QTDE do documento fiscal DF-e deve ser maior ou igual a da QTDE da venda Equipamento IOT.")
            return (True) # validou com erro

        return (False) # tudo ok


    def setDadosApplication (self, dado, valor):

        if   dado == 'venda_ate':
            self.vendas_ate.setentry (valor)
        elif dado == 'venda_de':
            self.vendas_de.setentry (valor)
        elif dado == 'numcasasdecimaisqtddfe':
            self.qtde_dfe.setentry (valor)
        elif dado == 'numcasasdecimaisqtdiot':
            self.qtde_iot.setentry (valor)
        elif dado == 'precounit':
            self.prc_unitario.setentry (valor)
        elif dado == 'cenario_iat':
            self.cenario.setentry (valor)

        root.update()


    def carregaDados (self):

        try:
            # Read JSON data into the datastore variable
            with open(filenameConfig, 'r') as f:
                dados_cenario = json.load(f)
        except FileNotFoundError:
            dados_cenario = dados_default

        for dado in dados_default['cenario']:
            try:
                #print (dado)
                if type (dados_cenario['cenario'][dado]) == type (dados_default['cenario'][dado]):
                    self.setDadosApplication (dado, dados_cenario['cenario'][dado])
                else:
                    raise KeyError
            except KeyError:
                self.setDadosApplication(dado, dados_default['cenario'][dado])


    def salvaDados (self):

        dados_cenario = dados_default

        # empacota dados_cenario
        for dado in dados_default['cenario']:

            valor = ''

            if dado == 'venda_ate':
                valor = self.vendas_ate.get()
            elif dado == 'venda_de':
                valor = self.vendas_de.get()
            elif dado == 'numcasasdecimaisqtddfe':
                valor = self.qtde_dfe.get()
            elif dado == 'numcasasdecimaisqtdiot':
                valor = self.qtde_iot.get()
            elif dado == 'precounit':
                valor = self.prc_unitario.get()
            elif dado == 'cenario_iat':
                valor = self.cenario.get()

            dados_cenario['cenario'][dado] = valor

        # Writing JSON data
        with open(filenameConfig, 'w') as f:
            json.dump(dados_cenario, f)


    def simulaVendas (self):

        if self.validaDados ():
            return

        self.salvaDados()

        self.simular_vendas['state'] = DISABLED
        self.sair['state'] = DISABLED

        self.msg_barra_progresso('Preparando imagem do relatorio...')
        imagem = ImagemSvg (self) # cria uma lista com todas as vendas Iot e ajustes Dfe

        self.msg_barra_progresso('Formatando vendas no formato planilha Excel...')

        XlSvg(self, imagem)

        self.simular_vendas['state'] = NORMAL
        self.sair['state'] = NORMAL

        self.resetaBarraProgresso ()


if __name__ == '__main__':


    root = Tk ()
    root.title ('SVG-IOT 1.0.0 - Simulador de Vendas a Granel - MIT License - by Leonardo Wascheck')
    root.option_add('*Entry*background', 'lightblue')
    root.option_add('*font', ('arial', '10')) # ('verdana', 10, 'bold'))

    barra = DoubleVar()
    filenameConfig = 'svg-iot.json'
    dados_default = {'cenario':
                         {"venda_ate": '100.00',
                          "venda_de": '0.00',
                          "numcasasdecimaisqtddfe": '3',
                          "numcasasdecimaisqtdiot": '3',
                          "precounit": '5.899',
                          "cenario_iat": '2'}
                     }
    display = Application (root)
    root.mainloop()
