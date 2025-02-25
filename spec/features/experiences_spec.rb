require 'spec_helper'

describe 'experiences', :js do
  describe 'submission' do
    it 'adds a experience when submitted' do
      visit root_path
      click_link "Submit a New Experience"
      fill_in "experience[name]", with: "Vancouver experience"
      fill_in "experience[street]", with: "684 East Hastings"
      fill_in "experience[city]", with: "Vancouver"
      fill_in "experience[state]", with: "British Columbia"
      find(:select, "Country").first(:option, "Canada").select_option
      click_button "Save Experience"

      expect(page).to have_content("A new experience entry has been created for")
    end

    it 'blocks a spam submission' do
      visit root_path
      click_link 'Submit a New Experience'
      fill_in 'experience[name]', with: 'Spam experience'
      fill_in 'experience[street]', with: 'Spamstreet'
      fill_in 'experience[city]', with: 'Spamland'
      fill_in 'experience[state]', with: 'Spamstate'
      find_by_id('experience_country').find(:xpath, "option[contains(., 'Canada')][1]").select_option
      click_button 'Save Experience'

      expect(page).to have_content("Your submission was rejected as spam.")
    end

    it 'guesses my location' do
      visit "/"
      click_link "Submit a New Experience"
      mock_location("Oakland")

      click_button 'Guess current location'
      page.driver.wait_for_network_idle

      expect(page).to have_field('experience[street]', with: "1400 Broadway")
      expect(page).to have_field('experience[city]', with: "Oakland")
      expect(page).to have_field('experience[state]', with: "California")
    end
  end

  describe 'search' do
    it 'searches for text from the splash page' do
      create(:experience, :geocoded, name: 'Mission Creek Cafe')

      visit root_path
      fill_in 'search', with: 'San Francisco'
      click_button 'Search'

      expect(page).to have_content 'Mission Creek Cafe'
    end

    it 'can search for location from the splash page' do
      create(:oakland_experience, name: "Some Cafe")

      visit root_path
      mock_location "Oakland"
      click_button 'Search by Current Location'

      expect(page).to have_content 'Some Cafe'
    end

    it 'can search from the splash page with a screen reader' do
      visit root_path

      expect(find('button.submit-search-button')['aria-label']).to be_truthy
      expect(find('button.current-location-button')['aria-label']).to be_truthy
    end

    it 'displays a map' do
      create(:oakland_experience)

      visit root_path
      mock_location "Oakland"
      find('.current-location-button').click
      expect(page).to have_css(".map-toggle-btn", visible: :visible)

      find('.map-toggle-btn').click

      expect(page).to have_css('#mapArea.loaded')
      expect(page).to have_css("#mapArea [role=button][aria-label='1']")
    end
  end

  describe 'preview' do
    it 'can preview a experience before submitting' do
      visit "/"
      click_link "Submit a New Experience"
      fill_in "experience[name]", with: "Vancouver experience"
      fill_in "experience[street]", with: "684 East Hastings"
      fill_in "experience[city]", with: "Vancouver"
      fill_in "experience[state]", with: "British Columbia"
      find(:select, "Country").first(:option, "Canada").select_option

      click_button "Preview"

      expect(page).to have_css("div#mapArea", visible: :visible)
      expect(page).to have_css("div#mapArea [title='Current Location']", visible: :visible)
    end
  end

  describe 'nearby experience' do
    it 'shows nearby experiences when they exist' do
      create(:oakland_experience)
      visit "/"
      click_link "Submit a New Experience"
      mock_location "Oakland"

      find(".guess-btn").click

      expect(page).to have_css(".nearby-container .listItem", visible: :visible)
    end

    it "does not show nearby experiences when they don't exist" do
      visit "/"
      click_link "Submit a New Experience"
      mock_location "Oakland"

      find(".guess-btn").click

      expect(page).to have_css(".nearby-container .none", visible: :visible)
    end
  end

  describe "edit" do
    it "creates an edit listing" do
      experience = create(:experience)
      visit "/experiences/#{experience.id}"
      click_link "Propose an edit to this listing."

      fill_in "experience[directions]", with: "This is an edit"
      click_button "Save Experience"

      expect(page).to have_content("Your edit has been submitted.")
      expect(Experience.where(edit_id: experience.id).size).to eq(2)
    end
  end

  describe "vote" do
    it "shows 'Not yet rated' message initially" do
      experience = create(:experience, upvote: 0, downvote: 0)

      visit "/experiences/#{experience.id}"

      expect(page).to have_content("Not yet rated")
    end

    it "can downvote" do
      experience = create(:experience, upvote: 0, downvote: 0)

      visit "/experiences/#{experience.id}"
      click_button "Thumbs Down"

      expect(page).to have_content("0% positive")
    end

    it "can upvote" do
      experience = create(:experience, upvote: 0, downvote: 0)

      visit "/experiences/#{experience.id}"
      click_button "Thumbs Up"

      expect(page).to have_content("100% positive")
    end
  end
end
