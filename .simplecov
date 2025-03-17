# frozen_string_literal: true

SimpleCov.start do
  add_filter('spec')
  enable_coverage :branch
  minimum_coverage line: 100, branch: 100

  # Single process. Generate coverage reports when done.
  require 'simplecov-console'
  require 'simplecov-lcov'

  SimpleCov::Formatter::LcovFormatter.config do |c|
    c.report_with_single_file = true # vscode-coverage-gutters prefers a single file for lcov reporting
    c.output_directory = 'coverage' # vscode-coverage-gutters default directory path is 'coverage'
    c.lcov_file_name = 'lcov.info' # vscode-coverage-gutters default report filename is 'lcov.info'
  end

  formatter SimpleCov::Formatter::MultiFormatter.new(
              [SimpleCov::Formatter::HTMLFormatter, SimpleCov::Formatter::Console, SimpleCov::Formatter::LcovFormatter]
            )
end
