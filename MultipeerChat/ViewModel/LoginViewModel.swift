//
//  LoginViewModel.swift
//  MultipeerChat
//
//  Created by Hesham on 3/9/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class LoginViewModel: ObservableObject {
    
    @Published var name = ""
    @Published var isLoggedIn = false
    @Published var isErrorShown = false
    private static let minCharsCountForUserName = 3
    let errorMessage = "Please enter a valid username (no spaces and should have more than \(minCharsCountForUserName) characters)"
    
    init() {
        loginIfUserRegistered()
    }
    
    func loginIfUserRegistered() {
        guard UserMP.shared.peerID != nil else {
            return
        }
        isLoggedIn = true
    }
    
    func attemptRegisteration(image: UIImage?) {
        if isValidUser() {
            saveMCPeerLocally(image: image)
            loginIfUserRegistered()
        } else {
            isErrorShown = true
        }
    }
    
    private func saveMCPeerLocally(image: UIImage?) {
        let peerID = MCPeerID(displayName: name)
        UserMP.shared.peerID = peerID
        UserMP.shared.profilePicture = image
        UserMP.shared.id = UUID()
    }
    
    private func isValidUser() -> Bool {
        return name.count >= LoginViewModel.minCharsCountForUserName && !name.contains(" ")
    }
}
