# 駄菓子屋ゲームセンター

子どもの頃、駄菓子屋の店先に置いてあったゲームをブラウザーで再現しています。
インストール不要・登録不要。PCでもスマホでも無料で遊べます。

### ▶ https://yhdog0425-eng.github.io

---

## これは何のリポジトリ？

作った作品を一覧で並べる**入口（ハブ）ページ**です。ゲーム本体はそれぞれ別のリポジトリにあります。

リポジトリ名を `yhdog0425-eng.github.io`（＝ユーザー名 + `.github.io`）にしてあるため、GitHub Pages がこれを**ユーザーサイト**として扱い、`https://yhdog0425-eng.github.io` という短いURLで配信されます。

**短さには理由があります。** YouTubeは説明欄のURLを約41文字で打ち切り、コピーしても途中までしか取れません。このURLは31文字なので、全部表示され、全部コピーできます。

## 収録作品

| 作品 | リポジトリ |
|---|---|
| レトロインベーダー84 | [retro-invaders-84](https://github.com/yhdog0425-eng/retro-invaders-84) |

## 作品を追加するには

[index.html](index.html) の `GAMES` 配列に1つ足すだけです。それ以外は触らなくて構いません。

```js
const GAMES = [
  {
    title: "作品名",
    year: 1980,
    desc: "短い紹介文",
    url: "https://yhdog0425-eng.github.io/リポジトリ名/",
    thumb: "https://yhdog0425-eng.github.io/リポジトリ名/ogp.png",
    ready: true,     // false にすると「準備中」の暗い筐体になります
  },
];
```

## OGP画像を作り直すには

```
powershell -ExecutionPolicy Bypass -File .\make-ogp.ps1
```

`ogp.png`（1200×630）が生成されます。LINEやSNSで共有したときのカード画像です。

> `make-ogp.ps1` は **UTF-8（BOM付き）** で保存してください。BOMがないと PowerShell 5.1 が日本語を文字化けさせ、構文エラーになります。

## 技術的なこと

- HTML1ファイル完結。ビルド不要、依存ライブラリなし、外部通信なし
- 走査線とビネットはCSSのみで再現（ゲーム本体のCanvas実装と見た目を揃えてあります）
- ドット絵はインラインSVG

## ライセンス

MIT
