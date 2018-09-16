module Common
  class PaginatedListing < Listing
    def base_url
      @options[:base_url]
    end

    def page_size
      @options[:page_size] || 15
    end

    def current_page
      @options[:current_page]
    end

    def items_count
      @options[:items_count]
    end

    def listing_class
      css_class + "-listing"
    end

    def get_page_label (index)
      (index + 1).to_s
    end

    def get_page_url (index)
      base_url + "?page=" + (index + 1).to_s
    end

    def is_current (index)
      (index + 1) == current_page
    end

    protected

    def page_count
      (items_count / page_size).ceil
    end
  end
end