module GamePassingInteractors
  class CheckCurrentState
    include Interactor::Organizer

    organize PerformChecks, PerformPostChecks
  end
end