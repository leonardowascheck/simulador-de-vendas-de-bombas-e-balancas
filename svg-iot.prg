/*
-------------------------------------------------
 SVG-IOT - SIMULADOR DE VENDAS A GRANEL NO VAREJO
-------------------------------------------------

UMA BREVE HISTORIA DO PROBLEMA DE ARREDONDAMENTO E TRUNCAMENTO NAS VENDAS A GRANEL NO VAREJO
=============================================================================================

Na automacao comercial a utilizacao de balancas digitais e de bombas de abastecimentos de combustiveis 
interligados a computadores faz parte do dia a dia da grande maioria dos estabelecimentos comerciais do 
varejo.  
Existem uma infinidade de marcas e modelos destes aparelhos no mercado, alguns modelos antigos e obsoletos
continuam sendo utilizado por alguns clientes, tornando a integracao com os aplicativos comerciais um 
tema complexo.
A partir de agora, irei me referenciar a estes aparelhos como "Equipamentos IOT".
Os Equipamentos IOT, reproduzem as vendas a granel e interagem com os aplicativos comerciais (PDV) que por 
sua vez geram e emitem os documentos fiscais eletronicos (DF-e), tais como, NF-e, NFC-e, CF-e e ECF, 
imprimem o extrato/danfe do cupom fiscal e enviam o XML para o site da SEFAZ, compartilhando essas 
informacoes entre os consumidores, empresas (estabelecimentos) e governos. 

Em 1998, o governo Geraldo Alckmin, do estado de Sao Paulo, com o intuito de reordenar o mercado varejista, 
instituiu a obrigatoriedade do ECF (emissor de cupom fiscal) e o cruzamento das informações fiscais entre 
Revendedores, distribuidores, transportadores e fabricantes de equipamentos para automação comercial. 
O sucesso dessa estratégia veio a ser replicado posteriormente em todo o país.  Logo depois, em meados
de 2010, o governo introduziu tambem ao varejo a obrigatoriedade da emissao da nota fiscal eletronica 
NF-e (modelo 55) em arquivo XML em substituicao da nota fiscal (modelo 1) em papel.  
Esta fase de transicao do papel para o digital trouxe muita instabilidade na operacao de venda, e um dos 
maiores problemas, dentre outros, estavam relacionados as divergencias de arredondamento e truncamento 
entre os Equipamentos IOT e os aplicativos comerciais para emissao dos DF-e.
Foi a partir dai que nasceu a ideia deu criar um aplicativo que simularia as vendas e me ajudasse a entender 
melhor os cenarios dos clientes para mitigar e/ou corrigir esses problemas de arredondamentos e 
truncamentos em campo.  Decidi chamar este aplicativo de SVG-IOT (Simulador de Vendas a Granel dos 
Equipamentos IOT para o varejo).  Na epoca, isso me ajudou bastante e por isso, eu gostaria de compartilhar 
este conhecimento com a comunidade de desenvolvedores de aplicativos comerciais, principalmente os que estao 
iniciando no mercado da automacao comercial.

Todas as vendas convertida pelos Equipamentos IOT, sao armezenadas em sua memoria e as informacoes basicas 
de um elemento de venda deve conter ao menos os campos: codigo do produto, IAT*, quantidade**, preco 
unitario e valor total**. 
* Em alguns modelos de bombas, o campo IAT pode estar presente de forma implicita (dentro das informacoes 
da venda) ou explicita (parametrizado na CPU do aparelho).  
O aplicativo comercial deve permitir a parametrizacao do IAT para compatibilizar a geracao dos DF-e com a
mesma regra do Equipamento IOT, principalmente nos documentos ECF convenio 09/09 e CF-e.
Preferencialmente o equipamento IOT deve estar parametrizado no modo Truncamento (T) pois muito estados
permitem apenas este metodo no DF-e.
** Em alguns modelos de balancas e bombas mecanicas, o campo qtde ou valor total do item podem nao fazer
parte das informacoes de vendas passas ao aplicativo comercial.  Mas ao menos um dos dois campos devem
estar presentes (qtde ou valor total).  Nestes casos, o aplicativo comercial precisa calcular ou a qtde 
(dividindo o valor total do item pelo preco unitario) ou o valor total do item (multiplicando a qtde pelo 
preco unitario).

Sei que muitos que estao lendo este documento ja devem estar familiarizado com o conceito do campo IAT 
(Indicador de Arredondamento e Truncamento) mas para aqueles que ainda nao conhecem, irei explicar como 
ele funciona e como isso afeta a operacao da venda e na emissao dos DF-e.
Para isso, vou dar uma revisada bem basica nos mecanismos de funcionamento de um Equipamento IOT.  
Este aparelho captura vendas analogicas e as converte em informacoes digitais se comunicando com os 
aplicativos comerciais via cabos seriais, USB, LAN ou Internet dependendo do modelo e marca.

Para que uma venda seja capturada corretamente, o equipamento IOT deve vincula-la de alguma forma a um 
produto.  No caso de uma balanca, eh necessario que o usuario/atendente informe o codigo do produto que 
sera pesado, ja em uma bomba de abastecimento, o numero da bomba deve estar previamente parametrizado 
a um determinado tanque/produto.
Agora sim, podemos descrever de forma bastante simplificada os passos de captura de uma venda realizada 
por um equipamento IOT:
1) O equipamento IOT identifica o produto
2) A venda analogica eh capturada e convertida para o digital
3) As informacoes basica da venda sao armazenadas na memoria 
4) O aplicativo comercial captura as informacoes da venda
5) O aplicativo comercial gera o DF-e a partir da venda capturada
6) O aplicativo envia o DF-e ao ECF/SAT/SEFAZ
7) O aplicativo obtem a resposta do envio para saber se o DF-e foi enviado com sucesso 

De maneira geral, é responsabilidade do Equipamento IOT calcular o valor total do item (multiplicando a 
qtde pelo preco unitario) e determinar o metodo IAT (exceto nos casos previstos nas notas acima).
Aqui temos um problema, o resultado desta multiplicacao muitas vezes é um numero real com mais de duas casas 
decimais mas, a legislacao permite que os documentos fiscais eletronicos (DF-e) sejam emitidos e impressos 
apenas com duas casas decimais.
Como nao existia um padrao quanto ao metodo de arredondamento e truncamento na transicao do documento em 
papel para o DF-e, a formatacao do campo valor total para duas casas decimais ficava a criterio de cada 
fabricante desses aparelhos.  Somente mais tarde foi que o governo se pocisionou e introduziu o campo IAT 
em alguns modelos de DF-e e tanto os fabricantes quanto os aplicativos comerciais tiveram que realizar 
as modificacoes necessarias.  

Resumindo, se voce conseguiu conciliar o metodo IAT do Equipamento IOT com o do DF-e, entao seus problemas
de arredondamento estarao resolvidos.  Entretando, como tudo no mundo de TI, as coisas nao sao tao simples.
Nem sempre será possivel atender aos cenario onde os IAT do Equipamento IOT e DF-e serão iguais.

Imagine um cenario onde sua bomba e/ou balanca esta parametrizada para arredondar (IAT=A) e o modelo do 
aparelho não possue uma forma de configurar o IAT na CPU.  E, para complicar, o seu estado só permite a 
emissao de DF-e pelo metodo de truncamento (IAT=T).  Neste caso, havera algumas vendas 
que serao capturadas pelo Equipamento IOT com um determinado valor que foi divulgado/exposto ao consumidor 
final atraves do display do aparelho.  Mas ao chegar no PDV, o aplicativo comercial pelas regras do DF-e 
daquele estado, emite o documento fiscal com diferenca de R$ 0,01 ou mais centavos.  De pouco em pouco estes 
centavos passam a ser um problema na operacao do caixa e da retaguarda.  Isso sem contar que se você atender 
um cliente exigente, ele podera (com todo direito) fazer uma reclamacao junto ao procon, e o estabelecimento 
pode tomar multa.
Mas tambem existe um outro cenario onde nao é possivel parametrizar o IAT na CPU do aparelho, a bomba/balanca 
esta parametrizada para truncar (IAT=T) e o estado ou o seu aplicativo só permite a emissao do DF-e pelo metodo 
arredondamento (IAT=A).

Veja alguns dos impactos na operacao (para citar alguns) apresentados nos dois cenarios citados acima:

NO PDV:
- O fechamento da bomba e do PDV nao batem e isso gera pequenas diferencas de caixas
- Dependendo do modelo do DF-e podera haver rejeicao do XML perante a SEZAZ ou comunicacao com o ECF
- A Reducao Z nao bate com as vendas do aplicativo comercial
- Problema de entendimento por parte do cliente pois o valor do display nao correponde ao do DF-e

NA RETAGUARDA:
- Os valores de vendas replicados do PDV para a retaguarda podem vir com diferencas
- Problema de divergencia no Livro de Movimentacao de Combustivel (LMC) e Sped - Bloco 1 Combustiveis
- Relatorio de vendas de documentos fiscais nao batem com os transmitidos no site da SEFAZ
- Problemas na geracao do Sped Icms/Ipi e Pis/Cofis pela retaguarda/ERP
- Problemas na geracao do Sintegra/GRF/GAM pela retaguarda/ERP

Nestes casos, a saida é fazer uma simulacao de uma nova venda (no aplicativo comercial) interpolando
quantidade ate encontrar um valor correspondente ao capturado pelo Equipamento IOT.  
Para isso, é necessario incrementar ou decrementar a quantidade em uma unidade na terceira ou quarta casa 
decimal, ate que o valor encontrado pelo metodo IAT do DF-e corresponda ao valor capturado do Equipamento 
IOT.  A cada incremento ou decremento iremos chama-lo de iteracoes da interpolacao.  Esta modificacao 
minuscula na qtde, tem efeito praticamente zero no estoque da empresa.  
 
A conciliacao do campo IAT entre o Equipamento IOT e o DF-e ainda nao é compreendido e/ou implementada por 
todos os desenvolvedores e a ideia deste documento eh tentar ajudar um pouco a este grupo de profissionais.
Nos Equipamentos IOT mais modernos existe a possbilidade de se parametrizar o campo IAT para 
arredondar (A) ou truncar (T).  Isso eh necessario pois muitas vezes um determinado ECF ou uma SEZAZ 
de um determinado estado permite a utilizacao apenas do metodo de truncamento (T).  
Para utilizacao correta do campo IAT, alem do conhecimento tecnico é necessario consultar a legislacao de
seu estado por modelo de documento fiscal.   
Se voce atuar somente em um estado e somente com uma marca de aparelho, a situacao é menos complexa mas se 
voce atuar em todos os estados do Brasil e operar com varias marcas e modelos será necessario prever a 
todos os cenarios.

Enfim, o SVG-IOT simula todas as vendas possiveis dentro de um intervalo em um determinado cenario e apresenta
os possiveis erros e alertas para auxiliar o desenvolvedor e dar insights para solucao do problema.  
Visto que esta é uma tarefa prioritaria e de muita importancia na automacao comercial.

Veja mais abaixo o topico "Como funciona o SVG-IOT".

OBJETIVO DO SVG-IOT
===================

O objetivo deste programa é simular as vendas dos equipamentos IOT, confronta-las com as do DF-e  
prevendo eventuais erros de arredondamento e truncamento que possam causar prejuizos na operacao tanto 
PDV quanto no ERP/RETAGUARDA.  O aplicativo tambem aponta novas qtdes para o DF-e, que com o uso da 
interpolacao, realiza iteracoes de incrementos/decrementos ate encontrar um valor exato que corresponda 
ao Equipamento IOT resolvendo essas divergencias.  Tudo isso, utilizando o cenario especifico do cliente.

Quis compartilhar meu conhecimento que adquiri trabalhando desde os primordios da automacao comercial pois
acredito que este trabalho possa ajudar a comunidade de desenvolvedores, principalmente aqueles que estao
iniciando na automacao comercial a evitar os mesmos erros que cometi.
Quem quiser contribuir na correcao e erros e indicando melhorias no SVG-IOT serao muito bem vindos.
Sua contribuiçao será muito bem vinda r em melhorias e nas eventuais correcoes de erros deste simulador.


// Entendendo e resolvendo problemas de Truncamento e Arredondamento nas vendas com documentos fiscais eletronicos (DF-e) com o simulador de vendas SVG-IOT.

-------------------------
Como funciona o SVG-IOT ?
-------------------------

O aplicativo Simulador de Vendas a Granel no Varejo (SVG-IOT), esta divido em 
tres partes:

1) Entrada de dados pelo usuario para geracao dos cenarios das vendas simuladas
2) Apresentacao do Relatorio dos elementos de vendas simulados
3) Apresentacao do Resultado das Analises dos Elementos de vendas

A seguir, Irei detalhar cada etapa do aplicativo.

1) Entrada de dados pelo usuario para geracao dos cenarios das vendas simuladas
-------------------------------------------------------------------------------

O usuario podera entrar com dados para parametrizar o cenario do cliente, podendo
formatar a qtde da venda IOT, numero de casas decimais da Qtde, escolher o intervalo 
das vendas e o metodo de arredondamento e truncamento para as simulacoes.

A seguir segue a descricao dos campos de entrada:

Cenario:
========
Existem quatro combinacoes possiveis do IAT para os equipamentos IOT e os DF-e o qual iremos denomina-los
de cenarios:

CENARIO               BOMBA/BALANCA         EQUIPAMENTO FISCAL/SEFAZ     
                (VENDA EQUIPAMENTO IOT)       (DOCUMENTO FISCAL DF-e)
   1*                       A                           A                
   2                        A                           T                
   3                        T                           A                
   4*                       T                           T                

*Note que nos cenarios 1 e 4 os IATs do euipamento IOT e DF-e sao equivalentes e 
nestas condicoes nao ocorrem divergencias de arredondamento e truncamento no 
calculo do valor total da venda.  Portanto, estes dois cenarios nao serao 
tratados neste aplicativo.
   
Ja para os cenarios 2 e 3, os metodos IAT sao diferentes, e o "Relatorio dos 
elementos de vendas simulados" ira tentar solucionar os problemas de arredondamento e 
truncamento conforme eles surjam.
O SVG-IOT aplica o algoritimo de interpolacao para tentar resolver os conflitos 
de valores gerados pelos Equipamentos IOT e DF-e.  Para isso, o aplicativo
a cada iteracao, incrementa (cenario 2) ou decrementa (cenario 3) a qtde do Df-e 
uma unidade na terceira ou quarta casa decimal ate encontrar um valor de venda 
do DF-e que correspondente ao do Equipamento IOT.  
Mas existem casos que mesmo apos a interpolacao nao é possivel solucionar/ajustar
um determinado elemento de venda.  Ao final do relatorio, o SVG-IOT reportara 
estes erros na linha "Numero de elementos impossivel solucionar o ajuste da 
Qtde do DF-e ".

Preco Unitario:
===============

O preco unitario é utilizado para se calcular o valor total da venda (VTV), onde VTV = preco unitario * qtde.
O usuario pode entrar com o preco unitario com ate tres casas decimais mas no varejo do Brasil, apenas 
Postos de Combustiveis estao autorizados a utilizar tres casas decimais.

Numero Casas deciamais QTDE na venda do Equipamento IOT:
========================================================

Cada marca e modelo de bombas ou balancas opera com um determinado numero de casas decimais para o campo
qtde.  As balancas tipicamente e alguns modelos do fabricante de bombas Wayne trabalham com duas casas 
decimais na geracao da venda.  
Ate o momento eu desconheco equipamentos IOT que formatam a qtde da venda com quatro casas decimais.
Entretanto, o SVG-IOT foi desenvolvido para simular vendas IOT com ate quatro casas decimais.

Numero Casas deciamais QTDE do documento fiscal DF-e:
=====================================================

Dependendo o modelo do documento fiscal de venda, o campo QTDE pode ser formatado para dois, tres, quatro
e ate seis casas decimais.  Entretanto, este aplicativo ira realizar os ajustes da QTDE para ate quatro
casas decimais.
Nota: O numero de casas decimais da QTDE do DF-e nao pode ser menor que o numero de casas decimais da 
QTDE do equipamento IOT.  Ate porque na pratica isso nunca acontece.  Na realidade, esta situacao poderia
ocorrer nos primeiros ECFs e que foram descontinuados pelo governo.

Simular Vendas DE e ATE xxxx Litros:
====================================

Entre com o intervalo DE e ATE das qtde vendas simuladas do equipamento IOT.  
O numero de elementos simulados dependera do intervalor e tambem do numero de 
casas decimais da Qtde Venda IOT.

2) Apresentacao do Relatorio dos elementos de vendas simulados
==============================================================

O relatorio gera os elementos de vendas do equipamento IOT e do DF-e separado
pelo delimitador "|".

Detalhando os elementos de vendas do equipamento IOT:
----------------------------------------------------
prcuni = Preco unitario
qt     = Qtde simulada do equipamento IOT
arred  = Valor total do IOT (prcuni * qt) - metodo arredondado
trunc  = Valor total do IOT (prcuni * qt) - metodo truncado
d      = diferenca apurada entre o valor arredondado e truncado (arred-trunc)
Note que, dependendo do cenario IAT o campo arred ou trunc estara delimitado 
por cochetes indicando se utilizado "A" ou "T".  Ex: [arred=10.00]  

Detalhando os elementos de vendas ajustados do DF-e:
----------------------------------------------------

Iteracao  = Numero da iteracao utilizada na tentativa de solucionar o possivel
            conflito de arredondamento e truncamento.  Caso for possivel
            resolver o problema sera exibido AchouN, onde N é a iteracao 
            que resolveu a diferenca. Caso contrario, sera exibido "Erro".
qtN       = Qtde ajustada do DF-e (incrementada/decrementada de acordo com o 
            numero de iteracao)
arredN    = Valor total do DF-e (prcuni * qtN) pelo metodo arredondado
truncN    = Valor total do DF-e (prcuni * qtN) pelo metodo truncado
dN        = diferenca apurada entre o valor arredondado e truncado (arred-trunc)
Note que, dependendo do cenario IAT o campo arred ou trunc estara delimitado 
por cochetes dependendo do metodo se "A" ou "T".  Ex: [arred=10.00]  

3) Apresentacao do Resultado das Analises dos Elementos de vendas

Nesta etapa é apresentado o sumario e alguns indicadores do relatorio de vendas.

Vale destacar o significado do alerta "Numero elementos ajustados porem c/possiveis diferencas entre BD x DF-e".
Mas antes vamos relembrar um conceito.  O valor total é sempre calculado multiplicando o preco unitario com a
qtde.  Note que o valor calculado por cada metodo de IAT podera resultar em valores diferencas.
Ex: O resultado pode ser 10,01 para o metodo de arredondamento e 10,00 para o metodo de truncamento.
Assim que o aplicativo fizer o ajuste da Qtde do DF-e, novos valores podem ser gerados pelo PDV e gravados no 
banco de dados do PDV e replicado ao ERP.  Caso o PDV nao estiver preparado para gravar o metodo IAT no banco 
de dados (BD) do aplicativo fiscal (AC), estes registros estarao passiveis de erros de arredondamentos na manuseio de relatorios
contabeis e fiscais que precisam estar fidedignos com os documentos fiscais eletronicos (DF-e) emitidos na SEFAZ.
O SVG-IOT consegue identificar estes possiveis erros de gravacao no BD da AC e alertar o usuario.
A melhor forma de contornar este problema é alterar o PDV para tratar o campo IAT junto com a venda.

Outro indicador importante é o "Numero de elementos impossivel solucionar o ajuste da Qtde do DF-e", o qual mostra
os elementos que requereram ajustes mas que a interpolacao nao conseguiu resolver atraves das iteracoes de incrementos
e decrementos.  

----------------------


ALERTAS COM BOMBAS VENDENDO COM PRECO UNITARIO MAIOR QUE R$ 5,000 POR LITRO
---------------------------------------------------------------------------

Testei o SVG-IOT com varios cenarios tentando prever impactos na emissao de DF-e no mundo real.
Fiz os testes com os seguintes campos de entrada:
Entre com o cenario IAT...............................: 2 ou 3
Preco Unitario........................................: R$ 5,899
Numero Casas decimais da QTDE na venda Equipamento IOT: 3
Numero Casas decimais da QTDE do documento fiscal DF-e: 3
Simular vendas DE  xxx litros ........................: 0
Simular vendas ATE xxx litros ........................: 100

Neste cenario, identifiquei que o sistema comecou a apresentar varios alertas "Ajustado, porem com diferenca 
entre: BD x DF-e".  Caso voce trabalhe com Postos de Combustiveis, a chance de voce ter problemas na geracao dos 
arquivos Sped e Sintegra é muito grande.
Portanto, recomendo que voce modifique a sua aplicacao comercial em uma das seguintes formas:
a) Alterar o seu aplicativo comercial quanto o ERP para tratar o campo IAT no seu banco de dados 
b) Alterar o seu aplicativo comercial quanto o ERP para tratar o campo Qtde com 4 casas decimais   

Nota: Fazendo novamente os testes acima mas modificando o campo Numero Casas Decimais da Qtde do DF-e para 4 casas 
decimais os alertas de diferencas entre BD x DF-e pararam de ser gerados.

ERROS COM BOMBAS VENDENDO COM PRECO UNITARIO MAIOR QUE R$ 10,000 POR LITRO
----------------------------------------------------------------------------------

Depois de realizar os testes com preco unitario maior que R$ 5,000, resolver testar com preco unitario maior
que R$ 10,000.  Veja o resultado a seguir.
Fiz os testes com os seguintes campos de entrada:
Entre com o cenario IAT...............................: 2 ou 3
Preco Unitario........................................: R$ 10,899
Numero Casas decimais da QTDE na venda Equipamento IOT: 3
Numero Casas decimais da QTDE do documento fiscal DF-e: 3
Simular vendas DE  xxx litros ........................: 0
Simular vendas ATE xxx litros ........................: 100

Neste cenario, identifiquei que o sistema comecou a apresentar varios erros "Numero de elementos impossivel 
solucionar o ajuste da Qtde do DF-e".  Note que, quando os precos das bombas de combustiveis chegarem a este valor
havera um caos para os aplicativos comercial que utilizam tres casas decimais no campo Qtde do DF-e.
Neste caso, havera rejeicao do XML pelo SEFAZ ou travamento no ECF.
A unica forma de contornar esta situacao é modificando a sua aplicacao comercial quanto o ERP para tratar o campo 
Qtde com 4 casas decimais.

Nota: Fazendo novamente os testes acima mas modificando o campo Numero Casas Decimais da Qtde do DF-e para 4 casas 
decimais os alertas de diferencas entre BD x DF-e pararam de ser gerados.



---------------------------------------------------------
Problemas encontrados em Bares, Restaurantes e Similares:
---------------------------------------------------------

ERROS COM BALANCAS VENDENDO COM DUAS CASAS DECIMAIS NA QTDE IOT
---------------------------------------------------------------

O problema de arredondamento e truncamento da da balanca é mais conhecido pelo fato que muitos modelos operam
no formato de duas casas decimais e o preco unitario do KG é passa os R$ 10,00, as vezes passando de R$ 100,00
o que intensifica ainda mais a situacao.

Realizei os testes com preco unitario de R$ 69,900, e o problema ocorre em praticamente todos os elementos de vendas.
Fiz os testes com os seguintes campos de entrada:
Entre com o cenario IAT...............................: 2 ou 3
Preco Unitario........................................: R$ 69,90
Numero Casas decimais da QTDE na venda Equipamento IOT: 2
Numero Casas decimais da QTDE do documento fiscal DF-e: 3
Simular vendas DE  xxx litros ........................: 0
Simular vendas ATE xxx litros ........................: 100

Neste cenario, praticamente para todos os elementos de vendas ocorreram erros sem ser possivel fazer o ajuste.
Muitas software houses resolvem este problema recalculando a Qtde como sendo o valor total (gerado pela balanca)
divido pelo preco unitario.  Mas mesmo assim, esta solucao pode levantar suspeita por parte do consumidor, uma
vez que as diferencas ajustas na Qtde do DF-e pode chegar a decimos ou centisimos e nao a milesimos ou decamilesimos
como o proposto por este aplicativo.
Mais uma vez, para contornar esta situacao é necessario a modificacao da aplicacao comercial e do ERP para tratar o 
campo Qtde com 4 casas decimais.
Nota: Fazendo novamente os testes acima mas modificando o campo Numero Casas Decimais da Qtde do DF-e para 4 casas 
decimais os erros pararam mas foram gerados alertas de diferencas entre BD x DF-e.


Conclusao:
----------

Os problemas de arredondamento e truncamento na automacao comercial com vendas a granael sao inevitaveis mas mesmo assim � possivel mitigar ou ate
mesmo eliminar este problemas caso algumas medidas forem tomadas.

As solucoes possiveis mitigar estes problemas sao:
- Quando possivel, parametrizar os campos IAT e numero de qtde decimais das bombas/balancas (consultar manual do fabricante)
- Parametrizar os campos IAT da AC e do documento fiscal de acordo com o IAT da bomba/balanca
- Utilizar 4 casas decimais na qtde do documento fiscal
- Utilizar o algoritimo de interpolacao desta simulador de vendas a granel


CENARIOS QUANTO CONFIGURACAO DO IAT (A=arredondamento, T=truncamento)

CENARIO               BOMBA/BALANCA         EQUIPAMENTO FISCAL/SEFAZ     SOLUCAO
                    (VENDA GRANEL IOT)       (DOCUMENTO FISCAL DF-e)
   1                        A                           A                METODOS SIMILARES, PORTANTO NAO PRECISA SER TRATADO
   2                        A                           T                CENARIO TRATADO POR ESTE PROGRAMA
   3                        T                           A                CENARIO TRATADO POR ESTE PROGRAMA
   4                        T                           T                METODOS SIMILARES, PORTANTO NAO PRECISA SER TRATADO

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

   altd ()

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
         // altd ()
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
