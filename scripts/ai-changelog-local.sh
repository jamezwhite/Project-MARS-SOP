#!/usr/bin/env bash
set -euo pipefail

# Local-only AI changelog for the *current* commit.
# Run during interactive rebase; does NOT push.

if ! git rev-parse HEAD^ >/dev/null 2>&1; then
  echo "[ai-changelog-local] Root commit detected; using 'git show'."
  DIFF=$(git show --stat --patch --format=short HEAD | head -c 12000)
else
  DIFF=$(git diff HEAD^ HEAD | head -c 12000)
fi

if [ -z "$DIFF" ]; then
  echo "[ai-changelog-local] No diff content detected; skipping."
  exit 0
fi

COMMIT_SUBJECT=$(git log -1 --pretty=%s)
COMMIT_BODY=$(git log -1 --pretty=%b)

if echo "$COMMIT_BODY" | grep -qi "AI changelog:"; then
  echo "[ai-changelog-local] Commit already has AI changelog; skipping."
  exit 0
fi

SYSTEM_PROMPT="You are an expert technical writer and LaTeX user who writes concise, accurate document change summaries from git diffs.
Your job is to produce a bullet-point changelog suitable for the body of a commit message in a long-form LaTeX project.

Guidelines:
- Stay grounded in the diff; do not invent content.
- Describe document-level changes: sections/subsections added or revised, explanations clarified, new paragraphs, updated figures/tables, citation changes, terminology/wording improvements.
- Describe human-visible effects, not raw LaTeX commands.
- Ignore trivial formatting/whitespace unless that is essentially all that changed.
- Group related edits; focus on what a reviewer would care about."

read -r -d '' USER_PROMPT <<EOF || true
You will receive a git diff for a single commit to a LaTeX-based document.

Produce a concise changelog in plain English that could be appended to the commit message body.

Output format:
- 3–6 bullet points.
- Each bullet MUST start with "- " (dash + space).
- Each bullet describes a distinct, meaningful document change or group of related changes.
- Describe content, structure, and clarity changes, not LaTeX mechanics.
- Avoid meta language like "in this commit" or "in the diff".

If the diff looks truncated, summarize as best you can from what is visible.

Diff:
$DIFF
EOF

if [ -z "${OPENAI_API_KEY:-}" ]; then
  echo "[ai-changelog-local] ERROR: OPENAI_API_KEY is not set."
  exit 1
fi

JSON_PAYLOAD=$(
  jq -n \
    --arg sys "$SYSTEM_PROMPT" \
    --arg user "$USER_PROMPT" \
    '{
      "model": "gpt-5-mini",
      "messages": [
        { "role": "system", "content": $sys },
        { "role": "user",   "content": $user }
      ]
    }'
)

echo "[ai-changelog-local] Requesting summary from gpt-5-mini..."

API_RESPONSE=$(printf '%s' "$JSON_PAYLOAD" | \
  curl -sS https://api.openai.com/v1/chat/completions \
    -H "Authorization: Bearer ${OPENAI_API_KEY}" \
    -H "Content-Type: application/json" \
    -d @-)

SUMMARY=$(printf '%s' "$API_RESPONSE" | jq -r '.choices[0].message.content // empty')

if [ -z "$SUMMARY" ] || [ "$SUMMARY" = "null" ]; then
  echo "[ai-changelog-local] ERROR: empty or unexpected response from OpenAI."
  echo "$API_RESPONSE"
  exit 1
fi

SUMMARY=$(printf '%s\n' "$SUMMARY" | sed 's/\r$//' | sed '1{/^$/d}')

echo "[ai-changelog-local] AI summary:"
echo "----------------------------------------"
echo "$SUMMARY"
echo "----------------------------------------"

NEW_MESSAGE="$COMMIT_SUBJECT

$COMMIT_BODY

AI changelog:
$SUMMARY
"

NEW_MESSAGE=$(printf '%s\n' "$NEW_MESSAGE" | sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' )

git commit --amend -m "$NEW_MESSAGE"

echo "[ai-changelog-local] Commit amended."
