<p align="center">
  <img src="docs/images/icon.png" width="128" height="128" alt="App-Symbol von CommandH">
</p>

<h1 align="center">CommandH</h1>

<p align="center">
  Damit <b>Cmd+H</b> auch die letzte App auf deinem Mac ausblendet und du endlich deinen Schreibtisch siehst.
</p>

<p align="center">
  <a href="README.md">English</a> · <b>Deutsch</b> · <a href="README.es.md">Español</a> · <a href="README.fr.md">Français</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.zh-Hans.md">简体中文</a> · <a href="README.zh-Hant.md">繁體中文</a>
</p>

---

macOS hat eine seltsame Regel: **Die letzte sichtbare App lässt sich nicht ausblenden.** Sind alle anderen Apps schon ausgeblendet, passiert nichts, wenn du bei der übrigen App Cmd+H drückst. Das Fenster bleibt, wo es ist, und du kommst nie zu deinem Schreibtisch.

CommandH ist eine winzige, kostenlose Open-Source-App für die Menüleiste, die genau das behebt. Solange sie läuft, funktioniert Cmd+H jedes Mal gleich, auch bei der letzten App.

- Keine Berechtigungen nötig (keine Bedienungshilfen, keine Bildschirmaufnahme)
- Kein Netzwerkzugriff, keine Analysen, keine Datenerfassung
- Wohnt in deiner Menüleiste oder, wenn du magst, nirgendwo sichtbar
- Erfordert macOS 14 Sonoma oder neuer

## Inhalt

