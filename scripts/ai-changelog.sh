#!/usr/bin/env bash
set -euo pipefail

# AI-powered changelog generator for the latest commit in a LaTeX/document repo.
# Requirements on the runner:
#   - curl
#   - jq
# Environment:
#   - OPENAI_API_KEY: your OpenAI API key
#   - GITHUB_SHA: provided by GitHub Actions (optional but nice for logging)

########################
# 1. Collect the diff  #
########################

# Handle the "first commit" edge case (no parent)
if ! git rev-parse HEAD^ >/dev/null 2>&1; then
  echo "[ai-changelog] Single initial commit detected; using 'git show'."
  DIFF=$(git show --stat --patch --format=short HEAD | head -c 12000)
else
  # Use parent diff. Trim to avoid giant prompts; adjust limit if needed.
  DIFF=$(git diff HEAD^ HEAD | head -c 12000)
fi

if [ -z "$DIFF" ]; then
  echo "[ai-changelog] No diff content detected; skipping AI changelog."
  exit 0
fi

#############################
# 2. Read current commit    #
#############################

COMMIT_SUBJECT=$(git log -1 --pretty=%s)
COMMIT_BODY=$(git log -1 --pretty=%b)

# Avoid re-writing an already AI-annotated commit
if echo "$COMMIT_BODY" | grep -qi "AI changelog:"; then
  echo "[ai-changelog] Commit already contains an AI changelog section; skipping."
  exit 0
fi

######################################
# 3. Build a high-quality AI prompt  #
######################################

# System message: role & expectations
SYSTEM_PROMPT="You are an expert technical writer and LaTeX user who writes concise, accurate document change summaries from git diffs.
Your job is to produce a bullet-point changelog suitable for the body of a commit message in a long-form LaTeX project.

Guidelines:
- You MUST stay grounded in the diff content. Do not invent sections, arguments, or edits that are not clearly implied.
- Focus on document-level changes: new sections or subsections, restructured content, clarified explanations, added or removed paragraphs, updated figures/tables, citation changes, and terminology/wording improvements.
- Treat LaTeX markup as an implementation detail: describe the human-readable effect (e.g., 'Added a new subsection describing X', not 'Added \\subsection{X}').
- Ignore purely mechanical or low-impact changes (whitespace, line wrapping, reordered commands, minor formatting) unless the diff is mainly those, in which case summarize that briefly.
- The output is for authors and reviewers skimming document history later, not for marketing or release notes.
- Prefer grouping related edits into a single bullet so the summary reads as coherent document changes, not a list of files."

# User message: instructions + diff
read -r -d '' USER_PROMPT <<EOF || true
You will receive a git diff for a single commit to a LaTeX-based document project (e.g., report, thesis, SOP, or technical manual).

Produce a concise changelog in plain English that could be appended to the commit message body.

Output format requirements:
- 3–10 bullet points in total. Use fewer if the change is very small.
- Each bullet MUST start with "- " (dash + space).
- Each bullet should describe a distinct, meaningful document change or group of related changes.
- Focus on the effect on the document's content, structure, and clarity:
  - what sections/subsections were added, removed, or significantly revised;
  - what key explanations, arguments, or descriptions were added or improved;
  - notable updates to figures, tables, examples, or citations/references.
- Avoid raw LaTeX markup in the wording whenever possible. Use natural language labels (e.g., 'introduction', 'methods section', 'appendix') instead.
- Avoid meta language like 'in this commit' or 'in the diff'. Just describe the changes directly.
- If the diff is mostly minor wording tweaks or formatting/typo fixes, summarize that honestly in 1–2 bullets (e.g., 'Polished phrasing and fixed typos in Section 2').

If the diff appears truncated (e.g., many changes cut off mid-hunk), still summarize as best you can based strictly on what you see.

Now summarize the following diff:

$DIFF
EOF

#################################
# 4. Call the OpenAI API (5-mini)
#################################

if [ -z "${OPENAI_API_KEY:-}" ]; then
  echo "[ai-changelog] ERROR: OPENAI_API_KEY is not set."
  exit 1
fi

# Build JSON payload safely
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


echo "[ai-changelog] Requesting LaTeX-aware summary from gpt-5-mini..."

API_RESPONSE=$(printf '%s' "$JSON_PAYLOAD" | \
  curl -sS https://api.openai.com/v1/chat/completions \
    -H "Authorization: Bearer ${OPENAI_API_KEY}" \
    -H "Content-Type: application/json" \
    -d @-)

# Extract summary text
SUMMARY=$(printf '%s' "$API_RESPONSE" | jq -r '.choices[0].message.content // empty')

if [ -z "$SUMMARY" ] || [ "$SUMMARY" = "null" ]; then
  echo "[ai-changelog] ERROR: OpenAI returned an empty summary or unexpected response."
  echo "[ai-changelog] Raw response:"
  echo "$API_RESPONSE"
  exit 1
fi

# Normalize line endings & trim leading blank lines
SUMMARY=$(printf '%s\n' "$SUMMARY" | sed 's/\r$//' | sed '1{/^$/d}')

echo "[ai-changelog] AI summary:"
echo "----------------------------------------"
echo "$SUMMARY"
echo "----------------------------------------"

#####################################
# 5. Amend commit & force-push back #
#####################################

NEW_MESSAGE="$COMMIT_SUBJECT

$COMMIT_BODY

AI changelog:
$SUMMARY
"

# Trim trailing blank lines from the commit message for tidiness
NEW_MESSAGE=$(printf '%s\n' "$NEW_MESSAGE" | sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' )

git commit --amend -m "$NEW_MESSAGE"

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "[ai-changelog] Amended commit on branch '$CURRENT_BRANCH'. Pushing with --force-with-lease..."

git push --force-with-lease origin "$CURRENT_BRANCH"

echo "[ai-changelog] Done."
