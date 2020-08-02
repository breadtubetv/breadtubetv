Feature: Home Page
  As a Visitor
  I want to see a Home Page
  So that I can find new content

  Background:
    Given 12 Videos Exist

  Scenario: Visitor sees Latest Videos, Random Channels, and Random Videos
    When I go to the Home Page
    Then I should see 12 Latest Videos
    And I should see 12 Random Channels
    And I should see 12 Random Videos
    And I should see an Upload Button
    And I should see the Footer
    And I should see the Page Title and Report Link "BreadTube.tv"