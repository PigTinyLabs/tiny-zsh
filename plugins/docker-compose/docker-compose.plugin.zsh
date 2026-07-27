# =============================================================================
# PLUGINS/DOCKER-COMPOSE/DOCKER-COMPOSE.PLUGIN.ZSH
# =============================================================================
# Alias chuẩn 1:1 với Oh My Zsh docker-compose plugin.
# Hỗ trợ cả "docker-compose" (v1) và "docker compose" (v2).
#
# NOTE: Thêm "docker-compose" vào PIGTINYLABS_PLUGINS trong pigtinylabs.zsh để bật.
#
# Xem toàn bộ alias: alias | grep "^dc"
# =============================================================================

# ── Tự nhận biết v1 hay v2 ────────────────────────────────────────────────────
# NOTE: Docker Compose v2 dùng "docker compose" (tích hợp vào docker CLI).
#       v1 dùng lệnh riêng "docker-compose".
#       Framework tự phát hiện, bạn không cần làm gì thêm.
#
#       Nếu muốn ép dùng v1 hoặc v2, bỏ comment và sửa dòng dưới:
# dccmd="docker-compose"   # Ép dùng v1
# dccmd="docker compose"   # Ép dùng v2

if pigtinylabs_has "docker" && docker compose version >/dev/null 2>&1; then
    dccmd="docker compose"     # Docker Compose v2 (tích hợp vào docker CLI)
elif pigtinylabs_has "docker-compose"; then
    dccmd="docker-compose"     # Docker Compose v1 (lệnh riêng)
else
    pigtinylabs_warn "Plugin docker-compose: không tìm thấy 'docker compose' hoặc 'docker-compose'"
    return
fi

# ── Alias chính (giống hệt Oh My Zsh) ────────────────────────────────────────
alias dco="$dccmd"                             # Lệnh gốc
alias dcb="$dccmd build"                       # Build image
alias dce="$dccmd exec"                        # Exec vào service: dce web bash
alias dcps="$dccmd ps"                         # Liệt kê container đang chạy
alias dcrestart="$dccmd restart"               # Restart service: dcrestart web
alias dcrm="$dccmd rm"                         # Xoá container (đã stop)
alias dcr="$dccmd run"                         # Chạy lệnh trong service mới: dcr web bash
alias dcstop="$dccmd stop"                     # Dừng service: dcstop web
alias dcstart="$dccmd start"                   # Khởi động service đã stop
alias dck="$dccmd kill"                        # Kill service ngay lập tức

# ── Up / Down ────────────────────────────────────────────────────────────────
alias dcup="$dccmd up"                         # Start tất cả service (foreground)
alias dcupd="$dccmd up -d"                     # Start ngầm (daemon) ← DÙNG NHIỀU NHẤT
alias dcupb="$dccmd up --build"                # Start + build lại image
alias dcupdb="$dccmd up -d --build"            # Start ngầm + build lại image ← HAY DÙNG
alias dcdn="$dccmd down"                       # Stop + xoá container
alias dcdnv="$dccmd down --volumes"            # Stop + xoá container + volume ⚠

# ── Logs ──────────────────────────────────────────────────────────────────────
alias dcl="$dccmd logs"                        # Xem log tất cả service
alias dclf="$dccmd logs -f"                    # Follow log: dclf web
alias dclF="$dccmd logs -f --tail 0"           # Follow log mới (bỏ qua log cũ)

# NOTE: Xem log 1 service cụ thể: dclf <tên-service>
# Ví dụ: dclf web → chỉ xem log service "web"

# ── Pull / Push ───────────────────────────────────────────────────────────────
alias dcpull="$dccmd pull"                     # Pull image mới nhất

# ── Config ────────────────────────────────────────────────────────────────────
alias dcconfig="$dccmd config"                 # Validate và xem config đã merge
alias dcconfigq="$dccmd config --quiet"        # Chỉ validate (không in ra)

# ── Hàm tiện ích (mở rộng hơn OMZ) ──────────────────────────────────────────

# Vào shell /bin/sh trong service đang chạy
# Dùng: dcsh web
dcsh() {
    $dccmd exec "$1" /bin/sh
}

# Vào bash trong service đang chạy
# Dùng: dcbash web
dcbash() {
    $dccmd exec "$1" /bin/bash
}

# Xem log của 1 service với số dòng tuỳ chỉnh
# Dùng: dctail web 100
dctail() {
    local service="${1:-}"
    local lines="${2:-50}"
    if [[ -z "$service" ]]; then
        echo "Dùng: dctail <service> [số-dòng]"
        return 1
    fi
    $dccmd logs --tail="$lines" --follow "$service"
}

# Restart 1 service cụ thể
# Dùng: dcr1 web
dcr1() {
    echo "Restart service: $1"
    $dccmd restart "$1"
}

# Stop tất cả + xoá + start lại (hard reset)
# Dùng: dcreset
dcreset() {
    echo "⚠ Hard reset: down + up -d"
    $dccmd down && $dccmd up -d
}

# Stop + xoá tất cả kể cả volume (dùng khi cần reset DB)
# Dùng: dcreset-volumes
dcreset-volumes() {
    echo -n "⚠ Xoá tất cả kể cả VOLUME? [y/N] "
    read -r confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || { echo "Đã huỷ"; return; }
    $dccmd down --volumes
    echo "✓ Xong. Chạy dcupd để start lại."
}

# Xem tài nguyên CPU/RAM của các container
# Dùng: dcstats
dcstats() {
    docker stats $($dccmd ps -q)
}

# Xem IP của 1 service
# Dùng: dcip web
dcip() {
    docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
        "$($dccmd ps -q "$1")"
}

# In ra lệnh docker compose đang dùng (v1 hay v2)
dcversion() {
    echo "docker-compose command: $dccmd"
    $dccmd version
}

unset dccmd
