# Handover

**Last updated:** 2026-06-10 (JST)
**Updated by:** claude (session: justfile/prek 艦隊整備)

## Current State

116 ルール（Go: 28 / Python: 33 / TypeScript: 55）が 11 カテゴリで実装済み。
2026-06-10 に開発ツーリングを導入（PR #1: justfile + prek hooks +
markdownlint、PR #2: .gitmodules の record-only コミット）。
`just check` = markdownlint + `semgrep --validate` + fixture スモークテスト
（166 findings）が green。

## In Progress

なし。

## Next Actions

1. CI workflow の検討（現状 GitHub Actions なし。`just check` 相当を PR
   ゲートにすると壊れたルールの混入を防げる）
2. `semgrep --test` の annotation 検証を有効にするか判断
   （intent.md の Open Questions 参照。fixture の再配置が必要）

## Known Risks / Blockers

- リポジトリの PR 機能が一時壊れていた（API が 404 / CreatePullRequest
  権限エラー）。2026-06-10 に hironow が修復済み。再発したら設定を疑う
- fixture 検証はスモーク（発火数 > 0）のみ。個別ルールの検出精度の
  リグレッションは検知できない

## Context the Next Actor Needs

- `submodules/ai-tools` は**意図的に clone されていない空ディレクトリ**。
  .gitmodules は出自の記録のみ（record-only、2026-06-10 の方針決定）。
  gitlink は無いので `git submodule update --init` は何もしない
- `.semgrep/tests/` の「悪いコード」は意図的なテストデータ。prek hooks と
  markdownlint の除外設定（.pre-commit-config.yaml / .markdownlint-cli2.yaml）
  を崩さないこと

## Relevant Files and Commands

- `.semgrep/<category>/` — ルール本体（1ルール1ファイル）
- `.semgrep/tests/` — fixture（ruleid/ok annotation 付き）
- `just check` — validate + fixtures + markdownlint の厳格ゲート
- `just install-hooks` — prek hooks 導入（clone 後1回）
