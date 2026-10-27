# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "timecalc-cli"
  spec.version = "0.1.0"
  spec.authors = ["Eli"]
  spec.summary = "A simple CLI time calculator"
  spec.description = "Calculate total duration from multiple time ranges."
  spec.license = "MIT"

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
