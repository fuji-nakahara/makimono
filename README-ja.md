# Makimono

[English](README.md)

Makimono はマークダウンで書かれたファイル群から電子書籍を生成するコマンドラインツールを提供します。

## はじめに

まず、Makimono をインストールします。

    $ gem install makimono

次に、`mybook` ディレクトリに Makimono プロジェクトを作成し、移動します。

    $ makimono new mybook
    $ cd mybook

`src` ディレクトリにあるマークダウンファイルに電子書籍にしたいテキストを書きます。

    $ vi src/01-mybook.md

編集が完了したら、電子書籍を作成します。

    $ makimono build

すると、`out/book.epub` に EPUB ファイルが作成されます。

## ファイル名の規約

Makimono では、ソースディレクトリ（デフォルトではカレントディレクトリの `src`）内のファイルで、正規表現 `^(\d+)-(.+)$` にマッチするファイル名のものを電子書籍に含めるべきコンテンツとみなします。
たとえば `01-プロローグ.md` や `99-エピローグ.md` などです。
また、`-` 以前の数値をコンテンツ順序の決定に利用し、`-` 以降拡張子までの文字列をタイトルとみなします。

正規表現にマッチしない場合は電子書籍の順序だったコンテンツを構成する要素とはみなしませんが、相対パスで参照することができます。
たとえば、`01-プロローグ.md` の中で画像 `sample.png` を表示したい場合、マークダウン記法を使って、

```
![サンプル](sample.png)
```

のように記述し、`src` ディレクトリに `sample.png` を配置すれば、電子書籍でも画像を表示することができます。

## 設定

Makimono はデフォルトでカレントディレクトリの `makimono.yml` を設定ファイルとみなします。
`--config` オプションで別のファイルを指定することもできます。

利用可能な設定項目とデフォルト値は以下のとおりです。

```yaml
# EPUB のメタデータ
# 詳しくは https://imagedrive.github.io/Submission/epub32/epub-packages.html を参照
identifier:                 # 指定しなかった場合は実行時に生成した UUID が設定される 
modified:                   # 指定しなかった場合は現在時刻が設定される
title: 'No title'
language: 'ja'
creator:                    # 配列でも指定可能
contributor:                # 配列でも指定可能
date:
page_progression_direction:

# Makimono 固有のビルド設定
source: 'src'              # 電子書籍にするファイル群を置くディレクトリ
output: 'out'              # 出力したファイルを置くディレクトリ
library: 'lib'             # Makimono 拡張用のユーザーライブラリを置くディレクトリ
converters: [ 'Markdown' ] # 使用するコンバーターの配列。この順で変換が行われる
markdown: 'CommonMarker'   # Markdown コンバーターで使用するマークダウンの種類。デフォルトは CommonMarker で FujiMarkdown も利用可能
CommonMarker:              # CommonMarker の設定
  options: 'DEFAULT'       # 配列でも指定可
  extensions: []
template: 'default.xhtml'  # 使用する ERB テンプレートのパス。default.xhtml を指定した場合はプリセットが適用される
style: null                # 使用する CSS のパス。fuji または fuji_tategaki を指定した場合はプリセットが適用される
generator: 'EPUB'          # 使用するジェネレーター
ebook_file_name: 'book'    # 電子書籍を出力するときのファイル名
```

#### markdown

