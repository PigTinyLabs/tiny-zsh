#!/usr/bin/env bash
# =============================================================================
# PIGTINYLABS - Lightweight Zsh Framework
# Cài đặt framework vào thư mục ~/.pigtinylabs
# =============================================================================
# CÁCH DÙNG: sh install.sh
# =============================================================================

set -e

PIGTINYLABS_DIR="$HOME/.pigtinylabs"
ZSHRC="$HOME/.zshrc"

# ── Màu sắc cho output ──────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info()    { echo -e "${CYAN}[pigtinylabs]${RESET} $1"; }
success() { echo -e "${GREEN}[pigtinylabs]${RESET} ✓ $1"; }
warn()    { echo -e "${YELLOW}[pigtinylabs]${RESET} ⚠ $1"; }
error()   { echo -e "${RED}[pigtinylabs]${RESET} ✗ $1"; exit 1; }

# ── Kiểm tra Zsh đã cài chưa ───────────────────────────────────────────────
command -v zsh >/dev/null 2>&1 || error "Zsh chưa được cài. Chạy: brew install zsh (macOS) hoặc apt install zsh (Linux)"

echo -e "${BOLD}"
cat << 'EOF'
  ____  _       _____ _             _           _         
 |  _ \(_) __ _|_   _(_)_ __  _   _| |    __ _| |__  ___  
 | |_) | |/ _` | | | | | '_ \| | | | |   / _` | '_ \/ __| 
 |  __/| | (_| | | | | | | | | |_| | |__| (_| | |_) \__ \ 
 |_|   |_|\__, | |_| |_|_| |_|\__, |_____\__,_|_.__/|___/ 
          |___/               |___/                       

 Lightweight Zsh Framework
EOF
echo -e "${RESET}"

# ── Sao chép files vào ~/.pigtinylabs ────────────────────────────────────────────
info "Đang cài đặt vào $PIGTINYLABS_DIR ..."

# Tạo backup nếu đã tồn tại
if [ -d "$PIGTINYLABS_DIR" ]; then
    BACKUP="$HOME/.pigtinylabs.backup.$(date +%Y%m%d%H%M%S)"
    warn "Đã tìm thấy ~/.pigtinylabs, backup sang $BACKUP"
    mv "$PIGTINYLABS_DIR" "$BACKUP"
fi

# Copy toàn bộ framework vào home
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp -r "$SCRIPT_DIR" "$PIGTINYLABS_DIR"
success "Đã copy files vào $PIGTINYLABS_DIR"

# ── Thêm dòng source vào .zshrc ────────────────────────────────────────────
SOURCE_LINE='source "$HOME/.pigtinylabs/pigtinylabs.zsh"'

if grep -qF 'pigtinylabs.zsh' "$ZSHRC" 2>/dev/null; then
    warn ".zshrc đã có dòng source pigtinylabs, bỏ qua"
else
    # Backup .zshrc trước khi sửa
    [ -f "$ZSHRC" ] && cp "$ZSHRC" "$ZSHRC.bak.$(date +%Y%m%d)"
    echo "" >> "$ZSHRC"
    echo "# ── PigTinyLabs Framework ──────────────────────────────────" >> "$ZSHRC"
    echo "$SOURCE_LINE" >> "$ZSHRC"
    success "Đã thêm source vào $ZSHRC"
fi

echo ""
echo -e "${GREEN}${BOLD}✓ Cài đặt hoàn tất!${RESET}"
echo ""
echo -e "  Khởi động lại terminal hoặc chạy: ${CYAN}source ~/.zshrc${RESET}"
echo ""
echo -e "  Để custom: ${CYAN}vi ~/.pigtinylabs/pigtinylabs.zsh${RESET}"
echo ""
