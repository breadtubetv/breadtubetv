Feature: Channels Index
  As a Visitor
  I want to see a list of channels
  So that I can find interesting material

  Scenario: Visitor sees list of Channels
    When I go to the Channels Index
    Then I should see the Page Title and Report Link "Channels - BreadTube.tv"