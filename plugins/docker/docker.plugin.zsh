# =============================================================================
# PLUGINS/DOCKER/DOCKER.PLUGIN.ZSH — Docker aliases
# =============================================================================
# Alias cho lệnh docker (không phải docker compose).
# NOTE: Thêm "docker" vào PIGTINYLABS_PLUGINS trong pigtinylabs.zsh để bật.
#
# Xem toàn bộ alias: alias | grep "^dk"
# =============================================================================

pigtinylabs_has "docker" || { pigtinylabs_warn "Plugin docker: lệnh 'docker' không tìm thấy"; return; }

# ── Image ─────────────────────────────────────────────────────────────────────
alias dki='docker image'
alias dkils='docker image ls'                  # Liệt kê image
alias dkib='docker image build'                # Build image: dkib -t myapp .
alias dkipu='docker image push'                # Push image lên registry
alias dkipl='docker image pull'                # Pull image từ registry
alias dkirm='docker image rm'                  # Xoá image
alias dkiprune='docker image prune'            # Xoá tất cả image không dùng
alias dkii='docker image inspect'              # Xem chi tiết image

# ── Container ─────────────────────────────────────────────────────────────────
alias dkc='docker container'
alias dkcls='docker container ls'              # Chỉ container đang chạy
alias dkclsa='docker container ls --all'       # Tất cả container (kể cả đã stop)
alias dkcrm='docker container rm'              # Xoá container: dkcrm <id>
alias dkcrmf='docker container rm --force'     # Xoá container đang chạy (force)
alias dkcstop='docker container stop'          # Dừng container
alias dkcstart='docker container start'        # Khởi động lại container đã stop
alias dkci='docker container inspect'          # Xem chi tiết container
alias dkclogs='docker container logs'          # Xem log
alias dkclogsf='docker container logs -f'      # Xem log realtime (follow)

# ── Run container ─────────────────────────────────────────────────────────────
# NOTE: Các alias run hay dùng nhất
alias dkr='docker run'
alias dkrit='docker run --interactive --tty'   # Chạy interactive: dkrit ubuntu bash
alias dkrm='docker run --rm'                   # Chạy rồi tự xoá container
alias dkrmit='docker run --rm --interactive --tty'  # Chạy interactive + tự xoá

# Exec vào container đang chạy
alias dke='docker exec'
alias dkeit='docker exec --interactive --tty'  # Vào shell: dkeit <container> bash

# ── Volume ────────────────────────────────────────────────────────────────────
alias dkv='docker volume'
alias dkvls='docker volume ls'
alias dkvrm='docker volume rm'
alias dkvprune='docker volume prune'           # Xoá volume không dùng ⚠

# ── Network ───────────────────────────────────────────────────────────────────
alias dkn='docker network'
alias dknls='docker network ls'
alias dknrm='docker network rm'
alias dkni='docker network inspect'

# ── System ────────────────────────────────────────────────────────────────────
alias dkps='docker ps'                         # Container đang chạy
alias dkpsa='docker ps --all'                  # Tất cả container
alias dktop='docker stats'                     # Xem CPU/RAM realtime (như top)
alias dkdf='docker system df'                  # Dung lượng docker đang dùng
alias dkprune='docker system prune'            # Dọn dẹp: xoá container/image/network cũ
alias dkprunef='docker system prune --force --volumes'  # ⚠ Dọn dẹp triệt để (kể cả volume)

# ── Build ─────────────────────────────────────────────────────────────────────
alias dkb='docker build'
alias dkbt='docker build --tag'                # Build với tên: dkbt myapp:1.0 .
alias dkbnc='docker build --no-cache'          # Build không dùng cache

# ── Hàm tiện ích ──────────────────────────────────────────────────────────────

# Vào shell của container đang chạy (tự chọn sh nếu không có bash)
# Dùng: dksh <tên-container>
dksh() {
    docker exec --interactive --tty "$1" sh
}

# Vào bash của container đang chạy
# Dùng: dkbash <tên-container>
dkbash() {
    docker exec --interactive --tty "$1" bash
}

# Xem log và follow (kèm timestamp)
# Dùng: dklog <tên-container>
dklog() {
    docker logs --follow --timestamps "$1"
}

# Xoá tất cả container đã stop
# Dùng: dkclean
dkclean() {
    echo "Xoá container đã stop..."
    docker container prune --force
    echo "✓ Xong"
}

# Xoá tất cả image không có tag (dangling)
# Dùng: dkclean-images
dkclean-images() {
    echo "Xoá dangling images..."
    docker image prune --force
    echo "✓ Xong"
}

# Xem IP của container
# Dùng: dkip <tên-container>
dkip() {
    docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$1"
}

# Copy file từ container ra host
# Dùng: dkcp <container>:/path/trong/container ./đích
dkcp() {
    docker cp "$@"
}
