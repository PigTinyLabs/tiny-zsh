# =============================================================================
# PLUGINS/GIT/GIT.PLUGIN.ZSH — Git aliases (chuẩn Oh My Zsh + mở rộng)
# =============================================================================
# Alias được nhóm theo chức năng, giống hệt Oh My Zsh.
# Điểm khác: có comment tiếng Việt giải thích từng nhóm.
#
# Xem toàn bộ alias đang active: alias | grep "^g"
# =============================================================================

myzsh_has "git" || { myzsh_warn "Plugin git: lệnh 'git' không tìm thấy"; return; }

# ── Hàm nội bộ: lấy branch hiện tại ─────────────────────────────────────────
# NOTE: Hàm này được dùng bởi ggp, ggl, ggu bên dưới.
#       Tự động nhận biết branch hiện tại không cần gõ tên.
git_current_branch() {
    git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null
}

# ── Cơ bản ───────────────────────────────────────────────────────────────────
alias g='git'
alias gst='git status'                         # NOTE: OMZ dùng gst, không phải gs
alias gsts='git status --short'                # Status ngắn gọn (1 ký tự mỗi file)

# ── Add / Stage ───────────────────────────────────────────────────────────────
alias ga='git add'
alias gaa='git add --all'                      # Stage tất cả (kể cả file mới + xoá)
alias gapa='git add --patch'                   # Stage từng chunk, hỏi y/n/s/q
alias gau='git add --update'                   # Stage file đã track (bỏ qua file mới)

# ── Commit ────────────────────────────────────────────────────────────────────
alias gc='git commit --verbose'                # Mở editor, xem diff bên dưới
alias gc!='git commit --verbose --amend'       # Sửa commit cuối (cả message)
alias gcn!='git commit --verbose --no-edit --amend' # Sửa commit cuối, GIỮ message cũ
alias gcm='git commit -m'                      # Commit nhanh: gcm "message"
alias gcam='git commit -a -m'                  # Add all + commit: gcam "message"
alias gca='git commit -a --verbose'            # Add all + mở editor

# Work In Progress: lưu nhanh không cần message (dùng khi cần chuyển branch gấp)
# NOTE: Dùng gunwip để hoàn tác
alias gwip='git add -A; git rm $(git ls-files --deleted) 2>/dev/null; git commit --no-verify --message "--wip-- [skip ci]"'
alias gunwip='git log --oneline | grep -q "\-\-wip\-\-" && git reset HEAD~1'

# ── Diff ──────────────────────────────────────────────────────────────────────
alias gd='git diff'                            # Diff file chưa stage
alias gds='git diff --staged'                  # Diff file đã staged (sắp commit)
alias gdt='git diff-tree --no-commit-id --name-only -r' # File thay đổi trong 1 commit: gdt <hash>
alias gdw='git diff --word-diff'               # Diff theo từ (thay vì dòng)

# ── Branch ────────────────────────────────────────────────────────────────────
alias gb='git branch'
alias gba='git branch --all'                   # Liệt kê tất cả branch (cả remote)
alias gbd='git branch --delete'                # Xoá branch (chỉ xoá khi đã merge)
alias gbD='git branch --delete --force'        # Xoá branch bất kể đã merge chưa
alias gbm='git branch --move'                  # Đổi tên branch: gbm tên-mới
alias gbnm='git branch --no-merged'            # Các branch chưa merge vào branch hiện tại
alias gbr='git branch --remote'                # Chỉ liệt kê remote branch

# ── Checkout / Switch ────────────────────────────────────────────────────────
alias gco='git checkout'
alias gcob='git checkout -b'                   # Tạo branch mới: gcob feature/login
alias gcom='git checkout $(git_default_branch 2>/dev/null || echo main)'
alias gsw='git switch'
alias gswc='git switch --create'               # Tạo + switch: gswc feature/login
alias gswm='git switch main 2>/dev/null || git switch master'

