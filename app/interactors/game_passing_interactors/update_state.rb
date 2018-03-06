module GamePassingInteractors
  class UpdateState
    include Interactor::Organizer

    organize PerformChecks, PerformPostChecks, GetAppState
  end
end