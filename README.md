# semgrep-bind

アーキテクチャルール・設計原則・命名規約・OOP原則・セキュリティ基準を [Semgrep](https://semgrep.dev/) のカスタムルールとして実装したリポジトリ。

Go / Python / TypeScript のコードに対して静的解析で自動検出する。

## Quick Start

```bash
# Semgrep のインストール (未インストールの場合)
pip install semgrep
# or
brew install semgrep

# サブモジュールの初期化
git submodule update --init --recursive

# 全ルールでスキャン
semgrep --config .semgrep/ <target-directory>

# カテゴリを絞ってスキャン
semgrep --config .semgrep/naming/ <target-directory>
semgrep --config .semgrep/type-safety/ <target-directory>

# ルールの検証
semgrep --validate --config .semgrep/
```

## Rule Categories

| Category | Rules | Description |
|---|---|---|
| `naming/` | 12 | 曖昧なサフィックス禁止, ゴミ箱パッケージ名禁止, domain層の技術駆動パッケージ名禁止 |
| `type-safety/` | 16 | TypeScript `any` 禁止, Domain Primitives, 同型引数並び検出, Parse Don't Validate |
| `immutability/` | 24 | 破壊的メソッド検出 (push/pop/splice/append/extend...), frozen dataclass推奨 |
| `encapsulation/` | 11 | デメテルの法則, Tell Don't Ask, Breach Encapsulation Naming, First Class Collection |
| `structure/` | 8 | 1ファイル1公開型 |
| `complexity/` | 3 | 深い継承/埋め込み 3+レベル検出 (Less Is More) |
| `layer-dependency/` | 13 | Clean Architecture 層依存違反, domain層のSQL検出, Repository Interface配置 |
| `repository/` | 10 | Repository命名 (インフラ名禁止), DB操作名禁止, ドメイン操作名禁止 |
| `error-handling/` | 7 | bare except, empty catch, ignored error return, stringly-typed error |
| `security/` | 8 | シークレットのログ出力禁止, ハードコードシークレット検出 |
| `backward-compat/` | 4 | version分岐散在検出, Legacy*Adapter増殖検出 |
| **Total** | **116** | Go: 28, Python: 33, TypeScript: 55 |

## Directory Structure

```
.
├── .semgrep/                  # Semgrep custom rules
│   ├── naming/                # 命名規約
│   ├── type-safety/           # 型安全
│   ├── immutability/          # イミュータブル
│   ├── encapsulation/         # カプセル化
│   ├── structure/             # ファイル構造
│   ├── complexity/            # 過剰設計
│   ├── layer-dependency/      # 層依存
│   ├── repository/            # リポジトリ設計
│   ├── error-handling/        # エラー処理
│   ├── security/              # セキュリティ
│   ├── backward-compat/       # 後方互換
│   └── tests/                 # テストフィクスチャ
└── .semgrepignore             # Semgrep ignore settings
```

## Rule Message Format

全ルールのメッセージは `[WHY]` と `[HOW]` の2セクションで構成される:

- **`[WHY]`** — なぜこのコードが問題なのか (根本的な理由)
- **`[HOW]`** — どう書き直すべきか (具体的な代替手段)

```
[WHY] `$X.push(...)` mutates the array in place. Any other reference to
this array will see the change, causing unpredictable side effects.
[HOW] Create a new array: `const newArr = [...$X, item]`.
```

## CI Integration

```yaml
# GitHub Actions example
- name: Run architecture rules
  run: semgrep --config .semgrep/ src/ --error
```

```bash
# Pre-commit hook
semgrep --config .semgrep/ --error --quiet $(git diff --cached --name-only)
```

## Path-Scoped Rules

一部のルールは `paths.include` でスコープが限定されている:

| Scope | Matched Paths | Rules |
|---|---|---|
| Domain layer | `**/domain/**`, `**/model/**`, `**/entity/**` | layer-dependency, encapsulation (breach/first-class-collection) |
| Repository files | `**/*repository*`, `**/*repo*` | repository (DB ops, domain ops) |
| Non-test files | excludes `*_test.*`, `*.spec.*` | security (hardcoded secrets) |

これらのルールはファイルパスの命名規約に依存するため、プロジェクトのディレクトリ構成が規約に沿っている必要がある。
