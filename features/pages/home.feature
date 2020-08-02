Feature: Homepage
  As a Visitor
  I want to see a homepage
  So that I can find new content

  Background:
    Given 12 Videos Exist

  Scenario: Visitor sees Latest Videos, Random Channels, and Random Videos
    When I go to the homepage
    Then I should see 12 Latest Videos
    Then I should see 12 Random Channels
    Then I should see 12 Random Videos