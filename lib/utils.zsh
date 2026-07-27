# =============================================================================
# LIB/UTILS.ZSH — Hàm tiện ích nội bộ của framework
# =============================================================================
# Các hàm ở đây được dùng bởi themes và plugins.
# Bạn cũng có thể gọi chúng trong custom.zsh
# =============================================================================

# ── Màu ANSI ─────────────────────────────────────────────────────────────────
# NOTE: Dùng các biến này trong theme để tô màu prompt.
#       Cú pháp: "%{$fg[red]%}text%{$reset_color%}"
#       Zsh tự load autoload colors khi gọi hàm colors bên dưới.
autoload -U colors && colors

# Shortcut màu thường dùng (dùng trong theme)
# Ví dụ: echo "${C_GREEN}Hello${C_RESET}"
C_RED="%{$fg[red]%}"
C_GREEN="%{$fg[green]%}"
C_YELLOW="%{$fg[yellow]%}"
C_BLUE="%{$fg[blue]%}"
C_MAGENTA="%{$fg[magenta]%}"
C_CYAN="%{$fg[cyan]%}"
C_WHITE="%{$fg[white]%}"
C_RESET="%{$reset_color%}"

# Màu bold
C_BOLD_RED="%{$fg_bold[red]%}"
C_BOLD_GREEN="%{$fg_bold[green]%}"
C_BOLD_YELLOW="%{$fg_bold[yellow]%}"
C_BOLD_BLUE="%{$fg_bold[blue]%}"
C_BOLD_CYAN="%{$fg_bold[cyan]%}"
C_BOLD_WHITE="%{$fg_bold[white]%}"

# ── Hàm kiểm tra lệnh tồn tại ────────────────────────────────────────────────
# NOTE: Dùng hàm này trong plugin để kiểm tra dependency.
#       Ví dụ: pigtinylabs_has "git" || return
#
# Cách dùng: pigtinylabs_has <tên-lệnh>
# Return:    0 nếu tồn tại, 1 nếu không
pigtinylabs_has() {
    command -v "$1" >/dev/null 2>&1
}

# ── Hàm in thông báo của framework ───────────────────────────────────────────
# NOTE: Dùng để in log có prefix [pigtinylabs] thống nhất
pigtinylabs_info()  { echo "[pigtinylabs] $1"; }
pigtinylabs_warn()  { echo "[pigtinylabs] ⚠ $1"; }
pigtinylabs_error() { echo "[pigtinylabs] ✗ $1"; }

# ── Kiểm tra đang trong git repo không ───────────────────────────────────────
# NOTE: Hàm này được dùng bởi theme để hiện/ẩn git info trên prompt.
#       Return 0 nếu đang trong git repo, 1 nếu không.
pigtinylabs_is_git_repo() {
    git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

# ── Lấy tên branch git hiện tại ──────────────────────────────────────────────
# NOTE: Trả về tên branch, hoặc chuỗi rỗng nếu không phải git repo.
#       Dùng trong theme: branch=$(pigtinylabs_git_branch)
pigtinylabs_git_branch() {
    pigtinylabs_is_git_repo || return
    git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null
}

# ── Lấy trạng thái git (dirty / clean) ───────────────────────────────────────
# NOTE: Trả về ký hiệu thể hiện trạng thái working tree.
#       "" = clean (không có file thay đổi)
#       "✗" = có file chưa commit
#
#       Để đổi ký hiệu, sửa hai dòng echo bên dưới.
pigtinylabs_git_status() {
    pigtinylabs_is_git_repo || return
    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
        echo "✗"   # NOTE: Đổi ký hiệu "dirty" ở đây
    else
        echo ""     # NOTE: Đổi ký hiệu "clean" ở đây (hoặc để trống)
    fi
}

# ── Rút gọn đường dẫn ─────────────────────────────────────────────────────────
# NOTE: Dùng trong theme để hiện đường dẫn ngắn gọn.
#       Ví dụ: ~/projects/myapp/src → ~/p/m/src
#
# Cách dùng: pigtinylabs_short_path [độ-sâu]
#   Mặc định độ sâu = 3 (giữ lại 3 cấp thư mục cuối)
pigtinylabs_short_path() {
    local depth="${1:-3}"
    local path="${PWD/#$HOME/~}"
    
    # Nếu đường dẫn ngắn hơn depth thì giữ nguyên
    local parts=(${(s:/:)path})
    if (( ${#parts[@]} <= depth )); then
        echo "$path"
        return
    fi
    
    # Rút gọn các phần đầu thành chữ cái đầu
    local result=""
    local limit=$(( ${#parts[@]} - depth + 1 ))
    for (( i=1; i<limit; i++ )); do
        result+="${parts[i][1]}/"
    done
    for (( i=limit; i<=${#parts[@]}; i++ )); do
        result+="${parts[i]}/"
    done
    echo "${result%/}"
}

# ── Đo thời gian thực thi lệnh ────────────────────────────────────────────────
# NOTE: Hiển thị thời gian chạy lệnh nếu lâu hơn ngưỡng (mặc định 5 giây).
#       Thêm vào theme bằng cách gọi _pigtinylabs_preexec và _pigtinylabs_precmd.
#       Biến PIGTINYLABS_CMD_TIME_THRESHOLD: số giây tối thiểu để hiển thị (mặc định 5)
PIGTINYLABS_CMD_TIME_THRESHOLD="${PIGTINYLABS_CMD_TIME_THRESHOLD:-5}"
_pigtinylabs_cmd_start_time=0

_pigtinylabs_preexec() {
    _pigtinylabs_cmd_start_time=$SECONDS
}

_pigtinylabs_precmd_timer() {
    local elapsed=$(( SECONDS - _pigtinylabs_cmd_start_time ))
    if (( _pigtinylabs_cmd_start_time > 0 && elapsed >= PIGTINYLABS_CMD_TIME_THRESHOLD )); then
        echo "[pigtinylabs] ⏱ Lệnh chạy ${elapsed}s"
    fi
    _pigtinylabs_cmd_start_time=0
}

# Hook vào Zsh
autoload -Uz add-zsh-hook
add-zsh-hook preexec _pigtinylabs_preexec
add-zsh-hook precmd  _pigtinylabs_precmd_timer
