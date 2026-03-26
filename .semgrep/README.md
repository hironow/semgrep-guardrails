# Semgrep Rules for ai-tools Architecture

[submodules/ai-tools](../submodules/ai-tools/) に定義されたアーキテクチャルールを Semgrep で静的解析するルール集。

## Directory Structure

```
.semgrep/
├── naming/                 # 曖昧なサフィックスを避ける
├── immutability/           # イミュータブルを推奨
├── structure/              # 1ファイルにつき1つの型
├── complexity/             # Less Is More (深い継承)
├── demeter/                # デメテルの法則 (Train Wreck検出)
├── parse-dont-validate/    # Parse, Don't Validate
├── tell-dont-ask/          # Tell, Don't Ask
├── domain-primitives/      # Domain Primitives (プリミティブ型濫用検出)
├── error-handling/         # エラーハンドリング
└── tests/                  # Test fixtures
```

## Rule Coverage

| Category | Source | Go | Python | TS/JS | Total |
|---|---|---|---|---|---|
| naming/ | AGENTS.md: 曖昧なサフィックスを避ける | 2 | 1 | 3 | **6** |
| immutability/ | AGENTS.md: イミュータブルを推奨 | 2 | 11 | 11 | **24** |
| structure/ | AGENTS.md: 1ファイルにつき1つの型 | 3 | 1 | 4 | **8** |
| complexity/ | AGENTS.md: Less Is More | 1 | 1 | 1 | **3** |
| demeter/ | okite-ai/skills/law-of-demeter | 1 | 1 | 1 | **3** |
| parse-dont-validate/ | okite-ai/skills/parse-dont-validate | 1 | 2 | 2 | **5** |
| tell-dont-ask/ | okite-ai/skills/tell-dont-ask | - | 1 | 1 | **2** |
| domain-primitives/ | okite-ai/skills/domain-primitives-and-always-valid | 1 | 1 | 1 | **3** |
| error-handling/ | okite-ai/skills/error-handling | 2 | 2 | 1 | **5** |
| **Total** | | **13** | **21** | **25** | **59** |

## Rules Detail

### naming/ — Ambiguous Suffix Detection

Prohibited suffixes: `Manager`, `Util`, `Facade`, `Service`, `Runtime`, `Engine`

### immutability/ — Immutable Data Operations

Detects destructive methods (`push`, `pop`, `splice`, `sort`, `reverse`, `append`, `extend`, `insert`, `remove`, `clear`, `update`, `delete`, etc.) and parameter mutations. Also recommends `@dataclass(frozen=True)` for Python.

### structure/ — One Public Type Per File

Detects files with multiple exported/public types (structs, classes, interfaces, type aliases).

### complexity/ — Less Is More

Detects 3+ level inheritance hierarchies (classes extending classes extending classes, or Go struct embedding chains).

### demeter/ — Law of Demeter

Detects triple method chains `a.b().c().d()` ("Train Wreck" anti-pattern). Exceptions: builder/fluent APIs, stream chains, standard library string chains.

### parse-dont-validate/ — Parse, Don't Validate

Detects `validate*()` functions returning `void`/`None` and `check*()` / `isValid*()` functions returning `bool` instead of returning validated types.

### tell-dont-ask/ — Tell, Don't Ask

Detects `if (obj.getX() == val)` patterns where the caller asks for state and branches externally instead of telling the object to act.

### domain-primitives/ — Domain Primitives

Detects raw `string` fields for domain concepts (email, name, phone, address, url, token, password, secret) that should be wrapped in validated domain types.

### error-handling/ — Error Handling

Detects bare `except:` (Python), `except Exception:` (Python), empty `catch` blocks (TS/JS), and ignored error returns `_, err :=` (Go).

## Usage

```bash
# Scan all rules
semgrep --config .semgrep/ <target>

# Scan specific category
semgrep --config .semgrep/naming/ <target>

# Validate rules
semgrep --validate --config .semgrep/
```

## Rules NOT Converted

| Rule | Reason |
|------|--------|
| Explain Skill Selection | AI behavioral rule |
| Learn Before Coding | Process workflow |
| Less Is More (YAGNI/KISS general) | Design principle, not code pattern |
| Less Is More (single-impl interface) | Requires cross-file analysis |
| First Class Collection | Requires intent analysis (is this a domain collection?) |
| Breach Encapsulation Naming | Naming convention, not an anti-pattern to block |
| Clean Architecture (layer deps) | Requires project-specific directory convention config |
| CC-SDD (Spec-Driven Dev) | Process/workflow rule |
