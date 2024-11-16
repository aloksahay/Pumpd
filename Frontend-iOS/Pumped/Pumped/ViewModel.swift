//
//  ViewModel.swift
//  Pumped
//
//  Created by Alok Sahay on 16.11.2024.
//

import Foundation
import Web3Auth

class ViewModel: ObservableObject {
    var web3Auth: Web3Auth?
    @Published var loggedIn: Bool = false
    @Published var user: Web3AuthState?
    @Published var isLoading = false
    @Published var navigationTitle: String = ""
    private var clientId = "BPdWoOWu8Nk743CSr1vaqcY0edE0Rh2VJtDX9b8CT_0FQZyNpMILG2ZUP1cTo4Vw9By51iTdzOUV945Mb6q6fdg"
    // IMP START - Whitelist bundle ID
    private var network: Network = .sapphire_devnet
    func setup() async {
        guard web3Auth == nil else { return }
        await MainActor.run(body: {
            isLoading = true
            navigationTitle = "Loading"
        })
        
        do {
            web3Auth = try await Web3Auth(W3AInitParams(
                clientId: clientId,
                network: network,
                redirectUrl: "com.alok.Pumped://auth"
            ))
        } catch {
            print(error.localizedDescription)
        }
        await MainActor.run(body: {
            if self.web3Auth?.state != nil {
                user = web3Auth?.state
                loggedIn = true
            }
            isLoading = false
            navigationTitle = loggedIn ? "UserInfo" : "SignIn"
        })
    }
    
    func login(provider: Web3AuthProvider) {
        Task {
            do {
                let result = try await web3Auth?.login(
                    W3ALoginParams(loginProvider: provider)
                )
                await MainActor.run(body: {
                    user = result
                    loggedIn = true
                })
                
            } catch {
                print("Error")
            }
        }
    }
    
    func logout() throws {
        Task {
            try await web3Auth?.logout()
            await MainActor.run(body: {
                loggedIn = false
            })
        }
    }
    
    func loginEmailPasswordless(provider: Web3AuthProvider, email: String) {
        Task {
            do {
                let result = try await web3Auth?.login(W3ALoginParams(loginProvider: provider, extraLoginOptions: ExtraLoginOptions(display: nil, prompt: nil, max_age: nil, ui_locales: nil, id_token_hint: nil, id_token: nil, login_hint: email, acr_values: nil, scope: nil, audience: nil, connection: nil, domain: nil, client_id: nil, redirect_uri: nil, leeway: nil, verifierIdField: nil, isVerifierIdCaseSensitive: nil, additionalParams: nil)))
                await MainActor.run(body: {
                    user = result
                    loggedIn = true
                    navigationTitle = "UserInfo"
                })
                
            } catch {
                print("Error")
            }
        }
    }
}
