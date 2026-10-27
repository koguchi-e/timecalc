# frozen_string_literal: true

require "open3"
require "rbconfig"
require "stringio"
require "spec_helper"
require_relative "../lib/timecalc_cli"

RSpec.describe TimecalcCLI do
  def run_cli(args)
    output = StringIO.new
    error = StringIO.new
    status = described_class.run(args, output: output, error: error)

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
      expect(output).to include("使い方: timecalc")
      expect(error).to be_empty
    end

    it "--help でヘルプを表示する" do
      status, output, error = run_cli(["--help"])

      expect(status).to eq(0)
      expect(output).to include("使い方: timecalc")
      expect(error).to be_empty
    end

    it "--version でバージョンを表示する" do
      status, output, error = run_cli(["--version"])

      expect(status).to eq(0)
      expect(output).to eq("#{described_class::VERSION}\n")
      expect(error).to be_empty
    end
  end

  it "実行コマンドは不正な入力で標準エラー出力と非0終了コードを返す" do
    output, error, process_status = Open3.capture3(RbConfig.ruby, "bin/timecalc", "12:90-14")

    expect(process_status.exitstatus).to eq(1)
    expect(output).to be_empty
    expect(error).to include("エラー:", "00:00 から 23:59")
  end
end
