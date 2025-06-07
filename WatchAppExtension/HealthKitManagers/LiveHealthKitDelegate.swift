//
//  LiveHealthKitDelegate.swift
//  AssestmentWatchOS
//
//  Created by Satyam Singh on 07/06/25.
//


import HealthKit
import Foundation

protocol LiveHealthKitDelegate: AnyObject {
    func didUpdateHeartRate(_ bpm: Double)
    func didUpdateStepCount(_ steps: Double)
}

final class LiveHealthKitManager: ObservableObject {
    static let shared = LiveHealthKitManager()
    private let healthStore = HKHealthStore()
    
    private var heartRateQuery: HKAnchoredObjectQuery?
    private var stepQuery: HKAnchoredObjectQuery?
    
    weak var delegate: LiveHealthKitDelegate?
    private var mockTimer: Timer?
    
    private init() {}
    
    // MARK: - Start Tracking
    func startLiveTracking() {
#if targetEnvironment(simulator)
        startSimulatedTracking()
#else
        startHeartRateQuery()
        startStepCountQuery()
#endif
    }

    func stopTracking() {
        if let heartRateQuery = heartRateQuery {
            healthStore.stop(heartRateQuery)
            self.heartRateQuery = nil
        }

        if let stepQuery = stepQuery {
            healthStore.stop(stepQuery)
            self.stepQuery = nil
        }

        mockTimer?.invalidate()
        mockTimer = nil
    }


#if targetEnvironment(simulator)
    // MARK: - Simulator Mode
    private func startSimulatedTracking() {
        var simulatedSteps: Double = 0

        mockTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            let randomBPM = Double(Int.random(in: 60...120))
            let randomSteps = Double(Int.random(in: 2...10))
            simulatedSteps += randomSteps

            DispatchQueue.main.async {
                self?.delegate?.didUpdateHeartRate(randomBPM)
                self?.delegate?.didUpdateStepCount(simulatedSteps)
            }
        }
    }
#endif

    // MARK: - Real Heart Rate Query
    private func startHeartRateQuery() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }
        let start = Date().addingTimeInterval(-60)
        let predicate = HKQuery.predicateForSamples(withStart: start, end: nil)

        let query = HKAnchoredObjectQuery(type: type, predicate: predicate, anchor: nil, limit: HKObjectQueryNoLimit) { _, _, _, _, _ in }
        query.updateHandler = { [weak self] _, samples, _, _, _ in
            guard let quantitySamples = samples as? [HKQuantitySample],
                  let latest = quantitySamples.last else { return }

            let bpm = latest.quantity.doubleValue(for: .init(from: "count/min"))
            DispatchQueue.main.async {
                self?.delegate?.didUpdateHeartRate(bpm)
            }
        }

        self.heartRateQuery = query
        healthStore.execute(query)
    }

    // MARK: - Real Step Count Query
    private func startStepCountQuery() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let start = Date().addingTimeInterval(-60)
        let predicate = HKQuery.predicateForSamples(withStart: start, end: nil)

        let query = HKAnchoredObjectQuery(type: type, predicate: predicate, anchor: nil, limit: HKObjectQueryNoLimit) { _, _, _, _, _ in }
        query.updateHandler = { [weak self] _, samples, _, _, _ in
            guard let quantitySamples = samples as? [HKQuantitySample] else { return }

            let steps = quantitySamples.reduce(0.0) {
                $0 + $1.quantity.doubleValue(for: .count())
            }

            DispatchQueue.main.async {
                self?.delegate?.didUpdateStepCount(steps)
            }
        }

        self.stepQuery = query
        healthStore.execute(query)
    }

    // MARK: - Permissions
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
#if targetEnvironment(simulator)
        completion(true, nil)
#else
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, nil)
            return
        }

        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!
        ]

        healthStore.requestAuthorization(toShare: [], read: readTypes) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
#endif
    }
}
