require 'spec_helper'

describe 'the contact process' do
  it 'shows a generic contact when contact is not from travesty form' do
    travesty = create(:travesty, name: "Mission Creek Cafe")

    visit travesty_path travesty
    click_link 'Contact'

    expect(page).not_to have_content('Mission Creek Cafe')
  end
end
