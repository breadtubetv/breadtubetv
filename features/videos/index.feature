Feature: Videos Index
  As a Visitor
  I want to see a list of channels
  So that I can find interesting material

  Scenario: Visitor sees list of Videos
    When I go to the Videos Index
    Then I should see the Page Title and Report Link "Videos - BreadTube.tv"