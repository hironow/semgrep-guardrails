# Intent

**Last updated:** 2026-06-10
**Requester:** hironow
**Work unit:** semgrep-guardrails — アーキテクチャ規約の静的ルール集

## Goal

アーキテクチャルール・設計原則・命名規約・OOP 原則・セキュリティ基準を
Semgrep カスタムルール（116本）として実装し、Go / Python / TypeScript の
コードベースに静的解析で適用する規約集とする。

## Success Criteria

- `semgrep --validate --config .semgrep/` がエラーゼロ（ルールの構文 +
  パターン妥当性）
- `.semgrep/tests/` の fixture に対してルールが実際に発火する
  （`just semgrep-fixtures` のスモークテストが non-zero findings）
- 全ルールのメッセージが `[WHY]` / `[HOW]` の2セクション構成を守る
- 利用側リポジトリから `semgrep --config <this-repo>/.semgrep/ <target>` で
  そのまま適用できる

## Scope

### In scope

- 11 カテゴリ（naming / type-safety / immutability / encapsulation /
  structure / complexity / layer-dependency / repository / error-handling /
  security / backward-compat）のルール整備と fixture
- ルールの検証ツーリング（justfile / prek hooks）

### Out of scope (Non-goals)

- type checker（mypy / tsc）や ruff が既にカバーする検査の再実装
- Semgrep Pro 専用機能（taint mode 等）への依存

## Constraints

- path-scoped ルール（domain / repository 等）はディレクトリ命名規約に依存
  するため、適用先プロジェクトの構成が規約準拠であることが前提
- `.semgrep/tests/` の fixture は意図的に「悪いコード」（fake secret 等）を
  含む。formatting / secret-detection hooks の対象外を維持する

## Open Questions

- [ ] fixture をルールと同名・同階層に再配置して `semgrep --test` の
      annotation 検証（ruleid/ok の期待一致）を有効にするか
      （現状はファイル名が対応しておらず discovery が効かない）
- [ ] CI workflow（validate + fixtures を PR ゲートにする）を追加するか
- [ ] submodules/ai-tools（j5ik2o/ai-tools）の位置づけ — 現状 .gitmodules の
      記録のみで clone しない方針（2026-06-10 確認済み）
