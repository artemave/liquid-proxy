Feature: change HTTP headers
  In order to create test scenarios that involve changing HTTP headers
  As developer in test
  I want to run the app under test via API controllable proxy
  that can change headers of requests passing through

  Scenario: add HTTP header
    Given liquid-proxy is running
    When I instruct liquid-proxy to add header "BOOM" with value "KABOOM"
    And an http client makes request to a server via liquid-proxy
    Then that server should see header "BOOM" with value "KABOOM" in incoming requests
