require 'spec_helper'

describe SaveExperience do
  it 'saves an experience' do
    experience = build(:experience, id: 1)

    actual_experience = described_class.new(experience).call

    expect(Experience.all.size).to eq(1)
    expect(actual_experience.id).to eq(1)
    expect(actual_experience.edit_id).to eq(1)
    expect(actual_experience.approved?).to be(true)
  end

  it 'creates an error for spam' do
    experience = build(:spam_experience)

    actual_experience = described_class.new(experience).call

    expect(Experience.all.size).to eq(0)
    expect(actual_experience.errors.key?(:spam)).to be true
  end

  it "updates the edit id and approved" do
    experience = build(:experience)
    experience.edit_id = 1
    experience.approved = false

    actual_experience = described_class.new(experience).call

    expect(Experience.all.size).to eq(1)
    expect(actual_experience.edit_id).to eq(1)
    expect(actual_experience.approved?).to be(false)
  end
end
