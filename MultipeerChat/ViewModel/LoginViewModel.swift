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
    @Published var image : UIImage?
    @Published var isLoggedIn = false
    @Published var isErrorShown = false
    let errorMessage = "Please enter a valid username (no spaces and should have more than 3 characters)"
    
    init() {
        loginIfUserRegistered()
    }
    
    func loginIfUserRegistered() {
        guard let mcPeerID = UserPeer.shared.peerID else {
            return
        }
        guard (MultipeerUser.getAll().filter { $0.mcPeerID.hashValue == mcPeerID.hashValue }.first) != nil else {
            return
        }
        isLoggedIn = true
    }
    
    func attemptRegisteration() {
        if isValidUser() {
            saveMCPeerLocally()
            loginIfUserRegistered()
        } else {
            isErrorShown = true
        }
    }
    
    private func saveMCPeerLocally() {
        let peerID = MCPeerID(displayName: name)
        UserPeer.shared.peerID = peerID
        let mPeerUser = MultipeerUser(mcPeerID: peerID, picture: image)
        mPeerUser.saveLocally()
    }
    
    private func isValidUser() -> Bool {
        return name.count >= 4 && !name.contains(" ")
    }
}
