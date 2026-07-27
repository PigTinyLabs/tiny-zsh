# =============================================================================
# CUSTOM.ZSH — File tuỳ chỉnh cá nhân của bạn
# =============================================================================
# ĐÂY LÀ FILE CỦA BẠN. Thêm mọi thứ cá nhân vào đây.
#
# ✅ File này KHÔNG bị ghi đè khi update framework.
# ✅ Được load SAU tất cả plugins → có thể override bất cứ thứ gì.
# ✅ Tổ chức theo section, dùng ### để phân tách.
#
# Mở file này nhanh bằng alias: myzrc
# Sau khi sửa, reload bằng: reload
# =============================================================================

# ── PATH ─────────────────────────────────────────────────────────────────────
# NOTE: Thêm thư mục vào PATH để chạy lệnh từ đó không cần đường dẫn đầy đủ.
#       Mỗi dự án/tool thường có hướng dẫn riêng để thêm PATH.
#
# Ví dụ:
# export PATH="$HOME/.local/bin:$PATH"          # Tool cài ở ~/.local/bin
# export PATH="/usr/local/go/bin:$PATH"         # Go
# export PATH="$HOME/.cargo/bin:$PATH"          # Rust/Cargo
# export PATH="$HOME/.bun/bin:$PATH"            # Bun
export EDITOR="vim"
export VISUAL="vim"

# Tắt autosuggestions dù đã cài hệ thống
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=""
unset ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE
zsh_autosuggest_stop 2>/dev/null   # tắt nếu đang chạy

# ── Biến môi trường ───────────────────────────────────────────────────────────
# NOTE: Thêm các biến môi trường cần thiết cho tool bạn dùng.
#
# export NVM_DIR="$HOME/.nvm"                   # Node Version Manager
# export GOPATH="$HOME/go"                      # Go workspace
# export JAVA_HOME="/usr/lib/jvm/java-17-openjdk"  # Java
# export ANDROID_HOME="$HOME/Android/Sdk"       # Android SDK


# ── Alias cá nhân ─────────────────────────────────────────────────────────────
# NOTE: Đặt alias thường dùng của bạn ở đây.
#       Tên alias nên ngắn và dễ nhớ.
#
# alias dev='cd ~/projects && ls'              # Vào thư mục dự án
# alias serve='python3 -m http.server 8080'   # Serve thư mục hiện tại
# alias update='brew update && brew upgrade'  # Update Homebrew (macOS)
# alias nrd='npm run dev'                     # Shortcut npm run dev
# alias dcu='docker compose up -d'            # Docker compose up


# ── Hàm cá nhân ───────────────────────────────────────────────────────────────
# NOTE: Hàm phức tạp hơn alias → dùng khi cần logic điều kiện hoặc nhiều bước.
#
# # Clone repo và cd vào luôn
# ghclone() {
#     git clone "https://github.com/$1" && cd "$(basename $1 .git)"
# }
#
# # Tạo file và mở editor
# touch-edit() {
#     touch "$1" && ${EDITOR:-nano} "$1"
# }
#
# # Tìm và kill process theo tên
# killp() {
#     ps aux | grep "$1" | grep -v grep | awk '{print $2}' | xargs kill -9
# }


# ── Load công cụ quản lý phiên bản ────────────────────────────────────────────
# NOTE: Bỏ comment dòng tương ứng với tool bạn dùng

# NVM (Node Version Manager)
# [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
# [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# rbenv (Ruby)
# pigtinylabs_has "rbenv" && eval "$(rbenv init - zsh)"

# pyenv (Python)
# pigtinylabs_has "pyenv" && eval "$(pyenv init - zsh)"

# jenv (Java)
# pigtinylabs_has "jenv" && eval "$(jenv init -)"

# Volta (Node, npm, yarn)
# export VOLTA_HOME="$HOME/.volta"
# export PATH="$VOLTA_HOME/bin:$PATH"


# ── Tuỳ chỉnh theme ────────────────────────────────────────────────────────────
# NOTE: Override các biến theme từ đây (không cần sửa file theme gốc)
#
# PIGTINYLABS_PROMPT_SYMBOL="→"          # Đổi ký hiệu prompt
# PIGTINYLABS_COLOR_PATH="magenta"       # Đổi màu đường dẫn
# PIGTINYLABS_SHOW_TIME=false            # Tắt giờ bên phải
# PIGTINYLABS_CMD_TIME_THRESHOLD=10      # Chỉ báo khi lệnh chạy > 10 giây


# ── SSH Agent ──────────────────────────────────────────────────────────────────
# NOTE: Tự động start SSH agent và add key khi mở terminal.
#       Bỏ comment nếu bạn dùng SSH key thường xuyên.
#
# if [ -z "$SSH_AUTH_SOCK" ]; then
#     eval "$(ssh-agent -s)" > /dev/null
#     ssh-add ~/.ssh/id_ed25519 2>/dev/null   # Đổi tên key của bạn ở đây
# fi


# ── Greeting khi mở terminal ──────────────────────────────────────────────────
# NOTE: Bỏ comment để hiện lời chào khi mở terminal mới.
#       Xoá hoặc sửa nội dung tuỳ thích.
#
# echo ""
# echo "  Xin chào, $(whoami)! 👋"
# echo "  $(date '+%A, %d/%m/%Y  %H:%M')"
# echo ""
