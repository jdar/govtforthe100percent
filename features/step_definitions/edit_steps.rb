Given(/^I am on the experience page for id 1$/) do
  FactoryBot.create(
    :experience,
    id: 1,
    name: 'Winnipeg experience',
    street: '91 Albert St.',
    city: 'Winnipeg',
    state: 'MB',
    country: 'Canada'.merge(locations[:Winnipeg])
  )
  visit '/experiences/1'
end

Then(/^I should see the edit link$/) do
  expect(page).to have_content("Propose an edit to this listing.")
end

Given(/^I visit the edit page for 'Winnepeg experience'$/) do
  FactoryBot.create(
    :experience,
    id: 1,
    name: 'Winnipeg experience',
    street: '91 Albert St.',
    city: 'Winnipeg',
    state: 'MB',
    country: 'Canada'.merge(locations[:Winnipeg])
  )
  visit '/experiences/new?edit_id=1&experience_id=1'
end

Then(/^I should see the experience address$/) do
  expect(page).to have_content("684 East hastings")
end

Given(/^I submit an edit to 'Winnepeg Experience'$/) do
  FactoryBot.create(
    :experience,
    id: 1,
    name: 'Winnipeg experience',
    street: '91 Albert St.',
    city: 'Winnipeg',
    state: 'MB',
    country: 'Canada'.merge(locations[:Winnipeg])
  )
  visit '/experiences/new?edit_id=1&experience_id=1'
  fill_in 'experience[name]', with: 'Not Winnepeg experience'
  click_button "Save Experience"
end

Then(/^I should see that the edit has been submitted$/) do
  expect(page).to have_content("Your edit has been submitted. We will review it and update the listing")
end
