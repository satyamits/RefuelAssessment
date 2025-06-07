//
//  HealthLiveView.swift
//  AssestmentWatchOS
//
//  Created by Satyam Singh on 07/06/25.
//


import SwiftUI

struct HealthLiveView: View {
    @ObservedObject var viewModel = LiveHealthDataViewModel()

        var body: some View {
            VStack(spacing: 10) {
                Text("Live Tracking")
                    .font(.headline)

                Text("❤️ \(Int(viewModel.liveHeartRate)) bpm")
                    .font(.title2)

                Text("👣 \(Int(viewModel.liveSteps)) steps")
                    .font(.title3)
            }
            .padding()
        }
}
