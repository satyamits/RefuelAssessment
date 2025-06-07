//
//  WatchAppSyncManagers.swift
//  WatchAppExtension Watch App
//
//  Created by Satyam Singh on 07/06/25.
//

import Foundation
import WatchConnectivity
class WatchAppSyncManagers: NSObject, ObservableObject {
    
    static let shared = WatchAppSyncManagers()

    var session: WCSession
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        self.session.activate()
    }
    
    func sendDateToiOS(model: Health) {
            guard WCSession.default.isReachable else {
                print("iPhone not reachable")
                return
            }
            do {
                let data = try JSONEncoder().encode(model)
                let dictionary: [String: Any] = ["health_data": data]
                WCSession.default.sendMessage(dictionary, replyHandler: nil, errorHandler: { error in
                    print("Send error: \(error.localizedDescription)")
                })
            } catch {
                print("Encoding failed: \(error)")
            }
        }
}

extension WatchAppSyncManagers: WCSessionDelegate {
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
    }
    
    
}
