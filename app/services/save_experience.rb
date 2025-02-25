class SaveExperience
  def initialize(experience)
    @experience = experience
  end

  def call
    if @experience.spam?
      @experience.errors.add(:spam, 'This experience is spam')
    else
      Experience.transaction do
        @experience.save
        @experience.update(edit_id: @experience.id) if @experience.approved?
      end
    end
    @experience
  end
end
