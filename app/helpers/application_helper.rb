module ApplicationHelper
  def is_visible_accessories_block
    current_page?(index_page_path) || (controller_name === 'games' && action_name === 'show')
  end

  def is_visible_photos_block
    current_page?(index_page_path)
  end

  def is_visible_helpful_block
    current_page?(index_page_path)
  end

  def datetime(object)
    if object.respond_to? :utc
      ('<span data-datetime-string>' + object.utc.strftime('%FT%T.%LZ') + '</span>').html_safe
    end
  end

  def get_setting(key)
    setting = Setting.find_by key: key
    setting ? setting.value : nil
  end

  def set_setting(key, value)
    model = Setting.find_by key: key
    if model.nil?
      model = Setting.new({
        :key => key
      })
    end

    model.value = value
    model.save!
  end
end
