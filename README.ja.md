# dotfiles

## このドキュメントは何？

- 勤め先の会社で私のdotfilesを使いたいという方が居たので、その方向けの説明書です
- といっても私のために作られたものでしかないのであまり体系立てられたモノではなく厳しい
- あらましのみ説明してあります。

## これは何？

- @ntgaura の使っている設定ファイル群です。
- 全体的に `Rakefile` で管理しており、rubyの存在する環境をある程度想定しています
  - 具体的に言うとMacOS Xあたりを想定しています
  - あとArchLinuxもある程度想定していますが、rubyがシステムに必要です `sudo pacman -S ruby` しておきましょう

## インストール手順

本当は以下も `Rakefile` 内で完結させたいのだけど
手で入力する部分があるので一旦手順で。

1. `git clone git@github.com:ntgaura/dotfiles.git`
2. `cd dotfiles`
3. `cp .gitconfig.local ~/.gitconfig`
4. `~/.gitconfig` を編集して、自分の設定にする
5. `cp .zshrc.local ~/.zshrc`
6. `~/.zshrc` を編集して、自分の設定にする
7. `cp -R .config ~/`
8. `~/.config/nvim/init.vim` を編集して、自分の設定にする
9. `rake setup`
10. `zsh`
11. `nvim`
12. 一度シェルを立て直し改めて `zsh`
13. `rake anyenv:packages`
14. シェルを立て直す
15. `nvim` を立ち上げて `:UpdateRemotePlugins`

## どんな機能があるの？

いろいろな機能があります。

### 基本設定

- いろんな設定を書き込んであります。
  - `git`, `zsh`, `neovim`の設定が主な部分です。
- `Brewfile`, `Caskfile`, `Masfile`, `Yaourtfile` などに書き込んであるパッケージを自動的に環境にインストールします
- `anyenv` を導入し、 `rbenv`, `pyenv`, `ndenv` を導入します。また適当なバージョンの言語処理系をインストールします

### git周り

- aliasがいろいろ設定されています
  - `git alias`: 設定してあるgitのaliasを全て表示するので参考にしてください
- ghq設定として `~/src` を使う設定が書き込まれています

### zsh周り

- `ys` をテーマにしてあります。oh-my-zshなthemeなので乗り換えたい。。。
- 諸々のプラグイン導入してあって `zplug` でそれらは管理してありますj
- `anyframe` で諸々の機能を呼び出すようになっています
  - `Ctrl + gg` (g二回) で `ghq` で管理されているプロジェクトを `peco` により選択できます
  - `Ctrl + gh` で現在のgitリポジトリのコミットハッシュを `peco` で選択して挿入できます
  - `Ctrl + gb` で現在のgitリポジトリのブランチ名を `peco` で選択して挿入できます^
  - `Ctrl + ff` (f二回) で ファイル名を `peco` で選んで挿入できます。
  - など。
- ディレクトリにはいった瞬間に `exa` コマンドでカレントディレクトリのファイル群を表示します
- 何も入力せずEnterを押すと `exa` コマンドでカレントディレクトリのファイル群を表示します

### neovim周り

- いくらかプラグインを導入してます。
  - プラグインは `dein` で管理しています。初回起動時に自動で `dein` がインストールされます。
  - `lightline` 設定で適当にステータスラインを管理しています
  - `indentguide` でインデントが縞模様に強調表示されます
- いくらかのmapを定義しています
  - 分割ウィンドウの移動をnormal modeで `Ctrl+h/j/l/k` にアサインしています
  - normal modeで `er` とすると即座に `.nvimrc` を編集できます
  - normal modeで `tt` とするとタブを開きます
  - normal modeで `tm` によりターミナルを開きます
  - normal modeで `Ctrl+Tab` によりタブを切り替えできます。
  - normal modeで `Ctrl+Shift+Tab` によりタブを逆方向に切り替えできます。
  - Escを2度押しすると検索強調されていた文字列の強調を解除できます 
  - など。詳しくは `.nvimrc`
- `rust` 向けの補完や自動フォーマット設定がはいっています
  - `rust` のときだけ動きが妙に変わるので注意。特に保存時に勝手に `rustfmt` が当たるので戸惑うかもしれません。
- `quickrun` が導入されており `Space-r` で現在のバッファの内容を実行できます
  - たとえば `test.rb` を開いて `puts "ok"` を書込み `Space-r` すると `ok` が出力された分割ウィンドウが開きます
  - どの言語として実行されるかは `:set filetype=ruby` などとして決定します
  - 通常は拡張子から自動的に判定されます。
- などなど。

## などなど

などなど。です。あらましだけでした。
