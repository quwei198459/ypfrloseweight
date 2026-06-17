#!/usr/bin/env bash
# =============================================================================
# 宝护健康瘦 一键部署脚本（本地构建 → rsync 上传 → systemctl 重启）
#
# 用法：
#   ./scripts/deploy.sh backend        构建后端 jar + 上传 + 重启服务（默认）
#   ./scripts/deploy.sh backend --no-build   跳过构建，直接上传现有 jar + 重启
#   ./scripts/deploy.sh admin          构建管理后台 + 上传 dist + reload nginx
#   ./scripts/deploy.sh all            后端 + 管理后台都部署
#   ./scripts/deploy.sh restart        仅重启后端服务（不构建/上传）
#   ./scripts/deploy.sh stop           关闭后端服务
#   ./scripts/deploy.sh start          启动后端服务
#   ./scripts/deploy.sh status         查看后端服务状态
#   ./scripts/deploy.sh logs           实时跟踪后端日志（Ctrl+C 退出）
#
# 可用环境变量覆盖（默认值见下方）：
#   DEPLOY_SSH_HOST   SSH 目标，默认 root@8.136.24.243（建议改成 ~/.ssh/config 里的别名 aliyun-www）
#   REMOTE_JAR        远端 jar 路径，默认 /www/backend/loseweight-api.jar
#   REMOTE_ADMIN_DIR  远端管理后台目录，默认 /www/admin
#   SERVICE           systemd 服务名，默认 loseweight-api
# =============================================================================
set -euo pipefail

# 切到仓库根目录（脚本在 scripts/ 下）
cd "$(dirname "$0")/.."

SSH_HOST="${DEPLOY_SSH_HOST:-root@8.136.24.243}"
REMOTE_JAR="${REMOTE_JAR:-/www/backend/loseweight-api.jar}"
REMOTE_ADMIN_DIR="${REMOTE_ADMIN_DIR:-/www/frontend-admin}"
SERVICE="${SERVICE:-loseweight-api}"
HEALTH_PORT="${HEALTH_PORT:-8081}"

bold() { printf "\033[1m%s\033[0m\n" "$*"; }
info() { printf "\033[36m==>\033[0m %s\n" "$*"; }
ok()   { printf "\033[32m✓\033[0m %s\n" "$*"; }
die()  { printf "\033[31m✗ %s\033[0m\n" "$*" >&2; exit 1; }

# 复用 SSH 主连接，避免每条命令重新握手（首次连上后后续秒连）
SSH_OPTS=(-o ControlMaster=auto -o "ControlPath=$HOME/.ssh/cm-%r@%h:%p" -o ControlPersist=10m -o ServerAliveInterval=30)
remote() { ssh "${SSH_OPTS[@]}" "$SSH_HOST" "$@"; }

resolve_jar() {
  # 取 target 下最新的主 jar（排除 sources/javadoc），兼容 SNAPSHOT 命名
  ls -t backend/target/*.jar 2>/dev/null | grep -vE 'sources|javadoc' | head -1
}

deploy_backend() {
  local no_build="${1:-}"
  if [[ "$no_build" != "--no-build" ]]; then
    info "构建后端（mvn clean package -DskipTests）"
    ( cd backend && mvn -q clean package -DskipTests ) || die "后端构建失败"
  else
    info "跳过构建，使用现有 jar"
  fi

  local jar; jar="$(resolve_jar)"
  [[ -n "$jar" && -f "$jar" ]] || die "未找到可上传的 jar，请先构建：cd backend && mvn package -DskipTests"
  bold "上传 $jar  →  $SSH_HOST:$REMOTE_JAR"

  info "rsync 上传 jar（仅传差异）"
  rsync -az --progress -e "ssh ${SSH_OPTS[*]}" "$jar" "$SSH_HOST:$REMOTE_JAR" || die "上传失败"

  info "重启 systemd 服务：$SERVICE"
  remote "systemctl restart $SERVICE && sleep 2 && systemctl --no-pager status $SERVICE | head -n 12" \
    || die "重启失败，请查看：./scripts/deploy.sh logs"
  ok "后端部署完成"
  info "健康检查：curl http://127.0.0.1:$HEALTH_PORT/api/v1/health（远端）"
  remote "curl -s -o /dev/null -w 'health HTTP %{http_code}\n' http://127.0.0.1:$HEALTH_PORT/api/v1/health || true"
}

deploy_admin() {
  info "构建管理后台（npm run build）"
  ( cd admin-frontend && npm run build ) || die "管理后台构建失败"
  [[ -d admin-frontend/dist ]] || die "未找到 admin-frontend/dist"

  info "rsync 上传 dist → $SSH_HOST:$REMOTE_ADMIN_DIR（--delete 清理旧文件）"
  rsync -az --delete --progress -e "ssh ${SSH_OPTS[*]}" admin-frontend/dist/ "$SSH_HOST:$REMOTE_ADMIN_DIR/" \
    || die "上传失败"

  info "校验并重载 nginx"
  remote "nginx -t && systemctl reload nginx" || die "nginx 重载失败"
  ok "管理后台部署完成"
}

case "${1:-backend}" in
  backend) deploy_backend "${2:-}";;
  admin)   deploy_admin;;
  all)     deploy_backend "${2:-}"; deploy_admin;;
  restart) info "重启 $SERVICE"; remote "systemctl restart $SERVICE && systemctl --no-pager status $SERVICE | head -n 12";;
  stop)    info "停止 $SERVICE"; remote "systemctl stop $SERVICE && systemctl --no-pager status $SERVICE | head -n 6 || true";;
  start)   info "启动 $SERVICE"; remote "systemctl start $SERVICE && systemctl --no-pager status $SERVICE | head -n 12";;
  status)  remote "systemctl --no-pager status $SERVICE | head -n 20";;
  logs)    info "跟踪日志（Ctrl+C 退出）"; remote "journalctl -u $SERVICE -f -n 100";;
  *) die "未知命令：$1（可用：backend|admin|all|restart|stop|start|status|logs）";;
esac
