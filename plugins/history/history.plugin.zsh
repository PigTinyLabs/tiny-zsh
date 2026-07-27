# =============================================================================
# PLUGINS/HISTORY/HISTORY.PLUGIN.ZSH — Tìm kiếm history nâng cao
# =============================================================================
# Thêm tính năng tìm kiếm và quản lý history thông minh hơn.
# NOTE: Plugin này hoạt động tốt nhất khi kết hợp với fzf:
#       brew install fzf (macOS) / apt install fzf (Linux)
# =============================================================================

# ── Tìm kiếm history với fzf ─────────────────────────────────────────────────
# NOTE: Ctrl+R mặc định của Zsh tìm kiếm đơn giản.
#       Nếu có fzf, ta override Ctrl+R để dùng giao diện tìm kiếm đẹp hơn.
if pigtinylabs_has "fzf"; then

    # Ctrl+R → mở fzf để tìm history
    # NOTE: Thay --height 40% bằng --height 80% nếu muốn cửa sổ to hơn
    fzf-history-widget() {
        local selected
        selected=$(
            history -n 1 \
            | sort -u \
            | fzf \
                --height 40% \
                --reverse \
                --border \
                --prompt="history ❯ " \
                --header="Ctrl+C để huỷ" \
                --query="${LBUFFER}"
        )
        if [[ -n "$selected" ]]; then
            LBUFFER="$selected"    # Điền vào dòng lệnh, chưa thực thi
        fi
        zle redisplay
    }
    zle -N fzf-history-widget
    bindkey '^R' fzf-history-widget

    # Ctrl+T → tìm file/thư mục với fzf
    # NOTE: Nhấn Ctrl+T để chọn file và chèn vào dòng lệnh
    fzf-file-widget() {
        local selected
        selected=$(
            find . -not -path '*/\.git/*' \
                -not -path '*/node_modules/*' \
                2>/dev/null \
            | fzf \
                --height 40% \
                --reverse \
                --border \
                --prompt="file ❯ " \
                --preview 'ls -la {} 2>/dev/null || echo {}'
        )
        if [[ -n "$selected" ]]; then
            LBUFFER+="$selected"
        fi
        zle redisplay
    }
    zle -N fzf-file-widget
    bindkey '^T' fzf-file-widget

    # Alt+C → cd vào thư mục chọn bằng fzf
    fzf-cd-widget() {
        local selected
        selected=$(
            find . -type d \
                -not -path '*/\.git/*' \
                -not -path '*/node_modules/*' \
                2>/dev/null \
            | fzf \
                --height 40% \
                --reverse \
                --border \
                --prompt="cd ❯ "
        )
        if [[ -n "$selected" ]]; then
            cd "$selected"
            zle reset-prompt
        fi
    }
    zle -N fzf-cd-widget
    bindkey '^[c' fzf-cd-widget   # Alt+C

else
    # Không có fzf: dùng tìm kiếm history cơ bản của Zsh
    # NOTE: Cài fzf để có trải nghiệm tốt hơn nhiều: brew install fzf
    bindkey '^R' history-incremental-search-backward
fi

# ── Hàm tìm lệnh trong history ────────────────────────────────────────────────
# Dùng: hs <từ-khoá>
# Ví dụ: hs docker → xem tất cả lệnh docker đã dùng
hs() {
    if [[ -z "$1" ]]; then
        echo "Dùng: hs <từ-khoá>"
        return 1
    fi
    history | grep --color=auto -i "$1"
}

# Xoá một dòng khỏi history
# Dùng: hdel <số-thứ-tự>
# Tìm số thứ tự bằng: hs <từ-khoá>
hdel() {
    if [[ -z "$1" ]]; then
        echo "Dùng: hdel <số-thứ-tự>"
        return 1
    fi
    # Xoá khỏi file history
    sed -i "${1}d" "$HISTFILE" 2>/dev/null || {
        # macOS sed cần -i ''
        sed -i '' "${1}d" "$HISTFILE"
    }
    echo "✓ Đã xoá dòng $1 khỏi history"
}

# Xoá toàn bộ history (hỏi xác nhận)
# Dùng: hclear
hclear() {
    echo -n "⚠ Xoá toàn bộ history? [y/N] "
    read -r confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        > "$HISTFILE"
        fc -p "$HISTFILE"
        echo "✓ Đã xoá history"
    else
        echo "Đã huỷ"
    fi
}
