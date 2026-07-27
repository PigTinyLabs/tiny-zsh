# =============================================================================
# THEMES/MINIMAL.ZSH-THEME — Theme mặc định: sạch + git status
# =============================================================================
# Prompt trông như này:
#   ~/projects/myapp  main ✗
#   ❯
#
# NOTE: Để tạo theme của riêng bạn:
#   1. Copy file này: cp minimal.zsh-theme mytheme.zsh-theme
#   2. Đổi PIGTINYLABS_THEME="mytheme" trong pigtinylabs.zsh
#   3. Sửa biến PROMPT và RPROMPT bên dưới
# =============================================================================

# ── Ký hiệu prompt ───────────────────────────────────────────────────────────
# NOTE: Đổi các ký hiệu này để thay đổi giao diện

PIGTINYLABS_PROMPT_SYMBOL="❯"          # NOTE: Ký hiệu prompt chính (thử: $, %, ➜, →)
PIGTINYLABS_PROMPT_SYMBOL_ROOT="#"     # NOTE: Ký hiệu khi là root user
PIGTINYLABS_GIT_PREFIX=" "             # NOTE: Icon trước tên branch (thử: 🌿  )
PIGTINYLABS_GIT_DIRTY="✗"             # NOTE: Ký hiệu có thay đổi chưa commit
PIGTINYLABS_GIT_CLEAN=""               # NOTE: Ký hiệu repo sạch (bỏ trống nếu không muốn hiện)

# ── Màu sắc ──────────────────────────────────────────────────────────────────
# NOTE: Các màu hợp lệ: black, red, green, yellow, blue, magenta, cyan, white
#       Thêm "bold" để in đậm, ví dụ: %B%F{cyan}

PIGTINYLABS_COLOR_PATH="cyan"          # NOTE: Màu đường dẫn thư mục
PIGTINYLABS_COLOR_GIT="yellow"         # NOTE: Màu thông tin git
PIGTINYLABS_COLOR_GIT_DIRTY="red"      # NOTE: Màu khi có file thay đổi
PIGTINYLABS_COLOR_SYMBOL_OK="green"    # NOTE: Màu ký hiệu prompt (lệnh thành công)
PIGTINYLABS_COLOR_SYMBOL_ERR="red"     # NOTE: Màu ký hiệu prompt (lệnh thất bại)
PIGTINYLABS_COLOR_TIME="white"         # NOTE: Màu giờ hiện tại (RPROMPT)

# ── Tuỳ chọn hiển thị ────────────────────────────────────────────────────────
# NOTE: Bật/tắt từng phần của prompt
PIGTINYLABS_SHOW_TIME=true             # Hiện giờ hiện tại bên phải (RPROMPT)
PIGTINYLABS_SHOW_USERNAME=false        # Hiện tên user (hữu ích khi SSH)
PIGTINYLABS_SHOW_HOSTNAME=false        # Hiện tên máy (hữu ích khi SSH)
PIGTINYLABS_SHORT_PATH=true            # Rút ngắn đường dẫn dài
PIGTINYLABS_PATH_DEPTH=3               # Số cấp thư mục giữ lại khi rút gọn

# ── Hàm build phần git của prompt ─────────────────────────────────────────────
_pigtinylabs_git_prompt() {
    # Không phải git repo → không hiện gì
    pigtinylabs_is_git_repo || return

    local branch
    branch=$(pigtinylabs_git_branch)
    [[ -z "$branch" ]] && return

    local status_symbol
    status_symbol=$(pigtinylabs_git_status)

    # Chọn màu dựa trên trạng thái
    local color
    if [[ -n "$status_symbol" ]]; then
        color="%F{$PIGTINYLABS_COLOR_GIT_DIRTY}"
    else
        color="%F{$PIGTINYLABS_COLOR_GIT}"
    fi

    # NOTE: Sửa format chuỗi này để thay đổi cách hiển thị git
    #       Ví dụ thêm số commit ahead/behind: xem hàm pigtinylabs_git_ahead_behind trong utils
    echo -n " ${color}${PIGTINYLABS_GIT_PREFIX}${branch}${status_symbol}%f"
}

