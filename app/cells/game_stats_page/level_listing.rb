module GameStatsPage
  class LevelListing < AbstractView

    def is_visible?
      super && !model.nil? && model.finished?
    end
  end
end