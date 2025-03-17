# frozen_string_literal: true

require_relative 'app/dependencies'
require 'syntax_tree/rake_tasks'
[SyntaxTree::Rake::CheckTask, SyntaxTree::Rake::WriteTask].each do |klass|
  klass.new { |t| t.source_files = FileList[%w[Gemfile Rakefile **/*.rb]] }
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new

task :coverage_badges do
  require_relative 'spec/support/coverage_badges'

  CoverageBadges.generate
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task lint_fix: %i[stree:write rubocop:autocorrect_all]
task lint: %i[stree:check rubocop]
task default: %i[lint spec coverage_badges]
