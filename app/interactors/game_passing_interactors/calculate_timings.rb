module GameInteractors
  class CalculateTimings
    include Interactor

    def call
      @game_passing = context.game_passing
      @level_results = LevelResult.of_game_passing(@game_passing).to_a
      @adjustments = PassingAdjustment.of_game_passing(@game_passing).to_a

      if @game_passing.finished?
        context.clean_time = to_human(clean_time)
        context.adjusted_time = to_human(adjusted_time)
        context.adjustment_time = to_human(adjustment_time)
      else
        context.fail!
      end
    end

    def clean_time
      @level_results.reduce(0.0) do |sum, result|
        sum += (result.created_at - result.entered_at)
        sum
      end
    end

    def adjusted_time
      clean_time + adjustment_time
    end

    def adjustment_time
      level_adjustment = @level_results.reduce(0.0) do |sum, result|
        sum += (result.adjustment)
        sum
      end

      passing_adjustment = @adjustments.reduce(0.0) do |sum, record|
        sum += (record.adjustment)
        sum
      end

      - (level_adjustment + passing_adjustment)
    end

    def to_human(diff)
      sign = ""
      if diff < 0
        sign = "-"
      end

      sign + Time.at(diff.abs).utc.strftime("%T")
    end

  end
end