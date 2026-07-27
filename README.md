# PigTinyLabs — Lightweight Zsh Framework

Framework Zsh nhỏ gọn, dễ hiểu, dễ custom — viết bằng tiếng Việt cho người Việt.

---

## Cài đặt

```bash
git clone https://github.com/you/pigtinylabs.git ~/.pigtinylabs-src
cd ~/.pigtinylabs-src
sh install.sh
```

Sau đó **khởi động lại terminal** hoặc chạy:

```bash
source ~/.zshrc
```

---

## Cấu trúc thư mục

```
~/.pigtinylabs/
├── pigtinylabs.zsh              ← Điểm vào chính (source từ .zshrc)
├── custom.zsh             ← File CỦA BẠN — thêm alias/function cá nhân ở đây
│
├── lib/
│   ├── utils.zsh          ← Hàm tiện ích (màu sắc, git, path...)
│   └── zsh-config.zsh     ← Cấu hình Zsh cơ bản (completion, history, keybinds)
│
├── themes/
│   ├── minimal.zsh-theme  ← Theme mặc định: sạch + git status
│   └── powerline.zsh-theme← Theme phong cách Powerline (cần Nerd Font)
│
└── plugins/
    ├── git/               ← Aliases & functions cho Git
    ├── aliases/           ← Aliases hữu ích hàng ngày
    ├── history/           ← Tìm kiếm history nâng cao (tích hợp fzf)
    └── autosuggestions/   ← Gợi ý lệnh từ history
```

---

## Cách custom

### 1. Đổi theme

Mở `~/.pigtinylabs/pigtinylabs.zsh`, tìm dòng:

```zsh
export PIGTINYLABS_THEME="minimal"
```

Đổi thành tên theme khác. Theme có sẵn: `minimal`, `powerline`.

Để **tạo theme mới**:

```bash
cp ~/.pigtinylabs/themes/minimal.zsh-theme ~/.pigtinylabs/themes/mytheme.zsh-theme
# Sửa file mytheme.zsh-theme theo ý thích
# Đổi PIGTINYLABS_THEME="mytheme" trong pigtinylabs.zsh
```

### 2. Thêm / bỏ plugin

Trong `~/.pigtinylabs/pigtinylabs.zsh`:

```zsh
export PIGTINYLABS_PLUGINS=(
    git          # Bật
    aliases      # Bật
    history      # Bật
    # autosuggestions   # Tắt (comment lại)
)
```

Để **tạo plugin mới**:

```bash
mkdir -p ~/.pigtinylabs/plugins/myplugin
vi ~/.pigtinylabs/plugins/myplugin/myplugin.plugin.zsh
# Thêm "myplugin" vào PIGTINYLABS_PLUGINS trong pigtinylabs.zsh
```

### 3. Thêm alias / function cá nhân

Mở `custom.zsh` bằng lệnh:

```bash
myzrc
```

Thêm alias vào, lưu, rồi reload:

```bash
reload
```

**Không bao giờ sửa file trong `lib/` hay plugin gốc** — hãy override trong `custom.zsh`.

### 4. Tuỳ chỉnh theme không cần sửa file theme

Thêm vào `custom.zsh`:

```zsh
PIGTINYLABS_PROMPT_SYMBOL="→"
PIGTINYLABS_COLOR_PATH="magenta"
PIGTINYLABS_SHOW_TIME=false
```

---

## Cài thêm công cụ (khuyến nghị)

| Công cụ | Tác dụng | Cài |
|---------|----------|-----|
| `fzf` | Tìm kiếm history/file đẹp | `brew install fzf` |
| `zsh-autosuggestions` | Gợi ý lệnh mờ khi gõ | `brew install zsh-autosuggestions` |
| `zsh-syntax-highlighting` | Tô màu lệnh khi gõ | `brew install zsh-syntax-highlighting` |
| `eza` | Thay thế `ls` hiện đại hơn | `brew install eza` |
| `bat` | Thay thế `cat` có màu | `brew install bat` |
| `ripgrep` | Tìm trong file nhanh hơn grep | `brew install ripgrep` |

---

## Tham chiếu nhanh

| Lệnh | Tác dụng |
|------|----------|
| `reload` | Reload `.zshrc` |
| `myzrc` | Mở `custom.zsh` để sửa |
| `zrc` | Mở `.zshrc` để sửa |
| `hs <từ>` | Tìm trong history |
| `mkcd <tên>` | Tạo thư mục và cd vào |
| `extract <file>` | Giải nén (tự nhận format) |
| `bak <file>` | Backup file nhanh |
| `topcmds` | 10 lệnh dùng nhiều nhất |
| `gclean-branches` | Xoá branch đã merge |
| `gcq "msg"` | git add all + commit |
| `gpush` | Push branch + set upstream |

---

## Cấu trúc một plugin (template)

```zsh
# plugins/myplugin/myplugin.plugin.zsh

# Kiểm tra dependency
pigtinylabs_has "sometool" || {
    pigtinylabs_warn "Plugin myplugin: cần cài sometool"
    return
}

# Alias
alias x='sometool do-something'

# Hàm
myfunction() {
    echo "Xin chào $1"
}
```

---

## Cấu trúc một theme (template)

```zsh
# themes/mytheme.zsh-theme

# Ký hiệu và màu
MY_SYMBOL="❯"
MY_COLOR="cyan"

# Hàm build prompt (chạy mỗi khi hiện prompt)
_pigtinylabs_precmd_prompt() {
    local path_part="%F{$MY_COLOR}%~%f"
    local git_part=$(_pigtinylabs_git_prompt)   # Hàm có sẵn trong utils.zsh
    PROMPT="${path_part}${git_part}"$'\n'"${MY_SYMBOL} "
    RPROMPT="%F{240}%D{%H:%M}%f"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _pigtinylabs_precmd_prompt
```

---

## License

MIT — Dùng thoải mái, sửa thoải mái.
