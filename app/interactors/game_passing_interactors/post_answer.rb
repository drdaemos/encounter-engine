module GamePassingInteractors
  class PostAnswer
    include Interactor::Organizer

    organize PerformChecks, CheckAnswer, PerformPostChecks, GetAppState
  end
end