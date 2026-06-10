# semgrep-bind task runner. `just` with no args prints this list.

# mise-pinned external tools (see mise.toml), wrapped so the pinned version wins.
MARKDOWNLINT := "mise exec -- markdownlint-cli2"
PREK := "mise exec -- prek"

default: help

# Show available tasks
help:
    @just --list

# Format: markdown (markdownlint-cli2 --fix)
fmt:
    git ls-files -z '*.md' | xargs -0 -r {{MARKDOWNLINT}} --fix

# Lint: markdown (markdownlint-cli2 --fix)
lint:
    git ls-files -z '*.md' | xargs -0 -r {{MARKDOWNLINT}} --fix

# Validate rule YAML syntax + patterns (README's verification step)
semgrep-validate:
    semgrep --validate --config .semgrep/

# Smoke-test the rules against .semgrep/tests/ fixtures: detection logic must
# actually fire. Fixture filenames do not pair with rule filenames, so semgrep's
# native `--test` discovery finds nothing here; asserting a non-zero findings
# count over the fixture tree is the honest substitute (catches dead patterns,
# not per-annotation expectations).
semgrep-fixtures:
    @count=$(semgrep --config .semgrep/ .semgrep/tests/ --json --quiet | python3 -c "import json,sys; print(len(json.load(sys.stdin)['results']))"); \
    echo "fixture findings: ${count}"; \
    test "${count}" -gt 0 || { echo "ERROR: rules produced zero findings on fixtures"; exit 1; }

# Strict gate, no writes: markdown + rule validation + fixture smoke test
check: semgrep-validate semgrep-fixtures
    git ls-files -z '*.md' | xargs -0 -r {{MARKDOWNLINT}}

# Install prek git hooks (pre-commit + pre-push); see .pre-commit-config.yaml
install-hooks:
    {{PREK}} install -t pre-commit -t pre-push

# Run all prek hooks against every file
pre-commit:
    {{PREK}} run --all-files
