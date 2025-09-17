# atcoder-cpp-docker

AtCoder用C++ Docker環境

## Features

- 2023年の[新ジャッジ環境](https://img.atcoder.jp/file/language-update/language-list.html)に対応したC++環境を構築
- [atcoder-cli](https://github.com/Tatamo/atcoder-cli)と[oj](https://github.com/online-judge-tools/oj)を用いた解答用ファイル生成、ローカルでのテストケースチェック、提出
- AC Library (v1.5.1) をプリインストール
- Boost 1.82.0 をプリインストール (C++2b標準対応)
- GMP、Eigen3 などの数学ライブラリを含む
- Fish shell と Starship プロンプトによる快適な開発環境

## Installation

### Build

```bash
git clone https://github.com/liebe-magi/atcoder-cpp-docker
cd atcoder-cpp-docker
docker build -t atcoder-cpp .
```

## Usage

### Docker コンテナの起動

```bash
docker run -it --rm -v $(pwd):/home/user/work atcoder-cpp
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

#### テストケースの取得・実行

```bash
oj d https://atcoder.jp/contests/abc001/tasks/abc001_a
g++ -o main main.cpp
oj t -c "./main"
```

#### 提出

```bash
oj s https://atcoder.jp/contests/abc001/tasks/abc001_a main.cpp
```

## 含まれるライブラリ・ツール

- **C++ Compiler**: g++-12 (C++2b対応)
- **AC Library**: v1.5.1
- **Boost**: 1.82.0 (static link)
- **数学ライブラリ**: GMP, Eigen3
- **開発ツール**: atcoder-cli, online-judge-tools
- **Shell**: Fish shell with Starship prompt
