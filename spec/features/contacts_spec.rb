require 'spec_helper'

describe 'the contact process' do
  it 'shows a generic contact when contact is not from experience form' do
    experience = create(:experience, name: "Mission Creek Cafe")

    visit experience_path experience
    click_link 'Contact'

    expect(page).not_to have_content('Mission Creek Cafe')
  end
end
