class ImagemSvg ():

    def sign(self, f):
        f = round (f + (5 / (10 ** 6)), 2)
        if f == 0:
            return 0
        return 1 if (f > 0) else -1

    def trunc(self, f, digits):
        sp = str(f + 0.00005).split('.')
        return float('.'.join([sp[0], sp[1][:digits]]))

    def roundSVG (self, f, n):
        if not (type (f) is float):
            f = float (f)
        # contorna o problema do "floating point trap" de muitos chips do mercado
        # ex. 0.575 * 13.40 = 7.70 (retornado pela linguagem) e nao 7.71 (valor correto)
        return (round (f + (5 / (10 ** (n + 4))), n))

    def ObtemElementosDasIteracoesDfe(self, arredondado, truncado, nSinal):

        self.elementos_vendas_dfe = []
        numIteracao = 0
        qtde_dfe = self.qtde
        requerAjuste = False
        trunc_dfe = 0
        arred_dfe = 0

        # realiza 1, 10 ou 100 iteracoes dependendo da precisao de numCasasDecimaisQtdDfe
        while (numIteracao < 10 * 10 ** (self.numCasasDecimaisQtdDfe - 3) and not requerAjuste):

            numIteracao += 1

            # incrementa ou decrementa uma unidade na ultima casa decimal informada pelo usuario
            qtde_dfe += (self.incrementaQtdDfe * nSinal)
            qtde_dfe = self.roundSVG(qtde_dfe, self.numCasasDecimaisQtdDfe)
            self.contadorTotalIteracoesDfe += 1

            # pega os valores totais das iteracoes ajustadas do DF-e pelos metodos arredondado e truncado
            trunc_dfe = self.trunc (qtde_dfe * self.preco_unit, 2)
            arred_dfe = self.roundSVG (qtde_dfe * self.preco_unit, 2)

            if (self.iat_dfe == 'T' and arredondado == trunc_dfe) or (self.iat_dfe == 'A' and truncado == arred_dfe):
                requerAjuste = True
                cIteracao = 'achou' + str(numIteracao)
                if numIteracao > 1:
                    self.requereramAjustesComMaisUmaIteracao += 1
            else:
                cIteracao = str(numIteracao)

            # adiciona um novo item na lista de elemento de vendas do DF-e ajustados
            self.elementos_vendas_dfe += [[cIteracao, qtde_dfe, arred_dfe, trunc_dfe, '']]

            if (self.iat_dfe == 'T' and trunc_dfe > arredondado) or (self.iat_dfe == 'A' and arred_dfe < truncado):
                # estourou valor, nao sera possivel realizar proximas iteracoes para este elemento de venda neste metodo
                break

        if numIteracao > self.numMaiorIteracao:
            self.numMaiorIteracao = numIteracao

        if not requerAjuste:
            mensagem = 'Erro, sem solucao apos "' + str(numIteracao) + '" iteracao(oes)'
            self.erroElementosNaoSolucionados += 1
        else:
            if trunc_dfe != arred_dfe:
                mensagem = 'Ajustado, porem com diferenca entre: BD x DF-e'
                self.contadorPossiveisDiferencasBD += 1
            else:
                mensagem = 'Ajustado OK'

        self.elementos_vendas_dfe[-1][4] = mensagem  # atualiza mensagem na ultima iteracao

        return (self.elementos_vendas_dfe)


    def simulaElementosVendas(self, master):

        self.elementos_vendas_iot = []
        self.qtde = self.qtde_de

        while (self.qtde <= self.qtde_ate):

            # pega os valores totais da venda do equipamento IOT pelos metodos arredondado e truncado
            truncado = self.trunc(self.qtde * self.preco_unit, 2)
            arredondado = self.roundSVG(self.qtde * self.preco_unit, 2)

            saldoInterpolacao = arredondado - truncado if (self.iat_iot == 'A') else truncado - arredondado
            saldoInterpolacao = self.roundSVG(saldoInterpolacao, 2)

            if abs(saldoInterpolacao) > 0:  # ha diferencas de valores entre os metodos IAT a serem ajustadas ?

                self.requereramAjustes += 1

                #if self.requereramAjustes == 1979:
                #    _a = 0

                # adiciona um novo item na lista elemento de vendas do Equipamento IOT
                self.elementos_vendas_iot += [[self.qtde, arredondado, truncado]]

                if abs(saldoInterpolacao) > 0.01:
                    self.contadorDifMaiorUmCentavos += 1

                # sign retorna - 1 se negativo, 0 para zero, e + 1 para numetos positivos
                self.elementos_vendas_iot[-1] += [self.ObtemElementosDasIteracoesDfe(arredondado, truncado, self.sign(saldoInterpolacao))]

            self.qtde += self.incrementaQtdIot
            self.qtde = self.roundSVG(self.qtde, self.numCasasDecimaisQtdIot)

            self.contadorTotalElementosIot += 1

            self.contadorBarra += 1
            master.update_barra_progresso_imagem (self)


    def __init__(self, master=None):

        # obtem valores digitados pelo usuario
        self.cenario_iat = master.cenario.get()
        self.preco_unit = self.roundSVG(master.prc_unitario.get(), 3)
        self.numCasasDecimaisQtdIot = int(master.qtde_iot.get())
        self.numCasasDecimaisQtdDfe = int(master.qtde_dfe.get())
        self.qtde_de = self.roundSVG(master.vendas_de.get(), 2)
        self.qtde_ate = self.roundSVG(master.vendas_ate.get(), 2)

        ###########################################################
        # prepara variaveis necessarias para emissao do relatorio #
        ###########################################################

        self.incrementaQtdIot  = 1 / (10 ** self.numCasasDecimaisQtdIot)  # incrementa a 2a, 3a ou 4a casa decimal da qtde para cada elemento de uma venda do equipamento IOT
        self.incrementaQtdDfe = 1 / (10 ** self.numCasasDecimaisQtdDfe)  # incrementa a 2a, 3a ou 4a casa decimal da qtde para cada elemento de uma venda de um documento fiscal eletronico (DF-e)

        if self.qtde_de == 0:
            self.qtde_de += self.incrementaQtdIot

        self.previsao_total_barra = (self.qtde_ate * 10 ** self.numCasasDecimaisQtdIot) - (self.qtde_de * 10 ** self.numCasasDecimaisQtdIot) + 1
        self.contadorBarra = 0

        # atualiza o display da barra de progresso a cada 2%
        self.fator_update_barra = int ((self.previsao_total_barra * 2) / 100)

        #barra = DoubleVar()

        if self.cenario_iat == '2':
            self.iat_iot = 'A'
            self.iat_dfe = 'T'
        else:  # self.cenario_iat = '3'
            self.iat_iot = 'T'
            self.iat_dfe = 'A'

        self.requereramAjustes = 0
        self.erroElementosNaoSolucionados = 0
        self.contadorTotalElementosIot = 0
        self.contadorTotalIteracoesDfe = 0
        self.numMaiorIteracao = 0
        self.requereramAjustesComMaisUmaIteracao = 0
        self.contadorDifMaiorUmCentavos = 0
        self.contadorPossiveisDiferencasBD = 0

        self.arredondado, self.truncado = 0, 0

        self.elementos_vendas_iot = []

        self.simulaElementosVendas (master)
