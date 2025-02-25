require 'spec_helper'

describe RatingLevel do
  describe '.for_experience' do
    it 'returns green level for experiences with a rating higher than 70%' do
      experience = Experience.new upvote: 71, downvote: 29
      expect(described_class.for_experience(experience)).to eq described_class.green
    end

    it 'returns red level for experiences with a rating up to 50%' do
      experience = Experience.new upvote: 50, downvote: 50
      expect(described_class.for_experience(experience)).to eq described_class.red
    end

    it 'returns yellow level for experiences with a rating of 51%' do
      experience = Experience.new upvote: 51, downvote: 49
      expect(described_class.for_experience(experience)).to eq described_class.yellow
    end

    it 'returns yellow level for experiences with a rating of 70%' do
      experience = Experience.new upvote: 70, downvote: 30
      expect(described_class.for_experience(experience)).to eq described_class.yellow
    end
  end
end
