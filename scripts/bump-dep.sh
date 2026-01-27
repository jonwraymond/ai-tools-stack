#!/usr/bin/env bash
set -euo pipefail

# Bump a single dependency across the local tool stack in DAG order.
# Dry-run by default. Use --apply to make changes.

PROJECTS_DIR_DEFAULT="$HOME/Documents/Projects"
PROJECTS_DIR="$PROJECTS_DIR_DEFAULT"
APPLY=false
USE_LATEST=false
DEP_KEY=""
DEP_VERSION=""

REPOS=(
  toolmodel
  toolindex
  tooldocs
  toolrun
  toolcode
  toolruntime
  toolsearch
  metatools-mcp
)

# DAG-aware order (upstream -> downstream).
ORDER=(
  toolmodel
  toolindex
  tooldocs
  toolrun
  toolcode
  toolruntime
  metatools-mcp
)

usage() {
  cat <<EOF
Usage:
  scripts/bump-dep.sh --dep <name> (--version <tag> | --latest) [--apply]

Examples:
  scripts/bump-dep.sh --dep toolindex --latest
  scripts/bump-dep.sh --dep toolindex --version v0.1.3 --apply

Options:
  --dep         Dependency key (e.g., toolmodel, toolindex, tooldocs, toolrun,
                toolcode, toolruntime, toolsearch, metatools-mcp)
  --version     Explicit tag/version to bump to (e.g., v0.1.3)
  --latest      Resolve the latest local git tag from the dependency repo
  --projects    Override projects dir (default: $PROJECTS_DIR_DEFAULT)
  --apply       Apply changes (default: dry-run)
  -h, --help    Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dep)
      DEP_KEY="${2:-}"
      shift 2
      ;;
    --version)
      DEP_VERSION="${2:-}"
      shift 2
      ;;
    --latest)
      USE_LATEST=true
      shift
      ;;
    --projects)
      PROJECTS_DIR="${2:-}"
      shift 2
      ;;
    --apply)
      APPLY=true
      shift
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

if [[ -z "$DEP_KEY" ]]; then
  echo "--dep is required" >&2
  usage
  exit 1
fi

module_for_dep() {
  case "$1" in
    toolmodel) echo "github.com/jonwraymond/toolmodel" ;;
    toolindex) echo "github.com/jonwraymond/toolindex" ;;
    tooldocs) echo "github.com/jonwraymond/tooldocs" ;;
    toolrun) echo "github.com/jonwraymond/toolrun" ;;
    toolcode) echo "github.com/jonwraymond/toolcode" ;;
    toolruntime) echo "github.com/jonwraymond/toolruntime" ;;
    toolsearch) echo "github.com/jonwraymond/toolsearch" ;;
    metatools-mcp) echo "github.com/jonwraymond/metatools-mcp" ;;
    *) echo "" ;;
  esac
}

DEP_MOD="$(module_for_dep "$DEP_KEY")"
if [[ -z "${DEP_MOD}" ]]; then
  echo "Unknown dep key: $DEP_KEY" >&2
  usage
  exit 1
fi

dep_repo_dir="$PROJECTS_DIR/$DEP_KEY"
if [[ "$USE_LATEST" == true ]]; then
  if [[ ! -d "$dep_repo_dir/.git" ]]; then
    echo "Cannot resolve --latest: missing repo at $dep_repo_dir" >&2
    exit 1
  fi
  DEP_VERSION="$(git -C "$dep_repo_dir" tag --sort=-v:refname | head -n1)"
  if [[ -z "$DEP_VERSION" ]]; then
    echo "No git tags found in $dep_repo_dir" >&2
    exit 1
  fi
fi

if [[ -z "$DEP_VERSION" ]]; then
  echo "Either --version or --latest is required" >&2
  usage
  exit 1
fi

echo "Dependency : $DEP_KEY ($DEP_MOD)"
echo "Version    : $DEP_VERSION"
echo "Projects   : $PROJECTS_DIR"
echo "Mode       : $([[ "$APPLY" == true ]] && echo APPLY || echo DRY-RUN)"

ROOT_REPO="$(cd "$(dirname "$0")/.." && pwd)"

has_dep() {
  local repo_dir="$1"
  local mod="$2"
  [[ -f "$repo_dir/go.mod" ]] && rg -q "$mod" "$repo_dir/go.mod"
}

run_in_repo() {
  local repo_dir="$1"
  local repo_name="$2"

  echo
  echo "== $repo_name =="
  echo "dir: $repo_dir"

  if [[ "$APPLY" != true ]]; then
    echo "would run: go get $DEP_MOD@$DEP_VERSION"
    echo "would run: go mod tidy"
    echo "would run: go test ./..."
    echo "would run: go vet ./..."
    return 0
  fi

  (
    cd "$repo_dir"
    go get "$DEP_MOD@$DEP_VERSION"
    go mod tidy
    go test ./...
    go vet ./...
  )
}

# Figure out impacted repos in DAG order, plus ai-tools-stack.
IMPACTED=()
for repo in "${ORDER[@]}"; do
  repo_dir="$PROJECTS_DIR/$repo"
  if [[ ! -d "$repo_dir" ]]; then
    continue
  fi
  if has_dep "$repo_dir" "$DEP_MOD"; then
    IMPACTED+=("$repo")
  fi
done

# toolsearch is out-of-band from ORDER but depends on toolmodel/toolindex.
toolsearch_dir="$PROJECTS_DIR/toolsearch"
if [[ -d "$toolsearch_dir" ]] && has_dep "$toolsearch_dir" "$DEP_MOD"; then
  IMPACTED+=("toolsearch")
fi

# ai-tools-stack should always be updated if it depends on the module.
if has_dep "$ROOT_REPO" "$DEP_MOD"; then
  IMPACTED+=("ai-tools-stack")
fi

if [[ ${#IMPACTED[@]} -eq 0 ]]; then
  echo
  echo "No impacted repos found for $DEP_MOD"
  exit 0
fi

echo
echo "Impacted repos (ordered): ${IMPACTED[*]}"

for repo in "${IMPACTED[@]}"; do
  if [[ "$repo" == "ai-tools-stack" ]]; then
    run_in_repo "$ROOT_REPO" "$repo"
  else
    run_in_repo "$PROJECTS_DIR/$repo" "$repo"
  fi
done

echo
echo "Done."
