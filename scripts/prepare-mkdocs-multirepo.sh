#!/usr/bin/env bash
set -euo pipefail

if [ -x ".venv/bin/python" ]; then
  PYTHON_BIN=".venv/bin/python"
else
  PYTHON_BIN="${PYTHON_BIN:-python3}"
fi
if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  PYTHON_BIN="python"
fi

"$PYTHON_BIN" - <<'PY'
import shutil
from pathlib import Path
import mkdocs_multirepo_plugin

scripts_dir = Path(mkdocs_multirepo_plugin.__file__).parent / "scripts"
if not scripts_dir.is_dir():
    raise SystemExit(f"scripts dir not found: {scripts_dir}")

temp_dir = Path("temp_dir")
temp_dir.mkdir(exist_ok=True)

for name in ("sparse_clone.sh", "sparse_clone_old.sh", "mv_docs_up.sh"):
    src = scripts_dir / name
    dst = temp_dir / name
    shutil.copy(src, dst)

def patch_clone_script(path: Path) -> None:
    marker = "# multirepo-move-docs"
    text = path.read_text()
    if marker in text:
        return
    lines = text.splitlines()
    insert_after = None
    clone_line = None
    for idx, line in enumerate(lines):
        if line.strip() == "set -f" and insert_after is None:
            insert_after = idx + 1
        if line.strip().startswith("git clone"):
            clone_line = idx
    if insert_after is None or clone_line is None:
        return
    script_dir_lines = [
        marker,
        "script_dir=\"$(cd \"$(dirname \"$0\")\" && pwd)\"",
    ]
    lines[insert_after:insert_after] = script_dir_lines
    lines.insert(
        clone_line + len(script_dir_lines) + 1,
        "cp \"$script_dir/mv_docs_up.sh\" \"$name/mv_docs_up.sh\"",
    )
    path.write_text("\n".join(lines) + "\n")

patch_clone_script(temp_dir / "sparse_clone.sh")
patch_clone_script(temp_dir / "sparse_clone_old.sh")
PY
