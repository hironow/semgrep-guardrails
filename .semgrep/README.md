# Semgrep Rules for ai-tools Architecture

[submodules/ai-tools](../submodules/ai-tools/) に定義されたアーキテクチャルールを Semgrep で静的解析するルール集。

## Directory Structure

```
.semgrep/
├── naming/                 # 曖昧なサフィックス + ゴミ箱パッケージ名
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
├── repository-design/      # Repository 命名・メソッド設計
├── repository-placement/   # Repository Interface 配置
├── backward-compat/        # 後方互換性ガバナンス
└── tests/
```

## Rule Coverage

| Category | Source | Go | Py | TS | Total |
|---|---|---|---|---|---|
| naming/ | 曖昧なサフィックス + package-design | 3 | 2 | 4 | **9** |
| immutability/ | イミュータブルを推奨 | 2 | 11 | 11 | **24** |
| structure/ | 1ファイルにつき1つの型 | 3 | 1 | 4 | **8** |
| complexity/ | Less Is More | 1 | 1 | 1 | **3** |
| demeter/ | law-of-demeter | 1 | 1 | 1 | **3** |
| parse-dont-validate/ | parse-dont-validate | 1 | 2 | 2 | **5** |
| tell-dont-ask/ | tell-dont-ask | - | 1 | 1 | **2** |
| domain-primitives/ | domain-primitives | 1 | 1 | 1 | **3** |
| error-handling/ | error-handling | 2 | 2 | 1 | **5** |
| clean-architecture/ | clean-architecture | 3 | 2 | 2 | **7** |
| breach-encapsulation/ | breach-encapsulation-naming | 1 | 1 | 1 | **3** |
| first-class-collection/ | first-class-collection | 1 | 1 | 1 | **3** |
| repository-design/ | repository-design | 3 | 3 | 4 | **10** |
| repository-placement/ | repository-placement | 1 | 1 | 1 | **3** |
| backward-compat/ | backward-compat-governance | 1 | 1 | 2 | **4** |
| **Total** | | **24** | **31** | **37** | **92** |

## Source Coverage

### AGENTS.md (6 rules → 4 semgrep categories)

| Rule | semgrep | Status |
|------|---------|--------|
| 曖昧なサフィックスを避ける | naming/ | ✅ |
| イミュータブルを推奨 | immutability/ | ✅ |
| 1ファイルにつき1つの型 | structure/ | ✅ |
| Less Is More | complexity/ | ✅ (継承3+) |
| Explain Skill Selection | - | ❌ AI行動規範 |
| コーディング前の学習 | - | ❌ プロセス |

### okite-ai/skills/ (32 skills → 11 semgrep categories)

| Skill | semgrep | Status |
|-------|---------|--------|
| law-of-demeter | demeter/ | ✅ |
| parse-dont-validate | parse-dont-validate/ | ✅ |
| tell-dont-ask | tell-dont-ask/ | ✅ |
| domain-primitives-and-always-valid | domain-primitives/ | ✅ |
| error-handling | error-handling/ | ✅ |
| clean-architecture | clean-architecture/ | ✅ |
| breach-encapsulation-naming | breach-encapsulation/ | ✅ |
| first-class-collection | first-class-collection/ | ✅ |
| repository-design | repository-design/ | ✅ |
| repository-placement | repository-placement/ | ✅ |
| backward-compat-governance | backward-compat/ | ✅ |
| package-design | naming/ (junk-drawer) | ✅ (部分的) |
| error-classification | - | ❌ 概念定義のみ |
| aggregate-design | - | ❌ 設計原則 (一部 immutability/ でカバー) |
| domain-building-blocks | - | ❌ 設計ガイド |
| when-to-wrap-primitives | - | ❌ 判断フロー (domain-primitives/ が補完) |
| cqrs-*/ddd-*/cross-aggregate-* | - | ❌ 設計パターン |
| reviewing-skills/creating-rules | - | ❌ メタスキル |
| CC-SDD | - | ❌ プロセス |

## Usage

```bash
semgrep --config .semgrep/ <target>           # All 92 rules
semgrep --config .semgrep/naming/ <target>    # Specific category
semgrep --validate --config .semgrep/         # Validate rules
```
