# TimeCalc

TimeCalcは、複数の時間帯を入力して、合計時間を計算できるRuby製のコマンドラインツール（CLI）です。

**日本語 | [English](#english)**

---

## 日本語

### 機能

- 複数の時間帯の合計時間を計算
- `HH:MM` または `HH` 形式で時刻を指定可能
- 各時間帯の経過時間と合計時間を表示
- `--hm` で標準入力の時間・分データを縦に合計
- 不正な入力は標準エラー出力に表示し、終了コード `1` で終了

### インストール

Rubyがインストールされている環境で、以下を実行してください。

```bash
gem install timecalc-cli
```

※ RubyGems.orgへの公開後に利用できます。

### 使い方

複数の時間帯をカンマ区切りで指定します。

```bash
timecalc "11:17-12, 12:30-13, 13:15-14, 15:30-18"
```

実行結果：

```text
11:17 - 12 : 0時間43分
12:30 - 13 : 0時間30分
13:15 - 14 : 0時間45分
15:30 - 18 : 2時間30分
--------------------------
合計：4時間28分
```

分を省略した場合は、0分として扱います。

```bash
timecalc "11-12, 13-15"
```

実行結果：

```text
11 - 12 : 1時間0分
13 - 15 : 2時間0分
--------------------------
合計：3時間0分
```

### 時間・分を縦に合計する（`--hm`）

`--hm` を指定すると、標準入力から1行につき1件の経過時間を受け取り、EOF（Ctrl+D）で合計を表示します。

```bash
timecalc --hm
6.15
8.4
7.7
# Ctrl+D
```

```text
合計：21時間26分
```

ファイルからの入力にも対応しています。

```bash
timecalc --hm < times.txt
```

`6.15` は6時間15分を表します。これは小数ではなく、ピリオドの前を時間、後ろを分として扱います。

### 入力ルール

- 時刻は2桁の `HH` または `HH:MM` 形式で指定します。
- 時は `00`〜`23`、分は `00`〜`59` の範囲です。
- 開始時刻は終了時刻以前にしてください。同じ時刻は0分として計算されます。
- 日付をまたぐ時間帯には対応していません。
- すべての時間帯を検証してから計算結果を表示します。不正な入力では結果を表示せず、標準エラー出力にエラーメッセージを表示して終了コード `1` で終了します。

### `--hm` の入力ルール

- 1行につき、非負の `H` または `H.MM` 形式で1件の経過時間を指定します。時間部分は24時間以上でも指定できます。
- 分は `0`〜`59` の範囲です。`8.4`、`7.5`、`0.3`、`8.04` はそれぞれ8時間4分、7時間5分、0時間3分、8時間4分を表します。
- 空行は無視します。負の数、文字列、不正な書式、範囲外の分はエラーになります。
- 不正な行がある場合は、行番号を含むエラーを標準エラー出力に表示し、合計は表示しません。

### オプション

```bash
timecalc --help
timecalc --version
timecalc --hm
```

### 開発方法

リポジトリをクローンし、依存ライブラリをインストールします。

```bash
git clone https://github.com/<username>/timecalc.git
cd timecalc
bundle install
```

ローカルで実行します。

```bash
bundle exec ruby bin/timecalc "11-12, 13-15"
```

テストを実行します。

```bash
bundle exec rspec
```

Gemをビルドします。

```bash
gem build timecalc-cli.gemspec
```

ビルドしたGemをローカルにインストールします。

```bash
gem install ./timecalc-cli-0.1.0.gem
```

### 動作環境

- Ruby 3.1以上

### ライセンス

MIT License

---

## English

TimeCalc is a Ruby command-line tool (CLI) that calculates the total duration of multiple time ranges.

### Features

- Calculate the total duration of multiple time ranges
- Support `HH:MM` and `HH` time formats
- Display individual durations and the total duration
- Sum line-oriented hours-and-minutes input from standard input with `--hm`
- Print invalid-input errors to standard error and exit with status `1`

### Installation

Run the following command in an environment with Ruby installed.

```bash
gem install timecalc-cli
```

_This command will be available after the gem is published to RubyGems.org._

### Usage

Pass multiple time ranges separated by commas.

```bash
timecalc "11:17-12, 12:30-13, 13:15-14, 15:30-18"
```

Output:

```text
11:17 - 12 : 0時間43分
12:30 - 13 : 0時間30分
13:15 - 14 : 0時間45分
15:30 - 18 : 2時間30分
--------------------------
合計：4時間28分
```

If minutes are omitted, they are treated as `00`.

```bash
timecalc "11-12, 13-15"
```

Output:

```text
11 - 12 : 1時間0分
13 - 15 : 2時間0分
--------------------------
合計：3時間0分
```

### Sum line-oriented hours and minutes (`--hm`)

With `--hm`, enter one elapsed duration per line through standard input. End input with EOF (Ctrl+D) to print the total.

```bash
timecalc --hm
6.15
8.4
7.7
# Ctrl+D
```

```text
合計：21時間26分
```

Input redirection is also supported:

```bash
timecalc --hm < times.txt
```

`6.15` means 6 hours and 15 minutes. It is not a decimal value: the portion before the period is hours and the portion after it is minutes.

### Input rules

- Times must use the two-digit `HH` or `HH:MM` format.
- Hours must be from `00` to `23`; minutes must be from `00` to `59`.
- The start time must be no later than the end time. Equal times count as zero minutes.
- Time ranges that cross midnight are not supported.
- All ranges are validated before any results are printed. Invalid input prints an error to standard error and exits with status `1` without printing results.

### `--hm` input rules

- Enter one non-negative elapsed duration per line in `H` or `H.MM` format. The hour portion may be 24 or greater.
- Minutes must be from `0` to `59`. `8.4`, `7.5`, `0.3`, and `8.04` mean 8 hours 4 minutes, 7 hours 5 minutes, 0 hours 3 minutes, and 8 hours 4 minutes, respectively.
- Blank lines are ignored. Negative values, text, malformed values, and out-of-range minutes are errors.
- If any line is invalid, an error including its line number is printed to standard error and no total is printed.

### Options

```bash
timecalc --help
timecalc --version
timecalc --hm
```

### Development

Clone the repository and install dependencies.

```bash
git clone https://github.com/<username>/timecalc.git
cd timecalc
bundle install
```

Run locally:

```bash
bundle exec ruby bin/timecalc "11-12, 13-15"
```

Run tests:

```bash
bundle exec rspec
```

Build the gem:

```bash
gem build timecalc-cli.gemspec
```

Install the gem locally:

```bash
gem install ./timecalc-cli-0.1.0.gem
```

### Requirements

- Ruby 3.1 or later

### License

MIT License
