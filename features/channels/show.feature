Feature: Channels Page
  As a Visitor
  I want to see a Channel page
  So that I can learn more about a Channel

  Background:
    Given The "Example Channel" Channel Exists

  Scenario: Visitor sees a Channel Page
    When I go to the "Example Channel" Channel Page
    Then I should see the Page Title and Report Link "Example Channel - BreadTube.tv"