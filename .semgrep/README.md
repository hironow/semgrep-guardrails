# Semgrep Rules for ai-tools Architecture

[submodules/ai-tools/COMMON.md](../submodules/ai-tools/COMMON.md) に定義されたアーキテクチャルールを Semgrep で静的解析するルール集。

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
│   └── no-destructive-mutation-typescript.yaml
├── structure/                               # 1ファイルにつき1つの型
│   ├── one-type-per-file-go.yaml
│   ├── one-type-per-file-python.yaml
│   └── one-type-per-file-typescript.yaml
└── tests/                                   # Test fixtures
    ├── naming/{go,python,typescript}/
    ├── immutability/{go,python,typescript}/
    └── structure/{go,python,typescript}/
```

## Rules

### naming/ - Ambiguous Suffix Detection

COMMON.md: **曖昧なサフィックスを避ける**

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

COMMON.md: **イミュータブルを推奨**

| Rule ID | Languages | Detects |
|---------|-----------|---------|
| `immutability.no-param-slice-append-go` | Go | `return append(param, ...)` |
| `immutability.no-pointer-field-mutation-go` | Go | `param.Field = val` (pointer arg) |
| `immutability.no-list-append-param-python` | Python | `param.append(...)` |
| `immutability.no-list-extend-param-python` | Python | `param.extend(...)` |
| `immutability.no-dict-mutation-param-python` | Python | `param[key] = val` |
| `immutability.no-list-sort-param-python` | Python | `param.sort()` |
| `immutability.no-array-push-typescript` | TS/JS | `x.push(...)` |
| `immutability.no-array-pop-typescript` | TS/JS | `x.pop()` |
| `immutability.no-array-splice-typescript` | TS/JS | `x.splice(...)` |
| `immutability.no-array-sort-inplace-typescript` | TS/JS | `x.sort(...)` |
| `immutability.no-array-reverse-inplace-typescript` | TS/JS | `x.reverse()` |
| `immutability.no-param-property-mutation-typescript` | TS/JS | `param.field = val` (function arg) |

### structure/ - One Public Type Per File

COMMON.md: **1ファイルにつき1つの型**

| Rule ID | Languages | Detects |
|---------|-----------|---------|
| `structure.multiple-exported-structs-go` | Go | 2+ exported structs in one file |
| `structure.multiple-exported-interfaces-go` | Go | 2+ exported interfaces in one file |
| `structure.exported-struct-and-interface-go` | Go | exported struct + interface in one file |
| `structure.multiple-classes-python` | Python | 2+ module-level classes in one file |
| `structure.multiple-exported-classes-typescript` | TS/JS | 2+ `export class` in one file |
| `structure.multiple-exported-interfaces-typescript` | TS | 2+ `export interface` in one file |

## Usage

```bash
# Scan all rules
semgrep --config .semgrep/ <target>

# Scan specific category
semgrep --config .semgrep/naming/ <target>

# Validate rules
semgrep --validate --config .semgrep/

# Run tests
semgrep --config .semgrep/naming/ .semgrep/tests/naming/
semgrep --config .semgrep/immutability/ .semgrep/tests/immutability/
semgrep --config .semgrep/structure/ .semgrep/tests/structure/
```

## Rules NOT Converted

The following COMMON.md rules are process/design guidelines and cannot be expressed as static analysis rules:

| Rule | Reason |
|------|--------|
| Explain Skill Selection | AI behavioral rule |
| Learn Before Coding | Process workflow |
| Less Is More (YAGNI/KISS) | Design principle |
