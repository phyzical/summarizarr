# frozen_string_literal: true

module FactoryBot
  def self.factory_by_class(klass)
    factories.index_by(&:build_class).fetch(klass).name
  end
end
