import XCTest

final class IOS_Weather_AppUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testGreetingHeaderIsVisible() {
        XCTAssertTrue(
            app.staticTexts["greetingHeader.greetingText"]
            .waitForExistence(timeout: 5)
        )
    }

    func testGreetingTextIsDisplayed() {
        let greeting = app.staticTexts["greetingHeader.greetingText"]

        XCTAssertTrue(
            greeting.waitForExistence(timeout: 5)
        )
        XCTAssertEqual(
            greeting.label, "Good Evening, Angus"
        )
    }

    func testCityAndConditionAreDisplayed() {
        let location = app.staticTexts["greetingHeader.LocationConditionText"]

        XCTAssertTrue(
            location.waitForExistence(timeout: 5)
        )
        XCTAssertEqual(
            location.label, "Glasgow • Raining"
        )
    }

    // boo
    
    func testSearchButtonWorks() {
        let searchButton = app.buttons["greetingHeader.searchButton"]

        XCTAssertTrue(
            searchButton.waitForExistence(timeout: 5)
            )
        XCTAssertTrue(
            searchButton.isHittable
            )

        searchButton.tap()

        XCTAssertTrue(
            app.staticTexts["searchTappedMessage"]
                .waitForExistence(timeout: 2)
        )
    }

    func testRefreshButtonWorks() {
        let refreshButton = app.buttons["greetingHeader.refreshButton"]

        XCTAssertTrue(
            refreshButton.waitForExistence(timeout: 5)
        )
        XCTAssertTrue(
            refreshButton.isHittable
        )

        refreshButton.tap()

        XCTAssertTrue(
            app.staticTexts["refreshTappedMessage"]
                .waitForExistence(timeout: 2)
        )
    }

    func testHelpButtonWorks() {
        let helpButton = app.buttons["greetingHeader.helpButton"]

        XCTAssertTrue(
            helpButton.waitForExistence(timeout: 5)
        )
        XCTAssertTrue(
            helpButton.isHittable
        )

        helpButton.tap()

        XCTAssertTrue(
            app.staticTexts["helpTappedMessage"]
                .waitForExistence(timeout: 2)
        )
    }

    func testButtonsHaveAccessibleLabels() {
        XCTAssertEqual(
            app.buttons["greetingHeader.searchButton"].label,
            "Search for a city"
        )

        XCTAssertEqual(
            app.buttons["greetingHeader.refreshButton"].label,
            "Refresh weather"
        )

        XCTAssertEqual(
            app.buttons["greetingHeader.helpButton"].label,
            "Weather colour key"
        )
    }
}