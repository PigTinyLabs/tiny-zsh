# =============================================================================
# THEMES/POWERLINE.ZSH-THEME — Theme phong cách Powerline
# =============================================================================
# Prompt trông như này (cần font Nerd Font hoặc Powerline):
#   ╭─  ~/projects/myapp   main ✗
#   ╰─❯
#
# NOTE: Cần cài Nerd Font để hiện icon đúng:
#   brew install --cask font-meslo-lg-nerd-font   (macOS)
#   Sau đó đổi font terminal sang "MesloLGS NF"
#
# NOTE: Để dùng theme này: đổi PIGTINYLABS_THEME="powerline" trong pigtinylabs.zsh
# =============================================================================

# ── Ký hiệu Powerline (cần Nerd Font) ────────────────────────────────────────
# NOTE: Nếu hiện □ hoặc ? thay vì icon → bạn chưa cài Nerd Font
PL_SEP=""        # Separator tam giác (U+E0B0)
PL_SEP_THIN=""   # Separator mỏng (U+E0B1)
PL_BRANCH=""     # Icon git branch (U+E0A0)
PL_LOCK=""       # Icon lock cho thư mục readonly
PL_DIR=""        # Icon thư mục (U+F07B)

# Nếu không có Nerd Font, dùng ký tự ASCII thay thế:
# PL_SEP=">"
# PL_BRANCH="git:"

# ── Màu Powerline ─────────────────────────────────────────────────────────────
# NOTE: Dùng mã màu 256 để có nhiều lựa chọn hơn
#       Tham khảo bảng màu: https://www.ditig.com/256-colors-cheat-sheet

PL_BG_PATH=24          # Màu nền đường dẫn (xanh dương đậm)
PL_FG_PATH=255         # Màu chữ đường dẫn (trắng)
PL_BG_GIT=136          # Màu nền git (vàng cam)
PL_FG_GIT=0            # Màu chữ git (đen)
PL_BG_DIRTY=124        # Màu nền khi có thay đổi (đỏ)
PL_FG_DIRTY=255        # Màu chữ khi dirty (trắng)

# ── Hàm tô màu nền/chữ theo mã 256 ──────────────────────────────────────────
_pl_bg() { echo -n "%K{$1}"; }
_pl_fg() { echo -n "%F{$1}"; }
_pl_reset() { echo -n "%k%f"; }

# ── Build segment: [bg_trước, fg_trước] → [bg_sau] ───────────────────────────
# NOTE: Hàm này vẽ mũi tên chuyển màu giữa 2 segment
_pl_arrow() {
    local prev_bg="$1" next_bg="$2"
    echo -n "$(_pl_bg $next_bg)$(_pl_fg $prev_bg)${PL_SEP}"
}

# ── Build toàn bộ prompt ──────────────────────────────────────────────────────
_pigtinylabs_precmd_prompt() {
    local path_segment git_segment

    # Segment 1: Đường dẫn
    local current_path="${PWD/#$HOME/~}"
    path_segment="$(_pl_bg $PL_BG_PATH)$(_pl_fg $PL_FG_PATH) ${PL_DIR} ${current_path} "

    # Segment 2: Git (nếu có)
    git_segment=""
    if pigtinylabs_is_git_repo; then
        local branch status_sym git_user
        branch=$(pigtinylabs_git_branch)
        status_sym=$(pigtinylabs_git_status)
        git_user=$(git config user.name 2>/dev/null)
        [[ -z "$git_user" ]] && git_user="git"

        if [[ -n "$status_sym" ]]; then
            git_segment+="$(_pl_fg $PL_BG_PATH)$(_pl_bg $PL_BG_DIRTY)${PL_SEP}"
            git_segment+="$(_pl_fg $PL_FG_DIRTY) ${git_user}:${PL_BRANCH} ${branch} ${status_sym} "
            git_segment+="$(_pl_fg $PL_BG_DIRTY)$(_pl_bg 0)${PL_SEP}"
        else
            git_segment+="$(_pl_fg $PL_BG_PATH)$(_pl_bg $PL_BG_GIT)${PL_SEP}"
            git_segment+="$(_pl_fg $PL_FG_GIT) ${git_user}:${PL_BRANCH} ${branch} "
            git_segment+="$(_pl_fg $PL_BG_GIT)$(_pl_bg 0)${PL_SEP}"
        fi
    else
        path_segment+="$(_pl_fg $PL_BG_PATH)$(_pl_bg 0)${PL_SEP}"
    fi

    # Ghép dòng 1
    local line1="╭─${path_segment}${git_segment}$(_pl_reset)"

    # Dòng 2: ký hiệu nhập
    local symbol_color
    symbol_color="%(?.%F{green}.%F{red})"
    local line2="╰─${symbol_color}❯%f "

    PROMPT="${line1}"$'\n'"${line2}"
    RPROMPT="%F{240}%D{%H:%M}%f"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _pigtinylabs_precmd_prompt
