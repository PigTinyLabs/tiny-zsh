# =============================================================================
# PLUGINS/ALIASES/ALIASES.PLUGIN.ZSH — Alias hữu ích hàng ngày
# =============================================================================
# NOTE: Đây là alias dùng chung. Alias cá nhân hơn → đặt vào custom.zsh
#       Xem toàn bộ alias đang active: alias
#       Xem alias của 1 lệnh cụ thể:  alias ll
# =============================================================================

# ── Điều hướng thư mục ────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'        # Quay về thư mục trước (cd -)

# ── Liệt kê file (ls) ─────────────────────────────────────────────────────────
# NOTE: macOS và Linux dùng ls khác nhau (GNU vs BSD).
#       Nếu bạn cài eza/exa thì bỏ comment phần eza bên dưới.

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS (BSD ls)
    alias ls='ls -G'                # Màu sắc
    alias ll='ls -lhG'              # Chi tiết + đơn vị đọc được
    alias la='ls -lahG'             # Bao gồm file ẩn
    alias lt='ls -lhGt'             # Sắp xếp theo thời gian
else
    # Linux (GNU ls)
    alias ls='ls --color=auto'
    alias ll='ls -lh --color=auto'
    alias la='ls -lah --color=auto'
    alias lt='ls -lht --color=auto'
fi

# NOTE: Nếu đã cài eza (ls hiện đại hơn): brew install eza
# Bỏ comment các dòng dưới để thay ls bằng eza:
# if pigtinylabs_has "eza"; then
#     alias ls='eza --icons'
#     alias ll='eza -lh --icons --git'
#     alias la='eza -lah --icons --git'
#     alias lt='eza -lh --icons --sort=modified'
#     alias tree='eza --tree --icons'
# fi

# ── Grep với màu sắc ──────────────────────────────────────────────────────────
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ── Xác nhận trước khi xoá / ghi đè ─────────────────────────────────────────
# NOTE: Những alias này bảo vệ bạn khỏi vô tình xoá file quan trọng.
#       Bỏ comment nếu bạn muốn thêm -v (verbose) để xem file nào bị ảnh hưởng.
alias rm='rm -i'          # Hỏi xác nhận trước khi xoá
alias cp='cp -i'          # Hỏi trước khi ghi đè
alias mv='mv -i'          # Hỏi trước khi ghi đè

# ── Xem nội dung file ─────────────────────────────────────────────────────────
# NOTE: Cài bat để thay thế cat: brew install bat
if pigtinylabs_has "bat"; then
    alias cat='bat'              # bat: cat có màu syntax highlighting
    alias catp='bat -p'          # bat không có header/line numbers
else
    alias cat='cat'
fi

# ── Tìm kiếm ──────────────────────────────────────────────────────────────────
# NOTE: Cài fd để thay thế find: brew install fd
if pigtinylabs_has "fd"; then
    alias find='fd'
fi

# NOTE: Cài ripgrep để thay thế grep: brew install ripgrep
if pigtinylabs_has "rg"; then
    alias search='rg'            # rg: tìm kiếm trong file nhanh hơn grep
fi

# ── Network ───────────────────────────────────────────────────────────────────
alias myip='curl -s ifconfig.me'         # IP public của bạn
alias localip="ipconfig getifaddr en0"   # IP local (macOS). Linux: hostname -I
alias ports='netstat -tulanp 2>/dev/null || lsof -i' # Xem port đang mở
alias ping='ping -c 5'                   # Ping 5 lần rồi dừng

# ── Hệ thống ──────────────────────────────────────────────────────────────────
alias df='df -h'             # Dung lượng ổ đĩa dạng human-readable
alias du='du -h'             # Dung lượng thư mục dạng human-readable
alias dusort='du -sh * | sort -hr'  # Xem thư mục nào chiếm nhiều nhất
alias free='free -m'         # RAM (Linux only)
alias top='top -o cpu'       # Sắp xếp theo CPU (macOS)

# ── Reload cấu hình ───────────────────────────────────────────────────────────
# NOTE: Dùng sau khi sửa custom.zsh hoặc pigtinylabs.zsh
alias reload='source ~/.zshrc && echo "✓ Đã reload .zshrc"'
alias zrc='${EDITOR:-nano} ~/.zshrc'        # Mở .zshrc để sửa
alias myzrc='${EDITOR:-nano} ~/.pigtinylabs/custom.zsh'  # Mở file custom

# ── Tiện ích ──────────────────────────────────────────────────────────────────
alias h='history | tail -50'    # 50 lệnh gần nhất
alias j='jobs -l'               # Xem background jobs
alias path='echo $PATH | tr ":" "\n"'  # Xem PATH rõ ràng từng dòng
alias now='date +"%Y-%m-%d %H:%M:%S"' # Giờ hiện tại

# Tạo thư mục và cd vào luôn
# Dùng: mkcd tên-thư-mục
mkcd() {
    mkdir -p "$1" && cd "$1" && echo "✓ Đã tạo và vào thư mục: $1"
}

# Trích xuất file nén (tự nhận biết định dạng)
# Dùng: extract file.tar.gz
extract() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2)  tar xjf "$1"    ;;
            *.tar.gz)   tar xzf "$1"    ;;
            *.tar.xz)   tar xJf "$1"    ;;
            *.tar)      tar xf "$1"     ;;
            *.zip)      unzip "$1"      ;;
            *.gz)       gunzip "$1"     ;;
            *.bz2)      bunzip2 "$1"    ;;
            *.7z)       7z x "$1"       ;;
            *.rar)      unrar x "$1"    ;;
            *)          echo "Không hỗ trợ định dạng: $1" ;;
        esac
    else
        echo "File không tồn tại: $1"
    fi
}

# Xem process đang dùng port nào
# Dùng: whoisport 8080
whoisport() {
    lsof -i :"$1"
}

# Backup nhanh file
# Dùng: bak myfile.txt  → tạo myfile.txt.bak
bak() {
    cp "$1" "${1}.bak" && echo "✓ Backup: ${1}.bak"
}

# Xem 10 lệnh dùng nhiều nhất
topcmds() {
    history | awk '{print $2}' | sort | uniq -c | sort -rn | head -10
}
