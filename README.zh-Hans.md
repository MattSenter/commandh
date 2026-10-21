<p align="center">
  <img src="docs/images/icon.png" width="128" height="128" alt="CommandH App 图标">
</p>

<h1 align="center">CommandH</h1>

<p align="center">
  让 <b>Cmd+H</b> 也能隐藏 Mac 上的最后一个 App，让你真正看到桌面。
</p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.de.md">Deutsch</a> · <a href="README.es.md">Español</a> · <a href="README.fr.md">Français</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <b>简体中文</b> · <a href="README.zh-Hant.md">繁體中文</a>
</p>

---

macOS 有一条奇怪的规则：**你无法隐藏最后一个可见的 App。** 当其他 App 都已隐藏时，对剩下的那个按 Cmd+H 毫无反应。窗口纹丝不动，你始终看不到桌面。

CommandH 是一款小巧、免费、开源的菜单栏 App，专门解决这个问题。只要它在运行，Cmd+H 每次都会以同样的方式生效，最后一个 App 也不例外。

- 无需授予任何权限（不需要“辅助功能”，也不需要“屏幕录制”）
- 不访问网络，没有分析统计，不收集任何数据
- 待在菜单栏里，你愿意的话也可以完全不露面
- 需要 macOS 14 Sonoma 或更高版本

## 目录

