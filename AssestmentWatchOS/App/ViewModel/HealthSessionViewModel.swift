//
//  HealthSessionViewModel.swift
//  AssestmentWatchOS
//
//  Created by Satyam Singh on 07/06/25.
//


import SwiftUI
import SwiftData

@Observable
class HealthSessionViewModel {
    var sessions: [HealthSession] = []

    func fetchSessions(context: ModelContext) {
        let descriptor = FetchDescriptor<HealthSession>(sortBy: [.init(\.timestamp, order: .reverse)])
        do {
            sessions = try context.fetch(descriptor)
        } catch {
            print("Fetch failed: \(error)")
        }
    }
}