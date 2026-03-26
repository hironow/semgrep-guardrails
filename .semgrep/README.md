# Semgrep Rules for ai-tools Architecture

[submodules/ai-tools](../submodules/ai-tools/) に定義されたアーキテクチャルールを Semgrep で静的解析するルール集。

## Directory Structure

```
.semgrep/
├── naming/              # 命名規約 (曖昧サフィックス, ゴミ箱pkg, 技術駆動pkg)
├── type-safety/         # 型安全 (no-any, domain-primitives, 同型引数, parse-dont-validate)
├── immutability/        # イミュータブル (破壊的メソッド, frozen dataclass)
├── encapsulation/       # カプセル化 (demeter, tell-dont-ask, breach-encapsulation, first-class-collection)
├── structure/           # ファイル構造 (1型1ファイル)
├── complexity/          # 過剰設計 (深い継承)
├── layer-dependency/    # 層依存 (clean-architecture imports/SQL, repository-placement)
├── repository/          # リポジトリ設計 (インフラ命名, DB操作名, ドメイン操作名)
├── error-handling/      # エラー処理 (broad catch, stringly-typed, ignored errors)
├── security/            # セキュリティ (ログ漏洩, ハードコードシークレット)
├── backward-compat/     # 後方互換 (version分岐, Legacy*)
└── tests/
```

## Rule Coverage: 116 rules / 11 categories

| Category | Concern | Go | Py | TS | Total |
|---|---|---|---|---|---|
| naming/ | 曖昧サフィックス, ゴミ箱pkg, 技術駆動pkg | 4 | 3 | 5 | **12** |
| type-safety/ | no-any, domain-primitives, 同型引数, parse-dont-validate | 4 | 3 | 9 | **16** |
| immutability/ | 破壊的メソッド, frozen dataclass | 2 | 11 | 11 | **24** |
| encapsulation/ | demeter, tell-dont-ask, breach-encapsulation, first-class-collection | 2 | 3 | 6 | **11** |
| structure/ | 1型1ファイル | 3 | 1 | 4 | **8** |
| complexity/ | 深い継承/埋め込み 3+レベル | 1 | 1 | 1 | **3** |
| layer-dependency/ | clean-architecture (imports + SQL), repository-placement | 4 | 3 | 6 | **13** |
| repository/ | インフラ命名, DB操作名, ドメイン操作名 | 3 | 3 | 4 | **10** |
| error-handling/ | broad catch, stringly-typed, ignored errors | 2 | 2 | 3 | **7** |
| security/ | ログ漏洩, ハードコードシークレット | 2 | 2 | 4 | **8** |
| backward-compat/ | version分岐散在, Legacy*Adapter増殖 | 1 | 1 | 2 | **4** |
| **Total** | | **28** | **33** | **55** | **116** |

## Usage

```bash
semgrep --config .semgrep/ <target>              # All 116 rules
semgrep --config .semgrep/naming/ <target>       # Specific category
semgrep --config .semgrep/type-safety/ <target>  # Type safety rules
semgrep --validate --config .semgrep/            # Validate rules
```
