# Pi Config

个人 Pi 全局配置备份。仓库通过 `PI_CODING_AGENT_DIR` 直接作为 Pi 配置目录使用，由 GitHub 负责跨设备同步。

> 建议使用 GitHub 私有仓库。仓库包含第三方 Skills；公开前需检查其许可证。

## 已包含内容

| 路径 | 内容 |
| --- | --- |
| `settings.json` | 默认模型、思考等级、主题、重试、上下文压缩和第三方 Packages |
| `caveman.json` | Caveman 输出风格配置 |
| `open-tui.json` | Open TUI 中文界面、页脚和遥测显示配置 |
| `skills/` | 当前已安装 Skills 的快照 |
| `extensions/` | 自定义 Pi Extensions 目录，目前为空 |
| `prompts/` | Prompt Templates 目录，目前为空 |
| `themes/` | 自定义主题目录，目前为空 |

### Packages

`settings.json` 会让 Pi 在首次启动时自动安装这些 Packages：

- `pi-web-access`
- `@narumitw/pi-btw`
- `@juicesharp/rpiv-ask-user-question`
- `@juicesharp/rpiv-todo`
- `@dietrichgebert/ponytail`
- `pi-caveman`
- `@plannotator/pi-extension`
- `@narumitw/pi-usage`
- `pi-subagents`
- `@narumitw/pi-goal`
- `pi-open-tui`

### Skills

- `codereview-architect`
- `find-skills`
- `self-learning`
- `tdd`

## 新设备安装

### 1. 安装 Pi

```bash
npm install -g --ignore-scripts @earendil-works/pi-coding-agent
```

### 2. 克隆仓库

```bash
git clone git@github.com:<user>/pi-config.git "$HOME/.config/pi-config"
```

### 3. 指定配置目录

#### Fish

使用 Universal Variable 持久化并导出环境变量：

```fish
set -Ux PI_CODING_AGENT_DIR "$HOME/.config/pi-config"
```

该命令立即生效，后续 Fish 会话也会自动加载，无需修改或重新加载 `config.fish`。

如需取消：

```fish
set -eU PI_CODING_AGENT_DIR
```

#### Zsh / Bash

将下面一行加入 `~/.zshrc`；使用 Bash 时改为 `~/.bashrc`：

```bash
export PI_CODING_AGENT_DIR="$HOME/.config/pi-config"
```

重新加载 Shell：

```bash
source ~/.zshrc
```

验证路径：

```bash
printf '%s\n' "$PI_CODING_AGENT_DIR"
```

### 4. 启动并登录

```bash
pi
```

首次启动会根据 `settings.json` 安装缺失 Packages。随后执行：

```text
/login
```

每台设备单独登录。`auth.json` 不进入 Git。

> 不要用 `pi install git:...` 安装整个仓库。Pi Package 安装只分发 Extensions、Skills、Prompts 和 Themes，不会应用完整 `settings.json` 等全局配置。

## 从现有 Pi 配置迁移

设置 `PI_CODING_AGENT_DIR` 后，Pi 会使用新目录，不再读取默认的 `~/.pi/agent`。推荐重新执行 `/login`。

如需保留本机登录状态，可只在本机复制凭据并限制权限：

```bash
cp "$HOME/.pi/agent/auth.json" "$PI_CODING_AGENT_DIR/auth.json"
chmod 600 "$PI_CODING_AGENT_DIR/auth.json"
```

不要提交该文件。

Pi 还会扫描 `~/.agents/skills`。若该目录保留了同名 Skills，可能出现名称冲突警告。确认其他 Agent 不依赖旧目录后，可将它改为指向本仓库：

```bash
mv "$HOME/.agents/skills" "$HOME/.agents/skills.backup"
ln -s "$PI_CODING_AGENT_DIR/skills" "$HOME/.agents/skills"
```

## 日常同步

拉取其他设备上的更新：

```bash
cd "$PI_CODING_AGENT_DIR"
git pull --ff-only
```

更新第三方 Packages：

```bash
pi update --extensions
```

提交本机配置改动：

```bash
cd "$PI_CODING_AGENT_DIR"
git add .
git commit -m "Update Pi config"
git push
```

通过 `pi install <package>` 修改 Packages 后，`settings.json` 会发生变化，需要提交。

## 添加资源

### Skill

```text
skills/<skill-name>/SKILL.md
```

### Extension

```text
extensions/<extension-name>.ts
```

### Prompt Template

```text
prompts/<name>.md
```

### Theme

```text
themes/<name>.json
```

修改资源后，可在 Pi 中运行 `/reload`。

## 不会同步的内容

`.gitignore` 排除了：

- `auth.json` 和凭据文件
- `trust.json`
- Sessions
- 模型缓存
- 自动安装的 npm/git Packages
- `node_modules`
- `.env`、私钥和本机 `*.local.json`

这些内容涉及秘密、机器状态或可重新生成文件，应在每台设备单独维护。

## 首次上传 GitHub

```bash
git remote add origin git@github.com:<user>/pi-config.git
git add .
git commit -m "Initialize Pi config"
git push -u origin main
```
