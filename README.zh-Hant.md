<p align="center">
  <img src="docs/images/icon.png" width="128" height="128" alt="CommandH 應用程式圖像">
</p>

<h1 align="center">CommandH</h1>

<p align="center">
  讓 <b>Cmd+H</b> 也能隱藏 Mac 上的最後一個應用程式，終於看得到你的桌面。
</p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.de.md">Deutsch</a> · <a href="README.es.md">Español</a> · <a href="README.fr.md">Français</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.zh-Hans.md">简体中文</a> · <b>繁體中文</b>
</p>

---

macOS 有個奇怪的規則：**最後一個可見的應用程式無法隱藏。** 當其他應用程式都已隱藏，對剩下的那一個按 Cmd+H 不會有任何反應。視窗依然停在原地，你始終看不到桌面。

CommandH 是一款免費、開放原始碼的小巧選單列應用程式，專門解決這個問題。只要它在執行，Cmd+H 每次的表現都一樣，就連最後一個應用程式也不例外。

- 不必授予任何權限（不需要「輔助使用」，也不需要「螢幕錄製」）
- 不連網、不做分析、不收集任何資料
- 待在選單列中，若你喜歡，也可以完全不顯示
- 需要 macOS 14 Sonoma 或以上版本

## 目錄

- [安裝](#安裝)
- [使用 CommandH](#使用-commandh)
- [設定](#設定)
- [選單列選單](#選單列選單)
- [鍵盤快速鍵](#鍵盤快速鍵)
- [疑難排解](#疑難排解)
- [運作原理](#運作原理)
- [解除安裝](#解除安裝)
- [建置與貢獻](#建置與貢獻)
- [支持這個專案](#支持這個專案)

## 安裝

目前要安裝 CommandH，需從原始碼建置。整個過程大約一分鐘。

1. 如果你還沒有 Apple 的命令列工具，請先安裝：
   ```sh
   xcode-select --install
   ```
2. 複製這個儲存庫並建置：
   ```sh
   git clone https://github.com/MattSenter/commandh.git
   cd commandh
   ./build.sh --install
   ```
   這會建置 `CommandH.app`，將它拷貝到你的「應用程式」檔案夾並開啟。
3. 「設定」視窗會出現。在 **系統** 面板中打開 **登入時開啟** 開關，讓 CommandH 隨時待命。

就這樣。照平常的方式隱藏應用程式即可。輪到最後一個時，Cmd+H 現在也能把它隱藏。

## 使用 CommandH

沒有新東西要學，照樣使用 Cmd+H 就好。

- **有兩個以上的應用程式顯示時，** CommandH 不會插手，Cmd+H 的表現和以往完全相同。
- **只剩一個應用程式顯示時，** CommandH 會出手，讓 Cmd+H 依然有效。接下來會發生什麼，取決於你在 [設定](#設定) 中選擇的方式。

若要讓隱藏的應用程式回來，照常按一下它的 Dock 圖像，或用 Cmd+Tab 切換過去即可。

### 處理最後一個應用程式的兩種方式

| | 隱藏應用程式（預設） | 顯示桌面 |
|---|---|---|
| 你看到的畫面 | 應用程式完整隱藏，和對其他應用程式按 Cmd+H 一樣 | 視窗滑到螢幕邊緣 |
| 如何復原 | 按一下它的 Dock 圖像，或使用 Cmd+Tab | 再按一次 Cmd+H，或按一下該應用程式 |
| Dock 圖像 | 當只有一個或沒有應用程式顯示時，CommandH 的圖像會出現在 Dock 中 | 不會出現在 Dock 中 |
| 適合對象 | 想要真正隱藏的人 | 不希望 CommandH 出現在 Dock 中的人 |

**為什麼「隱藏應用程式」模式下會出現 Dock 圖像？** macOS 只有在隱藏後畫面上不會再有任何一般應用程式時，才會拒絕隱藏。CommandH 會暫時變成一般應用程式（也就是有 Dock 圖像的那種），讓你的最後一個應用程式不再是最後一個。一般應用程式一定會有 Dock 圖像，這點無法避免。只要有兩個以上的應用程式顯示，圖像就會再次消失。詳情請參閱 [運作原理](#運作原理)。

## 設定

開啟「設定」視窗的方式有：從「應用程式」檔案夾（或 Spotlight、Launchpad）開啟 CommandH、從選單列圖像選擇 **設定…**，或在 CommandH 的 Dock 圖像出現時按一下它。側邊欄有五個面板：**隱藏**、**系統**、**隱私**、**其他專案**（同一位開發者的更多應用程式）和 **關於**（版本資訊與連結）。

<p align="center">
  <img src="docs/images/settings-light.png" width="440" alt="淺色模式下的 CommandH 設定視窗">
  <img src="docs/images/settings-dark.png" width="440" alt="深色模式下的 CommandH 設定視窗">
</p>

| 設定 | 面板 | 功能 |
|---|---|---|
| **啟用** | 隱藏 | 不必結束 CommandH 就能開啟或關閉它。關閉時，Cmd+H 的表現與原本的 macOS 相同。 |
| **只剩一個應用程式顯示時** | 隱藏 | 選擇 **隱藏應用程式** 或 **顯示桌面**。請參閱 [上方的比較](#處理最後一個應用程式的兩種方式)。 |
| **在選單列中顯示** | 系統 | 在選單列中顯示或移除 ⌘H 圖像。關閉後，CommandH 會在背景默默執行。從「應用程式」檔案夾開啟 CommandH 即可回到這個視窗。 |
| **登入時開啟** | 系統 | 登入時自動啟動 CommandH。它會安靜地啟動，不會開啟這個視窗。 |
| **結束 CommandH** | 系統 | 真正結束應用程式。關閉視窗（或按 Cmd+Q）只會關閉視窗，CommandH 仍會繼續執行。 |

設定會自動儲存，並立即生效。

## 選單列選單

按一下選單列中的 ⌘H 圖像，即可快速使用相同的設定。

<p align="center">
  <img src="docs/images/menu.png" width="537" alt="CommandH 的選單列選單，已展開「Cmd+H 無法隱藏時」子選單">
</p>

- **啟用**：開啟或關閉 CommandH。
- **Cmd+H 無法隱藏時**：選擇 **隱藏應用程式** 或 **顯示桌面**。
- **在選單列中顯示**：取消勾選即可移除圖像。你也可以按住 Cmd 鍵，把圖像拖出選單列。
- **登入時開啟**：登入時啟動 CommandH。
- **設定…**：開啟「設定」視窗。
- **結束 CommandH**：結束應用程式。

## 鍵盤快速鍵

當 CommandH 的「設定」視窗在最前方時：

| 快速鍵 | 功能 |
|---|---|
| Cmd+W | 關閉「設定」視窗。CommandH 仍會繼續執行。 |
| Cmd+Q | 同樣會關閉視窗並讓 CommandH 繼續執行，所以不小心按到 Cmd+Q 也不會把它關掉。要真正結束，請使用 **結束 CommandH**。 |
| Cmd+H | 和其他應用程式一樣隱藏 CommandH。 |
| Cmd+, | 開啟「設定」。 |

## 疑難排解

**對最後一個應用程式按 Cmd+H 仍然沒反應。**
請確認 CommandH 正在執行（從「應用程式」檔案夾開啟它），而且 **啟用** 已開啟。如果你使用 **顯示桌面**，請確認「顯示桌面」選項沒有變成灰色（見下方）。

**Dock 中出現了 CommandH 的圖像。**
在 **隱藏應用程式** 模式下，只要只有一個或沒有應用程式顯示，這是正常現象。等第二個應用程式顯示時，圖像就會消失。如果你不想看到它，請改用 **顯示桌面**。

**全部隱藏後，按一下桌面卻讓 Finder 視窗跑回來了。**
這是 macOS 的正常行為：按一下桌面會切換到 Finder，而切換到隱藏的應用程式會讓它的視窗重新顯示。你沒有按過的隱藏應用程式會維持隱藏。

**在「顯示桌面」模式下，我還是看得到視窗的邊緣。**
macOS 的「顯示桌面」就是這樣運作的。再按一次 Cmd+H，或按一下視窗邊緣，就能讓所有視窗回來。若要完整隱藏，請使用 **隱藏應用程式**。

**「顯示桌面」選項變成灰色。**
「顯示桌面」仰賴 macOS 的一項內部功能。如果未來的 macOS 版本移除了這項功能，CommandH 會把這個選項變成灰色，而不是讓它出錯。**隱藏應用程式** 仍可正常使用。

**我關閉了選單列圖像，結果找不到 CommandH。**
從「應用程式」檔案夾開啟 CommandH。「設定」視窗會出現，你可以在 **系統** 中重新開啟圖像。

**「登入時開啟」一直無法保持開啟。**
macOS 只允許放在固定位置的應用程式在登入時開啟。請確認 CommandH 位於「應用程式」檔案夾（`./build.sh --install` 會把它放在那裡），然後再次開啟這項設定。

**隱藏最後一個應用程式後，選單列顯示「CommandH」。**
在 **隱藏應用程式** 模式下，最後一個應用程式隱藏後，CommandH 會成為使用中的應用程式，所以選單列會顯示它的名稱。按一下任何應用程式或桌面即可。

## 運作原理

在寫 CommandH 之前，我們測試了所有能找到的方法，嘗試直接隱藏最後一個可見的應用程式。結果全都失敗：

| 方法 | 結果 |
|---|---|
| `NSRunningApplication.hide()` | 被拒絕 |
| AppleScript（`set visible of process ... to false`） | 當該應用程式是最後一個顯示中的應用程式時被拒絕 |
| 輔助使用（`kAXHiddenAttribute`） | 回報成功，但什麼都沒隱藏 |
| 私有 LaunchServices（`_LSSetApplicationInformationItem`） | 回報成功，但什麼都沒隱藏 |
| Carbon `ShowHideProcess` | 被拒絕 |

這些方法最後都會交給 macOS 內部的同一項檢查，而這項檢查只計算**一般應用程式**，也就是有 Dock 圖像的那種。只存在於選單列的應用程式不算在內。就算強行隱藏成功，macOS 也會立刻取消隱藏最近使用過的應用程式，確保畫面上總有東西。

**隱藏應用程式** 是在這條規則之內運作。當只有一個或沒有應用程式顯示時，CommandH 會把自己切換成一般應用程式，並帶有一個 1×1 像素、幾乎完全透明的視窗。這樣一來，你的最後一個應用程式就不再是最後一個，它自己的 Cmd+H 便能正常運作，而 macOS 會把焦點交給 CommandH，而不是讓別的應用程式取消隱藏。當有兩個以上的應用程式顯示時，CommandH 會切換回只存在於選單列的應用程式。

**顯示桌面** 走的是另一條路。當最前方的應用程式是唯一顯示中的應用程式時，CommandH 會把 Cmd+H 註冊為全域快速鍵（一旦情況改變就會立刻釋放），並觸發 macOS 內建的「顯示桌面」。除了這個情況之外，Cmd+H 都會直接傳給你的應用程式。

這兩種方法都不需要任何權限，CommandH 也絕不會讀取你的螢幕或按鍵。全域快速鍵只會在「顯示桌面」模式下、且只有一個應用程式顯示時存在。

整個應用程式的 Swift 程式碼不到 500 行，都在 [`Sources/`](Sources) 中。

## 解除安裝

1. 從選單列圖像或「設定」視窗的 **系統** 面板選擇 **結束 CommandH**。
2. 如果 **登入時開啟** 是開啟的，請先將它關閉，或到「系統設定」>「一般」>「登入項目」中移除 CommandH。
3. 將 `/Applications/CommandH.app` 拖到垃圾桶。
4. 你也可以選擇移除它的設定：
   ```sh
   defaults delete com.mattsenter.CommandH
   ```

## 建置與貢獻

從原始碼建置和參與貢獻的說明以英文撰寫，請參閱 [Building and contributing](README.md#building-and-contributing)。

## 支持這個專案

CommandH 是免費的，而且永遠免費。如果它幫你省去了每天的一點小麻煩，歡迎透過 Venmo 給我小費。

<p align="center">
  <a href="https://venmo.com/u/MattSenter"><b>透過 Venmo 給 @MattSenter 小費</b></a>
</p>

<p align="center">
  <a href="https://venmo.com/u/MattSenter">
    <img src="docs/images/venmo-qr.svg" width="160" height="160" alt="給 Matt Senter 小費的 Venmo QR 碼">
  </a>
  <br>
  <sub>用手機掃描</sub>
</p>

小費只是一份心意，不會解鎖任何功能，因為本來就沒有東西需要解鎖。

## 授權條款

[MIT](LICENSE)。開發者：[Matt Senter](https://www.mattsenter.com/?utm_source=github&utm_medium=readme&utm_campaign=commandh)。
