# frozen_string_literal: true

require "open3"
require "rbconfig"
require "stringio"
require "spec_helper"
require_relative "../lib/timecalc_cli"

RSpec.describe TimecalcCLI do
  def run_cli(args, input: "")
    output = StringIO.new
    error = StringIO.new
    status = described_class.run(args, input: StringIO.new(input), output: output, error: error)

    [status, output.string, error.string]
  end

  describe ".run" do
    it "HH 形式の時間帯を計算する" do
      status, output, error = run_cli(["11-12"])

      expect(status).to eq(0)
      expect(output).to include("11 - 12 : 1時間0分", "合計：1時間0分")
      expect(error).to be_empty
    end

    it "HH:MM 形式の時間帯を計算する" do
      status, output, error = run_cli(["11:30-12:45"])

      expect(status).to eq(0)
      expect(output).to include("11:30 - 12:45 : 1時間15分", "合計：1時間15分")
      expect(error).to be_empty
    end

    it "カンマ区切りの複数時間帯を合計する" do
      status, output, error = run_cli(["11-12,13-15"])

      expect(status).to eq(0)
      expect(output).to include("11 - 12 : 1時間0分", "13 - 15 : 2時間0分", "合計：3時間0分")
      expect(error).to be_empty
    end

    it "同じ開始・終了時刻を0分として計算する" do
      status, output, error = run_cli(["12-12"])

      expect(status).to eq(0)
      expect(output).to include("12 - 12 : 0時間0分", "合計：0時間0分")
      expect(error).to be_empty
    end

    {
      "12:90-14" => "00:00 から 23:59",
      "25-26" => "00:00 から 23:59",
      "abc-1" => "HH-HH または HH:MM-HH:MM",
      "12-13-14" => "HH-HH または HH:MM-HH:MM",
      "15-12" => "開始時刻は終了時刻以前",
      "23-1" => "HH-HH または HH:MM-HH:MM"
    }.each do |input, message|
      it "不正な入力 #{input.inspect} を標準エラーに表示して失敗する" do
        status, output, error = run_cli([input])

        expect(status).to eq(1)
        expect(output).to be_empty
        expect(error).to include("エラー:", message)
      end
    end

    it "すべての時間帯を検証してから結果を表示する" do
      status, output, error = run_cli(["11-12,12:90-14"])

      expect(status).to eq(1)
      expect(output).to be_empty
      expect(error).to include("エラー:")
    end

    it "引数なしではヘルプを表示する" do
      status, output, error = run_cli([])

      expect(status).to eq(0)
      expect(output).to include("使い方:", "timecalc --hm")
      expect(error).to be_empty
    end

    it "--help でヘルプを表示する" do
      status, output, error = run_cli(["--help"])

      expect(status).to eq(0)
      expect(output).to include("使い方:", "timecalc --hm")
      expect(error).to be_empty
    end

    it "--version でバージョンを表示する" do
      status, output, error = run_cli(["--version"])

      expect(status).to eq(0)
      expect(output).to eq("#{described_class::VERSION}\n")
      expect(error).to be_empty
    end

    it "--hm で複数行の時間と分を合計する" do
      input = <<~INPUT
        6.15
        8.4
        7.7
        7.5
        0.3
        1
        0
        8.04
      INPUT

      status, output, error = run_cli(["--hm"], input: input)

      expect(status).to eq(0)
      expect(output).to eq("合計：37時間38分\n")
      expect(error).to be_empty
    end

    it "--hm では空行を無視し、24時間以上の経過時間を受け付ける" do
      status, output, error = run_cli(["--hm"], input: "\n25.30\n\n1\n")

      expect(status).to eq(0)
      expect(output).to eq("合計：26時間30分\n")
      expect(error).to be_empty
    end

    {
      "1.60" => "分は 0〜59",
      "-1" => "時間は H または H.MM",
      "abc" => "時間は H または H.MM",
      "1.2.3" => "時間は H または H.MM",
      "1." => "時間は H または H.MM"
    }.each do |input, message|
      it "--hm は不正な入力 #{input.inspect} を行番号付きでエラーにする" do
        status, output, error = run_cli(["--hm"], input: "#{input}\n")

        expect(status).to eq(1)
        expect(output).to be_empty
        expect(error).to include("エラー: 行 1:", message)
      end
    end

    it "--hm は不正な行がある場合に合計を表示しない" do
      status, output, error = run_cli(["--hm"], input: "1\n\n2.60\n")

      expect(status).to eq(1)
      expect(output).to be_empty
      expect(error).to include("行 3:", "分は 0〜59")
    end
  end

  it "実行コマンドは不正な入力で標準エラー出力と非0終了コードを返す" do
    output, error, process_status = Open3.capture3(RbConfig.ruby, "bin/timecalc", "12:90-14")

    expect(process_status.exitstatus).to eq(1)
    expect(output).to be_empty
    expect(error).to include("エラー:", "00:00 から 23:59")
  end

  it "実行コマンドは --hm で標準入力を受け取る" do
    output, error, process_status = Open3.capture3(
      RbConfig.ruby,
      "bin/timecalc",
      "--hm",
      stdin_data: "6.15\n8.4\n"
    )

    expect(process_status.exitstatus).to eq(0)
    expect(output).to eq("合計：14時間19分\n")
    expect(error).to be_empty
  end
end
