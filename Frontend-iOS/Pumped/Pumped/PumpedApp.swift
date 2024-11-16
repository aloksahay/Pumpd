//
//  PumpedApp.swift
//  Pumped
//
//  Created by Alok Sahay on 16.11.2024.
//

import SwiftUI

struct PumpedApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(vm: ViewModel())
        }
    }
}