# ── Hàm build phần username@hostname ──────────────────────────────────────────
_pigtinylabs_user_host() {
    local result=""
    
    if [[ "$PIGTINYLABS_SHOW_USERNAME" == true ]]; then
        result+="%F{magenta}%n%f"      # %n = username
    fi
    
    if [[ "$PIGTINYLABS_SHOW_USERNAME" == true && "$PIGTINYLABS_SHOW_HOSTNAME" == true ]]; then
        result+="%F{white}@%f"
    fi
    
    if [[ "$PIGTINYLABS_SHOW_HOSTNAME" == true ]]; then
        result+="%F{blue}%m%f"         # %m = hostname (tên máy ngắn)
    fi
    
    [[ -n "$result" ]] && echo -n "$result "
}

# ── Hàm build đường dẫn ────────────────────────────────────────────────────────
_pigtinylabs_path_prompt() {
    if [[ "$PIGTINYLABS_SHORT_PATH" == true ]]; then
        echo -n "%F{$PIGTINYLABS_COLOR_PATH}$(pigtinylabs_short_path $PIGTINYLABS_PATH_DEPTH)%f"
    else
        # %~ = đường dẫn đầy đủ (thay ~ cho $HOME)
        echo -n "%F{$PIGTINYLABS_COLOR_PATH}%~%f"
    fi
}

# ── Hàm build ký hiệu prompt ────────────────────────────────────────────────────
# NOTE: %# tự động hiện # nếu là root, $ nếu là user thường
#       Ở đây ta dùng ký hiệu tuỳ chỉnh với màu theo exit code lệnh trước
_pigtinylabs_symbol() {
    local symbol
    # Kiểm tra là root không
    if [[ $EUID -eq 0 ]]; then
        symbol="$PIGTINYLABS_PROMPT_SYMBOL_ROOT"
    else
        symbol="$PIGTINYLABS_PROMPT_SYMBOL"
    fi
    
    # NOTE: %(?.ok.fail) là cú pháp Zsh: nếu exit code = 0 thì dùng "ok", ngược lại "fail"
    echo -n "%(?.%F{$PIGTINYLABS_COLOR_SYMBOL_OK}.%F{$PIGTINYLABS_COLOR_SYMBOL_ERR})${symbol}%f"
}

# ── Hàm precmd: chạy mỗi khi chuẩn bị hiện prompt ───────────────────────────
# NOTE: Đây là nơi PROMPT được gán lại mỗi lần.
#       Phải dùng precmd (không gán PROMPT tĩnh) để git info cập nhật động.
_pigtinylabs_precmd_prompt() {
    # ── Dòng 1: thông tin ──────────────────────────────────────────────────
    # NOTE: Sửa thứ tự/nội dung các hàm dưới để thay đổi dòng đầu prompt
    local line1=""
    line1+=$(_pigtinylabs_user_host)
    line1+=$(_pigtinylabs_path_prompt)
    line1+=$(_pigtinylabs_git_prompt)

    # ── Dòng 2: ký hiệu nhập lệnh ─────────────────────────────────────────
    # NOTE: Bỏ $'\n' nếu muốn prompt 1 dòng thay vì 2 dòng
    local line2=""
    line2+=$(_pigtinylabs_symbol)

    PROMPT="${line1}"$'\n'"${line2} "

    # ── RPROMPT: hiện bên phải ─────────────────────────────────────────────
    # NOTE: Đặt RPROMPT="" nếu không muốn hiện bên phải
    if [[ "$PIGTINYLABS_SHOW_TIME" == true ]]; then
        RPROMPT="%F{$PIGTINYLABS_COLOR_TIME}%D{%H:%M}%f"   # NOTE: %D{format} → xem man strftime
    else
        RPROMPT=""
    fi
}

# Đăng ký hook
autoload -Uz add-zsh-hook
add-zsh-hook precmd _pigtinylabs_precmd_prompt
