//
//  DashboardView.swift
//  Pumped
//
//  Created by Alok Sahay on 16.11.2024.
//

import SwiftUI
import Web3Auth

struct Game: Identifiable {
    let id = UUID()
    let homeTeam: String
    let awayTeam: String
    let date: Date
    let homeTeamLogo: String
    let awayTeamLogo: String
}

struct DashboardView: View {
    
    var user: Web3AuthState?
    
    let games: [Game] = [
        Game(homeTeam: "Liverpool", awayTeam: "Manchester United", date: Date().addingTimeInterval(86400), homeTeamLogo: "liverpool", awayTeamLogo: "manchester_united"),
        Game(homeTeam: "Barcelona", awayTeam: "Real Madrid", date: Date().addingTimeInterval(172800), homeTeamLogo: "barcelona", awayTeamLogo: "real_madrid"),
        Game(homeTeam: "Bayern Munich", awayTeam: "Borussia Dortmund", date: Date().addingTimeInterval(259200), homeTeamLogo: "bayern", awayTeamLogo: "dortmund"),
        Game(homeTeam: "PSG", awayTeam: "Marseille", date: Date().addingTimeInterval(345600), homeTeamLogo: "psg", awayTeamLogo: "marseille"),
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(games) { game in
                    GameRow(game: game)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Upcoming Games")
            .navigationBarItems(trailing: Button(action: {
                // Add action for refresh button
            }) {
                Image(systemName: "arrow.clockwise")
            })
        }
    }
}

struct GameRow: View {
    let game: Game
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(game.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 12) {
                    TeamLogo(logoName: game.homeTeamLogo)
                    Text(game.homeTeam)
                        .font(.headline)
                    Text("vs")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(game.awayTeam)
                        .font(.headline)
                    TeamLogo(logoName: game.awayTeamLogo)
                }
            }
            
            Spacer()
            
            Text(game.date, style: .time)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

struct TeamLogo: View {
    let logoName: String
    
    var body: some View {
        Image(logoName)
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(user: nil)
    }
}
