class SaveTravesty
  def initialize(travesty)
    @travesty = travesty
  end

  def call
    if @travesty.spam?
      @travesty.errors.add(:spam, 'This travesty is spam')
    else
      Travesty.transaction do
        @travesty.save
        @travesty.update(edit_id: @travesty.id) if @travesty.approved?
      end
    end
    @travesty
  end
end
