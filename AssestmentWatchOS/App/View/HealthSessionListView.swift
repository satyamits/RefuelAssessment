//
//  HealthSessionListView.swift
//  AssestmentWatchOS
//
//  Created by Satyam Singh on 07/06/25.
//

import Foundation
import SwiftUI
import SwiftData

struct HealthSessionListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \HealthSession.timestamp, order: .reverse) var sessions: [HealthSession]

    var body: some View {
        VStack {
            Text("Past Sessions")
                .font(.title2)

            List(sessions, id: \.id) { session in
                VStack(alignment: .leading) {
                    Text("❤️ \(Int(session.heartRate)) bpm, 👣 \(Int(session.stepsCount)) steps")
                    Text("🕒 \(session.timestamp.formatted())")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .onAppear {
            PhoneSyncManageer.shared.setContext(context)
        }
    }
}

