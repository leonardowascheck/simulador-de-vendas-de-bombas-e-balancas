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

# Como funciona o SVG-IOT ?

O aplicativo Simulador de Vendas a Granel no Varejo (SVG-IOT), esta divido em 
tres partes:

1. [Entrada de dados pelo usuario](#entrada-de-dados-pelo-usuario)
2. [Apresentacao do Relatorio dos elementos de vendas simulados](#apresentacao-do-relatorio-dos-elementos-de-vendas-simulados)
3. [Apresentacao do Resultado das Analises dos Elementos de vendas](#apresentacao-do-resultado-das-analises-dos-elementos-de-vendas)

A seguir, Irei detalhar cada etapa do aplicativo.

## Entrada de dados pelo usuario 

O usuario podera entrar com dados para parametrizar o cenario do cliente, podendo
formatar a qtde da venda IOT, numero de casas decimais da Qtde, escolher o intervalo 
das vendas e o metodo de arredondamento e truncamento para as simulacoes.

A seguir segue a descricao dos campos de entrada:

### Cenario:

Existem quatro combinacoes possiveis do IAT para os equipamentos IOT e os DF-e o qual iremos denomina-los
de cenarios:

CENARIO               BOMBA/BALANCA         EQUIPAMENTO FISCAL/SEFAZ     
                (VENDA EQUIPAMENTO IOT)       (DOCUMENTO FISCAL DF-e)
   1*                       A                           A                
   2                        A                           T                
   3                        T                           A                
   4*                       T                           T                

host<br>platform | target<br>platform/compiler | target CPU
 :------- | :---------------- | :---------------------------------------
 linux    | linux/gcc         | (CPU cross-builds possible)
 linux    | linux/clang       | (CPU cross-builds possible)
 linux    | linux/icc         | (CPU cross-builds possible: x86, x86-64, ia64)
 linux    | linux/sunpro      | (CPU cross-builds possible: x86, x86-64)
 linux    | linux/open64      | (CPU cross-builds possible: x86-64, ia64, ...)
 linux    | wce/mingwarm      | arm
 linux    | wce/mingw         | x86
 linux    | win/mingw         | x86
 linux    | win/mingw64       | x86-64
 linux    | win/watcom        | x86
 linux    | os2/watcom        | x86
 linux    | dos/watcom        | x86
 linux    | dos/djgpp         | x86
 linux    | android/gcc       | x86
 linux    | android/gccarm    | arm
 linux    | vxworks/gcc       | (CPU cross-builds possible: x86, arm, mips, ppc)
 linux    | vxworks/diab      | (CPU cross-builds possible: x86, arm, mips, ppc, sparc)
 win      | win/clang         | x86
 win      | win/clang64       | x86-64
 win      | win/mingw         | x86
 win      | win/mingw64       | x86-64
 win      | win/msvc          | x86
 win      | win/msvc64        | x86-64
 win      | wce/mingwarm      | arm
 win      | wce/msvcarm       | arm
 win      | dos/djgpp         | x86    (on Windows x86 hosts only)
 win      | dos/watcom        | x86
 win      | os2/watcom        | x86
 win      | linux/watcom      | x86
 win      | android/gcc       | x86
 win      | android/gccarm    | arm
 win      | vxworks/gcc       | (CPU cross-builds possible: x86, arm, mips, ppc)
 win      | vxworks/diab      | (CPU cross-builds possible: x86, arm, mips, ppc, sparc)
 win      | cygwin/gcc        | x86
 win      | win/clang-cl      | x86    (experimental)
 win      | win/clang-cl64    | x86-64 (experimental)
 win      | win/icc           | x86    (experimental)
 win      | win/icc64         | x86-64 (experimental)
 win      | win/watcom        | x86    (experimental)
 win      | win/bcc           | x86    (deprecated)
 win      | win/bcc64         | x86-64 (deprecated)
 win      | win/iccia64       | ia64   (deprecated)
 win      | win/msvcia64      | ia64   (deprecated)
 win      | win/pocc          | x86    (deprecated)
 win      | win/pocc64        | x86-64 (deprecated)
 win      | wce/poccarm       | arm    (deprecated)
 os2      | os2/gcc           | x86
 os2      | os2/watcom        | x86
 os2      | win/watcom        | x86
 os2      | dos/watcom        | x86
 os2      | linux/watcom      | x86
 darwin   | darwin/clang      | (CPU cross-builds possible: x86, x86-64, unibin)
 darwin   | darwin/gcc        | (CPU cross-builds possible: x86, x86-64, ppc, ppc64, unibin)
 darwin   | darwin/icc        | (CPU cross-builds possible: x86, x86-64)
 darwin   | wce/mingwarm      | arm
 darwin   | wce/mingw         | x86
 darwin   | win/mingw         | x86
 darwin   | win/mingw64       | x86-64
 darwin   | dos/djgpp         | x86
 darwin   | android/gcc       | x86
 darwin   | android/gccarm    | arm
 bsd      | bsd/gcc           | (CPU cross-builds possible)
 bsd      | bsd/clang         | (CPU cross-builds possible)
 bsd      | bsd/pcc           | (experimental)
 bsd      | wce/mingwarm      | arm
 bsd      | wce/mingw         | x86
 bsd      | win/mingw         | x86
 bsd      | dos/djgpp         | x86
 hpux     | hpux/gcc          | (CPU cross-builds possible)
 qnx      | qnx/gcc           | (CPU cross-builds possible - not tested)
 beos     | beos/gcc          | x86
 hpux     | wce/mingwarm      | arm
 hpux     | wce/mingw         | x86
 hpux     | win/mingw         | x86
 hpux     | dos/djgpp         | x86
 minix    | minix/clang       | x86
 minix    | minix/gcc         | x86
 aix      | aix/gcc           | (CPU cross-builds possible: ppc, ppc64)
 sunos    | sunos/gcc         | (CPU cross-builds possible)
 sunos    | sunos/sunpro      | (CPU cross-builds possible: x86, x86-64, sparc32, sparc64)
 sunos    | wce/mingwarm      | arm
 sunos    | wce/mingw         | x86
 sunos    | win/mingw         | x86
 sunos    | dos/djgpp         | x86
 sunos    | vxworks/gcc       | (CPU cross-builds possible: x86, arm, mips, ppc)
 sunos    | vxworks/diab      | (CPU cross-builds possible: x86, arm, mips, ppc, sparc)


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

## Apresentacao do Relatorio dos elementos de vendas simulados

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

## Apresentacao do Resultado das Analises dos Elementos de vendas

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




# Diagnosticando Problemas Criticos em Postos de Combustiveis

# Diagnosticando Problemas Criticos em Padarias, Lanchonetes e Supermercados

# Conclusao:










# How to Donate

  You can donate to fund further maintenance of this fork:

  [Donate Now!](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=BPSZQYKXMQJYG)

# Maintainer contacts

  * [Twitter](https://twitter.com/vszakats)
  * [GitHub](https://github.com/vszakats)
  * [PGP](https://keybase.io/vszakats) [key](https://keybase.io/vszakats/key.asc)
  * [Homepage](https://vszakats.net/)

# How to Get

## Stable versions (non-fork/mainline)

### Harbour stable binary download

<https://github.com/vszakats/harbour-core/releases/tag/v3.0.0>

> NOTE: It is identical to the mainline stable release, but
> not supported or recommended by this fork.

### Harbour stable source download

<https://github.com/vszakats/harbour-core/archive/v3.0.0.zip>

## Unstable versions

> :bulb: TIP:
> [For](https://groups.google.com/forum/#!msg/harbour-users/2fwUzdKwpKA/32nI4WhZLfYJ)
> [users](https://groups.google.com/forum/#!msg/harbour-users/Ro99f8S6my0/KvfjhCx_jE4J)
> [contributing](.github/CONTRIBUTING.md) to development, it's recommended to follow [commits](https://github.com/vszakats/harbour-core/commits/master) and reading
> [ChangeLog.txt](ChangeLog.txt?raw=true).

### Harbour live source repository

You will need Git version control software installed on your system
and to issue this command (remove the `--depth` option to clone the
complete history &mdash; useful for development):

    git clone --depth=10 https://github.com/vszakats/harbour-core.git harbour-core

You can get subsequent updates using this command:

    git pull

### Harbour unstable sources

Download source archive from any of these URLs and unpack:

* <https://github.com/vszakats/harbour-core/archive/master.zip>
* <https://github.com/vszakats/harbour-core/archive/master.tar.gz>

### Harbour unstable binaries (updated after each commit)

#### Windows (MinGW, 64-bit hosted, 32/64-bit targets, 7-zip archive)

* <https://github.com/vszakats/harbour-core/releases/download/v3.4.0dev/harbour-snapshot-win.7z>

#### Mac (using Homebrew :beer:)

    brew install https://raw.githubusercontent.com/vszakats/harbour-core/master/package/harbour-vszakats.rb --HEAD

### Follow commits using:

* [Web browser](https://github.com/vszakats/harbour-core/commits/master)
* [RSS feed](https://github.com/vszakats/harbour-core/commits/master.atom)
* Any of the Git/GitHub client mobile/desktop apps

# How to Build

For all platforms you will need:

* Supported ANSI C89 compiler
* GNU Make (3.81 or upper)
* Harbour sources

## on Windows hosts

Platform specific prerequisites:

1. Windows 7 or upper system is recommended to *build* Harbour. (64-bit
   edition is also recommended to make things simpler)
2. Consider using the binary release. On Windows, this is easier and
   recommended for most use-cases. You can still rebuild specific contribs
   this way.
3. Make sure to have your C compiler of choice installed in `PATH`. Refer to
   your C compiler installation and setup instructions for details. Make sure
   no tools in your `PATH` belonging to other C compilers are interfering with
   your setup. Also avoid to keep multiple copies of the same compiler, or
   different versions of the same compiler in `PATH` at the same time. For the
   list of supported compilers,
   look up [Supported Platforms and C Compilers](#supported-platforms-and-c-compilers).
4. A native build of GNU Make is required. It is usually named
   `mingw32-make.exe`. It's distributed in MSYS2, mingw-w64 packages. You can
   find download links [here](#external-links).
   Unpack it to your `PATH` or Harbour source root directory, and run it as
   `mingw32-make`.

To build:

    $ mingw32-make

To test it, type:

    $ cd tests
    $ ..\bin\<plat>\<comp>\hbmk2 hello.prg
    $ hello

You should see `Hello, world!` on screen.

## on Windows hosts with POSIX shells (MSYS2)

To build:

    $ sh -c make

To test it, type:

    $ cd tests
    $ ..\bin\<plat>\<comp>\hbmk2 hello.prg
    $ hello

You should see `Hello, world!` on screen.

## on Linux hosts (possible cross-build targets: Windows, Windows CE, MS-DOS, OS/2)

To build:

    $ make [HB_PLATFORM=<...>]

To test it, type:

    $ cd tests
    $ ../bin/<plat>/<comp>/hbmk2 hello.prg
    $ ./hello

You should see `Hello, world!` on screen.

## on Darwin (Mac) hosts (possible cross-build targets: Windows)

Platform specific prerequisite:
   Xcode or Command Line Tools for Xcode installed

To build:

    $ make [HB_PLATFORM=<...>]

To test it, type:

    $ cd tests
    $ ../bin/<plat>/<comp>/hbmk2 hello.prg
    $ ./hello

You should see `Hello, world!` on screen.

> You can override default (host) architecture by adding
> values below to `HB_USER_CFLAGS`, `HB_USER_LDFLAGS` envvars,
> you can use multiple values:<br>
> <br>
> Intel 32-bit: `-arch i386`<br>
> Intel 64-bit: `-arch x86_64`<br>

## on FreeBSD hosts

Platform specific prerequisites:

1. You will need to have the developer tools installed.
2. Then you will need to install gmake and optionally bison:

        $ pkg install gmake bison

To build:

    $ gmake

To test it, type:

    $ cd tests
    $ ../bin/<plat>/<comp>/hbmk2 hello.prg
    $ ./hello

You should see `Hello, world!` on screen.

## on Minix hosts

Install GNU make from the Minix pkgsrc repository; for details see [here](http://wiki.minix3.org/doku.php?id=usersguide:installingbinarypackages).

Optionally, GCC may also be installed if you wish to use that instead
of Clang, the Minix system compiler.

## on other \*nix hosts

To build:

    $ gmake [HB_PLATFORM=<...>]

Or

    $ make [HB_PLATFORM=<...>]

To test it, type:

    $ cd tests
    $ ../bin/<plat>/<comp>/hbmk2 hello.prg
    $ ./hello

You should see `Hello, world!` on screen.

> For sunpro on Solaris:<br>
> If you have any GNU binutils stuff installed, do make sure `/usr/ccs/bin`
> (the location of the native Sun C compilation system tools) come *before*
> the GNU binutils components in your `$PATH`.


# How to Do a Partial Build

If you want to build only a specific part of Harbour, like one core library
or all core libraries, or all contrib packages, you have to do everything
the same way as for a full build, the only difference is that you first
have to go into the specific source directory you'd like to build. When
starting GNU Make, all components under that directory will be built:

    cd src/rtl
    <make> [clean]

If you want to rebuild one specific contrib package, use this:

## On \*nix systems

    $ cd contrib/<name>
    $ make.hb [clean] [custom hbmk2 options]

## On Windows

    $ cd contrib/<name>
    $ hbmk2 make.hb [clean] [custom hbmk2 options]

> Where `make.hb` and `hbmk2` must be in `PATH`.

# How to Create Packages for Distribution

## Source .tgz on \*nix

    $ package/mpkg_src.sh

## Binary .tgz on \*nix

    $ export HB_BUILD_PKG=yes
    $ make clean install

## Binary .deb on Linux

    $ fakeroot debian/rules binary

## Binary .rpm on Linux

    $ package/mpkg_rpm.sh

You can fine-tune the build with these options:

    --with static      - link all binaries with static libs
    --with localzlib   - build local copy of zlib library
    --with localpcre2  - build local copy of pcre2 library
    --with localpcre1  - build local copy of pcre1 library
    --without x11      - do not build components dependent on x11 (gtxwc)
    --without curses   - do not build components dependent on curses (gtcrs)
    --without slang    - do not build components dependent on slang (gtsln)
    --without gpllib   - do not build components dependent on GPL 3rd party code
    --without gpm      - build components without gpm support (gttrm, gtsln, gtcrs)

## Binary .rpm on Linux (cross-builds)

### for Windows

    $ package/mpkg_rpm_win.sh

### for Windows CE

    $ package/mpkg_rpm_wce.sh

## Binary .7z archive on Windows for all targets (except Linux)

    $ set HB_DIR_7Z=C:\7-zip\
    $ set HB_BUILD_PKG=yes

Then run build as usual with `clean install` options.
See: [How to Build](#how-to-build)


# How to Enable Optional Components

Certain Harbour parts &mdash; typically contrib packages &mdash; depend on
3rd party components. To make these Harbour parts built, you need to tell
Harbour where to find the headers for these 3rd party components.

On \*nix systems most of these 3rd party components will automatically
be used if installed on well-known standard system locations.

You only need to use manual setup if the dependency isn't available on your
platform on a system location, or you wish to use a non-standard location.
Typically, you need to do this on non-\*nix (e.g. Windows) systems for all
packages and for a few packages on \*nix which are not available via
official package managers (e.g. ADS Client).

Note that Harbour is tuned to use 3rd party **binary** packages in their
default, unmodified &mdash; "vanilla" &mdash; install layout created by their
official/mainstream install kits. If you manually move, rename, delete, add
files under the 3rd party packages' root directory, or use a source package,
the default Harbour build process (especially Windows implib generation)
might not work as expected.

You can set these environment variables before starting the build. Make sure
to adjust them to your own directories:

    HB_WITH_CURSES= (on \*nix systems and DJGPP, auto-detected on both)
    HB_WITH_GPM= (on Linux only)
    HB_WITH_PCRE2=C:\pcre2 (defaults to locally hosted copy if not found)
    HB_WITH_PCRE=C:\pcre (defaults to locally hosted copy if not found)
    HB_WITH_PNG=C:\libpng (defaults to locally hosted copy if not found)
    HB_WITH_SLANG= (on \*nix systems)
    HB_WITH_WATT= (on MS-DOS systems)
    HB_WITH_X11= (on \*nix systems)
    HB_WITH_ZLIB=C:\zlib (defaults to locally hosted copy if not found)

To explicitly disable any given components, use the value `no`. This may be
useful to avoid auto-detection of installed packages on \*nix systems. You
may also use the value `local` to force using the locally hosted copy
(inside Harbour source repository) of these packages, where applicable.
`nolocal` will explicitly disable using locally hosted copy.

See contrib-specific dependencies and build notes in the projects' `.hbp`
file and find occasional link notes inside their `.hbc` files.


> NOTES:
>
>    * you need to use path format native to your shell/OS
>    * don't put directory names inside double quotes
>    * use absolute paths

## Darwin (Mac)

1. Install [Homebrew](https://brew.sh/) :beer:
2. Install packages:

        $ brew install valgrind pcre pcre2 s-lang upx uncrustify optipng jpegoptim

3. Install [X11](https://www.xquartz.org/) (optional, for `gtxwc`)

        $ brew cask install xquartz


## Linux (.deb based distros: Debian, \*buntu)

You will need these base packages to build/package/test/use Harbour:

      bash git gcc binutils fakeroot debhelper valgrind upx uncrustify p7zip-full

You will need these packages to compile optional core Harbour features:

      for gtcrs terminal lib:    libncurses-dev
      for gtsln terminal lib:    libslang2-dev OR libslang1-dev
      for gtxwc terminal lib:    libx11-dev
      for console mouse support: libgpm-dev OR libgpmg1-dev

Optional, to override locally hosted sources:

      for zlib support:          zlib1g-dev
      for pcre2 (regex) support: libpcre2-dev
      for pcre1 (regex) support: libpcre3-dev

## Linux (.rpm based distros: openSUSE, Fedora, CentOS)

You will need these base packages to build/package/test/use Harbour:

      bash git gcc make glibc-devel rpm-build valgrind upx uncrustify p7zip

You will need these packages to compile optional core Harbour features:

      for gtcrs terminal lib:    ncurses-devel ncurses
      for gtsln terminal lib:    slang-devel slang
      for gtxwc terminal lib:    xorg-x11-devel OR XFree86-devel
      for console mouse support: gpm-devel OR gpm

## pacman based systems (Windows/MSYS2, Arch Linux)

For Windows/MSYS2 environment:

      git base-devel msys2-devel mingw-w64-{x86_64,i686}-toolchain upx uncrustify p7zip

Packages for optional core Harbour features:

      for gtcrs terminal lib:    ncurses
      for gtsln terminal lib:    slang
      for gtxwc terminal lib:    libx11
      for console mouse support: gpm

> NOTES:
>
>   * See [this](https://distrowatch.com/dwres.php?resource=package-management)
>       on package management in various distros.
>   * On openSUSE, if you want to build 32-bit Harbour on a 64-bit host,
>       install above packages with `-32bit` suffix, e.g. `slang-devel-32bit`

## OpenSolaris

    $ pkg install SUNWgit SUNWgcc SUNWgmake

## FreeBSD

If you want to use the `gtsln` library instead of `gtstd` or `gtcrs`, then you
also need to install `libslang`. If you installed the ports collection, then
all you need to do to install `libslang` is to run the following commands,
which may require that you run `su` first to get the correct permissions:

    $ pkg install libslang2


# Build Options

You can fine-tune Harbour builds with below listed environment variables.
You can add most of these via the GNU Make command-line also, using
`make VARNAME=value` syntax. All of these settings are optional and all
settings are case-sensitive.

## General

   - `HB_BUILD_VERBOSE=yes`

     Enable verbose build output. Redirect it to file by appending this to
     the build command: `> log.txt 2>&1`<br>
     Default: `no`

   - `HB_PLATFORM`             Override platform auto-detection
   - `HB_COMPILER`             Override C compiler auto-detection

     Set these only if auto-detection doesn't suit your purpose.

     See this for possible values:
     [Supported Platforms and C Compilers](#supported-platforms-and-c-compilers)<br>
     See also: `HB_CC*` settings.

   - `HB_BUILD_CONTRIBS=no [<l>]`

     Do not build any, or space separated `<l>` list of, contrib packages.
     Please note that packages which are dependencies of other &mdash;
     enabled &mdash; packages will still be built, unless their dependents
     are disabled as well.

   - `HB_BUILD_CONTRIBS=[<l>]`

     Build space separated `<l>` list of contrib libraries.
     Build all if left empty (default).

   - `HB_BUILD_STRIP=[all|bin|lib|no]`

     Strip symbols and debug information from binaries.
     Default: `no`

   - `HB_BUILD_3RDEXT=no`

     Enable auto-detection of 3rd party components on default system
     locations. Default: `yes`

   - `HB_BUILD_NOGPLLIB=yes`

     Disable components dependent on GPL 3rd party code, to allow using
     Harbour for nonfree/proprietary projects. Default: `no`

   - `HB_CCPATH=[<dir>/]`

     Used with non-\*nix gcc family compilers (and sunpro) to specify path
     to compiler/linker/archive tool to help them run from \*nix hosts as
     cross-build tools. Ending slash must be added.

   - `HB_CCPREFIX=[<prefix>]`

     Used with gcc compiler family to specify compiler/linker/archive tool
     name prefix.

   - `HB_CCSUFFIX=[<suffix>]`

     Used with gcc/clang compiler families to specify compiler/linker tool
     name suffix &mdash; usually version number.

   - `HB_INSTALL_PREFIX`

     Target root directory to install Harbour files.
     On \*nix systems the default is set to `/usr/local/`
     or `$(PREFIX)` if specified, and
     `/usr/local/harbour-<arch>-<comp>` for cross-builds.
     It's always set to `./pkg/<arch>/<comp>` when
     `HB_BUILD_PKG` is set to `yes`. On non-\*nix systems,
     you must set it to a valid directory when using
     `install`. Use absolute paths only.
     You have to use path format native to your shell.
     E.g. to specify `C:\dir` on Windows.

     > WARNING:
     >
     > Harbour is fully functionaly on all platforms, without installing it
     > to any other directory. On \*nix systems, if you must install, please
     > use a stable installer package instead.

## For developing Harbour itself

   - `HB_USER_PRGFLAGS`        User Harbour compiler options
   - `HB_USER_CFLAGS`          User C compiler options
   - `HB_USER_DCFLAGS`         User C compiler options (for dynamic libraries only)
   - `HB_USER_RESFLAGS`        User resource compiler options (on win, wce, os2)
   - `HB_USER_LDFLAGS`         User linker options for executables
   - `HB_USER_AFLAGS`          User linker options for libraries
   - `HB_USER_DFLAGS`          User linker options for dynamic libraries

   - `HB_BUILD_DEBUG=yes`

     Create debug build. Default: `no`

   - `HB_BUILD_OPTIM=no`

     Enable C compiler optimizations. Default: `yes`

   - `HB_BUILD_PKG=yes`

     Create release package. Default: `no`
     Requires `clean install` in root source dir.

   - `HB_BUILD_CONTRIB_DYN=yes`

     Create contrib dynamic libraries (in addition to static).
     Default: `no`,
     except Windows and darwin platforms, where it's `yes`.

   - `HB_BUILD_3RD_DYN=yes`

     Create dynamic libraries of vendored 3rd party libaries
     (in addition to static). Default: `no`

   - `HB_BUILD_SHARED=yes`

     Create Harbour executables in shared mode.
     Default: `yes` on non-\*nix platforms that support
     is and on \*nix when `HB_INSTALL_PREFIX` points to
     a system location, otherwise `no`.

   - `HB_BUILD_PARTS=[all|compiler|lib]`

     Build only specific part of Harbour.

   - `HB_BUILD_NAME=[<name>]`

     Create named build. This allows keeping multiple builds in parallel for
     any given platform/compiler. E.g. debug / release.

     > In current implementation it's appended to compiler directory name, so
     > all file-system/platform name rules and limits apply. (Back)slashes will
     > be stripped from the name though.

   - `HB_USER_LIBS=[<list>]`

     Add space separated `<list>` of libs to link process.
     Lib names should be without extension and path.
     You only need this in special cases, like CodeGuard build with win/bcc.

   - `HB_BUILD_LIBPATH`

     Use extra library path when building contrib packages. It will be passed
     to hbmk2 via its `-L` option, _after_ any other custom option.

   - `HB_INSTALL_IMPLIB=no`

     Copy import libraries created for external .dll dependencies to the
     library install directory in `install` build phase. Default: `yes`<br>
     For Windows and OS/2 targets only. Please note that this feature doesn't
     work with all possible binary distributions of 3rd party packages.
     We test only the official/mainstream ones. Also note that the generated
     implibs will require .dlls compatible with the ones used at build time.

   - `HB_INSTALL_3RDDYN=yes`

     Copy dynamic libraries of external .dll dependencies to the dynamic
     library directory in `install` build phase. Default: `no`

   - `HB_REBUILD_EXTERN=yes`

     Rebuild extern headers. It is meant for developers doing Harbour code
     modifications and releases. Default: `no`

   - `HB_REBUILD_PARSER=yes`

     Rebuild language parser sources. You only need this if your are Harbour
     core developer modifying grammar rules (.y). Requires GNU Bison 1.28 or
     upper in `PATH`. Default: `no`

   - `HB_BUILD_MODE=[cpp|c]`

     Set default build mode to C++ or C. Default: `c`

     This option serves only to test Harbour code base for issues revealed
     by stricter C++ compiler rules and/or for C/C++ interoperability issues.
     C++ mode is deprecated and not supported for production use.

   - `HB_BUILD_POSTRUN_HOST=[<l>]`

     Run space separated `<l>` list of commands after successfully finishing
     a build. Commands will be run in the host binary directory.

   - `HB_BUILD_POSTRUN=[<l>]`

     Run space separated `<l>` list of commands after successfully finishing
     a build. Commands will be run in the target binary directory if possible
     to run on the host platform.

## Cross-builds

You can build Harbour for target platforms different from host platform. E.g.
you can create Windows build on \*nix systems, Linux builds on Windows systems,
etc. It's also possible to build targets for different from host CPU
architectures. E.g. you can create Windows 64-bit build on 32-bit Windows
platform, or Linux x86-64 build on x86 hosts, or Linux MIPS build on x86 host,
etc.

Point this envvar to the directory where native Harbour executables for your
host platform can be found:

      HB_HOST_BIN=<path-to-harbour-native-build>\bin

If you leave this value empty, the make system will try to auto-detect it, so
in practice all you have to do is to create a native build first (no `install`
required), then create the cross-build. If you set this value manually, it may
be useful to know that `harbour`, `hbpp` and `hbmk2` executables are required
for a cross-build process to succeed.


# Build Examples

## on Windows 64-bit hosts

> NOTES:
>
> - All code below should be copied to batch files or typed at command-line.
> - Naturally, you will need to adapt path names to valid ones on your system.
> - You can use additional `clean`, `install` or `clean install` make
>   parameters depending on what you want to do.
> - To redirect all output to a log file, append this after the make command:
>   `> log.txt 2>&1`

```batchfile
:: MinGW-w64 LLVM/Clang via MSYS2 (x86 target)
set PATH=C:\msys64\mingw32\bin;C:\msys64\usr\bin;%PATH%
set HB_COMPILER=clang
mingw32-make
```

```batchfile
:: MinGW-w64 LLVM/Clang via MSYS2 (x64 target)
set PATH=C:\msys64\mingw64\bin;C:\msys64\usr\bin;%PATH%
set HB_COMPILER=clang64
mingw32-make
```

```batchfile
:: MinGW-w64 GCC via MSYS2 (x86 target)
set PATH=C:\msys64\mingw32\bin;C:\msys64\usr\bin;%PATH%
mingw32-make
```

```batchfile
:: MinGW-w64 GCC via MSYS2 (x64 target)
set PATH=C:\msys64\mingw64\bin;C:\msys64\usr\bin;%PATH%
mingw32-make
```

```batchfile
:: MinGW-w64 GCC (x86 target)
set PATH=C:\mingw\bin;%PATH%
mingw32-make
```

```batchfile
:: MinGW-w64 GCC (x64 target)
set PATH=C:\mingw64\bin;%PATH%
mingw32-make
```

```batchfile
:: MSVC 2017 or upper
:: For configuration, see:
::   https://docs.microsoft.com/cpp/build/setting-the-path-and-environment-variables-for-command-line-builds
:: Then:
mingw32-make
```

```batchfile
:: MSVC 2015 (x86 target)
call "%ProgramFiles(x86)%\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"
mingw32-make
```

```batchfile
:: MSVC 2015 (x64 target)
call "%ProgramFiles(x86)%\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86_amd64
mingw32-make
```

```batchfile
:: Open Watcom C/C++
set WATCOM=C:\watcom
set PATH=%WATCOM%\BINNT64;%WATCOM%\BINNT;%PATH%
set INCLUDE=%WATCOM%\H;%WATCOM%\H\NT;%WATCOM%\H\NT\DIRECTX;%WATCOM%\H\NT\DDK;%INCLUDE%
mingw32-make
```

```batchfile
:: LLVM/Clang-cl (pre-experimental)
call "%ProgramFiles(x86)%\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"
set PATH=%ProgramFiles(x86)%\LLVM 3.6.svn;%PATH%
mingw32-make
```

```batchfile
:: Intel(R) C++ (x86 target)
call "%ProgramFiles(x86)%\Intel\Compiler\11.1\054\bin\ia32\iclvars_ia32.bat"
mingw32-make
```

```batchfile
:: Intel(R) C++ (x64 target)
call "%ProgramFiles(x86)%\Intel\Compiler\11.1\054\bin\intel64\iclvars_intel64.bat"
mingw32-make
```

## on Windows 32-bit hosts

Same as 64-bit Windows, with the difference that you will have to change
`%ProgramFiles(x86)%` to `%ProgramFiles%` for 32-bit and mixed tools.
Building 64-bit targets requires a preceding 32-bit build and to do
a cross-build. It's recommended to use a 64-bit environment for Windows
development.

```batchfile
:: MinGW-w64 LLVM/Clang via MSYS2 (x86 target)
set PATH=C:\msys64\mingw32\bin;C:\msys64\usr\bin;%PATH%
set HB_COMPILER=clang
mingw32-make
```

```batchfile
:: MinGW-w64 LLVM/Clang via MSYS2 (x64 target)
:: (requires preceding build for x86 target)
set PATH=C:\msys64\mingw64\bin;C:\msys64\usr\bin;%PATH%
set HB_COMPILER=clang64
mingw32-make
```

```batchfile
:: MinGW-w64 GCC via MSYS2 (x86 target)
set PATH=C:\msys64\mingw32\bin;C:\msys64\usr\bin;%PATH%
mingw32-make
```

```batchfile
:: MinGW-w64 GCC via MSYS2 (x64 target)
:: (requires preceding build for x86 target)
set PATH=C:\msys64\mingw64\bin;C:\msys64\usr\bin;%PATH%
mingw32-make
```

```batchfile
:: MinGW-w64 GCC (x86 target)
set PATH=C:\mingw\bin;%PATH%
mingw32-make
```

```batchfile
:: MinGW-w64 GCC (x64 target)
:: (requires preceding build for x86 target)
set PATH=C:\mingw64\bin;%PATH%
mingw32-make
```

```batchfile
:: MSVC 2017 or upper
:: For configuration, see:
::   https://docs.microsoft.com/cpp/build/setting-the-path-and-environment-variables-for-command-line-builds
:: Then:
mingw32-make
```

```batchfile
:: MSVC 2015 (x86 target)
call "%ProgramFiles%\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"
mingw32-make
```

```batchfile
:: MSVC 2015 (x64 target)
:: (requires preceding build for x86 target)
call "%ProgramFiles%\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86_amd64
mingw32-make
```

```batchfile
:: MinGW GCC (Windows CE ARM target)
:: (requires Cygwin + preceding build for x86 target)
set PATH=C:\mingwce\opt\mingw32ce\bin;C:\cygwin\bin;%PATH%
:: optional:
set CYGWIN=nodosfilewarning
mingw32-make
```

```batchfile
:: Delorie GNU C for MS-DOS
set DJGPP=C:\djgpp\djgpp.env
set PATH=C:\djgpp\bin;%PATH%
mingw32-make
```

```batchfile
:: Open Watcom C/C++
set WATCOM=C:\watcom
set PATH=%WATCOM%\BINNT;%WATCOM%\BINW;%PATH%
set INCLUDE=%WATCOM%\H;%WATCOM%\H\NT;%WATCOM%\H\NT\DIRECTX;%WATCOM%\H\NT\DDK;%INCLUDE%
mingw32-make
```

```batchfile
:: Open Watcom C/C++ for MS-DOS
set WATCOM=C:\watcom
set PATH=%WATCOM%\BINNT;%PATH%
set INCLUDE=%WATCOM%\H
mingw32-make
```

```batchfile
:: Open Watcom C/C++ for OS/2
:: (requires preceding build for Windows target)
set WATCOM=C:\watcom
set PATH=%WATCOM%\BINNT;%WATCOM%\BINW;%PATH%
set INCLUDE=%WATCOM%\H;%WATCOM%\H\OS2
set BEGINLIBPATH=%WATCOM%\BINP\DLL
mingw32-make
```

```batchfile
:: Open Watcom C/C++ for Linux
:: (requires preceding build for Windows target)
set WATCOM=C:\watcom
set PATH=%WATCOM%\BINNT;%WATCOM%\BINW;%PATH%
set INCLUDE=%WATCOM%\LH
mingw32-make
```

```batchfile
:: LLVM/Clang-cl (pre-experimental)
call "%ProgramFiles%\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"
set PATH=%ProgramFiles%\LLVM 3.6.svn;%PATH%
mingw32-make
```

```batchfile
:: VxWorks GCC x86
:: (requires preceding build for Windows target)
wrenv -p vxworks-6.8
set HB_COMPILER=gcc
mingw32-make
```

```batchfile
:: VxWorks GCC ARM
:: (requires preceding build for Windows target)
wrenv -p vxworks-6.8
set HB_COMPILER=gcc
set HB_CPU=arm
set HB_BUILD_NAME=arm
mingw32-make
```

```batchfile
:: VxWorks Wind River Compiler x86
:: (requires preceding build for Windows target)
wrenv -p vxworks-6.8
set HB_COMPILER=diab
mingw32-make
```

```batchfile
rem Open Watcom C/C++
set WATCOM=C:\watcom
set PATH=%WATCOM%\BINP;%WATCOM%\BINW;%PATH%
set INCLUDE=%WATCOM%\H;%WATCOM%\H\OS2
set BEGINLIBPATH=%WATCOM%\BINP\DLL
os2-make
```

## on Linux hosts

```sh
# Open Watcom C/C++ for OS/2
# (requires preceding build for Linux target)
export WATCOM="/opt/lng/watcom"
export PATH="${WATCOM}/binl:$PATH"
export INCLUDE="${WATCOM}/h:${WATCOM}/h/os2"
export HB_BUILD_3RDEXT=no
make
```

## on \*nix hosts in general

```sh
make
```

```sh
# MinGW GCC for Windows x86
make HB_PLATFORM=win
```

```sh
# MinGW GCC for Windows CE ARM
make HB_PLATFORM=wce
```


# Build Your Own Harbour App

For all platforms you will need two things:

* Harbour binaries

    Either a Harbour binary distribution or a local Harbour build will be okay.
    If you're reading this text, it's likely you have one of these already.

* Supported ANSI C89 compiler

    Your compiler of choice has to be placed in the `PATH` &mdash; and
    configured appropriately according to instructions.
    If you use official Harbour binary distribution on Windows, you already
    have MinGW compiler embedded in the installation, which will automatically
    be used, so you don't have to make any extra steps here.

Use `hbmk2` to build your app from source. It's recommended to put it in the
`PATH` (e.g. by using `set PATH=C:\hb\bin;%PATH%` on Windows).

See `hbmk2` [documentation, with examples](utils/hbmk2/doc/hbmk2.en.md).


# Debugging Options

## Tracing

Build Harbour with:

    HB_BUILD_DEBUG=yes

Run app with:

    HB_TR_LEVEL=debug
    # to override default STDERR output:
    HB_TR_OUTPUT=<filename>
    # to enable additional system specific logging output,
    # OutputDebugString() on Windows, syslog() on \*nix systems:
    HB_TR_SYSOUT=yes

## Memory statistics/tracking

Build Harbour with:

    HB_USER_CFLAGS=-DHB_FM_STATISTICS

## Valgrind (on linux and darwin targets)

Build Harbour with:

    HB_BUILD_DEBUG=yes

Build app with:

    $ hbmk2 myapp -debug

Run app with:

    $ valgrind --tool=memcheck --leak-check=yes --num-callers=16 -v ./myapp 2> myapp.log

## CodeGuard (on win/bcc target only)

Build Harbour with:

    HB_USER_CFLAGS=-vG
    HB_USER_LIBS=cg32

## Harbour Debugger

Build app with:

    $ hbmk2 myapp -b -run

or run script with:

    $ hbrun myapp --hb:debug

Press `<Alt+D>` in the app.


# Supported Platforms and C Compilers

## You can override target platform auto-detection with these `HB_PLATFORM` values:

* linux    - Linux
* darwin   - macOS / iOS / tvOS
* bsd      - \*BSD
* android  - Android
* win      - MS Windows (Win9x deprecated)
* wce      - MS Windows CE
* dos      - MS-DOS (32-bit protected mode only)
             (MS-DOS compatible systems also work, like dosemu)
* os2      - OS/2 Warp 4 / eComStation
* aix      - IBM AIX
* hpux     - HP-UX
* sunos    - Sun Solaris / OpenSolaris
* qnx      - QNX (experimental)
* vxworks  - VxWorks (experimental)
* minix    - Minix 3 (experimental, tested on 3.2.1; earlier releases will not work)
* cygwin   - Cygwin (experimental)
* beos     - BeOS / Haiku (deprecated)

## You can override C compiler auto-detection with these `HB_COMPILER` values:

### linux
* gcc      - GNU C
* clang    - LLVM/Clang
* watcom   - Open Watcom C/C++
* icc      - Intel(R) C/C++
* sunpro   - Sun Studio C/C++
* open64   - Open64 C/C++

### darwin
* clang    - Apple LLVM/Clang
* gcc      - GNU C
* icc      - Intel(R) C/C++

### bsd
* gcc      - GNU C
* clang    - LLVM/Clang
* pcc      - Portable C Compiler (experimental)

### android
* gcc      - GNU C x86
* gccarm   - GNU C ARM

### win
* clang    - LLVM/Clang (5.0.0 and above)
* clang64  - LLVM/Clang x86-64 (5.0.0 and above)
* mingw    - MinGW GNU C (4.4.0 and above, 6.x or newer recommended)
* mingw64  - MinGW GNU C x86-64
* msvc     - Microsoft Visual C++ (2013 and above)
* msvc64   - Microsoft Visual C++ x86-64 (2013 and above)

### win (experimental)
* clang-cl - LLVM/Clang-cl
* clang-cl64 - LLVM/Clang-cl x86-64
* watcom   - Open Watcom C/C++
* icc      - Intel(R) C/C++
* icc64    - Intel(R) C/C++ x86-64

### win (deprecated)
* bcc      - Borland/CodeGear/Embarcadero C++ 5.5 and above
* bcc64    - Embarcadero C++ 6.5 and above
* pocc     - Pelles C 4.5 and above
* pocc64   - Pelles C x86-64 5.0 and above
* iccia64  - Intel(R) C/C++ IA-64 (Itanium)
* msvcia64 - Microsoft Visual C++ IA-64 (Itanium)

### wce
* mingw    - MinGW GNU C x86
* mingwarm - MinGW GNU C ARM (CEGCC 0.55 and above)
* msvcarm  - Microsoft Visual C++ ARM
* poccarm  - Pelles C ARM 5.0 and above (deprecated)

### dos
* djgpp    - Delorie GNU C
* watcom   - Open Watcom C/C++

### os2
* gcc      - EMX GNU C 3.3.5 or lower
* gccomf   - EMX GNU C 3.3.5 or upper
* watcom   - Open Watcom C/C++

### aix
* gcc      - GNU C

### hpux
* gcc      - GNU C

### sunos
* gcc      - GNU C
* sunpro   - Sun Studio C/C++

### qnx (experimental)
* gcc      - GNU C

### vxworks (experimental)
* gcc      - GNU C
* diab     - Wind River Compiler

### minix (experimental)
* clang    - LLVM/Clang
* gcc      - GNU C

### cygwin (experimental)
* gcc      - GNU C

### beos (deprecated)
* gcc      - GNU C


# Platform Matrix

 host<br>platform | target<br>platform/compiler | target CPU
 :------- | :---------------- | :---------------------------------------
 linux    | linux/gcc         | (CPU cross-builds possible)
 linux    | linux/clang       | (CPU cross-builds possible)
 linux    | linux/icc         | (CPU cross-builds possible: x86, x86-64, ia64)
 linux    | linux/sunpro      | (CPU cross-builds possible: x86, x86-64)
 linux    | linux/open64      | (CPU cross-builds possible: x86-64, ia64, ...)
 linux    | wce/mingwarm      | arm
 linux    | wce/mingw         | x86
 linux    | win/mingw         | x86
 linux    | win/mingw64       | x86-64
 linux    | win/watcom        | x86
 linux    | os2/watcom        | x86
 linux    | dos/watcom        | x86
 linux    | dos/djgpp         | x86
 linux    | android/gcc       | x86
 linux    | android/gccarm    | arm
 linux    | vxworks/gcc       | (CPU cross-builds possible: x86, arm, mips, ppc)
 linux    | vxworks/diab      | (CPU cross-builds possible: x86, arm, mips, ppc, sparc)
 win      | win/clang         | x86
 win      | win/clang64       | x86-64
 win      | win/mingw         | x86
 win      | win/mingw64       | x86-64
 win      | win/msvc          | x86
 win      | win/msvc64        | x86-64
 win      | wce/mingwarm      | arm
 win      | wce/msvcarm       | arm
 win      | dos/djgpp         | x86    (on Windows x86 hosts only)
 win      | dos/watcom        | x86
 win      | os2/watcom        | x86
 win      | linux/watcom      | x86
 win      | android/gcc       | x86
 win      | android/gccarm    | arm
 win      | vxworks/gcc       | (CPU cross-builds possible: x86, arm, mips, ppc)
 win      | vxworks/diab      | (CPU cross-builds possible: x86, arm, mips, ppc, sparc)
 win      | cygwin/gcc        | x86
 win      | win/clang-cl      | x86    (experimental)
 win      | win/clang-cl64    | x86-64 (experimental)
 win      | win/icc           | x86    (experimental)
 win      | win/icc64         | x86-64 (experimental)
 win      | win/watcom        | x86    (experimental)
 win      | win/bcc           | x86    (deprecated)
 win      | win/bcc64         | x86-64 (deprecated)
 win      | win/iccia64       | ia64   (deprecated)
 win      | win/msvcia64      | ia64   (deprecated)
 win      | win/pocc          | x86    (deprecated)
 win      | win/pocc64        | x86-64 (deprecated)
 win      | wce/poccarm       | arm    (deprecated)
 os2      | os2/gcc           | x86
 os2      | os2/watcom        | x86
 os2      | win/watcom        | x86
 os2      | dos/watcom        | x86
 os2      | linux/watcom      | x86
 darwin   | darwin/clang      | (CPU cross-builds possible: x86, x86-64, unibin)
 darwin   | darwin/gcc        | (CPU cross-builds possible: x86, x86-64, ppc, ppc64, unibin)
 darwin   | darwin/icc        | (CPU cross-builds possible: x86, x86-64)
 darwin   | wce/mingwarm      | arm
 darwin   | wce/mingw         | x86
 darwin   | win/mingw         | x86
 darwin   | win/mingw64       | x86-64
 darwin   | dos/djgpp         | x86
 darwin   | android/gcc       | x86
 darwin   | android/gccarm    | arm
 bsd      | bsd/gcc           | (CPU cross-builds possible)
 bsd      | bsd/clang         | (CPU cross-builds possible)
 bsd      | bsd/pcc           | (experimental)
 bsd      | wce/mingwarm      | arm
 bsd      | wce/mingw         | x86
 bsd      | win/mingw         | x86
 bsd      | dos/djgpp         | x86
 hpux     | hpux/gcc          | (CPU cross-builds possible)
 qnx      | qnx/gcc           | (CPU cross-builds possible - not tested)
 beos     | beos/gcc          | x86
 hpux     | wce/mingwarm      | arm
 hpux     | wce/mingw         | x86
 hpux     | win/mingw         | x86
 hpux     | dos/djgpp         | x86
 minix    | minix/clang       | x86
 minix    | minix/gcc         | x86
 aix      | aix/gcc           | (CPU cross-builds possible: ppc, ppc64)
 sunos    | sunos/gcc         | (CPU cross-builds possible)
 sunos    | sunos/sunpro      | (CPU cross-builds possible: x86, x86-64, sparc32, sparc64)
 sunos    | wce/mingwarm      | arm
 sunos    | wce/mingw         | x86
 sunos    | win/mingw         | x86
 sunos    | dos/djgpp         | x86
 sunos    | vxworks/gcc       | (CPU cross-builds possible: x86, arm, mips, ppc)
 sunos    | vxworks/diab      | (CPU cross-builds possible: x86, arm, mips, ppc, sparc)

Supported shells per host platforms:

* \*nix / POSIX shell
* win  / NT shell (`cmd.exe`)
* win  / POSIX shell (MSYS2 `sh.exe`)
* win  / MS-DOS shell (`command.com`)
* dos  / MS-DOS shell (`command.com`)
* dos  / POSIX shell (`bash.exe`)
* os/2 / OS/2 shell (`cmd.exe`)
* os/2 / POSIX shell (`bash.exe`)


# External Links

* C/C++ Compilers/Shells:

     * LLVM/Clang via MSYS2 [win, multi-platform, free software, open-source]
        * <https://msys2.github.io/>
        * MinGW-w64 above + `pacman -S mingw-w64-{i686,x86_64}-clang`
        * <https://stackoverflow.com/questions/25019057/how-are-msys-msys2-and-msysgit-related-to-each-other>
     * LLVM/Clang [multi-platform, free software, open-source]
        * <https://releases.llvm.org/>
     * MinGW-w64 via MSYS2 [win, free software, open-source] (recommended)
        * <https://msys2.github.io/>
        * `pacman -S git base-devel msys2-devel mingw-w64-{i686,x86_64}-toolchain`
     * MinGW-w64 [win, \*nix, free software, open-source]
        * <https://mingw-w64.org/> <https://en.wikipedia.org/wiki/MinGW#MinGW-w64>
          * 64-bit: threads-posix, seh
            <https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/>
          * 32-bit: threads-posix, dwarf-2
            <https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win32/Personal%20Builds/mingw-builds/>
     * Dr. Mingw Just-in-Time debugger [win, free software, open-source]
        * <https://github.com/jrfonseca/drmingw>
        * MSYS2 package: mingw-w64-{i686,x86_64}-drmingw
     * Xcode / Command Line Tools for Xcode [darwin, zero price, proprietary with open-source components]
        * <https://itunes.apple.com/app/xcode/id497799835>
        * <https://developer.apple.com/downloads/> (needs login)
     * MS Windows SDK [zero price, proprietary]
        * <https://developer.microsoft.com/windows/downloads/sdk-archive/>
     * MS Visual C++ Build Tools [win, zero price, proprietary]
        * <https://go.microsoft.com/fwlink/?LinkId=691126>
     * MS Visual Studio Community [win, zero price, proprietary]
        * <https://www.visualstudio.com/vs/visual-studio-express/>
     * MS Windows Mobile SDK [wce, zero price, proprietary]
        * <https://www.microsoft.com/download/details.aspx?id=42>
     * MinGW CEGCC [win, \*nix, free software, open-source]
        * <https://sourceforge.net/projects/cegcc/files/cegcc/>
          * To use this package, you will also need Cygwin package
            installed and be in `PATH` for the Cygwin runtime (`cygwin1.dll`).
          * Unpack using these commands:

            `bzip2 -d cegcc_mingw32ce_cygwin1.7_r1399.tar.bz2`<br>
            `tar -xvf cegcc_mingw32ce_cygwin1.7_r1399.tar -h`

          * Compiler will be in the `opt\mingw32ce` subdirectory.
     * Open Watcom [multi-platform, free software, open-source]
        * <https://github.com/open-watcom/open-watcom-v2>, <https://open-watcom.github.io/open-watcom/>
     * Intel Compiler [multi-platform, commercial, proprietary]
        * <https://software.intel.com/c-compilers>
     * Cygwin [win, free software, open-source]
        * <https://cygwin.com/>
     * DJGPP [\*nix, dos, free software, open-source]
        * <http://www.delorie.com/djgpp/>

* Libraries:

     * `HB_WITH_PCRE2`, `HB_WITH_PCRE` - Perl Compatible Regular Expressions [multi-platform, free software, open-source]
        * <https://pcre.org/>
     * `HB_WITH_PNG` - libpng [multi-platform, free software, open-source]
        * <https://github.com/glennrp/libpng>
     * `HB_WITH_WATT` - Watt-32 (TCP/IP sockets) [dos, free software, open-source]
        * <http://www.watt-32.net/>
     * `HB_WITH_ZLIB` - zlib [multi-platform, free software, open-source]
        * <https://zlib.net/>

* Tools:

     * Git (2.2.0 or upper) [multi-platform, free software, open-source]
        * <https://git-scm.com/>
        * on Windows:
           * <https://git-for-windows.github.io/>
           * via Windows Subsystem for Linux on Windows 10 Anniversary Update
     * GitHub Desktop [multi-platform, zero price, proprietary]
        * <https://desktop.github.com/>
     * Travis CI [continuous integration, web service, free plan available]
        * <https://travis-ci.org/>
     * AppVeyor CI [continuous integration, web service, free plan available]
        * <https://www.appveyor.com/>
     * GNU Bison (grammar parser generator) [multi-platform, free software, open-source]
        * Windows binary: See at Git or MSYS2.
     * Cppcheck (static analysis) [multi-platform, free software, open-source]
        * <https://github.com/danmar/cppcheck>
     * Valgrind (dynamic executable analysis tool) [linux, darwin, free software, open-source]
        * <https://en.wikipedia.org/wiki/Valgrind>
     * Uncrustify (source formatter) [multi-platform, free software, open-source]
        * <https://github.com/uncrustify/uncrustify>
     * UPX (executable compressor) [multi-platform, free software, open-source]
        * <https://upx.github.io/>
     * GNU Make [multi-platform, free software, open-source]
        * <https://www.gnu.org/software/make/>

* Package searches

     * deb (Debian): <https://packages.debian.org/search>
     * deb (Ubuntu): <https://packages.ubuntu.com/>
     * rpm (Fedora): <https://apps.fedoraproject.org/packages/>
     * pacman (Arch Linux): <https://www.archlinux.org/packages/>
     * pkgng, ports (FreeBSD): <https://www.freebsd.org/ports/> <https://www.freshports.org/>
     * homebrew (macOS): <http://formulae.brew.sh/>
     * msys2 (Windows): <https://github.com/Alexpux/MINGW-packages>

* Documentation:

     * [Netiquette Guidelines](https://tools.ietf.org/html/rfc1855)
     * [Setting Up Git](https://help.github.com/articles/set-up-git)
     * [Pro Git](https://git-scm.com/book) [free book]
     * [GitHub Training Kit & Multi-language Cheat Sheet](https://training.github.com/kit/)
     * Using gettext (.po files)
       * <https://docs.transifex.com/formats/gettext>
       * <https://web.archive.org/web/20160427125642/heiner-eichmann.de/autotools/using_gettext.html>
     * [GitHub Guides](https://guides.github.com/)
     * [GitHub Flavored Markdown](https://help.github.com/articles/github-flavored-markdown)
     * [A Practical Git Introduction](https://github.com/marchelbling/marchelbling.github.io/blob/master/_posts/2014-09-22-practical-git-introduction.md)

* Community forums:

  * General:
     * [English](https://groups.google.com/forum/#!forum/harbour-users)
     * [Italian](https://groups.google.com/forum/#!forum/harbourita)
     * [Portuguese](https://pctoledo.websiteseguro.com/forum/viewforum.php?f=4)

  * Social media:
     * [Facebook](https://www.facebook.com/groups/harbour.project/)

  * Product-oriented:
     * [Harbour mainline development](https://groups.google.com/forum/#!forum/harbour-devel)
     * [hbqt (GUI)](https://groups.google.com/forum/#!forum/qtcontribs)
     * [hwgui (GUI)](https://sourceforge.net/p/hwgui/mailman/hwgui-developers/)
     * [xHarbour fork](https://groups.google.com/forum/#!forum/comp.lang.xharbour)

# Harbour Links

  * [Homepage](https://vszakats.github.io/harbour-core/)
  * [How to contribute](.github/CONTRIBUTING.md)
  * [Source code](https://github.com/vszakats/harbour-core)
  * [Issues](https://github.com/vszakats/harbour-core/issues)
  * [Localization](https://www.transifex.com/harbour/harbour/) (Resource [hbmk2-vszakats](https://www.transifex.com/harbour/harbour/hbmk2-vszakats/) (needs login))
  * Documents:
     * [hbmk2 documentation](utils/hbmk2/doc/hbmk2.en.md)
     * [hbrun documentation](contrib/hbrun/doc/hbrun.en.md)
     * [ChangeLog](ChangeLog.txt?raw=true)
     * Comparing [Harbour with xHarbour](doc/xhb-diff.txt?raw=true)
     * CA-Cl*pper 5.3 [online documentation](https://harbour.github.io/ng/c53g01c/menu.html)
     * Harbour [online documentation](https://harbour.github.io/doc/)
     * Harbour [internal documents](doc/)
     * [Harbour for Beginners](https://www.kresin.ru/en/hrbfaq_3.html) &mdash; by Alexander Kresin
     * [Harbour Wiki](https://github.com/Petewg/V-harbour-core/wiki) &mdash; by Pete D
     * [Harbour Magazine](https://medium.com/harbour-magazine) &mdash; by José Luis Sánchez
     * [Wikipedia](https://en.wikipedia.org/wiki/Harbour_compiler)
     * [Stack Overflow](https://stackoverflow.com/questions/tagged/clipper)


# Guarantees and Liability

   This document and all other parts of Harbour are distributed in the
   hope they will be useful, but WITHOUT GUARANTEE that they are complete,
   accurate, non-infringing or usable for any purpose whatsoever.
   Contributors are NOT LIABLE for any damages that result from using
   Harbour in any ways. For more legal details, see [LICENSE](LICENSE.txt).

   If you feel you can make Harbour better: contribute.
   [See how](.github/CONTRIBUTING.md).

   Information in this document is subject to change without notice and does
   not represent any future commitment by the participants of the project.

   This and related documents use the term "recommended" for practices and
   tools *tested most*, *focused on*, *used and deployed* by the
   maintainer/developer of this fork. While this is strongly believed to result
   in the best Harbour experience for most situations, it's ultimately
   a subjective decision. If you don't like it, use what fits your case best.

---
This document Copyright &copy;&nbsp;2019&ndash;present [Leonardo Wascheck](https://www.linkedin.com/in/leonardo-wascheck-a9312bb3/)<br>
