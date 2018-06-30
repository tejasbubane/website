class UnlocksNextCoreExercise
  include Mandate

  def initialize(track, user)
    @track = track
    @user = user
  end

  def call
    return if core_exercises_in_progress?

    next_exercise = track.exercises.locked_for(user).order(:position).first

    if next_exercise
      UnlocksCoreExercise.(user, next_exercise)
    else
      # TODO Complete
      # raise "Not Implemented"
    end
  end

  private
  attr_reader :track, :user

  def core_exercises_in_progress?
    user.
      solutions.
      joins(:exercise).
      where(exercises: { track: track, core: true }).
      where(completed_at: nil).
      exists?
  end
end
