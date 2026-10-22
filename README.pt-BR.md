<p align="center">
  <img src="docs/images/icon.png" width="128" height="128" alt="Ícone do app CommandH">
</p>

<h1 align="center">CommandH</h1>

<p align="center">
  Faça o <b>Cmd+H</b> ocultar o último app no seu Mac, para você enfim ver a sua Mesa.
</p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.de.md">Deutsch</a> · <a href="README.es.md">Español</a> · <a href="README.fr.md">Français</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <b>Português (Brasil)</b> · <a href="README.zh-Hans.md">简体中文</a> · <a href="README.zh-Hant.md">繁體中文</a>
</p>

---

O macOS tem uma regra estranha: **não dá para ocultar o último app visível.** Quando todos os outros apps já estão ocultos, pressionar Cmd+H no que sobrou não faz nada. A janela continua ali e você nunca chega à Mesa.

O CommandH é um app de barra de menus pequeno, gratuito e de código aberto que resolve isso. Com ele em execução, o Cmd+H funciona sempre do mesmo jeito, até no último app.

- Nenhuma permissão para conceder (sem Acessibilidade, sem Gravação de Tela)
- Sem acesso à rede, sem análises, sem coleta de dados
- Fica na sua barra de menus, ou em lugar nenhum, se você preferir
- Requer macOS 14 Sonoma ou posterior

## Conteúdo

