#!/usr/bin/env python
"""Generate GitHub permalink for current Helix buffer + line."""

import subprocess
import sys
from pathlib import Path


def run(cmd: list[str]) -> str | None:
    result = subprocess.run(cmd, capture_output=True, text=True)
    return result.stdout.strip() if result.returncode == 0 else None


def main():
    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} <buffer_name> <cursor_line>", file=sys.stderr)
        sys.exit(1)

    file_path = Path(sys.argv[1])
    line = sys.argv[2]

    git_root = run(["git", "rev-parse", "--show-toplevel"])
    if not git_root:
        print("Not in a git repository", file=sys.stderr)
        sys.exit(1)

    commit = run(["git", "rev-parse", "HEAD"])
    remote_url = run(["git", "config", "--get", "remote.origin.url"])

    if not remote_url:
        print("No origin remote found", file=sys.stderr)
        sys.exit(1)

    # Convert remote URL to https format
    if remote_url.startswith("git@github.com:"):
        repo = remote_url.removeprefix("git@github.com:").removesuffix(".git")
        base_url = f"https://github.com/{repo}"
    else:
        base_url = remote_url.removesuffix(".git")

    # Get relative path
    try:
        rel_path = file_path.resolve().relative_to(git_root)
    except ValueError:
        rel_path = file_path

    permalink = f"{base_url}/blob/{commit}/{rel_path}#L{line}"

    # Copy to clipboard
    print(f"{permalink}")


if __name__ == "__main__":
    main()