# ── Push ──────────────────────────────────────────────────────────────────────
# NOTE: Đây là nhóm alias hay dùng nhất, giống hệt Oh My Zsh

# ggp — Push branch HIỆN TẠI lên origin (không cần gõ tên branch!)
# Dùng: ggp          → git push origin <branch-hiện-tại>
# Dùng: ggp branch   → git push origin branch
ggp() {
    if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
        git push origin "${*}"
    else
        [[ "$#" == 0 ]] && local b="$(git_current_branch)"
        git push origin "${b:=$1}"
    fi
}
compdef _git ggp=git-checkout

# ggf — Force push origin (giống Oh My Zsh)
ggf() {
    [[ "$#" != 1 ]] && local b="$(git_current_branch)"
    git push --force origin "${b:=$1}"
}
compdef _git ggf=git-checkout

# ggfl — Force push with lease origin (giống Oh My Zsh)
ggfl() {
    [[ "$#" != 1 ]] && local b="$(git_current_branch)"
    git push --force-with-lease origin "${b:=$1}"
}
compdef _git ggfl=git-checkout

# gpsup / ggsup — Push và set upstream cùng lúc (lần đầu push branch mới)
# Dùng: gpsup        → git push --set-upstream origin <branch-hiện-tại>
alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
alias gpsupf='git push --set-upstream origin $(git_current_branch) --force-with-lease'

# gpf — Force push an toàn (kiểm tra không ai push trước)
alias gpf='git push --force-with-lease'
alias gpf!='git push --force'                  # ⚠ Force push tuyệt đối (nguy hiểm)

alias gp='git push'
alias ggpush='git push origin $(git_current_branch)'
alias gpoat='git push origin --all && git push origin --tags'

# ── Pull ──────────────────────────────────────────────────────────────────────
# NOTE: Nhóm alias pull, giống hệt Oh My Zsh

# ggl — Pull branch HIỆN TẠI từ origin
# Dùng: ggl          → git pull origin <branch-hiện-tại>
# Dùng: ggl branch   → git pull origin branch
ggl() {
    if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
        git pull origin "${*}"
    else
        [[ "$#" == 0 ]] && local b="$(git_current_branch)"
        git pull origin "${b:=$1}"
    fi
}
compdef _git ggl=git-checkout

# ggu — Pull rebase branch HIỆN TẠI (giữ history sạch hơn merge)
# Dùng: ggu          → git pull --rebase origin <branch-hiện-tại>
ggu() {
    [[ "$#" != 1 ]] && local b="$(git_current_branch)"
    git pull --rebase origin "${b:=$1}"
}
compdef _git ggu=git-checkout

# ggpur — Pull rebase origin (giống OMZ)
alias ggpur='ggu'

# ggpull — Pull origin (giống OMZ)
alias ggpull='git pull origin $(git_current_branch)'

# ggpnp — Pull rồi Push branch hiện tại (sync nhanh)
# NOTE: Tương đương ggl && ggp
ggpnp() {
    if [[ "$#" == 0 ]]; then
        ggl && ggp
    else
        ggl "${*}" && ggp "${*}"
    fi
}
compdef _git ggpnp=git-checkout

alias gpl='git pull'
alias gplr='git pull --rebase'
alias gf='git fetch'
alias gfa='git fetch --all --prune'            # Fetch tất cả remote, xoá branch đã xoá trên remote
alias gfo='git fetch origin'

# ── Log ───────────────────────────────────────────────────────────────────────
# NOTE: gl và glg là 2 alias log hay dùng nhất
alias gl='git pull'                            # NOTE: OMZ dùng gl = git pull, không phải log!
alias glo='git log --oneline --decorate'
alias gloa='git log --oneline --decorate --all'
alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
alias glola='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'
alias glols='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat'
alias glg='git log --stat'                     # Log kèm danh sách file thay đổi
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias gll='git log --oneline -15'             # 15 commit gần nhất, ngắn gọn

