//
//  PhoneSyncManageer.swift
//  AssestmentWatchOS
//
//  Created by Satyam Singh on 07/06/25.
//

import Foundation
import WatchConnectivity
import SwiftData

class PhoneSyncManageer: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = PhoneSyncManageer()

    @Published var receivedHeartRate: Double = 0
    @Published var receivedSteps: Double = 0
    private var context: ModelContext?

    private override init() {
        super.init()
        activateSession()
    }

    func activateSession() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func setContext(_ context: ModelContext) {
        self.context = context
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let data = message["health_data"] as? Data {
            do {
                let model = try JSONDecoder().decode(Health.self, from: data)
                DispatchQueue.main.async {
                    self.receivedHeartRate = model.heartRate
                    self.receivedSteps = model.stepsCount
                    if let ctx = self.context {
                        let newSession = HealthSession(heartRate: model.heartRate, stepsCount: model.stepsCount)
                        ctx.insert(newSession)
                        do {
                            try ctx.save()
                        } catch {
                            print("Save failed: \(error)")
                        }
                    }
                }
            } catch {
                print("Decoding failed: \(error)")
            }
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}

