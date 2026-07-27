# =============================================================================
# MYZSH.ZSH — Điểm khởi động chính của framework
# =============================================================================
# File này được source từ ~/.zshrc
# Thứ tự load: lib → config → theme → plugins → aliases
# =============================================================================

# ── Đường dẫn gốc của framework ────────────────────────────────────────────
# NOTE: Tất cả file trong framework đều dùng $MYZSH để tham chiếu lẫn nhau.
#       Đừng thay đổi tên biến này.
export MYZSH="$HOME/.myzsh"

# ── Chọn Theme ──────────────────────────────────────────────────────────────
# NOTE: Đổi tên theme ở đây để thay giao diện prompt.
#       Các theme nằm trong thư mục ~/.myzsh/themes/
#       Tên file: <tên-theme>.zsh-theme
#       Ví dụ: "minimal", "powerline", "clean"
#
#       Để tắt theme (tự viết prompt): gán MYZSH_THEME=""
export MYZSH_THEME="tiny"

# ── Chọn Plugins ────────────────────────────────────────────────────────────
# NOTE: Thêm tên plugin vào mảng này để kích hoạt.
#       Mỗi plugin là 1 file trong ~/.myzsh/plugins/<tên>/<tên>.plugin.zsh
#       Thứ tự trong mảng = thứ tự load.
#
#       Plugin có sẵn:
#         - git          : shortcuts cho git
#         - aliases      : các alias hữu ích
#         - autosuggestions : gợi ý lệnh từ history (cần cài thêm, xem plugin)
#         - history      : cấu hình history tốt hơn
#
#       Thêm plugin mới: tạo thư mục plugins/tên-plugin/ và file .plugin.zsh
export MYZSH_PLUGINS=(
    git
    aliases
    history
    # autosuggestions
    docker            # NOTE: Bỏ comment nếu dùng Docker
    docker-compose    # NOTE: Bỏ comment nếu dùng Docker Compose
)

# ── Tuỳ chọn toàn cục ───────────────────────────────────────────────────────
# NOTE: Bật/tắt các tính năng bằng cách đổi giá trị thành "true" / "false"

# Hiển thị thời gian load khi khởi động (dùng để debug nếu terminal chậm)
MYZSH_DEBUG_LOAD_TIME="false"

# Tự động cập nhật framework (hỏi người dùng khi có phiên bản mới)
MYZSH_AUTO_UPDATE="true"

# ── Load các module core ─────────────────────────────────────────────────────
_myzsh_start_time=$SECONDS

# Load thư viện nội bộ (hàm tiện ích dùng trong framework)
source "$MYZSH/lib/utils.zsh"

# Kiểm tra cập nhật nếu được bật
if [[ "$MYZSH_AUTO_UPDATE" == "true" ]]; then
    source "$MYZSH/lib/update.zsh"
fi

# Load cấu hình Zsh cơ bản (completion, keybinds, options)
source "$MYZSH/lib/zsh-config.zsh"

# ── Load Theme ───────────────────────────────────────────────────────────────
if [[ -n "$MYZSH_THEME" ]]; then
    _theme_file="$MYZSH/themes/${MYZSH_THEME}.zsh-theme"
    if [[ -f "$_theme_file" ]]; then
        source "$_theme_file"
    else
        echo "[myzsh] ⚠ Không tìm thấy theme: $_theme_file"
        echo "[myzsh]   Kiểm tra thư mục: ls ~/.myzsh/themes/"
    fi
fi

# ── Load Plugins ─────────────────────────────────────────────────────────────
for _plugin in "${MYZSH_PLUGINS[@]}"; do
    _plugin_file="$MYZSH/plugins/$_plugin/$_plugin.plugin.zsh"
    if [[ -f "$_plugin_file" ]]; then
        source "$_plugin_file"
    else
        echo "[myzsh] ⚠ Plugin không tồn tại: $_plugin"
        echo "[myzsh]   Tạo file: ~/.myzsh/plugins/$_plugin/$_plugin.plugin.zsh"
    fi
done

# ── Load file custom của user ─────────────────────────────────────────────
# NOTE: Đây là nơi BẠN thêm cấu hình riêng mà không cần sửa file gốc.
#       File này KHÔNG bị ghi đè khi update framework.
#       Đặt alias, function, biến môi trường cá nhân vào đây.
_custom_file="$MYZSH/custom.zsh"
if [[ -f "$_custom_file" ]]; then
    source "$_custom_file"
fi

# ── Debug load time ───────────────────────────────────────────────────────────
if [[ "$MYZSH_DEBUG_LOAD_TIME" == "true" ]]; then
    echo "[myzsh] Load time: $(( SECONDS - _myzsh_start_time ))s"
fi

# Dọn biến tạm
unset _plugin _plugin_file _theme_file _custom_file _myzsh_start_time
