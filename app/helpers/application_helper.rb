module ApplicationHelper
  def is_visible_accessories_block
    current_page?(index_page_path) or (controller_name === 'games' and action_name === 'show')
  end
end
