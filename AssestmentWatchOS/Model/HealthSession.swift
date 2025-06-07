//
//  HealthSession.swift
//  AssestmentWatchOS
//
//  Created by Satyam Singh on 07/06/25.
//


import Foundation
import SwiftData

@Model
class HealthSession {
    @Attribute(.unique) var id: UUID
    var heartRate: Double
    var stepsCount: Double
    var timestamp: Date

    init(heartRate: Double, stepsCount: Double, timestamp: Date = .now) {
        self.id = UUID()
        self.heartRate = heartRate
        self.stepsCount = stepsCount
        self.timestamp = timestamp
    }
}
