Feature: Video Page
  As a Visitor
  I want to see a Video page
  So that I can watch more about a Video

  Background:
    Given The "Example Channel" "Example Video" Video Exists

  Scenario: Visitor sees a Video Page
    When I go to the "Example Video" Video Page
    Then I should see the Page Title and Report Link "Example Video - Example Channel - BreadTube.tv"