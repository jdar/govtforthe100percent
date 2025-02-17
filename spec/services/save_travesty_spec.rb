require 'spec_helper'

describe SaveTravesty do
  it 'saves a travesty' do
    travesty = build(:travesty, id: 1)

    actual_travesty = described_class.new(travesty).call

    expect(Travesty.all.size).to eq(1)
    expect(actual_travesty.id).to eq(1)
    expect(actual_travesty.edit_id).to eq(1)
    expect(actual_travesty.approved?).to be(true)
  end

  it 'creates an error for spam' do
    travesty = build(:spam_travesty)

    actual_travesty = described_class.new(travesty).call

    expect(Travesty.all.size).to eq(0)
    expect(actual_travesty.errors.key?(:spam)).to be true
  end

  it "updates the edit id and approved" do
    travesty = build(:travesty)
    travesty.edit_id = 1
    travesty.approved = false

    actual_travesty = described_class.new(travesty).call

    expect(Travesty.all.size).to eq(1)
    expect(actual_travesty.edit_id).to eq(1)
    expect(actual_travesty.approved?).to be(false)
  end
end
