module Common
  class Table < AbstractView
    def columns
      @options[:columns] || []
    end

    def rows
      @options[:rows] || []
    end

    def css_class
      @options[:class] || ""
    end
  end
end