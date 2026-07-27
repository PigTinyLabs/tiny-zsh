# =============================================================================
# LIB/UPDATE.ZSH — Kiểm tra cập nhật framework
# =============================================================================

function myzsh_check_update() {
    # Bỏ qua nếu không phải là git repo (trường hợp cài bằng file zip)
    if [[ ! -d "$MYZSH/.git" ]]; then
        return
    fi

    local update_file="$MYZSH/.update-time"
    local current_time=$(date +%s)
    local check_interval=604800 # 7 ngày (60*60*24*7)

    # Đọc thời gian kiểm tra lần cuối
    local last_check=0
    if [[ -f "$update_file" ]]; then
        last_check=$(cat "$update_file")
    fi

    local elapsed=$(( current_time - last_check ))
    
    if (( elapsed > check_interval )); then
        # Cập nhật thời gian kiểm tra (để không hỏi liên tục mỗi lần mở tab mới)
        echo "$current_time" > "$update_file"
        
        # Chạy kiểm tra update ngầm
        (
            if git -C "$MYZSH" fetch origin >/dev/null 2>&1; then
                local local_head=$(git -C "$MYZSH" rev-parse HEAD 2>/dev/null)
                local remote_head=$(git -C "$MYZSH" rev-parse origin/main 2>/dev/null || git -C "$MYZSH" rev-parse origin/master 2>/dev/null)
                
                if [[ -n "$remote_head" && "$local_head" != "$remote_head" ]]; then
                    # Tạo file flag báo có update
                    touch "$MYZSH/.update-available"
                fi
            fi
        ) &!
    fi

    # Nếu có file flag, hiện thông báo cho người dùng
    if [[ -f "$MYZSH/.update-available" ]]; then
        echo ""
        echo "[myzsh] 🌟 Có phiên bản mới của framework!"
        echo -n "[myzsh] Bạn có muốn cập nhật ngay không? [Y/n] "
        
        # Đọc input từ terminal thay vì stdin chuẩn
        local do_update
        read -r do_update </dev/tty
        
        if [[ "$do_update" =~ ^[Yy]$ || -z "$do_update" ]]; then
            echo "[myzsh] Đang cập nhật..."
            if git -C "$MYZSH" pull origin main 2>/dev/null || git -C "$MYZSH" pull origin master 2>/dev/null; then
                echo "[myzsh] ✅ Cập nhật thành công! Vui lòng khởi động lại terminal."
                rm -f "$MYZSH/.update-available"
                echo "$current_time" > "$update_file"
            else
                echo "[myzsh] ❌ Cập nhật thất bại. Vui lòng kiểm tra ~/.myzsh"
            fi
        else
            echo "[myzsh] Đã bỏ qua cập nhật. Thông báo sẽ xuất hiện lại sau."
            # Bỏ qua lần này, xoá flag đi để sau 7 ngày mới check lại, hoặc có thể xoá luôn tuỳ logic
            rm -f "$MYZSH/.update-available"
        fi
        echo ""
    fi
}

myzsh_check_update
