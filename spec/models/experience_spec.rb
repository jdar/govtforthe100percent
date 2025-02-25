require 'spec_helper'

describe Experience do
  let(:experience) { described_class.new }

  describe '#rated?' do
    let(:unrated_experience) { described_class.new }
    let(:rated_experience)   { described_class.new(upvote: 1) }

    specify { expect(rated_experience).to be_rated }
    specify { expect(unrated_experience).not_to be_rated }
  end

  describe '#rating_percentage' do
    it 'returns 0 when there are no votes' do
      expect(experience.rating_percentage).to eq 0
    end

    it "returns zero if there are no upvotes" do
      expect(described_class.new(upvote: 0, downvote: 1).rating_percentage).to eq 0
    end

    it "returns 50% if upvotes equal downvotes" do
      expect(described_class.new(upvote: 1, downvote: 1).rating_percentage).to eq 50
    end

    it "returns 100% if there are upvotes and no downvotes" do
      expect(described_class.new(upvote: 1, downvote: 0).rating_percentage).to eq 100
    end
  end

  describe '#unisex?' do
    it { expect(described_class.new.unisex?).to be false }
    it { expect(described_class.new(unisex: true).unisex?).to be true }
  end

  describe '#accessible?' do
    it { expect(described_class.new.accessible?).to be false }
    it { expect(described_class.new(accessible: true).accessible?).to be true }
  end

  describe '#changing_table?' do
    it { expect(described_class.new.changing_table?).to be false }
    it { expect(described_class.new(changing_table: true).changing_table?).to be true }
  end

  describe '.current' do
    it 'returns active listings' do
      create(:experience, directions: "Most Recent")
      edit = create(:experience)
      edit.update(approved: false, edit_id: 2)

      experiences = described_class.current

      expect(experiences.size).to eq(1)
      expect(experiences.first.directions).to eq("Most Recent")
    end

    it 'returns most recent edit approved' do
      experience = create(:experience, id: 1, edit_id: 1)
      edit1 = create(:experience, id: 2, approved: true, directions: "Most Recent")
      edit1.update(edit_id: experience.id)
      edit2 = create(:experience, id: 3, directions: "Not approved", approved: false)
      edit2.update(edit_id: experience.id)

      experiences = described_class.current

      expect(experiences.size).to eq(1)
      expect(experiences.first.directions).to eq("Most Recent")
    end
  end
end
