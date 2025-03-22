# frozen_string_literal: true

module CoverageBadges
  class << self
    def generate
      convert_coverage
      generate_badges
    end

    private

    def convert_coverage
      converted_result = { total: { lines: {}, statements: {}, functions: {}, branches: {} } }
      coverage = JSON.parse(coverage_file_contents, symbolize_names: true)[:result]
      converted_result[:total][:statements][:pct] = 'N/A'
      converted_result[:total][:functions][:pct] = 'N/A'
      converted_result[:total][:lines][:pct] = coverage[:line]
      converted_result[:total][:branches][:pct] = coverage[:branch]
      File.write('coverage/coverage-summary.json', converted_result.to_json)
    end

    def coverage_file_contents
      File.read('coverage/.last_run.json').to_s
    end

    def generate_badges
      puts 'generating badges'
      `npm run badges`
    end
  end
end
