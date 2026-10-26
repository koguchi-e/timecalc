# frozen_string_literal: true

module Timecalc
  def self.run(args)
    input = args.join(" ")
    ranges = input.split(",")

    total_minutes = 0

    ranges.each do |range|
      start_time, end_time = range.strip.split("-")

      start_minutes = to_minutes(start_time)
      end_minutes = to_minutes(end_time)

      duration = end_minutes - start_minutes
      total_minutes += duration

      puts "#{start_time} - #{end_time} : #{format_duration(duration)}"
    end

    puts "--------------------------"
    puts "合計："
    puts "#{format_duration(total_minutes)}"
  end

  def self.to_minutes(time)
    hours, minutes = time.split(":").map(&:to_i)
    minutes ||= 0
    hours * 60 + minutes
  end

  def self.format_duration(total_minutes)
    hours, minutes = total_minutes.divmod(60)
    "#{hours}時間#{minutes}分"
  end
end
