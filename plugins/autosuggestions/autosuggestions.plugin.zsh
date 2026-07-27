# =============================================================================
# PLUGINS/AUTOSUGGESTIONS/AUTOSUGGESTIONS.PLUGIN.ZSH
# =============================================================================
# Plugin này tích hợp zsh-autosuggestions:
#   → Gợi ý lệnh mờ khi bạn gõ (dựa vào history)
#   → Nhấn → (mũi tên phải) hoặc Ctrl+F để chấp nhận gợi ý
#   → Nhấn Alt+→ để chấp nhận từng từ một
#
# NOTE: Cần cài zsh-autosuggestions trước:
#   macOS:  brew install zsh-autosuggestions
#   Ubuntu: apt install zsh-autosuggestions
#   Manual: git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
# =============================================================================

# ── Tìm file zsh-autosuggestions ─────────────────────────────────────────────
# NOTE: Framework tự tìm ở các vị trí phổ biến.
#       Nếu cài ở nơi khác, thêm đường dẫn vào mảng _as_paths bên dưới.

_as_paths=(
    "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"          # Ubuntu/Debian apt
    "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" # macOS Homebrew (Apple Silicon)
    "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh"    # macOS Homebrew (Intel)
    "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"          # Cài thủ công
    "${XDG_DATA_HOME:-$HOME/.local/share}/zsh-autosuggestions/zsh-autosuggestions.zsh"
)

_as_loaded=false
for _as_path in "${_as_paths[@]}"; do
    if [[ -f "$_as_path" ]]; then
        source "$_as_path"
        _as_loaded=true
        break
    fi
done

if [[ "$_as_loaded" == false ]]; then
    pigtinylabs_warn "zsh-autosuggestions chưa được cài."
    pigtinylabs_warn "macOS:  brew install zsh-autosuggestions"
    pigtinylabs_warn "Ubuntu: sudo apt install zsh-autosuggestions"
fi
unset _as_paths _as_path _as_loaded

# ── Cấu hình autosuggestions ──────────────────────────────────────────────────
# NOTE: Chỉnh các biến này để thay đổi hành vi

# Màu của gợi ý mờ
# NOTE: Dùng mã màu ANSI. "fg=8" là xám (mặc định).
#       Thử: "fg=240", "fg=cyan", "fg=#555555"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8,underline"

# Nguồn gợi ý
# NOTE: "history" = gợi ý từ lịch sử, "completion" = gợi ý từ completion
#       Dùng cả hai: ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Số ký tự tối thiểu mới bắt đầu gợi ý
# NOTE: Tăng lên nếu gợi ý hiện quá sớm làm khó chịu
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50

# Không gợi ý các lệnh ngắn hơn N ký tự
# NOTE: Để tránh gợi ý lệnh "ls", "cd" v.v.
ZSH_AUTOSUGGEST_HISTORY_IGNORE="?(#c1,3)"  # Bỏ qua lệnh ≤ 3 ký tự

# ── Phím tắt ──────────────────────────────────────────────────────────────────
# NOTE: Mặc định dùng → để chấp nhận toàn bộ gợi ý.
#       Bỏ comment bindkey nào bạn muốn thêm.

# Ctrl+F: chấp nhận toàn bộ gợi ý (thay cho →)
bindkey '^F' autosuggest-accept

# Ctrl+Space: chấp nhận gợi ý (tiện khi không muốn rời phím chính)
# bindkey '^ ' autosuggest-accept

# Alt+→: chấp nhận từng từ một
bindkey '^[[1;3C' autosuggest-accept-word

# Ctrl+]: xoá gợi ý hiện tại
bindkey '^]' autosuggest-clear

# ── Tích hợp zsh-syntax-highlighting ──────────────────────────────────────────
# NOTE: Nếu cài thêm zsh-syntax-highlighting, nó sẽ tô màu lệnh khi bạn gõ.
#       Cài: brew install zsh-syntax-highlighting (macOS)
#            sudo apt install zsh-syntax-highlighting (Ubuntu)
#
#       Framework tự load nếu tìm thấy:

_sh_paths=(
    "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
)

for _sh_path in "${_sh_paths[@]}"; do
    if [[ -f "$_sh_path" ]]; then
        source "$_sh_path"
        # NOTE: Tuỳ chỉnh màu syntax highlighting ở đây
        # ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
        # ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
        break
    fi
done
unset _sh_paths _sh_path
