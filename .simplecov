# frozen_string_literal: true

SimpleCov.start do
  add_filter('spec')
  enable_coverage :branch
  minimum_coverage line: 100, branch: 100

  if ENV['TEST_ENV_NUMBER'].nil?
    # Single process. Generate coverage reports when done.
    require 'simplecov-console'
    require 'simplecov-lcov'

    SimpleCov::Formatter::LcovFormatter.config do |c|
      c.report_with_single_file = true # vscode-coverage-gutters prefers a single file for lcov reporting
      c.output_directory = 'coverage' # vscode-coverage-gutters default directory path is 'coverage'
      c.lcov_file_name = 'lcov.info' # vscode-coverage-gutters default report filename is 'lcov.info'
    end

    formatter SimpleCov::Formatter::MultiFormatter.new(
                [
                  SimpleCov::Formatter::HTMLFormatter,
                  SimpleCov::Formatter::Console,
                  SimpleCov::Formatter::LcovFormatter
                ]
              )
  else
    # Multithreaded.

    # WARNING: turbo_tests has exit code 0 when all the tests pass, regardless of the coverage. Run check_coverage to
    # see the coverage results and get a non-zero exit code if the coverage is below the minimum.

    # Don't set a formatter. Assume the system/developer will run check_coverage when they want to see the results.
    # Setting a formatter here would cause intermediate results to be printed to the console, which is confusing.

    # Explicitly set command name to work around https://github.com/serpapi/turbo_tests/issues/24.
    SimpleCov.command_name "spec:#{ENV['TEST_ENV_NUMBER'].empty? ? '1' : ENV['TEST_ENV_NUMBER']}"
  end
end
