from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
EXPECTED_SKILLS = ("shenron", "e2e-qa-team")


def parse_frontmatter(path: Path) -> dict[str, str]:
    text = path.read_text(encoding="utf-8")
    if not text.startswith("---\n"):
        raise ValueError(f"{path}: missing opening frontmatter delimiter")

    try:
        raw_frontmatter, body = text[4:].split("\n---\n", 1)
    except ValueError as exc:
        raise ValueError(f"{path}: missing closing frontmatter delimiter") from exc

    if "TODO" in text:
        raise ValueError(f"{path}: unresolved TODO")
    if not body.strip():
        raise ValueError(f"{path}: empty skill body")

    values: dict[str, str] = {}
    for line in raw_frontmatter.splitlines():
        if not line.strip():
            continue
        if ":" not in line:
            raise ValueError(f"{path}: malformed frontmatter line {line!r}")
        key, value = line.split(":", 1)
        values[key.strip()] = value.strip()

    if set(values) != {"name", "description"}:
        raise ValueError(
            f"{path}: frontmatter keys must be exactly name and description, got {sorted(values)}"
        )
    if not values["description"]:
        raise ValueError(f"{path}: empty description")
    return values


def validate_skill(skill_name: str) -> None:
    skill_dir = ROOT / "skills" / skill_name
    manifest = skill_dir / "SKILL.md"
    metadata = skill_dir / "agents" / "openai.yaml"

    if not manifest.is_file():
        raise ValueError(f"missing {manifest}")
    if not metadata.is_file():
        raise ValueError(f"missing {metadata}")

    frontmatter = parse_frontmatter(manifest)
    if frontmatter["name"] != skill_name:
        raise ValueError(
            f"{manifest}: name {frontmatter['name']!r} does not match directory {skill_name!r}"
        )

    yaml_text = metadata.read_text(encoding="utf-8")
    if f"${skill_name}" not in yaml_text:
        raise ValueError(f"{metadata}: default prompt must mention ${skill_name}")


def validate_markdown_links(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    for target in re.findall(r"\[[^\]]+\]\(([^)]+)\)", text):
        if "://" in target or target.startswith("#"):
            continue
        resolved = (path.parent / target).resolve()
        if not resolved.exists():
            raise ValueError(f"{path}: broken local link {target!r}")


def main() -> int:
    try:
        for skill_name in EXPECTED_SKILLS:
            validate_skill(skill_name)

        validate_markdown_links(ROOT / "README.md")
        for path in (ROOT / "docs").rglob("*.md"):
            validate_markdown_links(path)
    except ValueError as exc:
        print(f"validation failed: {exc}", file=sys.stderr)
        return 1

    print(f"validated {len(EXPECTED_SKILLS)} skills and repository metadata")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
