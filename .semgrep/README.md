# Semgrep Rules for ai-tools Architecture

[submodules/ai-tools/AGENTS.md](../submodules/ai-tools/AGENTS.md) に定義されたアーキテクチャルールを Semgrep で静的解析するルール集。

## Directory Structure

```
.semgrep/
├── naming/                                  # 曖昧なサフィックスを避ける
│   ├── ambiguous-suffix-go.yaml
│   ├── ambiguous-suffix-python.yaml
│   └── ambiguous-suffix-typescript.yaml
├── immutability/                            # イミュータブルを推奨
│   ├── no-slice-append-go.yaml
│   ├── no-destructive-mutation-python.yaml
│   ├── no-destructive-mutation-typescript.yaml
│   └── prefer-frozen-dataclass-python.yaml
├── structure/                               # 1ファイルにつき1つの型
│   ├── one-type-per-file-go.yaml
│   ├── one-type-per-file-python.yaml
│   └── one-type-per-file-typescript.yaml
├── complexity/                              # Less Is More
│   ├── deep-embedding-go.yaml
│   ├── deep-inheritance-python.yaml
│   └── deep-inheritance-typescript.yaml
└── tests/                                   # Test fixtures
    ├── naming/{go,python,typescript}/
    ├── immutability/{go,python,typescript}/
    ├── structure/{go,python,typescript}/
    └── complexity/{go,python,typescript}/
```

## Rules

### naming/ - Ambiguous Suffix Detection

AGENTS.md: **曖昧なサフィックスを避ける**

Prohibited suffixes: `Manager`, `Util`, `Facade`, `Service`, `Runtime`, `Engine`

| Rule ID | Languages | Target |
|---------|-----------|--------|
| `naming.ambiguous-suffix-struct-go` | Go | `type XxxManager struct` |
| `naming.ambiguous-suffix-interface-go` | Go | `type XxxManager interface` |
| `naming.ambiguous-suffix-class-python` | Python | `class XxxManager` |
| `naming.ambiguous-suffix-class-typescript` | TS/JS | `class XxxManager` |
| `naming.ambiguous-suffix-interface-typescript` | TS | `interface XxxManager` |
| `naming.ambiguous-suffix-type-alias-typescript` | TS | `type XxxManager = ...` |

### immutability/ - Immutable Data Operations

AGENTS.md: **イミュータブルを推奨**

#### Go (2 rules)

| Rule ID | Detects |
|---------|---------|
| `immutability.no-param-slice-append-go` | `return append(param, ...)` |
| `immutability.no-pointer-field-mutation-go` | `param.Field = val` (pointer arg) |

#### Python (11 rules)

| Rule ID | Detects |
|---------|---------|
| `immutability.no-list-append-param-python` | `param.append(...)` |
| `immutability.no-list-extend-param-python` | `param.extend(...)` |
| `immutability.no-list-insert-param-python` | `param.insert(...)` |
| `immutability.no-list-remove-param-python` | `param.remove(...)` |
| `immutability.no-list-clear-param-python` | `param.clear()` |
| `immutability.no-list-reverse-param-python` | `param.reverse()` |
| `immutability.no-list-sort-param-python` | `param.sort()` |
| `immutability.no-dict-mutation-param-python` | `param[key] = val` |
| `immutability.no-dict-update-param-python` | `param.update(...)` |
| `immutability.no-dict-pop-param-python` | `param.pop(...)` |
| `immutability.prefer-frozen-dataclass-python` | `@dataclass` without `frozen=True` |

#### TypeScript/JavaScript (11 rules)

| Rule ID | Detects |
|---------|---------|
| `immutability.no-array-push-typescript` | `x.push(...)` |
| `immutability.no-array-pop-typescript` | `x.pop()` |
| `immutability.no-array-unshift-typescript` | `x.unshift(...)` |
| `immutability.no-array-splice-typescript` | `x.splice(...)` |
| `immutability.no-array-fill-typescript` | `x.fill(...)` |
| `immutability.no-array-copywithin-typescript` | `x.copyWithin(...)` |
| `immutability.no-array-sort-inplace-typescript` | `x.sort(...)` |
| `immutability.no-array-reverse-inplace-typescript` | `x.reverse()` |
| `immutability.no-delete-property-typescript` | `delete x.prop` |
| `immutability.no-param-property-mutation-typescript` | `param.field = val` (function arg) |
| `immutability.no-nested-property-mutation-typescript` | `param.a.b = val` (nested mutation) |

### structure/ - One Public Type Per File

AGENTS.md: **1ファイルにつき1つの型**

| Rule ID | Languages | Detects |
|---------|-----------|--------|
| `structure.multiple-exported-structs-go` | Go | 2+ exported structs |
| `structure.multiple-exported-interfaces-go` | Go | 2+ exported interfaces |
| `structure.exported-struct-and-interface-go` | Go | exported struct + interface |
| `structure.multiple-classes-python` | Python | 2+ module-level classes |
| `structure.multiple-exported-classes-typescript` | TS/JS | 2+ `export class` |
| `structure.multiple-exported-interfaces-typescript` | TS | 2+ `export interface` |
| `structure.multiple-exported-type-aliases-typescript` | TS | 2+ `export type` |
| `structure.mixed-exported-class-and-interface-typescript` | TS | `export class` + `export type` |

### complexity/ - Less Is More

AGENTS.md: **Less Is More** (過剰設計の兆候: 継承階層が3+レベル)

| Rule ID | Languages | Detects |
|---------|-----------|--------|
| `complexity.deep-embedding-3-levels-go` | Go | 3+ level struct embedding chain |
| `complexity.deep-inheritance-3-levels-python` | Python | 3+ level class inheritance chain |
| `complexity.deep-inheritance-3-levels-typescript` | TS/JS | 3+ level class extends chain |

## Usage

```bash
# Scan all rules
semgrep --config .semgrep/ <target>

# Scan specific category
semgrep --config .semgrep/naming/ <target>
semgrep --config .semgrep/immutability/ <target>
semgrep --config .semgrep/structure/ <target>
semgrep --config .semgrep/complexity/ <target>

# Validate rules
semgrep --validate --config .semgrep/

# Run tests (requires .semgrepignore to not exclude test dirs)
semgrep --config .semgrep/naming/ .semgrep/tests/naming/
semgrep --config .semgrep/immutability/ .semgrep/tests/immutability/
semgrep --config .semgrep/structure/ .semgrep/tests/structure/
semgrep --config .semgrep/complexity/ .semgrep/tests/complexity/
```

## Rule Coverage Summary

| AGENTS.md Rule | Category | Go | Python | TS/JS | Total |
|---|---|---|---|---|---|
| 曖昧なサフィックスを避ける | naming | 2 | 1 | 3 | **6** |
| イミュータブルを推奨 | immutability | 2 | 11 | 11 | **24** |
| 1ファイルにつき1つの型 | structure | 3 | 1 | 4 | **8** |
| Less Is More (継承3+) | complexity | 1 | 1 | 1 | **3** |
| **Total** | | **8** | **14** | **19** | **41** |

## Rules NOT Converted

| Rule | Reason |
|------|--------|
| Explain Skill Selection | AI behavioral rule, not statically detectable |
| Learn Before Coding | Process workflow, not statically detectable |
| Less Is More (YAGNI/KISS general) | Design principle, only specific symptoms detectable |
| Less Is More (single implementation interface) | Requires cross-file analysis beyond semgrep's scope |
