//
//  HealthTrackerViewModel.swift
//  WatchAppExtension Watch App
//
//  Created by Satyam Singh on 07/06/25.
//

import Foundation
import SwiftUI

class LiveHealthDataViewModel: ObservableObject, LiveHealthKitDelegate {
    @Published var liveHeartRate: Double = 0
    @Published var liveSteps: Double = 0
    @Published var isSessionStarted: Bool = false

    init() {
        LiveHealthKitManager.shared.delegate = self
    }

    func startTracking() {
        LiveHealthKitManager.shared.requestAuthorization { success, _ in
            if success {
                self.isSessionStarted = true
                LiveHealthKitManager.shared.startLiveTracking()
            }
        }
    }

    // Delegate Methods
    func didUpdateHeartRate(_ bpm: Double) {
        liveHeartRate = bpm
    }

    func didUpdateStepCount(_ steps: Double) {
        liveSteps = steps
    }

    func stopTracking() {
        self.isSessionStarted = false
        self.liveSteps = 0
        self.liveHeartRate = 0
        LiveHealthKitManager.shared.stopTracking()
    }
}

