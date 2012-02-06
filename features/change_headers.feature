Feature: change HTTP headers
  In order to create test scenarios that involve changing HTTP headers
  As developer in test
  I want to run the app under test via API controllable proxy
  that can change headers of requests passing through

  Background:
    Given liquid-proxy is running
    When I instruct liquid-proxy to add header "BOOM" with value "KABOOM"
    And an http client makes request to a server via liquid-proxy

  Scenario: add HTTP header
    Then that server should see header "BOOM" with value "KABOOM" in incoming requests

  Scenario: clear custom headers
    When I instruct liquid-proxy to clear custom headers
    And an http client makes request to a server via liquid-proxy
    Then that server should not see header "BOOM" in incoming requests
