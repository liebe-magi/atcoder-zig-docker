# atcoder-zig-docker

AtCoder用Zig Docker環境

## Features

- 2025年9月の[AtCoder言語環境更新](https://img.atcoder.jp/file/language-update/language-list.html)に対応したZig 0.15.1環境を構築
- [atcoder-cli](https://github.com/Tatamo/atcoder-cli)と[oj](https://github.com/online-judge-tools/oj)を用いた解答用ファイル生成、ローカルでのテストケースチェック、提出
- AC Library for Zig (v0.4.0) をプリインストール
- proconio-zig (v0.3.0) による便利な入力処理
- zig-string、mvzr などの便利なライブラリを含む
- Fish shell と Starship プロンプトによる快適な開発環境

## Installation

### Build

```bash
git clone https://github.com/liebe-magi/atcoder-zig-docker
cd atcoder-zig-docker
docker build -t atcoder-zig .
```

## Usage

### Docker コンテナの起動

```bash
docker run -it --rm -v $(pwd):/home/user/work atcoder-zig
```

### AtCoder CLI の使用

#### ログイン

```bash
acc login
```

#### コンテスト環境のセットアップ

```bash
acc new abc001
```

#### プロジェクトのセットアップ

```bash
./setup-zig-project.sh
```

#### テストケースの取得・実行

```bash
oj d https://atcoder.jp/contests/abc001/tasks/abc001_a
zig build --release -Doptimize=ReleaseFast
oj t -c "./zig-out/bin/judge"
```

#### 提出

```bash
oj s https://atcoder.jp/contests/abc001/tasks/abc001_a src/main.zig
```

## 含まれるライブラリ・ツール

- **Zig**: 0.15.1
- **AC Library for Zig**: v0.4.0
- **proconio-zig**: v0.3.0 (入力処理ライブラリ)
- **zig-string**: 文字列処理ライブラリ
- **mvzr**: 数学・アルゴリズムライブラリ
- **開発ツール**: atcoder-cli, online-judge-tools
- **Shell**: Fish shell with Starship prompt

## Zig プログラムの書き方

### 基本的な構造

```zig
const std = @import("std");
const ac = @import("ac-library");
const proconio = @import("proconio");

pub fn main() !void {
    // プログラムのメイン処理
}
```

### 入力処理（proconio-zig使用）

```zig
const std = @import("std");
const proconio = @import("proconio");

pub fn main() !void {
    var stdin = proconio.stdin();
    const n = try stdin.read(i32);
    const s = try stdin.read([]u8);

    // 処理...
}
```
