# Bem vindo ao SVG-IOT - Simulador de Vendas a Granel no Varejo 

O Simulador de Vendas a Granel de bombas e balancas (Equipamentos IOT) é
um software de dominio publico desenvolvido em liguagem Harbour 3.0 de facil
entendimento.

# Conteudo 

1. [Objetivo do SVG-IOT](#objetivo-do-svg-iot)
2. [Uma Breve Historia do Arredondamento e Truncamento nas Vendas do Varejo](#uma-breve-historia-do-Arredondamento-e-truncamento-nas-vendas-do-varejo)
3. [Como funciona o SVG-IOT ?](#como-funciona-o-svg-iot-?)
4. [Diagnosticando Problemas Criticos em Postos de Combustiveis](#diagnosticando-problemas-criticos-em-postos-de-combustiveis)
5. [Diagnosticando Problemas Criticos em Padarias, Lanchonetes e Supermercados](#diagnosticando-problemas-criticos-em-padarias,-Lanchonetes-e-supermercados)
6. [Conclusao](#conclusao)

---

# Objetivo do SVG-IOT

O objetivo deste programa é simular as vendas de balancas digitais e bombas de abastecimentos de combustiveis
interligadas a computadores, confronta-las com as dos documentos fiscais eletronicos (DF-e) prevendo eventuais erros 
de arredondamento e truncamento que possam causar prejuizos na operacao tanto PDV quanto no ERP/RETAGUARDA.  
O aplicativo tambem aponta/ajusta novas qtdes para o DF-e, que com o uso da interpolacao, realiza iteracoes de 
incrementos/decrementos ate encontrar um valor exato que corresponda ao Equipamento IOT resolvendo essas divergencias.  
Tudo isso, utilizando o cenario especifico do cliente.

Quis compartilhar meu conhecimento que adquiri trabalhando desde os primordios da automacao comercial pois
acredito que este trabalho possa ajudar a comunidade de desenvolvedores, principalmente aqueles que estao
iniciando na automacao comercial a evitar os mesmos erros que cometi.
Quem quiser contribuir na correcao e erros e indicando melhorias no SVG-IOT serao muito bem vindos.

---

# Uma Breve Historia do Arredondamento e Truncamento nas Vendas do Varejo

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
Foi a partir dai que nasceu a ideia de eu criar um aplicativo que simularia as vendas e me ajudasse a entender 
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
* Em alguns modelos de balancas e bombas mecanicas, o campo qtde ou valor total do item podem nao fazer
parte das informacoes de vendas passadas ao aplicativo comercial.  Mas ao menos um dos dois campos devem
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

### Ciclo de vida simplificado de uma venda capturada por um Equipamento IOT:
* O equipamento IOT identifica o produto
* A venda analogica eh capturada e convertida para o digital
* As informacoes basica da venda sao armazenadas na memoria 
* O aplicativo comercial captura as informacoes da venda
* O aplicativo comercial gera o DF-e a partir da venda capturada
* O aplicativo envia o DF-e ao ECF/SAT/SEFAZ
* O aplicativo obtem a resposta do envio para saber se o DF-e foi enviado com sucesso 

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

### NO PDV:
* O fechamento da bomba e do PDV nao batem e isso gera pequenas diferencas de caixas
* Dependendo do modelo do DF-e podera haver rejeicao do XML perante a SEZAZ ou comunicacao com o ECF
* A Reducao Z nao bate com as vendas do aplicativo comercial
* Problema de entendimento por parte do cliente pois o valor do display nao correponde ao do DF-e

### NA RETAGUARDA:
* Os valores de vendas replicados do PDV para a retaguarda podem vir com diferencas
* Problema de divergencia no Livro de Movimentacao de Combustivel (LMC) e Sped - Bloco 1 Combustiveis
* Relatorio de vendas de documentos fiscais nao batem com os transmitidos no site da SEFAZ
* Problemas na geracao do Sped Icms/Ipi e Pis/Cofis pela retaguarda/ERP
* Problemas na geracao do Sintegra/GRF/GAM pela retaguarda/ERP

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

Veja mais abaixo o topico [Como funciona o SVG-IOT](#como-funciona-o-svg-iot-?).

---

# Como funciona o SVG-IOT ?

O aplicativo Simulador de Vendas a Granel no Varejo (SVG-IOT), esta divido em 
tres partes:

1. [Entrada de dados pelo usuario](#entrada-de-dados-pelo-usuario)
2. [Apresentacao do Relatorio dos elementos de vendas simulados](#apresentacao-do-relatorio-dos-elementos-de-vendas-simulados)
3. [Apresentacao do Resultado das Analises dos Elementos de vendas](#apresentacao-do-resultado-das-analises-dos-elementos-de-vendas)

A seguir, Irei detalhar cada etapa do aplicativo.

## 1. Entrada de dados pelo usuario 

O usuario podera entrar com dados para parametrizar o cenario do cliente, podendo
formatar a qtde da venda IOT, numero de casas decimais da Qtde, escolher o intervalo 
das vendas e o metodo de arredondamento e truncamento para as simulacoes.

A seguir segue a descricao dos campos de entrada:

### Cenario IAT:

Existem quatro combinacoes possiveis do IAT para os equipamentos IOT e os DF-e o qual iremos denomina-los
de cenarios:

Cenario IAT |    BOMBA/BALANCA<br>(VENDA EQUIPAMENTO IOT) | EQUIPAMENTO FISCAL/SEFAZ<br>  (DOCUMENTO FISCAL DF-e)
 :--------- | :----------------------- | :------------------------
1*      | A         | A
2       | A         | T
3       | T         | A
4*      | T         | T
 

Note que, nos cenarios 1 e 4 os IATs do euipamento IOT e DF-e sao equivalentes nos dois ambientes e 
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

### Preco Unitario:

O preco unitario é utilizado para se calcular o valor total da venda (VTV), onde VTV = preco unitario * qtde.
O usuario pode entrar com o preco unitario com ate tres casas decimais mas no varejo do Brasil, apenas 
Postos de Combustiveis estao autorizados a utilizar tres casas decimais.

### Numero Casas deciamais QTDE na venda do Equipamento IOT:

Cada marca e modelo de bombas ou balancas opera com um determinado numero de casas decimais para o campo
qtde.  As balancas tipicamente e alguns modelos do fabricante de bombas Wayne trabalham com duas casas 
decimais na geracao da venda.  
Ate o momento eu desconheco equipamentos IOT que formatam a qtde da venda com quatro casas decimais.
Entretanto, o SVG-IOT foi desenvolvido para simular vendas IOT com ate quatro casas decimais.

### Numero Casas deciamais QTDE do documento fiscal DF-e:

Dependendo do modelo do documento fiscal de venda, o campo QTDE pode ser formatado para dois, tres, quatro
e ate seis casas decimais.  Entretanto, este aplicativo ira realizar os ajustes da QTDE para ate quatro
casas decimais.
>Nota: O numero de casas decimais da QTDE do DF-e nao pode ser menor que o numero de casas decimais da 
QTDE do equipamento IOT.  Ate porque na pratica isso nunca acontece.  Na realidade, esta situacao poderia
ocorrer nos primeiros ECFs e que foram descontinuados pelo governo.

### Simular Vendas DE e ATE xxxx Litros:

Entre com o intervalo DE e ATE das qtde vendas simuladas do equipamento IOT.  
O numero de elementos simulados dependera do intervalo e tambem do numero de 
casas decimais da Qtde Venda IOT.

## 2. Apresentacao do Relatorio dos elementos de vendas simulados

O relatorio gera os elementos de vendas do equipamento IOT e do DF-e separado
pelo delimitador "|".

### Detalhando os elementos de vendas do equipamento IOT:
    prcuni = Preco unitario
    qt     = Qtde simulada do equipamento IOT
    arred  = Valor total do IOT (prcuni * qt) - metodo arredondado
    trunc  = Valor total do IOT (prcuni * qt) - metodo truncado
    d      = diferenca apurada entre o valor arredondado e truncado (arred-trunc)
    Nota: Note que, dependendo do cenario IAT o campo arred ou trunc estara delimitado 
    por cochetes indicando se utilizado "A" ou "T".  Ex: [arred=10.00]  

### Detalhando os elementos de vendas ajustados do DF-e:

    Iteracao  = Numero da iteracao utilizada para solucionar o possivel conflito de arredondamento e truncamento.  
    qtN       = Qtde ajustada do DF-e (incrementada/decrementada de acordo com o numero de iteracao "N")
    arredN    = Valor total do DF-e (prcuni * qtN) pelo metodo arredondado
    truncN    = Valor total do DF-e (prcuni * qtN) pelo metodo truncado
    dN        = diferenca apurada entre o valor arredondado e truncado (arred-trunc)
    Nota: Note que, dependendo do cenario IAT o campo arred ou trunc estara delimitado por cochetes dependendo do metodo se "A" ou "T".  Ex: [arred=10.00]  

## 3. Apresentacao do Resultado das Analises dos Elementos de vendas

Nesta etapa é apresentado o sumario e alguns indicadores do relatorio de vendas.

Vale destacar o significado do alerta "Numero elementos ajustados porem c/possiveis diferencas entre BD x DF-e".
Mas antes vamos relembrar um conceito.  O valor total é sempre calculado multiplicando o preco unitario com a
qtde.  Note que o valor calculado por cada metodo de IAT podera resultar em valores diferencas.
Ex: O resultado pode ser 10,01 para o metodo de arredondamento e 10,00 para o metodo de truncamento.
Assim que o aplicativo fizer o ajuste da Qtde do DF-e, novos valores podem ser gerados pelo PDV e gravados no 
banco de dados do PDV e replicado ao ERP.  Caso o PDV nao estiver preparado para gravar o metodo IAT no banco 
de dados (BD) do aplicativo fiscal (AC), estes registros estarao passiveis de erros de arredondamentos no manuseio de relatorios
contabeis e fiscais que precisam estar fidedignos com os documentos fiscais eletronicos (DF-e) emitidos na SEFAZ.
 O SVG-IOT consegue identificar estes possiveis erros de gravacao no BD da AC e alertar o usuario.
A melhor forma de contornar este problema é alterar o PDV para tratar o campo IAT junto com a venda.

Outro indicador importante é o "Numero de elementos impossivel solucionar o ajuste da Qtde do DF-e", o qual mostra
os elementos que requereram ajustes mas que a interpolacao nao conseguiu resolver atraves das iteracoes de incrementos
e decrementos.  

---

# Diagnosticando Problemas Criticos em Postos de Combustiveis

## ALERTAS COM BOMBAS VENDENDO COM PRECO UNITARIO MAIOR QUE R$ 5,000 POR LITRO

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
* Alterar o seu aplicativo comercial quanto o ERP para tratar o campo IAT no seu banco de dados 
* Alterar o seu aplicativo comercial quanto o ERP para tratar o campo Qtde com 4 casas decimais   

>Nota: Fazendo novamente os testes acima mas modificando o campo Numero Casas Decimais da Qtde do DF-e para 4 casas decimais os alertas de diferencas entre BD x DF-e pararam de ser gerados.

## ERROS COM BOMBAS VENDENDO COM PRECO UNITARIO MAIOR QUE R$ 10,000 POR LITRO

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

>Nota: Fazendo novamente os testes acima mas modificando o campo Numero Casas Decimais da Qtde do DF-e para 4 casas decimais os alertas de diferencas entre BD x DF-e pararam de ser gerados.

---

# Diagnosticando Problemas Criticos em Padarias, Lanchonetes e Supermercados

## ERROS COM BALANCAS VENDENDO COM DUAS CASAS DECIMAIS NA QTDE IOT

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
>Nota: Fazendo novamente os testes acima mas modificando o campo Numero Casas Decimais da Qtde do DF-e para 4 casas decimais os erros pararam mas foram gerados alertas de diferencas entre BD x DF-e.

---

# Conclusao:

Os problemas de arredondamento e truncamento na automacao comercial nas vendas a granel 
conbinados com as diversas marcas e modelos de Equipamentos IOT existentes sao inevitaveis mas é possivel mitigar ou ate mesmo eliminar estes erros caso algumas medidas forem tomadas:

* Quando possivel, parametrizar os campos IAT e numero de qtde decimais das bombas/balancas (consultar manual do fabricante) para garantir o mesmo metodo do aplicativo comercial
* Parametrizar os campos IAT da AC e do documento fiscal de acordo com o IAT da bomba/balanca IOT
* Utilizar 4 casas decimais na qtde do documento fiscal
* Utilizar o algoritimo de interpolacao do SVG-IOT conforme codigo fonte disponivel neste projeto

Espero que esta minha contribuicao possa te-lo ajudado de alguma forma.

---

This document Copyright &copy;&nbsp;2019&ndash;present [Leonardo Wascheck](https://www.linkedin.com/in/leonardo-wascheck-a9312bb3/)<br>