- [安装](#安装)
- [使用 CommandH](#使用-commandh)
- [设置](#设置)
- [菜单栏菜单](#菜单栏菜单)
- [键盘快捷键](#键盘快捷键)
- [故障排除](#故障排除)
- [工作原理](#工作原理)
- [卸载](#卸载)
- [构建与贡献](#构建与贡献)
- [支持本项目](#支持本项目)

## 安装

目前需要从源代码构建来安装 CommandH，大约只需一分钟。

1. 如果还没有安装 Apple 的命令行工具，请先安装：
   ```sh
   xcode-select --install
   ```
2. 克隆此仓库并构建：
   ```sh
   git clone https://github.com/MattSenter/commandh.git
   cd commandh
   ./build.sh --install
   ```
   这会构建 `CommandH.app`，将它拷贝到“应用程序”文件夹并打开。
3. 随后会出现设置窗口。在 **系统** 下打开 **登录时打开**，让 CommandH 随时待命。

就这么简单。像平常一样隐藏 App 即可。到只剩最后一个时，Cmd+H 现在也能把它隐藏。

## 使用 CommandH

没有任何新东西要学，继续用 Cmd+H 就好。

- **当有两个或更多 App 显示时，** CommandH 不会插手，Cmd+H 的表现和以前完全一样。
- **当只有一个 App 显示时，** CommandH 会介入，让 Cmd+H 依然有效。接下来会发生什么，取决于你在[设置](#设置)中选择的方式。

要找回隐藏的 App，像平常一样点按它在程序坞中的图标，或用 Cmd+Tab 切换过去。

### 处理最后一个 App 的两种方式

| | 隐藏 App（默认） | 显示桌面 |
|---|---|---|
| 你会看到 | App 完全隐藏，和对其他 App 按 Cmd+H 一样 | 窗口滑到屏幕边缘 |
| 如何恢复 | 点按它在程序坞中的图标，或使用 Cmd+Tab | 再按一次 Cmd+H，或点按该 App |
| 程序坞图标 | 当只有一个 App 或没有 App 显示时，CommandH 的图标会出现在程序坞中 | 从不出现在程序坞中 |
| 适合 | 想要真正隐藏的人 | 不希望 CommandH 出现在程序坞中的人 |

**为什么“隐藏 App”模式下程序坞里会出现图标？** macOS 只在隐藏某个 App 会导致屏幕上不剩任何常规 App 时才拒绝隐藏。CommandH 会暂时变成一个常规 App（带程序坞图标的那种），这样你的最后一个 App 就不再是最后一个了。常规 App 一定会有程序坞图标，这一点无法绕开。一旦有两个或更多 App 显示，图标就会再次消失。详情请参阅[工作原理](#工作原理)。

## 设置

打开设置窗口的方法有：从“应用程序”文件夹（或聚焦、启动台）打开 CommandH，从菜单栏图标中选取 **设置…**，或在 CommandH 的程序坞图标出现时点按它。边栏有五个面板：**隐藏**、**系统**、**隐私**、**其他项目**（同一开发者的更多 App）以及 **关于**（版本信息和链接）。

<p align="center">
  <img src="docs/images/settings-light.png" width="440" alt="浅色模式下的 CommandH 设置窗口">
  <img src="docs/images/settings-dark.png" width="440" alt="深色模式下的 CommandH 设置窗口">
</p>

| 设置 | 面板 | 作用 |
|---|---|---|
| **已启用** | 隐藏 | 无需退出即可打开或关闭 CommandH。关闭时，Cmd+H 的表现与原生 macOS 相同。 |
| **当只有一个 App 显示时** | 隐藏 | 选择 **隐藏 App** 或 **显示桌面**。请参阅[上面的对比](#处理最后一个-app-的两种方式)。 |
| **在菜单栏中显示** | 系统 | 在菜单栏中显示或移除 ⌘H 图标。关闭后，CommandH 会在后台隐形运行。从“应用程序”文件夹打开 CommandH 即可回到此窗口。 |
| **登录时打开** | 系统 | 登录时自动启动 CommandH。它会安静地启动，不会打开此窗口。 |
| **退出 CommandH** | 系统 | 真正退出 App。关闭窗口（或按 Cmd+Q）只会关闭窗口，CommandH 会继续运行。 |

设置会自动存储并立即生效。

## 菜单栏菜单

点按菜单栏中的 ⌘H 图标，即可快速访问同样的设置。

<p align="center">
  <img src="docs/images/menu.png" width="537" alt="CommandH 菜单栏菜单，“当 Cmd+H 无法隐藏时”子菜单已展开">
</p>

- **已启用**：打开或关闭 CommandH。
- **当 Cmd+H 无法隐藏时**：选择 **隐藏 App** 或 **显示桌面**。
- **在菜单栏中显示**：取消勾选即可移除图标。你也可以按住 Cmd 将图标拖出菜单栏。
- **登录时打开**：登录时启动 CommandH。
- **设置…**：打开设置窗口。
- **退出 CommandH**：退出 App。

## 键盘快捷键

当 CommandH 设置窗口位于最前面时：

| 快捷键 | 作用 |
|---|---|
| Cmd+W | 关闭设置窗口。CommandH 会继续运行。 |
| Cmd+Q | 同样只关闭窗口并让 CommandH 继续运行，以免误按 Cmd+Q 把它关掉。要真正退出，请使用 **退出 CommandH**。 |
| Cmd+H | 像其他 App 一样隐藏 CommandH。 |
| Cmd+, | 打开设置。 |

## 故障排除

**对最后一个 App 按 Cmd+H 仍然没有反应。**
请确认 CommandH 正在运行（从“应用程序”文件夹打开它），并且 **已启用** 处于打开状态。如果你使用 **显示桌面**，请检查“显示桌面”选项是否呈灰色（见下文）。

**程序坞里出现了 CommandH 图标。**
在 **隐藏 App** 模式下，只要只有一个 App 显示或没有 App 显示，就会这样，这是正常的。一旦有第二个 App 显示，图标就会消失。如果你不想看到它，请切换到 **显示桌面**。

**全部隐藏后，点按桌面又让访达窗口回来了。**
这是 macOS 的正常行为：点按桌面会切换到访达，而切换到隐藏的 App 会让它的窗口重新显示。你没有点按的隐藏 App 会保持隐藏。

**在“显示桌面”模式下，我仍能看到窗口的边缘。**
macOS 的“显示桌面”就是这样工作的。再按一次 Cmd+H 或点按窗口边缘，即可恢复所有窗口。要完全隐藏，请使用 **隐藏 App**。

**“显示桌面”选项呈灰色。**
“显示桌面”依赖 macOS 的一项内部功能。如果未来的 macOS 版本移除了它，CommandH 会将该选项变灰，而不是让它出错。**隐藏 App** 依然可用。

**我关闭了菜单栏图标，找不到 CommandH 了。**
从“应用程序”文件夹打开 CommandH。设置窗口会出现，你可以在 **系统** 下重新打开图标。

**“登录时打开”总是保持不住。**
macOS 只允许位于固定位置的 App 在登录时打开。请确保 CommandH 位于“应用程序”文件夹中（`./build.sh --install` 会把它放在那里），然后再次打开该设置。

**隐藏最后一个 App 后，菜单栏显示“CommandH”。**
在 **隐藏 App** 模式下，最后一个 App 隐藏后，CommandH 会成为当前活跃的 App，所以菜单栏中会显示它的名称。点按任意 App 或桌面即可继续。

## 工作原理

在编写 CommandH 之前，我们测试了能找到的所有直接隐藏最后一个可见 App 的方法，全部失败：

| 方法 | 结果 |
|---|---|
| `NSRunningApplication.hide()` | 被拒绝 |
| AppleScript（`set visible of process ... to false`） | 当该 App 是最后一个显示的 App 时被拒绝 |
| 辅助功能（`kAXHiddenAttribute`） | 报告成功，但什么都没隐藏 |
| 私有 LaunchServices（`_LSSetApplicationInformationItem`） | 报告成功，但什么都没隐藏 |
| Carbon `ShowHideProcess` | 被拒绝 |

这些方法最终都交给 macOS 内部的同一项检查，而这项检查只计算 **常规 App**，也就是带程序坞图标的那种。仅存在于菜单栏的 App 不算在内。即使强行隐藏成功，macOS 也会立即重新显示最近使用的 App，确保屏幕上始终有东西。

**隐藏 App** 在这条规则之内运作。当只有一个 App 或没有 App 显示时，CommandH 会把自己切换成常规 App，并带一个 1×1 像素、几乎透明的窗口。这样你的最后一个 App 就不再是最后一个，它自己的 Cmd+H 就能正常生效，而 macOS 会把焦点交给 CommandH，而不是重新显示别的 App。当有两个或更多 App 显示时，CommandH 会切换回仅菜单栏 App。

**显示桌面** 走的是另一条路。当最前面的 App 是唯一显示的 App 时，CommandH 会把 Cmd+H 注册为全局快捷键（一旦情况不再如此就立即释放），并触发 macOS 内置的“显示桌面”。除此之外，Cmd+H 都会直接传给你的 App。

两种方式都不需要任何权限，CommandH 也从不读取你的屏幕或按键。全局快捷键只在“显示桌面”模式下、且只有一个 App 显示时才存在。

整个 App 不到 500 行 Swift 代码，位于 [`Sources/`](Sources)。

## 卸载

1. 从菜单栏图标或设置窗口的 **系统** 面板中选取 **退出 CommandH**。
2. 如果 **登录时打开** 已打开，请先将它关闭，或在“系统设置”>“通用”>“登录项”中移除 CommandH。
3. 将 `/Applications/CommandH.app` 拖到废纸篓。
4. 也可以移除它的设置（可选）：
   ```sh
   defaults delete com.mattsenter.CommandH
   ```

## 构建与贡献

从源代码构建以及参与贡献的说明请参阅[英文文档](README.md#building-and-contributing)。

## 支持本项目

CommandH 现在免费，将来也永远免费。如果它帮你省去了每天的一点小烦恼，欢迎通过 Venmo 给我打赏。

<p align="center">
  <a href="https://venmo.com/u/MattSenter"><b>通过 Venmo 打赏 @MattSenter</b></a>
</p>

<p align="center">
  <a href="https://venmo.com/u/MattSenter">
    <img src="docs/images/venmo-qr.svg" width="160" height="160" alt="打赏 Matt Senter 的 Venmo 二维码">
  </a>
  <br>
  <sub>用手机扫描</sub>
</p>

打赏只是一份谢意，不会解锁任何东西，因为本来就没有什么需要解锁。

## 许可证

[MIT](LICENSE)。开发者：[Matt Senter](https://www.mattsenter.com/?utm_source=github&utm_medium=readme&utm_campaign=commandh)。
