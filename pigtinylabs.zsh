# =============================================================================
# PIGTINYLABS.ZSH — Điểm khởi động chính của framework
# =============================================================================
# File này được source từ ~/.zshrc
# Thứ tự load: lib → config → theme → plugins → aliases
# =============================================================================

# ── Đường dẫn gốc của framework ────────────────────────────────────────────
# NOTE: Tất cả file trong framework đều dùng $PIGTINYLABS để tham chiếu lẫn nhau.
#       Đừng thay đổi tên biến này.
export PIGTINYLABS="$HOME/.pigtinylabs"

# ── Chọn Theme ──────────────────────────────────────────────────────────────
# NOTE: Đổi tên theme ở đây để thay giao diện prompt.
#       Các theme nằm trong thư mục ~/.pigtinylabs/themes/
#       Tên file: <tên-theme>.zsh-theme
#       Ví dụ: "minimal", "powerline", "clean"
#
#       Để tắt theme (tự viết prompt): gán PIGTINYLABS_THEME=""
export PIGTINYLABS_THEME="tiny"

# ── Chọn Plugins ────────────────────────────────────────────────────────────
# NOTE: Thêm tên plugin vào mảng này để kích hoạt.
#       Mỗi plugin là 1 file trong ~/.pigtinylabs/plugins/<tên>/<tên>.plugin.zsh
#       Thứ tự trong mảng = thứ tự load.
#
#       Plugin có sẵn:
#         - git          : shortcuts cho git
#         - aliases      : các alias hữu ích
#         - autosuggestions : gợi ý lệnh từ history (cần cài thêm, xem plugin)
#         - history      : cấu hình history tốt hơn
#
#       Thêm plugin mới: tạo thư mục plugins/tên-plugin/ và file .plugin.zsh
export PIGTINYLABS_PLUGINS=(
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
PIGTINYLABS_DEBUG_LOAD_TIME="false"

# Tự động cập nhật framework (hỏi người dùng khi có phiên bản mới)
PIGTINYLABS_AUTO_UPDATE="true"

# ── Load các module core ─────────────────────────────────────────────────────
_pigtinylabs_start_time=$SECONDS

# Load thư viện nội bộ (hàm tiện ích dùng trong framework)
source "$PIGTINYLABS/lib/utils.zsh"

# Kiểm tra cập nhật nếu được bật
if [[ "$PIGTINYLABS_AUTO_UPDATE" == "true" ]]; then
    source "$PIGTINYLABS/lib/update.zsh"
fi

# Load cấu hình Zsh cơ bản (completion, keybinds, options)
source "$PIGTINYLABS/lib/zsh-config.zsh"

# ── Load Theme ───────────────────────────────────────────────────────────────
if [[ -n "$PIGTINYLABS_THEME" ]]; then
    _theme_file="$PIGTINYLABS/themes/${PIGTINYLABS_THEME}.zsh-theme"
    if [[ -f "$_theme_file" ]]; then
        source "$_theme_file"
    else
        echo "[pigtinylabs] ⚠ Không tìm thấy theme: $_theme_file"
        echo "[pigtinylabs]   Kiểm tra thư mục: ls ~/.pigtinylabs/themes/"
    fi
fi

# ── Load Plugins ─────────────────────────────────────────────────────────────
for _plugin in "${PIGTINYLABS_PLUGINS[@]}"; do
    _plugin_file="$PIGTINYLABS/plugins/$_plugin/$_plugin.plugin.zsh"
    if [[ -f "$_plugin_file" ]]; then
        source "$_plugin_file"
    else
        echo "[pigtinylabs] ⚠ Plugin không tồn tại: $_plugin"
        echo "[pigtinylabs]   Tạo file: ~/.pigtinylabs/plugins/$_plugin/$_plugin.plugin.zsh"
    fi
done

# ── Load file custom của user ─────────────────────────────────────────────
# NOTE: Đây là nơi BẠN thêm cấu hình riêng mà không cần sửa file gốc.
#       File này KHÔNG bị ghi đè khi update framework.
#       Đặt alias, function, biến môi trường cá nhân vào đây.
_custom_file="$PIGTINYLABS/custom.zsh"
if [[ -f "$_custom_file" ]]; then
    source "$_custom_file"
fi

# ── Debug load time ───────────────────────────────────────────────────────────
if [[ "$PIGTINYLABS_DEBUG_LOAD_TIME" == "true" ]]; then
    echo "[pigtinylabs] Load time: $(( SECONDS - _pigtinylabs_start_time ))s"
fi

# Dọn biến tạm
unset _plugin _plugin_file _theme_file _custom_file _pigtinylabs_start_time
