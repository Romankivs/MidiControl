//
//  MidiControlUITests.swift
//  MidiControlUITests
//
//  Created by Sviatoslav Romankiv on 23.12.2023.
//

import XCTest

extension XCUIElement {
    var hasFocus: Bool { value(forKey: "hasKeyboardFocus") as? Bool ?? false }
}

extension XCTestCase {
    func waitUntilElementHasFocus(element: XCUIElement, timeout: TimeInterval = 600, file: StaticString = #file, line: UInt = #line) -> XCUIElement {
        let expectation = expectation(description: "waiting for element \(element) to have focus")

        let timer = Timer(timeInterval: 1, repeats: true) { timer in
            guard element.hasFocus else { return }

            expectation.fulfill()
            timer.invalidate()
        }

        RunLoop.current.add(timer, forMode: .common)

        wait(for: [expectation], timeout: timeout)

        return element
    }
}

final class MidiControlUITests: XCTestCase {
    // UI tests must launch the application that they test.
    let app = XCUIApplication()

    let midiSetupApp = XCUIApplication(bundleIdentifier: "com.apple.audio.AudioMIDISetup")

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTabsArePresent() throws {
        XCTAssertTrue(app.tabs["Note On"].exists)
        XCTAssertTrue(app.tabs["Note Off"].exists)
        XCTAssertTrue(app.tabs["Control Change"].exists)
        XCTAssertTrue(app.tabs["Program Change"].exists)
        XCTAssertTrue(app.tabs["Channel Pressure"].exists)
        XCTAssertTrue(app.tabs["Poly Pressure"].exists)
        XCTAssertTrue(app.tabs["Pitch Bend"].exists)
    }

    func testMidiSourcesAddedAndRemoved() throws {
        midiSetupApp.terminate()
        midiSetupApp.launch()

        let iacDriver = midiSetupApp.images["IAC Driver (Online)"]
        XCTAssertTrue(iacDriver.exists)

        iacDriver.doubleClick()

        let windowProperties = midiSetupApp.windows["IAC Driver Properties"]
        XCTAssertTrue(windowProperties.waitForExistence(timeout: 5))

        let addPort = windowProperties.buttons["Add Port"]
        XCTAssertTrue(addPort.exists)

        let removePort = windowProperties.buttons["Remove Port"]
        XCTAssertTrue(removePort.exists)

        let portsTable = windowProperties.tables.firstMatch
        XCTAssertTrue(portsTable.exists)

        let numberOfCheckBoxesBefore = app.checkBoxes.count

        let numberOfRows = portsTable.tableRows.count
        addPort.click()
        XCTAssertTrue(portsTable.tableRows.count > numberOfRows)

        let createdRow = portsTable.tableRows.element(boundBy: portsTable.tableRows.count - 1)
        XCTAssertTrue(createdRow.exists)

        let editor = createdRow.textFields.firstMatch
        XCTAssertTrue(editor.exists)
        let newBusName = editor.value as! String

        XCTAssertTrue(app.checkBoxes["IAC Driver \(newBusName) (MIDI 2.0)"].waitForExistence(timeout: 5))
        XCTAssert(app.checkBoxes.count == numberOfCheckBoxesBefore + 1)

        removePort.click()

        sleep(2) // Wait for checkbox to disappear

        XCTAssert(app.checkBoxes.count == numberOfCheckBoxesBefore)
        XCTAssertFalse(app.checkBoxes["IAC Driver \(newBusName) (MIDI 2.0)"].exists)

        midiSetupApp.terminate()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
