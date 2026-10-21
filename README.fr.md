<p align="center">
  <img src="docs/images/icon.png" width="128" height="128" alt="Icône de l’app CommandH">
</p>

<h1 align="center">CommandH</h1>

<p align="center">
  Faites en sorte que <b>Cmd+H</b> masque la dernière app sur votre Mac, pour enfin voir votre bureau.
</p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.de.md">Deutsch</a> · <a href="README.es.md">Español</a> · <b>Français</b> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.zh-Hans.md">简体中文</a> · <a href="README.zh-Hant.md">繁體中文</a>
</p>

---

macOS a une règle étrange : **impossible de masquer la dernière app visible.** Quand toutes les autres apps sont déjà masquées, appuyer sur Cmd+H dans celle qui reste ne fait rien. La fenêtre reste en place et vous n’atteignez jamais votre bureau.

CommandH est une toute petite app gratuite et open source, logée dans la barre des menus, qui corrige ce problème. Tant qu’elle est ouverte, Cmd+H fonctionne de la même façon à chaque fois, même sur la dernière app.

- Aucune autorisation à accorder (ni Accessibilité, ni Enregistrement de l’écran)
- Aucun accès réseau, aucune statistique d’utilisation, aucune donnée collectée
- Vit dans votre barre des menus, ou nulle part si vous préférez
- Nécessite macOS 14 Sonoma ou version ultérieure

## Sommaire

