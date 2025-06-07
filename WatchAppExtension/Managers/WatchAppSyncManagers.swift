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
        guard let dataToSend = try? JSONEncoder().encode(model) else { return }
        if self.session.isReachable {
            WCSession.default.sendMessage(["recordData" : dataToSend], replyHandler: nil)
        } else {
            WCSession.default.transferUserInfo(["recordData" : dataToSend])
        }
    }
}

extension WatchAppSyncManagers: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
    }
    
    
}
