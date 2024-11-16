//
//  Untitled.swift
//  Pumped
//
//  Created by Alok Sahay on 16.11.2024.
//

import Foundation
import UIKit

class HeartRateViewModel: ObservableObject {
    @Published var currentHeartRate: Int = 70
    @Published var isUploading = false
    private var heartRates: [HeartRate] = []
    private var timer: Timer?
    private var uploadTimer: Timer?
    
    func startSimulation() {
        // Generate heart rate every second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.generateHeartRate()
        }
        
        // Upload every 10 seconds
        uploadTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.uploadData()
        }
    }
    
    func stopSimulation() {
        timer?.invalidate()
        uploadTimer?.invalidate()
        timer = nil
        uploadTimer = nil
    }
    
    private func generateHeartRate() {
        // Simulate heart rate between 60-100 BPM
        currentHeartRate = Int.random(in: 60...100)
        heartRates.append(HeartRate(bpm: currentHeartRate))
    }
    
    private func uploadData() {
        guard !heartRates.isEmpty else { return }
        
        let payload = HeartRatePayload(
            heartRates: heartRates,
            deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "simulator",
            timestamp: ISO8601DateFormatter().string(from: Date())
        )
        
        // Clear the array after creating payload
        heartRates.removeAll()
        
        Task {
            do {
                isUploading = true
                try await uploadToAkave(payload)
                print("✅ Upload successful")
            } catch {
                print("❌ Upload failed: \(error.localizedDescription)")
            }
            isUploading = false
        }
    }
    
    private func uploadToAkave(_ payload: HeartRatePayload) async throws {
        guard let url = URL(string: "http://localhost:3000/upload") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(payload)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
}
