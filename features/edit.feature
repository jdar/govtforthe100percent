Feature: Edit experience

  Scenario: Visit an experience page
    When I am on the experience page for id 1
    Then I should see the edit link

  Scenario: View an edit
    When I visit the edit page for 'Winnepeg Experience'
    Then I should see the experience address
