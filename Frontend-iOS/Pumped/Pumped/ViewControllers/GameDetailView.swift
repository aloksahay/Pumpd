//
//  GameDetailView.swift
//  Pumped
//
//  Created by Alok Sahay on 16.11.2024.
//

import SwiftUI

struct GameDetailView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to the Home Screen")
                    .font(.largeTitle)
                    .padding()

                // Button to push to a new view
                NavigationLink(destination: DetailView()) {
                    Text("Go to Detail View")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}

struct DetailView: View {
    var body: some View {
        VStack {
            Text("This is the Detail View")
                .font(.title)
                .padding()

            // Optional back button
            Text("Swipe from the left or press Back to return")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
