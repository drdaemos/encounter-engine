class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize(transliterations: :russian).to_s
  end
end
