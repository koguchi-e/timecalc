# frozen_string_literal: true

module TimecalcCLI
  VERSION = "0.1.0"
  TIME_PATTERN = /\A\d{2}(?::\d{2})?\z/
  RANGE_PATTERN = /\A(?<start>\d{2}(?::\d{2})?)-(?<finish>\d{2}(?::\d{2})?)\z/
  ParsedRange = Struct.new(:start_label, :end_label, :duration, keyword_init: true)

  class InputError < StandardError; end

  def self.run(args, output: $stdout, error: $stderr)
    case args
    when []
      output.puts help
      return 0
    when ["--help"]
      output.puts help
      return 0
    when ["--version"]
      output.puts VERSION
      return 0
    end

    ranges = parse_ranges(args.join(" "))
    print_result(ranges, output)
    0
  rescue InputError => e
    error.puts "エラー: #{e.message}"
    1
  end

  def self.parse_ranges(input)
    ranges = input.split(",", -1).map(&:strip)
    raise InputError, "時間帯を指定してください。" if ranges.empty? || ranges.any?(&:empty?)

    ranges.map { |range| parse_range(range) }
  end

  def self.parse_range(range)
    match = RANGE_PATTERN.match(range)
    raise InputError, "時間帯は HH-HH または HH:MM-HH:MM 形式で指定してください: #{range}" unless match

    start_label = match[:start]
    end_label = match[:finish]
    start_minutes = to_minutes(start_label)
    end_minutes = to_minutes(end_label)

    if start_minutes > end_minutes
      raise InputError, "開始時刻は終了時刻以前にしてください（日付をまたぐ時間帯には対応していません）: #{range}"
    end

    ParsedRange.new(
      start_label: start_label,
      end_label: end_label,
      duration: end_minutes - start_minutes
    )
  end

  def self.to_minutes(time)
    raise InputError, "時刻は HH または HH:MM 形式で指定してください: #{time}" unless TIME_PATTERN.match?(time)

    hours, minutes = time.split(":").map(&:to_i)
    minutes ||= 0

    unless hours.between?(0, 23) && minutes.between?(0, 59)
      raise InputError, "時刻は 00:00 から 23:59 の範囲で指定してください: #{time}"
    end

    hours * 60 + minutes
  end

  def self.format_duration(total_minutes)
    hours, minutes = total_minutes.divmod(60)
    "#{hours}時間#{minutes}分"
  end

  def self.print_result(ranges, output)
    total_minutes = ranges.sum(&:duration)

    ranges.each do |range|
      output.puts "#{range.start_label} - #{range.end_label} : #{format_duration(range.duration)}"
    end

    output.puts "--------------------------"
    output.puts "合計：#{format_duration(total_minutes)}"
  end

  def self.help
    <<~HELP.chomp
      使い方: timecalc "HH-HH, HH:MM-HH:MM"

      複数の時間帯をカンマ区切りで指定します。
      時刻は 00〜23 時、00〜59 分の範囲で指定してください。
      日付をまたぐ時間帯には対応していません。
    HELP
  end
end
