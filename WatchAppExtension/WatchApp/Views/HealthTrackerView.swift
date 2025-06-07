//
//  HealthTrackerView.swift
//  WatchAppExtension Watch App
//
//  Created by Satyam Singh on 07/06/25.
//

import Foundation
import SwiftUI

struct HealthTrackerView: View {
    
    @StateObject private var viewModel = LiveHealthDataViewModel()

    var body: some View {
        VStack(spacing: 8) {
            
            Text("Session start")
            if !self.viewModel.isSessionStarted {
                Button {
                    self.viewModel.startTracking()
                } label: {
                    Text("Start Session")
                }
                
            } else {
                Button {
                    
                    let model = Health(heartRate: self.viewModel.liveHeartRate, stepsCount: self.viewModel.liveSteps)
                    
                    WatchAppSyncManagers.shared.sendDateToiOS(model: model)
                    self.viewModel.stopTracking()
                } label: {
                    Text("Stop Session")
                }
            }
            
            HStack {
                HStack {
                    Image(systemName: "heart")
                    Text("\(Int(viewModel.liveHeartRate)) bpm")
                }
                
                Spacer()
                
                HStack {
                    Image(systemName: "sparkle")
                    Text("\(Int(viewModel.liveSteps))")
                }
            }
        }
        .padding()
    }
}


#Preview {
    HealthTrackerView()
}