- [Instalação](#instalação)
- [Como usar o CommandH](#como-usar-o-commandh)
- [Ajustes](#ajustes)
- [O menu da barra de menus](#o-menu-da-barra-de-menus)
- [Atalhos de teclado](#atalhos-de-teclado)
- [Solução de problemas](#solução-de-problemas)
- [Como funciona](#como-funciona)
- [Desinstalação](#desinstalação)
- [Compilação e contribuições](#compilação-e-contribuições)
- [Apoie o projeto](#apoie-o-projeto)
- [Outros projetos](#outros-projetos)

## Instalação

Por enquanto, o CommandH é instalado compilando o código-fonte. Leva cerca de um minuto.

1. Instale as ferramentas de linha de comando da Apple, se ainda não as tiver:
   ```sh
   xcode-select --install
   ```
2. Clone este repositório e compile:
   ```sh
   git clone https://github.com/MattSenter/commandh.git
   cd commandh
   ./build.sh --install
   ```
   Isso compila o `CommandH.app`, copia o app para a sua pasta Aplicativos e o abre.
3. A janela Ajustes aparece. Em **Sistema**, ative **Abrir ao iniciar sessão** para que o CommandH esteja sempre pronto.

Pronto. Oculte os apps como você sempre faz. Quando chegar ao último, o Cmd+H agora oculta esse também.

## Como usar o CommandH

Não há nada novo para aprender. Continue usando o Cmd+H.

- **Quando dois ou mais apps estão visíveis,** o CommandH não interfere e o Cmd+H se comporta exatamente como sempre.
- **Quando só um app está visível,** o CommandH entra em ação para que o Cmd+H continue funcionando. O que acontece depois depende do método que você escolher em [Ajustes](#ajustes).

Para trazer de volta um app oculto, clique no ícone dele no Dock ou alterne para ele com Cmd+Tab, como de costume.

### Duas formas de lidar com o último app

| | Ocultar o app (padrão) | Mostrar Mesa |
|---|---|---|
| O que você vê | O app é ocultado por completo, igual ao Cmd+H em qualquer outro app | As janelas deslizam para as bordas da tela |
| Como trazer de volta | Clique no ícone dele no Dock ou use Cmd+Tab | Pressione Cmd+H de novo ou clique no app |
| Ícone no Dock | O ícone do CommandH aparece no Dock enquanto houver um app visível ou nenhum | Nunca aparece no Dock |
| Ideal para | Quem quer ocultar de verdade | Quem nunca quer ver o CommandH no Dock |

**Por que aparece um ícone no Dock no modo "Ocultar o app"?** O macOS só se recusa a ocultar um app quando isso deixaria a tela sem nenhum app comum. O CommandH se torna um app comum (um com ícone no Dock) por um instante, para que o seu último app deixe de ser o último. Apps comuns sempre ganham um ícone no Dock, e não há como evitar isso. O ícone some de novo assim que dois ou mais apps estiverem visíveis. Veja os detalhes em [Como funciona](#como-funciona).

## Ajustes

Abra a janela Ajustes abrindo o CommandH pela pasta Aplicativos (ou pelo Spotlight, ou pelo Launchpad), escolhendo **Ajustes…** no ícone da barra de menus, ou clicando no ícone do CommandH no Dock enquanto ele estiver visível. A barra lateral tem cinco painéis: **Ocultar**, **Sistema**, **Privacidade**, **Outros projetos** (mais apps do mesmo desenvolvedor) e **Sobre** (informações da versão e links).

<p align="center">
  <img src="docs/images/settings-light.png" width="440" alt="Janela Ajustes do CommandH no modo claro">
  <img src="docs/images/settings-dark.png" width="440" alt="Janela Ajustes do CommandH no modo escuro">
</p>

| Ajuste | Painel | O que faz |
|---|---|---|
| **Ativado** | Ocultar | Liga ou desliga o CommandH sem encerrá-lo. Desligado, o Cmd+H se comporta como no macOS padrão. |
| **Quando só um app está visível** | Ocultar | Escolhe entre **Ocultar o app** e **Mostrar Mesa**. Veja [a comparação acima](#duas-formas-de-lidar-com-o-último-app). |
| **Mostrar na barra de menus** | Sistema | Mostra ou remove o ícone ⌘H da sua barra de menus. Desativado, o CommandH funciona de forma invisível. Abra o CommandH pela pasta Aplicativos para voltar a esta janela. |
| **Abrir ao iniciar sessão** | Sistema | Abre o CommandH automaticamente quando você inicia sessão. Ele abre discretamente, sem mostrar esta janela. |
| **Encerrar CommandH** | Sistema | Encerra o app de verdade. Fechar a janela (ou pressionar Cmd+Q) só fecha a janela e mantém o CommandH em execução. |

Os ajustes são salvos automaticamente e entram em vigor na hora.

## O menu da barra de menus

Clique no ícone ⌘H na sua barra de menus para acessar rapidamente os mesmos ajustes.

<p align="center">
  <img src="docs/images/menu.png" width="537" alt="Menu do CommandH na barra de menus com o submenu Quando o Cmd+H Não Puder Ocultar aberto">
</p>

- **Ativado**: liga ou desliga o CommandH.
- **Quando o Cmd+H Não Puder Ocultar**: escolha **Ocultar o App** ou **Mostrar Mesa**.
- **Mostrar na Barra de Menus**: desmarque para remover o ícone. Você também pode manter Cmd pressionado e arrastar o ícone para fora da barra de menus.
- **Abrir ao Iniciar Sessão**: abre o CommandH quando você inicia sessão.
- **Ajustes…**: abre a janela Ajustes.
- **Encerrar CommandH**: encerra o app.

## Atalhos de teclado

Enquanto a janela Ajustes do CommandH estiver na frente:

| Atalho | O que faz |
|---|---|
| Cmd+W | Fecha a janela Ajustes. O CommandH continua em execução. |
| Cmd+Q | Também fecha a janela e mantém o CommandH em execução, para que um Cmd+Q acidental nunca o desligue. Use **Encerrar CommandH** para encerrar de verdade. |
| Cmd+H | Oculta o CommandH como qualquer outro app. |
| Cmd+, | Abre os Ajustes. |

## Solução de problemas

**O Cmd+H continua sem fazer nada no último app.**
Verifique se o CommandH está em execução (abra-o pela pasta Aplicativos) e se **Ativado** está ligado. Se você usa **Mostrar Mesa**, confira se a opção Mostrar Mesa não está esmaecida (veja abaixo).

**Apareceu um ícone do CommandH no meu Dock.**
Isso é esperado no modo **Ocultar o app** sempre que houver um app visível ou nenhum. Ele some quando um segundo app fica visível. Se preferir nunca vê-lo, mude para **Mostrar Mesa**.

**Depois de ocultar tudo, clicar na Mesa trouxe de volta as janelas do Finder.**
Esse é o comportamento normal do macOS: clicar na Mesa alterna para o Finder, e alternar para um app oculto mostra as janelas dele de novo. Os apps ocultos em que você não clicou continuam ocultos.

**No modo Mostrar Mesa, ainda vejo as bordas das minhas janelas.**
É assim que o Mostrar Mesa do macOS funciona. Pressione Cmd+H de novo ou clique na borda de uma janela para trazer tudo de volta. Para ocultar por completo, use **Ocultar o app**.

**A opção Mostrar Mesa está esmaecida.**
O Mostrar Mesa depende de um recurso interno do macOS. Se uma versão futura do macOS removê-lo, o CommandH esmaece a opção em vez de se comportar mal. **Ocultar o app** continua funcionando.

**Desativei o ícone da barra de menus e não encontro o CommandH.**
Abra o CommandH pela pasta Aplicativos. A janela Ajustes aparece, e você pode reativar o ícone em **Sistema**.

**Abrir ao iniciar sessão não fica ativado.**
O macOS só permite abrir ao iniciar sessão apps que estejam em um local estável. Verifique se o CommandH está na sua pasta Aplicativos (o `./build.sh --install` o coloca lá) e ative o ajuste de novo.

**A barra de menus mostra "CommandH" depois que oculto o meu último app.**
No modo **Ocultar o app**, o CommandH passa a ser o app ativo depois que o último app é ocultado, então o nome dele aparece na barra de menus. Clique em qualquer app ou na Mesa para seguir em frente.

## Como funciona

Antes de escrever o CommandH, testamos todas as formas que encontramos de ocultar diretamente o último app visível. Todas falham:

| Abordagem | Resultado |
|---|---|
| `NSRunningApplication.hide()` | Recusado |
| AppleScript (`set visible of process ... to false`) | Recusado quando o app é o último visível |
| Acessibilidade (`kAXHiddenAttribute`) | Informa sucesso, mas nada é ocultado |
| LaunchServices privado (`_LSSetApplicationInformationItem`) | Informa sucesso, mas nada é ocultado |
| Carbon `ShowHideProcess` | Recusado |

Todas elas acabam na mesma verificação interna do macOS, e essa verificação só conta **apps comuns**, os que têm ícone no Dock. Apps que ficam só na barra de menus não contam. Mesmo quando a ocultação é forçada, o macOS logo volta a mostrar o app usado mais recentemente, para que sempre haja algo na tela.

**Ocultar o app** funciona dentro dessa regra. Quando há um app visível ou nenhum, o CommandH se transforma em um app comum com uma janela de 1 por 1 pixel, quase transparente. Assim, o seu último app deixa de ser o último, o Cmd+H dele funciona normalmente e o macOS passa o foco para o CommandH em vez de mostrar de novo outro app. Quando dois ou mais apps estão visíveis, o CommandH volta a ser um app só da barra de menus.

**Mostrar Mesa** segue outro caminho. Enquanto o app da frente for o único visível, o CommandH registra o Cmd+H como atalho global (liberado assim que isso deixa de ser verdade) e aciona o Mostrar Mesa nativo do macOS. Fora desse único caso, o Cmd+H vai direto para os seus apps.

Nenhum dos métodos precisa de permissão, e o CommandH nunca lê a sua tela nem o que você digita. O atalho global só existe no modo Mostrar Mesa e só enquanto um único app está visível.

O app inteiro tem menos de 500 linhas de Swift em [`Sources/`](Sources).

## Desinstalação

1. Escolha **Encerrar CommandH** no ícone da barra de menus ou no painel **Sistema** da janela Ajustes.
2. Se **Abrir ao iniciar sessão** estava ativado, desative-o antes, ou remova o CommandH em Ajustes do Sistema > Geral > Itens de Início.
3. Arraste `/Applications/CommandH.app` para o Lixo.
4. Se quiser, remova os ajustes dele:
   ```sh
   defaults delete com.mattsenter.CommandH
   ```

## Compilação e contribuições

As instruções para compilar a partir do código-fonte e contribuir estão [em inglês](README.md#building-and-contributing).

## Apoie o projeto

O CommandH é gratuito e sempre será. Se ele poupa você de uma pequena irritação diária, você pode me dar uma gorjeta pelo Venmo.

<p align="center">
  <a href="https://venmo.com/u/MattSenter"><b>Dê uma gorjeta para @MattSenter no Venmo</b></a>
</p>

<p align="center">
  <a href="https://venmo.com/u/MattSenter">
    <img src="docs/images/venmo-qr.svg" width="160" height="160" alt="QR code do Venmo para dar uma gorjeta a Matt Senter">
  </a>
  <br>
  <sub>Escaneie com o celular</sub>
</p>

A gorjeta é um agradecimento. Ela não desbloqueia nada, porque não há nada para desbloquear.

## Outros projetos

O CommandH é um dos vários produtos que [Matt Senter](https://www.mattsenter.com/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects), da [Senternet](https://www.senter.net/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects), projeta, desenvolve e lança de ponta a ponta. Aqui está o resto da linha.

- **[Despacer](https://github.com/MattSenter/despacer)**: Copie comandos longos do Claude Code e do Codex, e cole-os inteiros, de uma vez só.
- **[Weatherling](https://www.weatherling.app/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Chuva, neve e folhas de outono na área de trabalho do Mac. Efeitos de clima, não um app de previsão.
- **[Burly](https://www.burly.click/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Cada link, no perfil de navegador certo.
- **[Comoji](https://www.comoji.io/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Autocompletar de :emoji: no estilo Slack, em todo o seu Mac.
- **[Premail](https://www.premail.pro/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Sua caixa de entrada, defendida.
- **[Highwire](https://www.highwire.news/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Enxergar além das manchetes.
- **[StockCar](https://www.stockcar.app/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Um podcast da sua carteira, não do mercado.
- **[Orgabot](https://www.orga.bot/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Orquestrar o trabalho, não apenas os agentes.
- **[BeeReady](https://www.beeready.buzz/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Habilidades que salvam vidas, um jogo de cada vez.
- **[SeedMatrix](https://www.seedmatrix.com/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Cada variedade, cada ensaio, uma comparação clara.

## Licença

[MIT](LICENSE). Criado por [Matt Senter](https://www.mattsenter.com/?utm_source=github&utm_medium=readme&utm_campaign=commandh).
