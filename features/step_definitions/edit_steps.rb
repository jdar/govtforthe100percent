Given(/^I am on the travesty page for id 1$/) do
  FactoryBot.create(
    :travesty,
    id: 1,
    name: 'Winnipeg travesty',
    street: '91 Albert St.',
    city: 'Winnipeg',
    state: 'MB',
    country: 'Canada'.merge(locations[:Winnipeg])
  )
  visit '/travesties/1'
end

Then(/^I should see the edit link$/) do
  expect(page).to have_content("Propose an edit to this listing.")
end

Given(/^I visit the edit page for 'Winnepeg travesty'$/) do
  FactoryBot.create(
    :travesty,
    id: 1,
    name: 'Winnipeg travesty',
    street: '91 Albert St.',
    city: 'Winnipeg',
    state: 'MB',
    country: 'Canada'.merge(locations[:Winnipeg])
  )
  visit '/travesties/new?edit_id=1&travesty_id=1'
end

Then(/^I should see the travesty address$/) do
  expect(page).to have_content("684 East hastings")
end

Given(/^I submit an edit to 'Winnepeg Travesty'$/) do
  FactoryBot.create(
    :travesty,
    id: 1,
    name: 'Winnipeg travesty',
    street: '91 Albert St.',
    city: 'Winnipeg',
    state: 'MB',
    country: 'Canada'.merge(locations[:Winnipeg])
  )
  visit '/travesties/new?edit_id=1&travesty_id=1'
  fill_in 'travesty[name]', with: 'Not Winnepeg travesty'
  click_button "Save Travesty"
end

Then(/^I should see that the edit has been submitted$/) do
  expect(page).to have_content("Your edit has been submitted. We will review it and update the listing")
end
