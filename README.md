# TimeCalc

TimeCalcは、複数の時間帯を入力して、合計時間を計算できるRuby製のコマンドラインツール（CLI）です。

**日本語 | [English](#english)**

---

## 日本語

### 機能

- 複数の時間帯の合計時間を計算
- `HH:MM` または `HH` 形式で時刻を指定可能
- 各時間帯の経過時間と合計時間を表示
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

### 入力ルール

- 時刻は2桁の `HH` または `HH:MM` 形式で指定します。
- 時は `00`〜`23`、分は `00`〜`59` の範囲です。
- 開始時刻は終了時刻以前にしてください。同じ時刻は0分として計算されます。
- 日付をまたぐ時間帯には対応していません。
- すべての時間帯を検証してから計算結果を表示します。不正な入力では結果を表示せず、標準エラー出力にエラーメッセージを表示して終了コード `1` で終了します。

### オプション

```bash
timecalc --help
timecalc --version
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

### Input rules

- Times must use the two-digit `HH` or `HH:MM` format.
- Hours must be from `00` to `23`; minutes must be from `00` to `59`.
- The start time must be no later than the end time. Equal times count as zero minutes.
- Time ranges that cross midnight are not supported.
- All ranges are validated before any results are printed. Invalid input prints an error to standard error and exits with status `1` without printing results.

### Options

```bash
timecalc --help
timecalc --version
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
