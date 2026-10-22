<p align="center">
  <img src="docs/images/icon.png" width="128" height="128" alt="CommandH 앱 아이콘">
</p>

<h1 align="center">CommandH</h1>

<p align="center">
  Mac에서 <b>Cmd+H</b>로 마지막 앱까지 가려서, 드디어 데스크탑을 볼 수 있게 합니다.
</p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.de.md">Deutsch</a> · <a href="README.es.md">Español</a> · <a href="README.fr.md">Français</a> · <a href="README.ja.md">日本語</a> · <b>한국어</b> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.zh-Hans.md">简体中文</a> · <a href="README.zh-Hant.md">繁體中文</a>
</p>

---

macOS에는 이상한 규칙이 하나 있습니다. **화면에 보이는 마지막 앱은 가릴 수 없습니다.** 다른 앱을 모두 가린 상태에서 남은 앱에 Cmd+H를 누르면 아무 일도 일어나지 않습니다. 윈도우는 그대로 있고, 데스크탑은 끝내 보이지 않습니다.

CommandH는 이 문제를 해결하는 작고 무료인 오픈 소스 메뉴 막대 앱입니다. CommandH가 실행 중이면 Cmd+H는 마지막 앱에서도 언제나 똑같이 작동합니다.

- 허용해야 할 권한이 없습니다(손쉬운 사용, 화면 기록 모두 필요 없음)
- 네트워크 접근, 분석, 데이터 수집이 없습니다
- 메뉴 막대에 머물거나, 원하면 아이콘 없이도 실행됩니다
- macOS 14 Sonoma 이상이 필요합니다

## 목차

