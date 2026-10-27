# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "timecalc-cli"
  spec.version = "0.1.1"
  spec.authors = ["Eli"]
  spec.summary = "時間帯・経過時間を合計するCLI / CLI for calculating time ranges and elapsed durations"
  spec.description = <<~DESCRIPTION
    TimeCalcは、カンマ区切りの時間帯、または標準入力から受け取る時間・分の一覧を合計するRuby製CLIです。
    時刻は HH または HH:MM 形式で指定でき、--hm オプションでは H または H.MM 形式の経過時間を行ごとに合計できます。

    TimeCalc is a Ruby CLI for calculating totals from comma-separated time ranges or line-oriented hours-and-minutes input.
    Times can be specified in HH or HH:MM format, and the --hm option sums elapsed durations in H or H.MM format.
  DESCRIPTION
  spec.license = "MIT"
  spec.homepage = "https://github.com/koguchi-e/timecalc"
  spec.metadata = {
    "source_code_uri" => "https://github.com/koguchi-e/timecalc",
    "bug_tracker_uri" => "https://github.com/koguchi-e/timecalc/issues"
  }

  spec.required_ruby_version = ">= 3.1"

  spec.files = [
    "lib/timecalc/cli.rb",
    "lib/timecalc_cli.rb",
    "bin/timecalc",
    "LICENSE",
    "README.md"
  ]

  spec.bindir = "bin"
  spec.executables = ["timecalc"]
  spec.require_paths = ["lib"]
end
