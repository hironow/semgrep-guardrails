# Semgrep Rules for ai-tools Architecture

[submodules/ai-tools](../submodules/ai-tools/) に定義されたアーキテクチャルールを Semgrep で静的解析するルール集。

## Directory Structure

```
.semgrep/
├── naming/                 # 曖昧なサフィックスを避ける
├── immutability/           # イミュータブルを推奨
├── structure/              # 1ファイルにつき1つの型
├── complexity/             # Less Is More (深い継承)
├── demeter/                # デメテルの法則 (Train Wreck)
├── parse-dont-validate/    # Parse, Don't Validate
├── tell-dont-ask/          # Tell, Don't Ask
├── domain-primitives/      # Domain Primitives
├── error-handling/         # エラーハンドリング
├── clean-architecture/     # Clean Architecture 層依存
├── breach-encapsulation/   # Breach Encapsulation Naming
├── first-class-collection/ # First Class Collection
└── tests/
```

## Rule Coverage

| Category | Source | Go | Py | TS | Total |
|---|---|---|---|---|---|
| naming/ | AGENTS.md: 曖昧なサフィックスを避ける | 2 | 1 | 3 | **6** |
| immutability/ | AGENTS.md: イミュータブルを推奨 | 2 | 11 | 11 | **24** |
| structure/ | AGENTS.md: 1ファイルにつき1つの型 | 3 | 1 | 4 | **8** |
| complexity/ | AGENTS.md: Less Is More | 1 | 1 | 1 | **3** |
| demeter/ | okite-ai: law-of-demeter | 1 | 1 | 1 | **3** |
| parse-dont-validate/ | okite-ai: parse-dont-validate | 1 | 2 | 2 | **5** |
| tell-dont-ask/ | okite-ai: tell-dont-ask | - | 1 | 1 | **2** |
| domain-primitives/ | okite-ai: domain-primitives | 1 | 1 | 1 | **3** |
| error-handling/ | okite-ai: error-handling | 2 | 2 | 1 | **5** |
| clean-architecture/ | okite-ai: clean-architecture | 3 | 2 | 2 | **7** |
| breach-encapsulation/ | okite-ai: breach-encapsulation-naming | 1 | 1 | 1 | **3** |
| first-class-collection/ | okite-ai: first-class-collection | 1 | 1 | 1 | **3** |
| **Total** | | **18** | **25** | **29** | **72** |

## Rules Detail

### naming/ — Ambiguous Suffix Detection
Prohibited suffixes: `Manager`, `Util`, `Facade`, `Service`, `Runtime`, `Engine`

### immutability/ — Immutable Data Operations
Detects destructive methods (`push`, `pop`, `splice`, `sort`, `reverse`, `append`, `extend`, `insert`, `remove`, `clear`, `update`, `delete`, etc.), parameter mutations, and mutable dataclasses.

### structure/ — One Public Type Per File
Detects files with multiple exported/public types.

### complexity/ — Less Is More
Detects 3+ level inheritance/embedding hierarchies.

### demeter/ — Law of Demeter
Detects triple method chains `a.b().c().d()` ("Train Wreck").

### parse-dont-validate/ — Parse, Don't Validate
Detects `validate*()` → `void`/`None` and `check*()` → `bool` functions.

### tell-dont-ask/ — Tell, Don't Ask
Detects `if (obj.getX() == val)` patterns.

### domain-primitives/ — Domain Primitives
Detects raw `string` fields for domain concepts (email, name, phone, address, url, token, password, secret).

### error-handling/ — Error Handling
Detects bare `except:`, `except Exception:`, empty `catch` blocks, and ignored error returns.

### clean-architecture/ — Layer Dependency Rules
Scoped to `**/domain/**`, `**/model/**`, `**/entity/**` paths. Detects imports from:
- Infrastructure layer (`infrastructure/`, `infra/`)
- Adapter layer (`adapter/`, `controller/`, `gateway/`, `handler/`, `presenter/`)
- UseCase layer (`usecase/`, `application/`, `service/`) (Go only, WARNING)

### breach-encapsulation/ — Getter Naming in Domain
Scoped to `**/domain/**`, `**/model/**`, `**/entity/**` paths (excludes tests and value objects).
Detects `get*()` / `Get*()` methods that should be `breachEncapsulationOf*()`.

### first-class-collection/ — Raw Collection Fields in Domain
Scoped to `**/domain/**`, `**/model/**`, `**/entity/**` paths (excludes DTOs).
Detects raw collection fields (`[]T`, `list[T]`, `T[]`) that should be wrapped in first-class collection types.

## Usage

```bash
semgrep --config .semgrep/ <target>           # All rules
semgrep --config .semgrep/naming/ <target>    # Specific category
semgrep --validate --config .semgrep/         # Validate rules
```

## Rules NOT Converted

| Rule | Reason |
|------|--------|
| Explain Skill Selection | AI behavioral rule, not code |
| Learn Before Coding | Process workflow, not code |
| CC-SDD (Spec-Driven Dev) | Process/workflow rule |
| Less Is More (YAGNI/KISS general) | Too abstract for pattern matching |
| Less Is More (single-impl interface) | Requires whole-project analysis |
