Feature: change HTTP headers
  In order to create test scenarios that involve changing HTTP headers
  As developer in test
  I want to run the app under test via API controllable proxy
  that can change headers of requests passing through

  Scenario: add HTTP header
    Given I have http client using liquid-proxy
    When I instruct liquid-proxy to add header "BOOM" with value "KABOOM"
    And the client makes http request to a server
    Then that server should see header "BOOM" with value "KABOOM" in incoming requests
