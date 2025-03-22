# frozen_string_literal: true

module Summary
  def self.new(title:, items:)
    Thing.new(title:, items:)
  end

  Thing =
    Struct.new(:title, :items) do
      def type
        items.count >= 2 ? :upgrade : :new
      end
    end
end
