#!/bin/bash
# TIP 日报自动采集脚本
# 由系统 crontab 调用： 3 0 * * * /home/ubuntu/TIP/run_daily.sh >> /home/ubuntu/TIP/logs/cron.log 2>&1

set -e

export HOME=/home/ubuntu
export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
export CLAUDE_CODE_SIMPLE=1

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
mkdir -p "$LOG_DIR"

exec 1> >(tee -a "$LOG_DIR/$(date +%Y%m%d).log")
exec 2>&1

echo "=== TIP 日报开始 $(date) ==="

cd "$SCRIPT_DIR"
git pull origin main --rebase 2>/dev/null || true

claude -p --max-budget-usd 2 --allowedTools "Bash,Read,Write,Edit,WebSearch,WebFetch,Glob,Grep" "$(cat $SCRIPT_DIR/prompts/daily.md)"

echo "=== TIP 日报结束 $(date) ==="
