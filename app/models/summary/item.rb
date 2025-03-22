# frozen_string_literal: true

module Summary
  module Item
    def self.new(title:, items:)
      Thing.new(title:, items:)
    end

    Thing =
      Struct.new(:title, :items) do
        def summary
          if old_item.present?
            "#{title} has upgraded from #{old_item.quality} to #{new_item.quality}"
          else
            "#{title} has downloaded at #{new_item.quality}"
          end
        end

        private

        def old_item
          items.find(&:deletion?)
        end

        def new_item
          items.reject(&:deletion?).first
        end
      end
  end
end
