#!/usr/bin/env bash
set -euo pipefail

# Sync VERSIONS.md and README pointers across tool repos using ai-tools-stack go.mod.
# Dry-run by default. Use --apply to write changes.

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECTS_DIR_DEFAULT="$HOME/Documents/Projects"
PROJECTS_DIR="$PROJECTS_DIR_DEFAULT"
APPLY=false
COMMIT=false
PUSH=false
OPEN_PR=false
BRANCH="main"
BASE_BRANCH="main"
COMMIT_MESSAGE="docs: update version matrix"

REPOS=(
  toolmodel
  toolindex
  tooldocs
  toolrun
  toolcode
  toolruntime
  toolsearch
  metatools-mcp
  ai-tools-stack
)

ORDERED_LABELS=(
  toolmodel
  toolindex
  tooldocs
  toolrun
  toolcode
  toolruntime
  toolsearch
  metatools-mcp
)

usage() {
  cat <<EOF
Usage:
  scripts/update-version-matrix.sh [--apply] [--commit] [--push] [--pr] [--branch NAME] [--base NAME] [--projects DIR]

Options:
  --apply       Apply changes (default: dry-run)
  --commit      Commit changes in each repo
  --push        Push commits to origin/<branch> (implies --commit)
  --pr          Open/refresh PRs for pushed branches (implies --push)
  --branch      Branch to push (default: main)
  --base        Base branch for PRs (default: main)
  --projects    Override projects dir (default: $PROJECTS_DIR_DEFAULT)
  -h, --help    Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply)
      APPLY=true
      shift
      ;;
    --commit)
      COMMIT=true
      shift
      ;;
    --push)
      COMMIT=true
      PUSH=true
      shift
      ;;
    --pr)
      COMMIT=true
      PUSH=true
      OPEN_PR=true
      shift
      ;;
    --branch)
      BRANCH="${2:-}"
      shift 2
      ;;
    --base)
      BASE_BRANCH="${2:-}"
      shift 2
      ;;
    --projects)
      PROJECTS_DIR="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

cd "$ROOT_DIR"

MODULE_OUTPUT="$(go list -m -f '{{.Path}} {{.Version}}' all | rg '^github.com/jonwraymond/' || true)"
if [[ -z "${MODULE_OUTPUT}" ]]; then
  echo "No jonwraymond modules found in go.mod" >&2
  exit 1
fi

version_for() {
  local label="$1"
  rg -n "^github.com/jonwraymond/${label} " <<< "$MODULE_OUTPUT" | awk '{print $2}' | head -n1
}

versions_md() {
  echo "## Version compatibility (current tags)"
  echo
  for label in "${ORDERED_LABELS[@]}"; do
    ver="$(version_for "$label")"
    if [[ -n "$ver" ]]; then
      echo "- \`${label}\`: \`${ver}\`"
    fi
  done
  echo
  echo "Generated from \`ai-tools-stack/go.mod\`."
}

update_readme() {
  local file="$1"
  perl -0777 -pi -e 's/## Version compatibility(?: \\(current tags\\))?\\n\\n(?:- .*\\n)+/## Version compatibility\\n\\nSee `VERSIONS.md` for the authoritative, auto-generated compatibility matrix.\\n\\n/g' "$file"
}

echo "Projects dir: $PROJECTS_DIR"
echo "Mode: $([[ "$APPLY" == true ]] && echo APPLY || echo DRY-RUN)"
echo "Version source: $ROOT_DIR/go.mod"

for repo in "${REPOS[@]}"; do
  repo_dir="$PROJECTS_DIR/$repo"
  readme="$repo_dir/README.md"
  versions="$repo_dir/VERSIONS.md"

  if [[ ! -d "$repo_dir" ]]; then
    continue
  fi

  echo
  echo "== $repo =="

  if [[ "$APPLY" != true ]]; then
    echo "would write $versions"
    if [[ -f "$readme" ]]; then
      echo "would update $readme to point at VERSIONS.md"
    fi
    continue
  fi

  versions_md > "$versions"

  if [[ -f "$readme" ]]; then
    update_readme "$readme"
  fi

  if [[ "$COMMIT" == true ]]; then
    if [[ "$PUSH" == true || "$OPEN_PR" == true ]]; then
      git -C "$repo_dir" fetch origin "$BASE_BRANCH" >/dev/null 2>&1 || true
      git -C "$repo_dir" checkout -B "$BRANCH" "origin/$BASE_BRANCH" >/dev/null 2>&1 || true
    fi

    git -C "$repo_dir" add "$versions"
    if [[ -f "$readme" ]]; then
      git -C "$repo_dir" add "$readme"
    fi
    if ! git -C "$repo_dir" diff --cached --quiet; then
      git -C "$repo_dir" commit -m "$COMMIT_MESSAGE"
      if [[ "$PUSH" == true ]]; then
        git -C "$repo_dir" push origin "$BRANCH"
      fi
      if [[ "$OPEN_PR" == true ]]; then
        if command -v gh >/dev/null 2>&1; then
          if [[ -z "$(gh -R "jonwraymond/$repo" pr list --state open --head "$BRANCH" --base "$BASE_BRANCH" --json number --jq '.[].number')" ]]; then
            gh -R "jonwraymond/$repo" pr create --base "$BASE_BRANCH" --head "$BRANCH" \
              --title "$COMMIT_MESSAGE" \
              --body "Sync VERSIONS.md to latest ai-tools-stack versions."
          else
            echo "PR already open for $repo:$BRANCH -> $BASE_BRANCH"
          fi
        else
          echo "gh CLI not available; skipping PR creation for $repo"
        fi
      fi
    else
      echo "no changes to commit"
    fi
  fi
done

echo
echo "Done."
