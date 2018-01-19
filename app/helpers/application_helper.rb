module ApplicationHelper
  def is_visible_accessories_block
    current_page?(index_page_path) or (controller_name === 'games' and action_name === 'show')
  end

  def is_visible_photos_block
    current_page?(index_page_path)
  end

  def is_visible_helpful_block
    current_page?(index_page_path)
  end
end
