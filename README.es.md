<p align="center">
  <img src="docs/images/icon.png" width="128" height="128" alt="Icono de la app CommandH">
</p>

<h1 align="center">CommandH</h1>

<p align="center">
  Haz que <b>Cmd+H</b> oculte la última app en tu Mac, para que por fin puedas ver tu escritorio.
</p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.de.md">Deutsch</a> · <b>Español</b> · <a href="README.fr.md">Français</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.zh-Hans.md">简体中文</a> · <a href="README.zh-Hant.md">繁體中文</a>
</p>

---

macOS tiene una regla curiosa: **no puedes ocultar la última app visible.** Cuando todas las demás apps ya están ocultas, pulsar Cmd+H en la que queda no hace nada. La ventana sigue ahí y nunca llegas a ver el escritorio.

CommandH es una pequeña app de la barra de menús, gratuita y de código abierto, que soluciona esto. Con ella en marcha, Cmd+H funciona siempre igual, incluso con la última app.

- Sin permisos que conceder (ni Accesibilidad ni Grabación de pantalla)
- Sin acceso a la red, sin analíticas, sin recopilar datos
- Vive en tu barra de menús, o en ningún sitio si lo prefieres
- Requiere macOS 14 Sonoma o posterior

## Contenido

- [Instalación](#instalación)
- [Cómo usar CommandH](#cómo-usar-commandh)
- [Ajustes](#ajustes)
- [El menú de la barra de menús](#el-menú-de-la-barra-de-menús)
- [Atajos de teclado](#atajos-de-teclado)
- [Solución de problemas](#solución-de-problemas)
- [Cómo funciona](#cómo-funciona)
- [Desinstalación](#desinstalación)
- [Compilación y contribuciones](#compilación-y-contribuciones)
- [Apoya el proyecto](#apoya-el-proyecto)
- [Otros proyectos](#otros-proyectos)

## Instalación

Por ahora, CommandH se instala compilándolo desde el código fuente. Se tarda más o menos un minuto.

1. Instala las herramientas de línea de comandos de Apple si no las tienes:
   ```sh
   xcode-select --install
   ```
2. Clona este repositorio y compila:
   ```sh
   git clone https://github.com/MattSenter/commandh.git
   cd commandh
   ./build.sh --install
   ```
   Esto compila `CommandH.app`, lo copia a tu carpeta Aplicaciones y lo abre.
3. Aparece la ventana de ajustes. En **Sistema**, activa **Abrir al iniciar sesión** para que CommandH esté siempre listo.

Y ya está. Oculta las apps como siempre. Cuando llegues a la última, Cmd+H ahora también la oculta.

## Cómo usar CommandH

No hay nada nuevo que aprender. Sigue usando Cmd+H.

- **Cuando se ven dos o más apps,** CommandH no interviene y Cmd+H se comporta exactamente como siempre.
- **Cuando solo se ve una app,** CommandH entra en acción para que Cmd+H siga funcionando. Lo que pasa después depende del método que elijas en [Ajustes](#ajustes).

Para recuperar una app oculta, haz clic en su icono del Dock o cambia a ella con Cmd+Tab, como siempre.

### Dos formas de gestionar la última app

| | Ocultar la app (predeterminado) | Mostrar escritorio |
|---|---|---|
| Lo que ves | La app se oculta por completo, igual que con Cmd+H en cualquier otra app | Las ventanas se apartan a los bordes de la pantalla |
| Cómo recuperarla | Haz clic en su icono del Dock o usa Cmd+Tab | Pulsa Cmd+H otra vez o haz clic en la app |
| Icono en el Dock | El icono de CommandH aparece en el Dock mientras se ve una sola app o ninguna | Nunca aparece en el Dock |
| Ideal para | Quien quiere ocultar de verdad | Quien no quiere ver nunca CommandH en el Dock |

**¿Por qué aparece un icono en el Dock en el modo "Ocultar la app"?** macOS solo se niega a ocultar una app cuando no quedaría ninguna app normal en pantalla. CommandH se convierte un momento en una app normal (de las que tienen icono en el Dock) para que tu última app deje de ser la última. Las apps normales siempre tienen icono en el Dock, y no hay forma de evitarlo. El icono vuelve a desaparecer en cuanto se ven dos o más apps. Consulta [Cómo funciona](#cómo-funciona) para ver los detalles.

## Ajustes

Abre la ventana de ajustes abriendo CommandH desde tu carpeta Aplicaciones (o desde Spotlight o Launchpad), eligiendo **Ajustes…** en el icono de la barra de menús o haciendo clic en el icono de CommandH en el Dock cuando esté visible. La barra lateral tiene cinco paneles: **Ocultación**, **Sistema**, **Privacidad**, **Otros proyectos** (más apps del mismo desarrollador) y **Acerca de** (información de versión y enlaces).

<p align="center">
  <img src="docs/images/settings-light.png" width="440" alt="Ventana Ajustes de CommandH en modo claro">
  <img src="docs/images/settings-dark.png" width="440" alt="Ventana Ajustes de CommandH en modo oscuro">
</p>

| Ajuste | Panel | Qué hace |
|---|---|---|
| **Activado** | Ocultación | Activa o desactiva CommandH sin salir de él. Cuando está desactivado, Cmd+H se comporta como en macOS de serie. |
| **Cuando solo se ve una app** | Ocultación | Elige entre **Ocultar la app** y **Mostrar escritorio**. Consulta [la comparación de arriba](#dos-formas-de-gestionar-la-última-app). |
| **Mostrar en la barra de menús** | Sistema | Muestra o quita el icono ⌘H de tu barra de menús. Si lo desactivas, CommandH funciona de forma invisible. Abre CommandH desde tu carpeta Aplicaciones para volver a esta ventana. |
| **Abrir al iniciar sesión** | Sistema | Inicia CommandH automáticamente al iniciar sesión. Se inicia en silencio, sin abrir esta ventana. |
| **Salir de CommandH** | Sistema | Sale de la app de verdad. Cerrar la ventana (o pulsar Cmd+Q) solo cierra la ventana y deja CommandH en ejecución. |

Los ajustes se guardan automáticamente y se aplican al instante.

## El menú de la barra de menús

Haz clic en el icono ⌘H de tu barra de menús para acceder rápidamente a los mismos ajustes.

<p align="center">
  <img src="docs/images/menu.png" width="537" alt="Menú de CommandH en la barra de menús con el submenú Si Cmd+H no puede ocultar abierto">
</p>

- **Activado**: activa o desactiva CommandH.
- **Si Cmd+H no puede ocultar**: elige **Ocultar la app (con icono en el Dock)** o **Mostrar escritorio (sin icono en el Dock)**.
- **Mostrar en la barra de menús**: desmárcalo para quitar el icono. También puedes mantener pulsada la tecla Cmd y arrastrar el icono fuera de la barra de menús.
- **Abrir al iniciar sesión**: inicia CommandH al iniciar sesión.
- **Ajustes…**: abre la ventana de ajustes.
- **Salir de CommandH**: sale de la app.

## Atajos de teclado

Mientras la ventana Ajustes de CommandH está en primer plano:

| Atajo | Qué hace |
|---|---|
| Cmd+W | Cierra la ventana de ajustes. CommandH sigue en ejecución. |
| Cmd+Q | También cierra la ventana y deja CommandH en ejecución, para que un Cmd+Q accidental nunca lo apague. Usa **Salir de CommandH** para salir de verdad. |
| Cmd+H | Oculta CommandH como cualquier otra app. |
| Cmd+, | Abre los ajustes. |

## Solución de problemas

**Cmd+H sigue sin hacer nada con la última app.**
Comprueba que CommandH está en ejecución (ábrelo desde tu carpeta Aplicaciones) y que **Activado** está activado. Si usas **Mostrar escritorio**, comprueba que esa opción no esté atenuada (consulta más abajo).

**Me ha aparecido un icono de CommandH en el Dock.**
Es lo esperado en el modo **Ocultar la app** siempre que se ve una sola app o ninguna. Desaparece en cuanto se ve una segunda app. Si prefieres no verlo nunca, cambia a **Mostrar escritorio**.

**En el modo Mostrar escritorio, sigo viendo los bordes de mis ventanas.**
Así funciona Mostrar escritorio en macOS. Pulsa Cmd+H otra vez o haz clic en el borde de una ventana para que todo vuelva. Para ocultarlo todo por completo, usa **Ocultar la app**.

**La opción Mostrar escritorio aparece atenuada.**
Mostrar escritorio depende de una función interna de macOS. Si una versión futura de macOS la elimina, CommandH atenúa la opción en lugar de fallar. **Ocultar la app** sigue funcionando.

**Desactivé el icono de la barra de menús y no encuentro CommandH.**
Abre CommandH desde tu carpeta Aplicaciones. Aparece la ventana de ajustes y puedes volver a activar el icono en **Sistema**.

**Abrir al iniciar sesión no se queda activado.**
macOS solo permite abrir al iniciar sesión las apps que están en una ubicación estable. Comprueba que CommandH está en tu carpeta Aplicaciones (`./build.sh --install` lo deja ahí) y vuelve a activar el ajuste.

**La barra de menús muestra "CommandH" después de ocultar mi última app.**
En el modo **Ocultar la app**, CommandH pasa a ser la app activa cuando se oculta la última app, así que su nombre aparece en la barra de menús. Haz clic en cualquier app o en el escritorio para continuar.

## Cómo funciona

Antes de escribir CommandH, probamos todas las formas que encontramos de ocultar directamente la última app visible. Todas fallan:

| Método | Resultado |
|---|---|
| `NSRunningApplication.hide()` | Rechazado |
| AppleScript (`set visible of process ... to false`) | Rechazado cuando la app es la última que se ve |
| Accesibilidad (`kAXHiddenAttribute`) | Indica que ha funcionado, pero no se oculta nada |
| LaunchServices privado (`_LSSetApplicationInformationItem`) | Indica que ha funcionado, pero no se oculta nada |
| Carbon `ShowHideProcess` | Rechazado |

Todos estos métodos acaban en la misma comprobación interna de macOS, y esa comprobación solo cuenta las **apps normales**, las que tienen icono en el Dock. Las apps que solo viven en la barra de menús no cuentan. Incluso cuando se fuerza la ocultación, macOS vuelve a mostrar de inmediato la app usada más recientemente para que siempre haya algo en pantalla.

**Ocultar la app** funciona dentro de esa regla. Cuando se ve una sola app o ninguna, CommandH se convierte en una app normal con una ventana de 1 por 1 píxel casi transparente. Así tu última app deja de ser la última, su propio Cmd+H funciona con normalidad y macOS pasa el foco a CommandH en lugar de volver a mostrar otra app. Cuando se ven dos o más apps, CommandH vuelve a ser una app solo de la barra de menús.

**Mostrar escritorio** sigue otro camino. Mientras la app en primer plano es la única que se ve, CommandH registra Cmd+H como atajo global (y lo libera en cuanto deja de ser así) y activa la función Mostrar escritorio integrada en macOS. Fuera de ese caso concreto, Cmd+H llega directamente a tus apps.

Ninguno de los dos métodos necesita permisos, y CommandH nunca lee tu pantalla ni tus pulsaciones de teclas. El atajo global solo existe en el modo Mostrar escritorio y solo mientras se ve una única app.

Toda la app ocupa menos de 500 líneas de Swift en [`Sources/`](Sources).

## Desinstalación

1. Elige **Salir de CommandH** en el icono de la barra de menús o en el panel **Sistema** de la ventana de ajustes.
2. Si **Abrir al iniciar sesión** estaba activado, desactívalo antes o quita CommandH en Ajustes del Sistema > General > Ítems de inicio.
3. Arrastra `/Applications/CommandH.app` a la Papelera.
4. Si quieres, borra también sus ajustes:
   ```sh
   defaults delete com.mattsenter.CommandH
   ```

## Compilación y contribuciones

Las instrucciones para compilar desde el código fuente y contribuir están en inglés, en [Building and contributing](README.md#building-and-contributing).

## Apoya el proyecto

CommandH es gratis y siempre lo será. Si te ahorra una pequeña molestia diaria, puedes dejarme una propina en Venmo.

<p align="center">
  <a href="https://venmo.com/u/MattSenter"><b>Deja una propina a @MattSenter en Venmo</b></a>
</p>

<p align="center">
  <a href="https://venmo.com/u/MattSenter">
    <img src="docs/images/venmo-qr.svg" width="160" height="160" alt="Código QR de Venmo para dejar una propina a Matt Senter">
  </a>
  <br>
  <sub>Escanéalo con tu teléfono</sub>
</p>

Una propina es un agradecimiento. No desbloquea nada, porque no hay nada que desbloquear.

## Otros proyectos

CommandH es uno de varios productos que [Matt Senter](https://www.mattsenter.com/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects), de [Senternet](https://www.senter.net/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects), diseña, desarrolla y lanza de principio a fin. Aquí está el resto del catálogo.

- **[Despacer](https://github.com/MattSenter/despacer)**: Copia comandos largos de Claude Code y Codex, y pégalos de una sola pieza.
- **[Weatherling](https://www.weatherling.app/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Lluvia, nieve y hojas de otoño en el escritorio de tu Mac. Efectos del tiempo, no una app del tiempo.
- **[Burly](https://www.burly.click/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Cada enlace, en el perfil de navegador correcto.
- **[Comoji](https://www.comoji.io/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Autocompletado de :emoji: al estilo de Slack, en todo tu Mac.
- **[Premail](https://www.premail.pro/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Tu bandeja de entrada, defendida.
- **[Highwire](https://www.highwire.news/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Ver más allá de los titulares.
- **[StockCar](https://www.stockcar.app/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Un pódcast de tu cartera, no del mercado.
- **[Orgabot](https://www.orga.bot/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Orquestar el trabajo, no solo a los agentes.
- **[BeeReady](https://www.beeready.buzz/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Habilidades que salvan vidas, un partido cada vez.
- **[SeedMatrix](https://www.seedmatrix.com/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Cada variedad, cada ensayo, una comparación clara.

## Licencia

[MIT](LICENSE). Creado por [Matt Senter](https://www.mattsenter.com/?utm_source=github&utm_medium=readme&utm_campaign=commandh).
