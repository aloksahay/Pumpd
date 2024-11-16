//
//  HeartRateMeasureView.swift
//  Pumped
//
//  Created by Alok Sahay on 16.11.2024.
//

import SwiftUICore
import SwiftUI

struct HeartRateMeasureView: View {
    @StateObject private var viewModel = HeartRateViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Heart Rate Monitor")
                .font(.title)
            
            Text("\(viewModel.currentHeartRate) BPM")
                .font(.system(size: 48, weight: .bold))
            
            // Animated heart
            Image(systemName: "heart.fill")
                .foregroundColor(.red)
                .font(.system(size: 64))
                .scaleEffect(1.0)
                .animation(
                    .easeInOut(duration: 60.0 / Double(max(viewModel.currentHeartRate, 60)))
                    .repeatForever(autoreverses: true),
                    value: viewModel.currentHeartRate
                )
            
            if viewModel.isUploading {
                ProgressView("Uploading...")
            }
        }
        .padding()
        .onAppear {
            viewModel.startSimulation()
        }
        .onDisappear {
            viewModel.stopSimulation()
        }
    }
}