# ── Stash ─────────────────────────────────────────────────────────────────────
alias gsta='git stash push'                    # Stash (kể cả file mới chưa track: thêm -u)
alias gstp='git stash pop'                     # Lấy stash mới nhất ra
alias gstl='git stash list'                    # Danh sách các stash
alias gstd='git stash drop'                    # Xoá stash mới nhất
alias gstc='git stash clear'                   # Xoá tất cả stash ⚠
alias gsts='git stash show --text'             # Xem nội dung stash mới nhất
alias gstaa='git stash apply'                  # Apply stash không xoá khỏi list

# ── Rebase ────────────────────────────────────────────────────────────────────
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase --interactive'          # Interactive rebase: grbi HEAD~3
alias grbs='git rebase --skip'
alias grbo='git rebase --onto'

# ── Merge ─────────────────────────────────────────────────────────────────────
alias gm='git merge'
alias gma='git merge --abort'
alias gmom='git merge origin/main'             # NOTE: Đổi main → master nếu cần
alias gmt='git mergetool --no-prompt'

# ── Reset / Restore ───────────────────────────────────────────────────────────
alias grh='git reset'                          # Unstage (giữ thay đổi trong file)
alias grhh='git reset --hard'                  # ⚠ Bỏ mọi thay đổi chưa commit
alias groh='git reset origin/$(git_current_branch) --hard' # Reset về trạng thái remote
alias grs='git restore'
alias grss='git restore --staged'              # Unstage file: grss <file>
alias gru='git reset --'                       # Unstage file cụ thể: gru <file>

# ── Remote ────────────────────────────────────────────────────────────────────
alias gr='git remote'
alias grv='git remote --verbose'
alias gra='git remote add'                     # Thêm remote: gra origin <url>
alias grrm='git remote remove'
alias grset='git remote set-url'               # Đổi URL remote: grset origin <url>
alias grup='git remote update'

# ── Tag ───────────────────────────────────────────────────────────────────────
alias gt='git tag'
alias gta='git tag --annotate'                 # Tạo tag có message: gta v1.0.0
alias gtl='git tag --list | sort -V'           # Liệt kê tag, sắp xếp theo version
alias gtp='git push --tags'                    # Push tất cả tags lên remote

# ── Cherry-pick ───────────────────────────────────────────────────────────────
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

# ── Worktree (làm việc nhiều branch song song) ────────────────────────────────
alias gwt='git worktree'
alias gwta='git worktree add'
alias gwtl='git worktree list'
alias gwtrm='git worktree remove'

# ── Điều hướng ───────────────────────────────────────────────────────────────
# grt — cd về thư mục gốc của git repo (dù bạn đang ở thư mục con nào)
alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'

# ── Hàm tiện ích (không có trong OMZ) ────────────────────────────────────────

# Xoá tất cả branch đã merge vào main/master
# NOTE: Đổi "main" thành "master" nếu repo dùng master
gclean-branches() {
    local main="${1:-main}"
    echo "Xoá các branch đã merge vào '$main'..."
    git branch --merged "$main" \
        | grep -vE "^\*|$main|master|develop" \
        | xargs -r git branch -d
    echo "✓ Xong"
}

# Commit nhanh: add all + commit 1 lệnh
# Dùng: gcq "fix login bug"
gcq() { git add --all && git commit -m "$1"; }

# Push branch mới lên remote + set upstream (1 lệnh)
# Dùng: gpush (tự lấy tên branch hiện tại)
gpush() { git push --set-upstream origin "$(git_current_branch)"; }

# Tìm commit chứa từ khoá trong message
# Dùng: gfind "fix login"
gfind() { git log --all --oneline --grep="$1"; }

# Xem ai sửa dòng nào trong file
# Dùng: gblame src/app.js
gblame() { git log --follow -p -- "$1" | head -80; }

# So sánh branch hiện tại với branch khác
# Dùng: gdiff main
gdiff() { git diff "$(git_current_branch)".."${1:-main}"; }
