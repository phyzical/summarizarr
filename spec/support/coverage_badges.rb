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
      JSON.parse(coverage_file_contents, symbolize_names: true)[:result].each do |key, val|
        converted_result[:total][key] = { pct: val }
      end
      converted_result[:total][:statements][:pct] = converted_result[:total][:line][:pct]
      converted_result[:total][:functions][:pct] = converted_result[:total][:line][:pct]
      File.write('coverage/coverage-summary.json', converted_result.to_json)
    end

    def coverage_file_contents
      File.read('coverage/.last_run.json').to_s
    end

    def generate_badges
      `npm run badges`
    end
  end
end
