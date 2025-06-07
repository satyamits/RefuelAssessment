//
//  LiveHealthDataViewModel.swift
//  AssestmentWatchOS
//
//  Created by Satyam Singh on 07/06/25.
//


import Foundation
import Combine

final class LiveHealthDataViewModel: ObservableObject {
    @Published var liveHeartRate: Double = 0
    @Published var liveSteps: Double = 0
    private var cancellables = Set<AnyCancellable>()

    init() {
        PhoneSyncManageer.shared.$receivedHeartRate
            .receive(on: RunLoop.main)
            .assign(to: \LiveHealthDataViewModel.liveHeartRate, on: self)
            .store(in: &cancellables)

        PhoneSyncManageer.shared.$receivedSteps
            .receive(on: RunLoop.main)
            .assign(to: \LiveHealthDataViewModel.liveSteps, on: self)
            .store(in: &cancellables)
    }
}