Makimono は [CommonMark](https://commonmark.org/) の Ruby 実装である [CommonMarker](https://github.com/gjtorikian/commonmarker) をデフォルトのマークダウンコンバーターとして使用します。
また、日本語小説用の拡張マークダウンである [FujiMarkdown](https://github.com/fuji-nakahara/fuji_markdown) を仕様するよう変更することも可能です。
以下は、縦書き日本語小説用の設定例です。

```yaml
page_progression_direction: rtl # ページ送りを右から左（right to left）にする
markdown: FujiMarkdown          # マークダウンコンバーターとして FujiMarkdown を使用する
style: fuji_tategaki            # プリセットの縦書きスタイルを用いる
```

後述のユーザーライブラリ機能を用いれば、kramdown など任意のマークダウンコンバーターを使用することもできます。 

#### template

設定 `template` にファイルパスを渡せば、マークダウン変換時に利用するテンプレートを変更可能です。
テンプレートとして指定されたファイルは ERB として処理されます。
変数として、設定のハッシュオブジェクト `config`、[`Resource`](lib/makimono/resource.rb) クラスのインスタンス `resource`、マークダウン変換後の文字列 `body` の3つが渡されます。
詳しい書き方はデフォルトの XHTML テンプレート [`default.xhtml`](lib/templates/default.xhtml.erb) を参考にしてください。

#### style

設定 `style` に CSS ファイルのパスを渡せば、電子書籍で利用するスタイルを変更できます。
また、プリセットとして横書き日本語小説に適した [`fuji`](lib/styles/fuji.css) と縦書き日本語小説に適した [`fuji_tategaki`](lib/styles/fuji_tategaki.css) が用意されています。

## ユーザーライブラリ

Makimono は Makimono 自体のコードを変更することなく Ruby で拡張できます。

拡張用の Ruby ファイルはライブラリディレクトリ以下に配置すれば実行時に自動でロードされます。
デフォルトのライブラリディレクトリは `lib` ですが、設定 `library` でディレクトリパスを変更可能です。

また、gem として配布されている場合は、`Gemfile` で `makimono` group に含めれば実行時に自動でロードされます。

```ruby
gem 'my_makimono_library', group: :makimono
```

### マークダウン

独自のマークダウンコンバーターを使用するには、`Makimono::Converter::Markdown` 以下に `#render` メソッドを持つ新しいクラスを定義し、設定 `markdown` でクラス名を指定します。
実装は [`CommonMarker`](lib/makimono/converter/markdown/commonmarker.rb) や [`FujiMarkdown`](lib/makimono/converter/markdown/fuji_markdown.rb) を参考にしてください。

たとえば、[kramdown](https://github.com/gettalong/kramdown) をマークダウンコンバーターとして利用するには、まず以下のようなクラス `Makimono::Converter::Markdown::Kramdown` を定義します。

```ruby
require 'kramdown'

module Makimono
  class Converter
    class Markdown
      class Kramdown
        def initialize(config)
          @config = config
        end

        def render(markdown)
          ::Kramdown::Document.new(markdown).to_html
        end
      end
    end
  end
end
```

次に設定 `markdown` でクラス名 `Kramdown` を指定します。

```yaml
markdown: Kramdown
```

### コンバーター

独自のコンバーターを使用するには、`Makimono::Converter` 以下に `#convertible?` と `#convert` メソッドを持つ新しいクラスを定義し、設定 `converters` でクラス名を指定します。
実装は [`Markdown`](lib/makimono/converter/markdown.rb) を参考にしてください。

たとえば、タイトルのアンダースコア (`_`) を空白に変換するコンバーターを追加するには、まず以下のようなクラス `Makimono::Converter::UnderscoreToSpace` を定義します。

```ruby
module Makimono
  class Converter
    class UnderscoreToSpace
      def initialize(config)
        @config = config
      end

      def convertible?(resource)
        resource.ordered?
      end

      def convert(resource)
        converted = resource.dup
        converted.title = resource.title.gsub('_', ' ')
        converted
      end
    end
  end
end
```

次に設定 `converters` にクラス名 `UnderscoreToSpace` を追加します。

```yaml
converters: [ 'Markdown', 'UnderscoreToSpace' ]
```

### ジェネレーター

独自のジェネレーターを使用するには、`Makimono::Generator` 以下に `#generate` メソッドを持つ新しいクラスを定義し、設定 `generator` でクラス名を指定します。
実装は [`Epub`](lib/makimono/generator/epub.rb) や [`SimpleFile`](lib/makimono/generator/simple_file.rb) を参考にしてください。
