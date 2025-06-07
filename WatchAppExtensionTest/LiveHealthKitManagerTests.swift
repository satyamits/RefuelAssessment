//
//  LiveHealthKitManagerTests.swift
//  AssestmentWatchOS
//
//  Created by Satyam Singh on 07/06/25.
//


import XCTest
@testable import WatchAppExtension

final class LiveHealthKitManagerTests: XCTestCase {

    // MARK: - Mock Delegate
    final class MockDelegate: LiveHealthKitDelegate {
        var receivedHeartRates: [Double] = []
        var receivedStepCounts: [Double] = []
        var expectation: XCTestExpectation?

        func didUpdateHeartRate(_ bpm: Double) {
            receivedHeartRates.append(bpm)
            expectation?.fulfill()
        }

        func didUpdateStepCount(_ steps: Double) {
            receivedStepCounts.append(steps)
        }
    }

    func testSimulatedHeartRateAndSteps_onSimulator() {
        #if targetEnvironment(simulator)
        let mockDelegate = MockDelegate()
        let expectation = self.expectation(description: "Wait for simulated health updates")
        expectation.expectedFulfillmentCount = 1
        mockDelegate.expectation = expectation

        let manager = LiveHealthKitManager.shared
        manager.delegate = mockDelegate
        manager.startLiveTracking()

        wait(for: [expectation], timeout: 5.0)

        XCTAssertFalse(mockDelegate.receivedHeartRates.isEmpty, "Should receive at least one heart rate")
        XCTAssertFalse(mockDelegate.receivedStepCounts.isEmpty, "Should receive at least one step count")

        manager.stopTracking()
        #else
        print("Skipping test on real device")
        #endif
    }
}