- [설치](#설치)
- [CommandH 사용하기](#commandh-사용하기)
- [설정](#설정)
- [메뉴 막대 메뉴](#메뉴-막대-메뉴)
- [키보드 단축키](#키보드-단축키)
- [문제 해결](#문제-해결)
- [작동 원리](#작동-원리)
- [제거](#제거)
- [빌드 및 기여](#빌드-및-기여)
- [프로젝트 후원하기](#프로젝트-후원하기)
- [다른 프로젝트](#다른-프로젝트)

## 설치

현재 CommandH는 소스에서 직접 빌드해 설치합니다. 1분 정도 걸립니다.

1. Apple 명령어 라인 도구가 없다면 설치합니다.
   ```sh
   xcode-select --install
   ```
2. 이 저장소를 복제하고 빌드합니다.
   ```sh
   git clone https://github.com/MattSenter/commandh.git
   cd commandh
   ./build.sh --install
   ```
   `CommandH.app`을 빌드해 응용 프로그램 폴더에 복사한 뒤 실행합니다.
3. 설정 윈도우가 나타납니다. **시스템**에서 **로그인 시 열기**를 켜 두면 CommandH가 항상 준비되어 있습니다.

이제 끝입니다. 평소처럼 앱을 가리면 됩니다. 마지막 하나가 남아도 이제 Cmd+H로 가릴 수 있습니다.

## CommandH 사용하기

새로 배울 것은 없습니다. 계속 Cmd+H를 사용하세요.

- **앱이 두 개 이상 표시되어 있으면** CommandH는 개입하지 않고, Cmd+H는 늘 그랬듯 그대로 작동합니다.
- **앱이 하나만 표시되어 있으면** CommandH가 나서서 Cmd+H가 계속 작동하게 합니다. 그다음 동작은 [설정](#설정)에서 고른 방식에 따라 달라집니다.

가린 앱을 다시 보려면 평소처럼 Dock 아이콘을 클릭하거나 Cmd+Tab으로 전환하세요.

### 마지막 앱을 처리하는 두 가지 방법

| | 앱 가리기(기본값) | 데스크탑 보기 |
|---|---|---|
| 보이는 모습 | 다른 앱에서 Cmd+H를 누를 때처럼 앱이 완전히 가려집니다 | 윈도우가 화면 가장자리로 밀려납니다 |
| 되돌리는 방법 | Dock 아이콘을 클릭하거나 Cmd+Tab을 사용합니다 | Cmd+H를 다시 누르거나 앱을 클릭합니다 |
| Dock 아이콘 | 표시된 앱이 하나 이하일 때 CommandH 아이콘이 Dock에 나타납니다 | Dock에 나타나지 않습니다 |
| 이런 분께 추천 | 제대로 가리기를 원하는 분 | CommandH가 Dock에 절대 나타나지 않기를 원하는 분 |

**'앱 가리기' 모드에서는 왜 Dock 아이콘이 나타나나요?** macOS는 앱을 가렸을 때 화면에 일반 앱이 하나도 남지 않는 경우에만 가리기를 거부합니다. CommandH는 잠시 일반 앱(Dock 아이콘이 있는 앱)으로 바뀌어, 사용자의 마지막 앱이 더 이상 마지막이 아니게 만듭니다. 일반 앱에는 반드시 Dock 아이콘이 생기며, 이를 피할 방법은 없습니다. 앱이 두 개 이상 표시되면 아이콘은 곧바로 사라집니다. 자세한 내용은 [작동 원리](#작동-원리)를 참고하세요.

## 설정

설정 윈도우는 응용 프로그램 폴더(또는 Spotlight, Launchpad)에서 CommandH를 열거나, 메뉴 막대 아이콘에서 **설정…**을 선택하거나, CommandH의 Dock 아이콘이 보일 때 클릭하면 열립니다. 사이드바에는 **가리기**, **시스템**, **개인정보 보호**, **다른 프로젝트**(같은 개발자의 다른 앱), **정보**(버전 정보와 링크)의 다섯 패널이 있습니다.

<p align="center">
  <img src="docs/images/settings-light.png" width="440" alt="라이트 모드의 CommandH 설정 윈도우">
  <img src="docs/images/settings-dark.png" width="440" alt="다크 모드의 CommandH 설정 윈도우">
</p>

| 설정 | 패널 | 하는 일 |
|---|---|---|
| **활성화** | 가리기 | CommandH를 종료하지 않고 켜거나 끕니다. 끄면 Cmd+H는 기본 macOS처럼 작동합니다. |
| **앱이 하나만 표시될 때** | 가리기 | **앱 가리기**와 **데스크탑 보기** 중에서 고릅니다. [위의 비교](#마지막-앱을-처리하는-두-가지-방법)를 참고하세요. |
| **메뉴 막대에서 보기** | 시스템 | 메뉴 막대의 ⌘H 아이콘을 표시하거나 없앱니다. 끄면 CommandH는 보이지 않게 실행됩니다. 이 윈도우로 돌아오려면 응용 프로그램 폴더에서 CommandH를 여세요. |
| **로그인 시 열기** | 시스템 | 로그인할 때 CommandH를 자동으로 시작합니다. 이 윈도우를 열지 않고 조용히 시작합니다. |
| **CommandH 종료** | 시스템 | 앱을 실제로 종료합니다. 윈도우를 닫거나 Cmd+Q를 누르면 윈도우만 닫히고 CommandH는 계속 실행됩니다. |

설정은 자동으로 저장되며 바로 적용됩니다.

## 메뉴 막대 메뉴

메뉴 막대의 ⌘H 아이콘을 클릭하면 같은 설정에 빠르게 접근할 수 있습니다.

<p align="center">
  <img src="docs/images/menu.png" width="537" alt="'Cmd+H로 가릴 수 없을 때' 하위 메뉴가 열린 CommandH 메뉴 막대 메뉴">
</p>

- **활성화**: CommandH를 켜거나 끕니다.
- **Cmd+H로 가릴 수 없을 때**: **앱 가리기**나 **데스크탑 보기**를 고릅니다.
- **메뉴 막대에서 보기**: 체크를 해제하면 아이콘이 사라집니다. Cmd를 누른 채 아이콘을 메뉴 막대 밖으로 드래그해도 됩니다.
- **로그인 시 열기**: 로그인할 때 CommandH를 시작합니다.
- **설정…**: 설정 윈도우를 엽니다.
- **CommandH 종료**: 앱을 종료합니다.

## 키보드 단축키

CommandH 설정 윈도우가 맨 앞에 있을 때:

| 단축키 | 하는 일 |
|---|---|
| Cmd+W | 설정 윈도우를 닫습니다. CommandH는 계속 실행됩니다. |
| Cmd+Q | 마찬가지로 윈도우만 닫고 CommandH는 계속 실행되므로, 실수로 Cmd+Q를 눌러도 꺼지지 않습니다. 완전히 종료하려면 **CommandH 종료**를 사용하세요. |
| Cmd+H | 다른 앱처럼 CommandH를 가립니다. |
| Cmd+, | 설정을 엽니다. |

## 문제 해결

**마지막 앱에서 Cmd+H를 눌러도 여전히 아무 일도 일어나지 않습니다.**
CommandH가 실행 중인지(응용 프로그램 폴더에서 열어 보세요), **활성화**가 켜져 있는지 확인하세요. **데스크탑 보기**를 사용한다면 데스크탑 보기 옵션이 흐리게 표시되지 않았는지 확인하세요(아래 참고).

**Dock에 CommandH 아이콘이 나타났습니다.**
**앱 가리기** 모드에서 표시된 앱이 하나 이하일 때는 정상입니다. 두 번째 앱이 표시되면 사라집니다. 아예 보고 싶지 않다면 **데스크탑 보기**로 바꾸세요.

**모두 가린 뒤 데스크탑을 클릭했더니 Finder 윈도우가 다시 나타났습니다.**
macOS의 정상적인 동작입니다. 데스크탑을 클릭하면 Finder로 전환되고, 가려진 앱으로 전환하면 그 앱의 윈도우가 다시 표시됩니다. 클릭하지 않은 가려진 앱은 그대로 가려져 있습니다.

**데스크탑 보기 모드에서 윈도우 가장자리가 여전히 보입니다.**
macOS의 데스크탑 보기가 원래 그렇게 작동합니다. Cmd+H를 다시 누르거나 윈도우 가장자리를 클릭하면 모두 돌아옵니다. 완전히 가리려면 **앱 가리기**를 사용하세요.

**데스크탑 보기 옵션이 흐리게 표시됩니다.**
데스크탑 보기는 macOS 내부 기능을 이용합니다. 앞으로의 macOS 버전에서 이 기능이 사라지면 CommandH는 오작동하는 대신 이 옵션을 흐리게 표시합니다. **앱 가리기**는 계속 작동합니다.

**메뉴 막대 아이콘을 껐더니 CommandH를 찾을 수 없습니다.**
응용 프로그램 폴더에서 CommandH를 여세요. 설정 윈도우가 나타나면 **시스템**에서 아이콘을 다시 켤 수 있습니다.

**로그인 시 열기가 계속 꺼집니다.**
macOS는 고정된 위치에 있는 앱만 로그인 시 열 수 있게 허용합니다. CommandH가 응용 프로그램 폴더에 있는지 확인한 뒤(`./build.sh --install`을 사용하면 그곳에 설치됩니다) 설정을 다시 켜세요.

**마지막 앱을 가린 뒤 메뉴 막대에 'CommandH'가 표시됩니다.**
**앱 가리기** 모드에서는 마지막 앱이 가려진 뒤 CommandH가 활성 앱이 되므로 메뉴 막대에 이름이 표시됩니다. 아무 앱이나 데스크탑을 클릭하면 됩니다.

## 작동 원리

CommandH를 만들기 전에, 보이는 마지막 앱을 직접 가리는 방법을 찾을 수 있는 대로 모두 시험해 보았습니다. 모두 실패했습니다.

| 방법 | 결과 |
|---|---|
| `NSRunningApplication.hide()` | 거부됨 |
| AppleScript(`set visible of process ... to false`) | 마지막으로 표시된 앱이면 거부됨 |
| 손쉬운 사용(`kAXHiddenAttribute`) | 성공했다고 보고하지만 아무것도 가려지지 않음 |
| 비공개 LaunchServices(`_LSSetApplicationInformationItem`) | 성공했다고 보고하지만 아무것도 가려지지 않음 |
| Carbon `ShowHideProcess` | 거부됨 |

이 방법들은 모두 macOS 내부의 같은 검사로 넘어가는데, 이 검사는 **일반 앱**, 즉 Dock 아이콘이 있는 앱만 셉니다. 메뉴 막대 전용 앱은 세지 않습니다. 가리기를 강제로 실행해도 macOS는 화면에 항상 무언가가 보이도록 가장 최근에 사용한 앱을 즉시 다시 표시합니다.

**앱 가리기**는 이 규칙 안에서 작동합니다. 표시된 앱이 하나 이하가 되면 CommandH는 1×1픽셀 크기의 거의 투명한 윈도우를 가진 일반 앱으로 스스로 바뀝니다. 그러면 사용자의 마지막 앱은 더 이상 마지막이 아니므로 그 앱의 Cmd+H가 정상적으로 작동하고, macOS는 다른 앱을 다시 표시하는 대신 CommandH에 포커스를 넘깁니다. 앱이 두 개 이상 표시되면 CommandH는 다시 메뉴 막대 전용 앱으로 돌아갑니다.

**데스크탑 보기**는 다른 방식을 씁니다. 맨 앞의 앱이 유일하게 표시된 앱인 동안 CommandH는 Cmd+H를 전역 단축키로 등록하고(이 조건이 끝나면 즉시 해제), macOS에 내장된 데스크탑 보기를 실행합니다. 그 외의 경우 Cmd+H는 그대로 앱에 전달됩니다.

두 방법 모두 어떤 권한도 필요하지 않으며, CommandH는 화면이나 키 입력을 절대 읽지 않습니다. 전역 단축키는 데스크탑 보기 모드에서, 그리고 앱이 하나만 표시되어 있을 때만 존재합니다.

앱 전체는 [`Sources/`](Sources)에 있는 500줄 미만의 Swift 코드입니다.

## 제거

1. 메뉴 막대 아이콘이나 설정 윈도우의 **시스템** 패널에서 **CommandH 종료**를 선택합니다.
2. **로그인 시 열기**를 켜 두었다면 먼저 끄거나, 시스템 설정 > 일반 > 로그인 항목에서 CommandH를 제거합니다.
3. `/Applications/CommandH.app`을 휴지통으로 드래그합니다.
4. 원한다면 설정도 삭제합니다.
   ```sh
   defaults delete com.mattsenter.CommandH
   ```

## 빌드 및 기여

소스에서 빌드하는 방법과 기여 방법은 [영어 문서](README.md#building-and-contributing)에서 안내합니다.

## 프로젝트 후원하기

CommandH는 무료이며 앞으로도 계속 무료입니다. 매일 겪던 작은 짜증을 덜어 주었다면 Venmo로 팁을 보내 주세요.

<p align="center">
  <a href="https://venmo.com/u/MattSenter"><b>Venmo로 @MattSenter에게 팁 보내기</b></a>
</p>

<p align="center">
  <a href="https://venmo.com/u/MattSenter">
    <img src="docs/images/venmo-qr.svg" width="160" height="160" alt="Matt Senter에게 팁을 보내는 Venmo QR 코드">
  </a>
  <br>
  <sub>휴대폰으로 스캔하세요</sub>
</p>

팁은 감사의 표시입니다. 잠금 해제되는 기능은 없습니다. 애초에 잠긴 기능이 없기 때문입니다.

## 다른 프로젝트

CommandH는 [Senternet](https://www.senter.net/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)의 [Matt Senter](https://www.mattsenter.com/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)가 설계부터 개발, 출시까지 직접 하는 여러 제품 중 하나입니다. 나머지 제품을 소개합니다.

- **[Despacer](https://github.com/MattSenter/despacer)**: Claude Code와 Codex의 긴 명령어를 복사해서 한 줄 그대로 붙여넣으세요.
- **[Weatherling](https://www.weatherling.app/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Mac 데스크탑 위로 내리는 비, 눈, 낙엽. 날씨 앱이 아니라 날씨 효과입니다.
- **[Burly](https://www.burly.click/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: 모든 링크를 알맞은 브라우저 프로필로.
- **[Comoji](https://www.comoji.io/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: Slack 스타일 :emoji: 자동 완성을 Mac 어디서나.
- **[Premail](https://www.premail.pro/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: 받은 편지함을 지킵니다.
- **[Highwire](https://www.highwire.news/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: 헤드라인 너머를 보세요.
- **[StockCar](https://www.stockcar.app/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: 시장이 아닌, 내 포트폴리오의 팟캐스트.
- **[Orgabot](https://www.orga.bot/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: 에이전트만이 아니라 일 전체를 조율하세요.
- **[BeeReady](https://www.beeready.buzz/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: 생명을 구하는 기술, 한 경기씩.
- **[SeedMatrix](https://www.seedmatrix.com/?utm_source=github&utm_medium=readme&utm_campaign=commandh&utm_content=other-projects)**: 모든 품종, 모든 시험, 하나의 명확한 비교.

## 라이선스

[MIT](LICENSE). 개발: [Matt Senter](https://www.mattsenter.com/?utm_source=github&utm_medium=readme&utm_campaign=commandh).
