# Semgrep Rules for ai-tools Architecture

[submodules/ai-tools](../submodules/ai-tools/) に定義されたアーキテクチャルールを Semgrep で静的解析するルール集。

## Directory Structure

```
.semgrep/
├── naming/                 # 曖昧サフィックス + ゴミ箱pkg + 技術駆動pkg + no-any
├── immutability/           # イミュータブルを推奨
├── structure/              # 1ファイルにつき1つの型
├── complexity/             # Less Is More (深い継承)
├── demeter/                # デメテルの法則 (Train Wreck)
├── parse-dont-validate/    # Parse, Don't Validate
├── tell-dont-ask/          # Tell, Don't Ask
├── domain-primitives/      # Domain Primitives + 同型引数並び
├── error-handling/         # エラーハンドリング + stringly-typed errors
├── clean-architecture/     # Clean Architecture 層依存
├── breach-encapsulation/   # Breach Encapsulation Naming
├── first-class-collection/ # First Class Collection
├── repository-design/      # Repository 命名・メソッド設計
├── repository-placement/   # Repository Interface 配置
├── backward-compat/        # 後方互換性ガバナンス
├── security/               # シークレット漏洩防止
└── tests/
```

## Rule Coverage: 113 rules / 16 categories

| Category | Source | Go | Py | TS | Total |
|---|---|---|---|---|---|
| naming/ | 曖昧サフィックス + pkg-design + ddd-module + design-principles | 4 | 3 | 9 | **16** |
| immutability/ | イミュータブルを推奨 | 2 | 11 | 11 | **24** |
| structure/ | 1ファイルにつき1つの型 | 3 | 1 | 4 | **8** |
| complexity/ | Less Is More | 1 | 1 | 1 | **3** |
| demeter/ | law-of-demeter | 1 | 1 | 1 | **3** |
| parse-dont-validate/ | parse-dont-validate | 1 | 2 | 2 | **5** |
| tell-dont-ask/ | tell-dont-ask | - | 1 | 1 | **2** |
| domain-primitives/ | domain-primitives + when-to-wrap | 3 | 2 | 2 | **7** |
| error-handling/ | error-handling + steering | 2 | 2 | 3 | **7** |
| clean-architecture/ | clean-architecture | 3 | 2 | 2 | **7** |
| breach-encapsulation/ | breach-encapsulation-naming | 1 | 1 | 1 | **3** |
| first-class-collection/ | first-class-collection | 1 | 1 | 1 | **3** |
| repository-design/ | repository-design | 3 | 3 | 4 | **10** |
| repository-placement/ | repository-placement | 1 | 1 | 1 | **3** |
| backward-compat/ | backward-compat-governance | 1 | 1 | 2 | **4** |
| security/ | security + error-handling steering | 2 | 2 | 2 | **6** |
| **Total** | | **29** | **35** | **47** | **111** |

*Note: Total in table sums to 111. 2 additional rules are language-generic regex patterns counted in the 113 validation total.*

## Sources Covered

- `AGENTS.md` (4/6 rules → semgrep化済み)
- `okite-ai/skills/` (14/32 skills → semgrep化済み)
- `okite-ai/.kiro/settings/rules/design-principles.md` (TypeScript `any` 禁止)
- `okite-ai/.kiro/settings/templates/steering-custom/security.md` (シークレット漏洩)
- `okite-ai/.kiro/settings/templates/steering-custom/error-handling.md` (stringly-typed errors)

## Usage

```bash
semgrep --config .semgrep/ <target>           # All 113 rules
semgrep --config .semgrep/naming/ <target>    # Specific category
semgrep --validate --config .semgrep/         # Validate rules
```
