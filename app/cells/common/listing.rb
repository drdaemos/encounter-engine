module Common
  class Listing < AbstractView
    def item_view
      @options[:item_view] || Common::String
    end

    def item_key
      @options[:item_key] || default_item_key
    end

    def items
      model
    end

    def css_class
      @options[:class] || ""
    end

    def empty_message
      @options[:empty_message] || "Список пуст"
    end

    protected

    def default_item_key
      ->(item) {
        if item.is_a? ApplicationRecord
          return item.id.to_s
        end

        ""
      }
    end
  end
end