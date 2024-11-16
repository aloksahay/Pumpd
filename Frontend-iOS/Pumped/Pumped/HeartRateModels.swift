//
//  Untitled.swift
//  Pumped
//
//  Created by Alok Sahay on 16.11.2024.
//

import Foundation

struct HeartRate: Codable {
    let timestamp: String
    let bpm: Int
    
    init(bpm: Int) {
        self.timestamp = ISO8601DateFormatter().string(from: Date())
        self.bpm = bpm
    }
}

struct HeartRatePayload: Codable {
    let heartRates: [HeartRate]
    let deviceId: String
    let timestamp: String
}
