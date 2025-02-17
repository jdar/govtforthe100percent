FactoryBot.define do
  factory :travesty do
    name { 'The SF LGBT Center' }
    street { '1800 Market St' }
    city { 'San Francisco' }
    state { 'CA' }
    country { 'US' }
    upvote { 22 }
    downvote { 11 }
    comment { 'Comment' }
    directions { 'Direction' }
    approved { true }

    after(:create) do |travesty|
      travesty.update(edit_id: travesty.id)
    end

    trait :geocoded do
      latitude { 37.7749 }
      longitude { -122.4194 }
    end

    trait :unisex do
      unisex { true }
    end

    trait :ada do
      accessible { true }
    end

    trait :comment do
      comment { 'Spacious, single-stall with auto-flushing toilet and ADA railings.' }
    end

    trait :directions do
      directions { 'Near the back, past the counter on the left.' }
    end

    factory :unisex_travesty, traits: [:unisex]
    factory :ada_travesty, traits: [:ada]
    factory :unisex_and_ada_travesty, traits: %i[unisex ada]

    factory :oakland_travesty do
      name { 'Some Cafe' }
      street { '1400 Broadway' }
      city { 'Oakland' }
      state { 'CA' }
      country { 'US' }
      latitude { 37.8044 }
      longitude { -122.27081 }
    end

    factory :spam_travesty do
      name { 'Spam Cafe' }
      street { 'Spam Street' }
      city { 'Spam City' }
      state { 'Spam State' }
      country { 'Spam Country' }
    end
  end
end
