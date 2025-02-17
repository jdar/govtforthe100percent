Feature: Edit travesty

  Scenario: Visit a travesty page
    When I am on the travesty page for id 1
    Then I should see the edit link

  Scenario: View an edit
    When I visit the edit page for 'Winnepeg Travesty'
    Then I should see the travesty address