- [Installation](#installation)
- [CommandH verwenden](#commandh-verwenden)
- [Einstellungen](#einstellungen)
- [Das Menü in der Menüleiste](#das-menü-in-der-menüleiste)
- [Tastaturkurzbefehle](#tastaturkurzbefehle)
- [Fehlerbehebung](#fehlerbehebung)
- [So funktioniert es](#so-funktioniert-es)
- [Deinstallieren](#deinstallieren)
- [Kompilieren und mitwirken](#kompilieren-und-mitwirken)
- [Das Projekt unterstützen](#das-projekt-unterstützen)
- [Weitere Projekte](#weitere-projekte)

## Installation

CommandH wird derzeit installiert, indem du es aus dem Quellcode kompilierst. Das dauert etwa eine Minute.

1. Installiere Apples Befehlszeilentools, falls du sie noch nicht hast:
   ```sh
   xcode-select --install
   ```
2. Klone dieses Repository und kompiliere es:
   ```sh
   git clone https://github.com/MattSenter/commandh.git
   cd commandh
   ./build.sh --install
   ```
   Dadurch wird `CommandH.app` erstellt, in deinen Ordner „Programme“ kopiert und geöffnet.
3. Das Einstellungsfenster erscheint. Schalte unter **System** die Option **Bei der Anmeldung öffnen** ein, damit CommandH immer bereit ist.

Das war's. Blende Apps aus wie gewohnt. Wenn nur noch eine übrig ist, blendet Cmd+H jetzt auch diese aus.

## CommandH verwenden

Du musst nichts Neues lernen. Verwende einfach weiter Cmd+H.

- **Wenn zwei oder mehr Apps sichtbar sind,** hält sich CommandH heraus, und Cmd+H verhält sich genau wie immer.
- **Wenn nur eine App sichtbar ist,** springt CommandH ein, damit Cmd+H trotzdem funktioniert. Was dann passiert, hängt von der Methode ab, die du in den [Einstellungen](#einstellungen) wählst.

Um eine ausgeblendete App zurückzuholen, klicke wie gewohnt auf ihr Symbol im Dock oder wechsle mit Cmd+Tab zu ihr.

### Zwei Wege für die letzte App

| | App ausblenden (Standard) | Schreibtisch anzeigen |
|---|---|---|
| Was du siehst | Die App wird vollständig ausgeblendet, genau wie mit Cmd+H bei jeder anderen App | Die Fenster gleiten an die Bildschirmränder |
| Zurückholen | Klicke auf ihr Symbol im Dock oder verwende Cmd+Tab | Drücke erneut Cmd+H oder klicke auf die App |
| Dock-Symbol | Das Symbol von CommandH erscheint im Dock, solange eine oder keine App sichtbar ist | Erscheint nie im Dock |
| Ideal für | Alle, die wirklich ausblenden wollen | Alle, die CommandH nie im Dock sehen wollen |

**Warum erscheint im Modus „App ausblenden“ ein Dock-Symbol?** macOS verweigert das Ausblenden einer App nur dann, wenn danach keine reguläre App mehr auf dem Bildschirm wäre. CommandH wird kurzzeitig selbst zu einer regulären App (einer mit Dock-Symbol), damit deine letzte App nicht mehr die letzte ist. Reguläre Apps bekommen immer ein Dock-Symbol, daran führt kein Weg vorbei. Das Symbol verschwindet wieder, sobald zwei oder mehr Apps sichtbar sind. Die Details findest du unter [So funktioniert es](#so-funktioniert-es).

## Einstellungen

Du öffnest das Einstellungsfenster, indem du CommandH aus deinem Ordner „Programme“ (oder über Spotlight oder das Launchpad) öffnest, im Menü des Menüleistensymbols **Einstellungen…** wählst oder auf das Dock-Symbol von CommandH klickst, solange es angezeigt wird. Die Seitenleiste hat fünf Bereiche: **Ausblenden**, **System**, **Datenschutz**, **Weitere Projekte** (mehr Apps vom selben Entwickler) und **Über** (Versionsinfo und Links).

<p align="center">
  <img src="docs/images/settings-light.png" width="440" alt="Einstellungsfenster von CommandH im hellen Erscheinungsbild">
  <img src="docs/images/settings-dark.png" width="440" alt="Einstellungsfenster von CommandH im dunklen Erscheinungsbild">
</p>

| Einstellung | Bereich | Was sie bewirkt |
|---|---|---|
| **Aktiviert** | Ausblenden | Schaltet CommandH ein oder aus, ohne es zu beenden. Wenn sie aus ist, verhält sich Cmd+H wie im normalen macOS. |
| **Wenn nur eine App sichtbar ist** | Ausblenden | Wählt zwischen **App ausblenden** und **Schreibtisch anzeigen**. Siehe [den Vergleich oben](#zwei-wege-für-die-letzte-app). |
| **In der Menüleiste anzeigen** | System | Zeigt das ⌘H-Symbol in deiner Menüleiste an oder entfernt es. Ist die Option aus, läuft CommandH unsichtbar. Öffne CommandH aus deinem Ordner „Programme“, um zu diesem Fenster zurückzukehren. |
| **Bei der Anmeldung öffnen** | System | Startet CommandH automatisch, wenn du dich anmeldest. Es startet still, ohne dieses Fenster zu öffnen. |
| **CommandH beenden** | System | Beendet die App wirklich. Das Schließen des Fensters (oder Cmd+Q) schließt nur das Fenster, CommandH läuft weiter. |

Einstellungen werden automatisch gesichert und gelten sofort.

## Das Menü in der Menüleiste

Klicke auf das ⌘H-Symbol in deiner Menüleiste, um schnell auf dieselben Einstellungen zuzugreifen.

<p align="center">
  <img src="docs/images/menu.png" width="537" alt="Menüleistenmenü von CommandH mit geöffnetem Untermenü „Wenn Cmd+H nicht ausblenden kann“">
</p>

- **Aktiviert**: CommandH ein- oder ausschalten.
- **Wenn Cmd+H nicht ausblenden kann**: **App ausblenden** oder **Schreibtisch anzeigen** wählen.
- **In der Menüleiste anzeigen**: Deaktiviere die Option, um das Symbol zu entfernen. Du kannst auch die Befehlstaste gedrückt halten und das Symbol aus der Menüleiste ziehen.
- **Bei der Anmeldung öffnen**: CommandH starten, wenn du dich anmeldest.
- **Einstellungen…**: das Einstellungsfenster öffnen.
- **CommandH beenden**: die App beenden.

## Tastaturkurzbefehle

Solange das Fenster „CommandH-Einstellungen“ im Vordergrund ist:

| Kurzbefehl | Was er bewirkt |
|---|---|
| Cmd+W | Schließt das Einstellungsfenster. CommandH läuft weiter. |
| Cmd+Q | Schließt ebenfalls das Fenster und lässt CommandH weiterlaufen, damit ein versehentliches Cmd+Q es nie ausschaltet. Mit **CommandH beenden** beendest du es wirklich. |
| Cmd+H | Blendet CommandH aus wie jede andere App. |
| Cmd+, | Öffnet die Einstellungen. |

## Fehlerbehebung

**Cmd+H bewirkt bei der letzten App immer noch nichts.**
Stelle sicher, dass CommandH läuft (öffne es aus deinem Ordner „Programme“) und dass **Aktiviert** eingeschaltet ist. Wenn du **Schreibtisch anzeigen** verwendest, prüfe, ob die Option „Schreibtisch anzeigen“ nicht ausgegraut ist (siehe unten).

**In meinem Dock ist ein CommandH-Symbol aufgetaucht.**
Das ist im Modus **App ausblenden** so gewollt, solange eine oder keine App sichtbar ist. Es verschwindet, sobald eine zweite App sichtbar ist. Wenn du es nie sehen möchtest, wechsle zu **Schreibtisch anzeigen**.

**Nachdem ich alles ausgeblendet hatte, holte ein Klick auf den Schreibtisch Finder-Fenster zurück.**
Das ist normales Verhalten von macOS: Ein Klick auf den Schreibtisch wechselt zum Finder, und der Wechsel zu einer ausgeblendeten App zeigt ihre Fenster wieder an. Ausgeblendete Apps, die du nicht angeklickt hast, bleiben ausgeblendet.

**Im Modus „Schreibtisch anzeigen“ sehe ich noch die Ränder meiner Fenster.**
So funktioniert „Schreibtisch anzeigen“ in macOS. Drücke erneut Cmd+H oder klicke auf einen Fensterrand, um alles zurückzuholen. Um vollständig auszublenden, verwende **App ausblenden**.

**Die Option „Schreibtisch anzeigen“ ist ausgegraut.**
„Schreibtisch anzeigen“ beruht auf einer internen Funktion von macOS. Falls eine künftige macOS-Version sie entfernt, graut CommandH die Option lieber aus, als sich falsch zu verhalten. **App ausblenden** funktioniert weiterhin.

**Ich habe das Menüleistensymbol ausgeschaltet und finde CommandH nicht mehr.**
Öffne CommandH aus deinem Ordner „Programme“. Das Einstellungsfenster erscheint, und du kannst das Symbol unter **System** wieder einschalten.

**„Bei der Anmeldung öffnen“ bleibt nicht eingeschaltet.**
macOS erlaubt das Öffnen bei der Anmeldung nur für Apps an einem festen Ort. Stelle sicher, dass CommandH in deinem Ordner „Programme“ liegt (`./build.sh --install` legt es dort ab), und schalte die Einstellung dann erneut ein.

**Nachdem ich meine letzte App ausgeblendet habe, steht in der Menüleiste „CommandH“.**
Im Modus **App ausblenden** wird CommandH zur aktiven App, nachdem die letzte App ausgeblendet wurde, deshalb erscheint sein Name in der Menüleiste. Klicke auf eine beliebige App oder auf den Schreibtisch, um weiterzumachen.

## So funktioniert es

Bevor wir CommandH geschrieben haben, haben wir jeden Weg getestet, den wir finden konnten, um die letzte sichtbare App direkt auszublenden. Alle scheitern:

| Ansatz | Ergebnis |
|---|---|
| `NSRunningApplication.hide()` | Verweigert |
| AppleScript (`set visible of process ... to false`) | Verweigert, wenn die App die letzte sichtbare ist |
| Bedienungshilfen (`kAXHiddenAttribute`) | Meldet Erfolg, nichts wird ausgeblendet |
| Private LaunchServices (`_LSSetApplicationInformationItem`) | Meldet Erfolg, nichts wird ausgeblendet |
| Carbon `ShowHideProcess` | Verweigert |

Alle landen bei derselben Prüfung in macOS, und diese Prüfung zählt nur **reguläre Apps**, also solche mit Dock-Symbol. Apps, die nur in der Menüleiste laufen, zählen nicht. Selbst wenn das Ausblenden erzwungen wird, blendet macOS sofort die zuletzt verwendete App wieder ein, damit immer etwas auf dem Bildschirm ist.

**App ausblenden** arbeitet innerhalb dieser Regel. Wenn eine oder keine App sichtbar ist, wird CommandH selbst zu einer regulären App mit einem 1 mal 1 Pixel großen, fast durchsichtigen Fenster. Deine letzte App ist dann nicht mehr die letzte, also funktioniert ihr eigenes Cmd+H ganz normal, und macOS übergibt den Fokus an CommandH, statt etwas anderes wieder einzublenden. Sind zwei oder mehr Apps sichtbar, wird CommandH wieder zu einer reinen Menüleisten-App.

**Schreibtisch anzeigen** geht einen anderen Weg. Solange die App im Vordergrund die einzige sichtbare ist, registriert CommandH Cmd+H als globalen Kurzbefehl (der wieder freigegeben wird, sobald das nicht mehr zutrifft) und löst die in macOS eingebaute Funktion „Schreibtisch anzeigen“ aus. Außerhalb dieses einen Falls geht Cmd+H direkt an deine Apps.

Keine der beiden Methoden braucht eine Berechtigung, und CommandH liest nie deinen Bildschirm oder deine Tastatureingaben. Der globale Kurzbefehl existiert nur im Modus „Schreibtisch anzeigen“ und nur, solange eine App sichtbar ist.

Die ganze App besteht aus weniger als 500 Zeilen Swift in [`Sources/`](Sources).

## Deinstallieren

1. Wähle **CommandH beenden** über das Menüleistensymbol oder im Bereich **System** des Einstellungsfensters.
2. Falls **Bei der Anmeldung öffnen** eingeschaltet war, schalte es vorher aus oder entferne CommandH unter „Systemeinstellungen“ > „Allgemein“ > „Anmeldeobjekte“.
3. Ziehe `/Applications/CommandH.app` in den Papierkorb.
4. Entferne bei Bedarf seine Einstellungen:
   ```sh
   defaults delete com.mattsenter.CommandH
   ```

## Kompilieren und mitwirken

Wie du CommandH aus dem Quellcode kompilierst und zum Projekt beiträgst, ist [auf Englisch dokumentiert](README.md#building-and-contributing).

## Das Projekt unterstützen

CommandH ist kostenlos und wird es immer bleiben. Wenn es dir einen kleinen täglichen Ärger erspart, kannst du mir über Venmo ein Trinkgeld geben.

<p align="center">
  <a href="https://venmo.com/u/MattSenter"><b>@MattSenter auf Venmo ein Trinkgeld geben</b></a>
</p>

<p align="center">
  <a href="https://venmo.com/u/MattSenter">
    <img src="docs/images/venmo-qr.svg" width="160" height="160" alt="Venmo-QR-Code für ein Trinkgeld an Matt Senter">
  </a>
  <br>
  <sub>Mit dem Handy scannen</sub>
</p>

Ein Trinkgeld ist ein Dankeschön. Es schaltet nichts frei, denn es gibt nichts freizuschalten.

## Weitere Projekte

CommandH ist eines von mehreren Produkten, die [Matt Senter](https://www.mattsenter.com/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects) von [Senternet](https://www.senter.net/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects) von Anfang bis Ende entwirft, entwickelt und veröffentlicht. Hier ist der Rest der Reihe.

- **[Despacer](https://github.com/MattSenter/despacer)**: Lange Befehle aus Claude Code und Codex kopieren und in einem Stück einsetzen.
- **[Weatherling](https://www.weatherling.app/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Regen, Schnee und Herbstlaub auf deinem Mac-Desktop. Wettereffekte, keine Wetter-App.
- **[Burly](https://www.burly.click/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Jeder Link im richtigen Browserprofil.
- **[Comoji](https://www.comoji.io/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: :emoji:-Autovervollständigung wie in Slack, überall auf deinem Mac.
- **[Premail](https://www.premail.pro/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Dein Posteingang, verteidigt.
- **[Highwire](https://www.highwire.news/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Hinter die Schlagzeilen sehen.
- **[StockCar](https://www.stockcar.app/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Ein Podcast über dein Depot, nicht über den Markt.
- **[Orgabot](https://www.orga.bot/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Die Arbeit orchestrieren, nicht nur die Agenten.
- **[BeeReady](https://www.beeready.buzz/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Lebensrettende Handgriffe, ein Spiel nach dem anderen.
- **[SeedMatrix](https://www.seedmatrix.com/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Jede Sorte, jeder Versuch, ein klarer Vergleich.

## Lizenz

[MIT](LICENSE). Entwickelt von [Matt Senter](https://www.mattsenter.com/?utm_source=github&utm_medium=readme&utm_campaign=commandh).
