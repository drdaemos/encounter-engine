module Common
  class Table < AbstractView
    def columns
      @options[:columns] || []
    end

    def rows
      @options[:rows] || []
    end
  end
end