- [Installation](#installation)
- [Utiliser CommandH](#utiliser-commandh)
- [Réglages](#réglages)
- [Le menu de la barre des menus](#le-menu-de-la-barre-des-menus)
- [Raccourcis clavier](#raccourcis-clavier)
- [Dépannage](#dépannage)
- [Fonctionnement](#fonctionnement)
- [Désinstallation](#désinstallation)
- [Compilation et contribution](#compilation-et-contribution)
- [Soutenir le projet](#soutenir-le-projet)

## Installation

Pour l’instant, CommandH s’installe en le compilant à partir du code source. Cela prend environ une minute.

1. Installez les outils en ligne de commande d’Apple si vous ne les avez pas déjà :
   ```sh
   xcode-select --install
   ```
2. Clonez ce dépôt et compilez :
   ```sh
   git clone https://github.com/MattSenter/commandh.git
   cd commandh
   ./build.sh --install
   ```
   Cette commande compile `CommandH.app`, la copie dans votre dossier Applications et l’ouvre.
3. La fenêtre Réglages apparaît. Dans **Système**, activez **Ouvrir avec la session** pour que CommandH soit toujours prêt.

C’est tout. Masquez vos apps comme d’habitude. Quand il n’en reste plus qu’une, Cmd+H la masque désormais elle aussi.

## Utiliser CommandH

Rien de nouveau à apprendre. Continuez d’utiliser Cmd+H.

- **Quand au moins deux apps sont affichées,** CommandH se fait oublier et Cmd+H se comporte exactement comme d’habitude.
- **Quand une seule app est affichée,** CommandH intervient pour que Cmd+H fonctionne quand même. La suite dépend de la méthode choisie dans les [Réglages](#réglages).

Pour faire réapparaître une app masquée, cliquez sur son icône dans le Dock ou passez-y avec Cmd+Tab, comme d’habitude.

### Deux façons de gérer la dernière app

| | Masquer l’app (par défaut) | Afficher le bureau |
|---|---|---|
| Ce que vous voyez | L’app est entièrement masquée, exactement comme Cmd+H sur n’importe quelle autre app | Les fenêtres glissent vers les bords de l’écran |
| Pour la retrouver | Cliquez sur son icône dans le Dock ou utilisez Cmd+Tab | Appuyez de nouveau sur Cmd+H, ou cliquez sur l’app |
| Icône dans le Dock | L’icône de CommandH apparaît dans le Dock tant qu’une seule app ou aucune n’est affichée | N’apparaît jamais dans le Dock |
| Idéal pour | Ceux qui veulent un vrai masquage | Ceux qui ne veulent jamais voir CommandH dans le Dock |

**Pourquoi une icône apparaît-elle dans le Dock en mode « Masquer l’app » ?** macOS refuse de masquer une app uniquement quand il ne resterait plus aucune app ordinaire à l’écran. CommandH devient brièvement une app ordinaire (avec une icône dans le Dock) pour que votre dernière app ne soit plus la dernière. Les apps ordinaires ont toujours une icône dans le Dock, impossible d’y échapper. L’icône disparaît dès qu’au moins deux apps sont affichées. Consultez la section [Fonctionnement](#fonctionnement) pour les détails.

## Réglages

Pour ouvrir la fenêtre Réglages, ouvrez CommandH depuis votre dossier Applications (ou depuis Spotlight ou Launchpad), choisissez **Réglages…** dans l’icône de la barre des menus, ou cliquez sur l’icône de CommandH dans le Dock quand elle est visible. La barre latérale contient cinq sections : **Masquage**, **Système**, **Confidentialité**, **Autres projets** (d’autres apps du même développeur) et **À propos** (infos de version et liens).

<p align="center">
  <img src="docs/images/settings-light.png" width="440" alt="Fenêtre Réglages de CommandH en mode clair">
  <img src="docs/images/settings-dark.png" width="440" alt="Fenêtre Réglages de CommandH en mode sombre">
</p>

| Réglage | Section | Rôle |
|---|---|---|
| **Activé** | Masquage | Active ou désactive CommandH sans le quitter. Une fois désactivé, Cmd+H se comporte comme dans macOS d’origine. |
| **Quand une seule app est affichée** | Masquage | Choisit **Masquer l’app** ou **Afficher le bureau**. Consultez [la comparaison ci-dessus](#deux-façons-de-gérer-la-dernière-app). |
| **Afficher dans la barre des menus** | Système | Affiche ou retire l’icône ⌘H de votre barre des menus. Une fois désactivé, CommandH fonctionne de façon invisible. Ouvrez CommandH depuis votre dossier Applications pour revenir à cette fenêtre. |
| **Ouvrir avec la session** | Système | Lance CommandH automatiquement à l’ouverture de votre session. Il démarre discrètement, sans ouvrir cette fenêtre. |
| **Quitter CommandH** | Système | Quitte vraiment l’app. Fermer la fenêtre (ou appuyer sur Cmd+Q) ferme seulement la fenêtre et laisse CommandH ouvert. |

Les réglages sont enregistrés automatiquement et s’appliquent immédiatement.

## Le menu de la barre des menus

Cliquez sur l’icône ⌘H de votre barre des menus pour accéder rapidement aux mêmes réglages.

<p align="center">
  <img src="docs/images/menu.png" width="537" alt="Menu de CommandH dans la barre des menus, avec le sous-menu Quand Cmd+H ne peut pas masquer ouvert">
</p>

- **Activé** : active ou désactive CommandH.
- **Quand Cmd+H ne peut pas masquer** : choisissez **Masquer l’app** ou **Afficher le bureau**.
- **Afficher dans la barre des menus** : décochez pour retirer l’icône. Vous pouvez aussi maintenir Cmd et faire glisser l’icône hors de la barre des menus.
- **Ouvrir avec la session** : lance CommandH à l’ouverture de votre session.
- **Réglages…** : ouvre la fenêtre Réglages.
- **Quitter CommandH** : quitte l’app.

## Raccourcis clavier

Quand la fenêtre Réglages de CommandH est au premier plan :

| Raccourci | Rôle |
|---|---|
| Cmd+W | Ferme la fenêtre Réglages. CommandH reste ouvert. |
| Cmd+Q | Ferme aussi la fenêtre et laisse CommandH ouvert, pour qu’un Cmd+Q accidentel ne le désactive jamais. Utilisez **Quitter CommandH** pour le quitter vraiment. |
| Cmd+H | Masque CommandH comme n’importe quelle autre app. |
| Cmd+, | Ouvre les Réglages. |

## Dépannage

**Cmd+H ne fait toujours rien sur la dernière app.**
Vérifiez que CommandH est ouvert (ouvrez-le depuis votre dossier Applications) et que le réglage **Activé** est actif. Si vous utilisez **Afficher le bureau**, vérifiez que cette option n’est pas grisée (voir plus bas).

**Une icône CommandH est apparue dans mon Dock.**
C’est normal en mode **Masquer l’app** chaque fois qu’une seule app ou aucune n’est affichée. Elle disparaît dès qu’une deuxième app est affichée. Si vous préférez ne jamais la voir, passez à **Afficher le bureau**.

**Après avoir tout masqué, un clic sur le bureau a fait réapparaître des fenêtres du Finder.**
C’est le comportement normal de macOS : cliquer sur le bureau active le Finder, et passer à une app masquée affiche de nouveau ses fenêtres. Les apps masquées sur lesquelles vous n’avez pas cliqué restent masquées.

**En mode Afficher le bureau, je vois encore les bords de mes fenêtres.**
C’est ainsi que fonctionne la fonction Afficher le bureau de macOS. Appuyez de nouveau sur Cmd+H ou cliquez sur un bord de fenêtre pour tout faire revenir. Pour un masquage complet, utilisez **Masquer l’app**.

**L’option Afficher le bureau est grisée.**
Afficher le bureau repose sur une fonction interne de macOS. Si une future version de macOS la supprime, CommandH grise l’option plutôt que de mal fonctionner. **Masquer l’app** continue de fonctionner.

**J’ai désactivé l’icône de la barre des menus et je ne trouve plus CommandH.**
Ouvrez CommandH depuis votre dossier Applications. La fenêtre Réglages apparaît, et vous pouvez réactiver l’icône dans **Système**.

**Ouvrir avec la session ne reste pas activé.**
macOS n’autorise l’ouverture avec la session que pour les apps situées à un emplacement stable. Vérifiez que CommandH se trouve dans votre dossier Applications (`./build.sh --install` l’y place), puis réactivez le réglage.

**La barre des menus affiche « CommandH » après que j’ai masqué ma dernière app.**
En mode **Masquer l’app**, CommandH devient l’app active une fois la dernière app masquée, d’où son nom dans la barre des menus. Cliquez sur n’importe quelle app ou sur le bureau pour continuer.

## Fonctionnement

Avant d’écrire CommandH, nous avons testé toutes les méthodes que nous avons pu trouver pour masquer directement la dernière app visible. Toutes échouent :

| Approche | Résultat |
|---|---|
| `NSRunningApplication.hide()` | Refusé |
| AppleScript (`set visible of process ... to false`) | Refusé quand l’app est la dernière affichée |
| Accessibilité (`kAXHiddenAttribute`) | Signale un succès, rien n’est masqué |
| LaunchServices privé (`_LSSetApplicationInformationItem`) | Signale un succès, rien n’est masqué |
| Carbon `ShowHideProcess` | Refusé |

Toutes ces méthodes aboutissent à la même vérification interne de macOS, et cette vérification ne compte que les **apps ordinaires**, celles qui ont une icône dans le Dock. Les apps qui vivent uniquement dans la barre des menus ne comptent pas. Même quand on force le masquage, macOS réaffiche aussitôt l’app utilisée le plus récemment, pour qu’il y ait toujours quelque chose à l’écran.

**Masquer l’app** respecte cette règle. Quand une seule app ou aucune n’est affichée, CommandH se transforme en app ordinaire avec une fenêtre de 1 pixel sur 1, presque transparente. Votre dernière app n’est alors plus la dernière, donc son propre Cmd+H fonctionne normalement, et macOS donne le focus à CommandH au lieu de réafficher une autre app. Quand au moins deux apps sont affichées, CommandH redevient une app logée uniquement dans la barre des menus.

**Afficher le bureau** emprunte un autre chemin. Tant que l’app au premier plan est la seule affichée, CommandH enregistre Cmd+H comme raccourci global (libéré dès que ce n’est plus le cas) et déclenche la fonction Afficher le bureau intégrée à macOS. En dehors de ce cas précis, Cmd+H va directement à vos apps.

Aucune des deux méthodes ne demande d’autorisation, et CommandH ne lit jamais votre écran ni vos frappes au clavier. Le raccourci global n’existe qu’en mode Afficher le bureau, et seulement quand une seule app est affichée.

Toute l’app tient en moins de 500 lignes de Swift, dans [`Sources/`](Sources).

## Désinstallation

1. Choisissez **Quitter CommandH** dans l’icône de la barre des menus ou dans la section **Système** de la fenêtre Réglages.
2. Si **Ouvrir avec la session** était activé, désactivez-le d’abord, ou retirez CommandH dans Réglages Système > Général > Ouverture.
3. Faites glisser `/Applications/CommandH.app` dans la Corbeille.
4. Si vous le souhaitez, supprimez ses réglages :
   ```sh
   defaults delete com.mattsenter.CommandH
   ```

## Compilation et contribution

La compilation à partir du code source et la contribution au projet sont documentées [en anglais](README.md#building-and-contributing).

## Soutenir le projet

CommandH est gratuit et le restera. S’il vous épargne une petite contrariété quotidienne, vous pouvez me laisser un pourboire sur Venmo.

<p align="center">
  <a href="https://venmo.com/u/MattSenter"><b>Laisser un pourboire à @MattSenter sur Venmo</b></a>
</p>

<p align="center">
  <a href="https://venmo.com/u/MattSenter">
    <img src="docs/images/venmo-qr.svg" width="160" height="160" alt="Code QR Venmo pour laisser un pourboire à Matt Senter">
  </a>
  <br>
  <sub>Scannez-le avec votre téléphone</sub>
</p>

Un pourboire est un simple merci. Il ne débloque rien, car il n’y a rien à débloquer.

## Licence

[MIT](LICENSE). Créé par [Matt Senter](https://www.mattsenter.com/?utm_source=github&utm_medium=readme&utm_campaign=commandh).
