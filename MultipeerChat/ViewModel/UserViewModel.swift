//
//  UserViewModel.swift
//  MultipeerChat
//
//  Created by Hesham on 3/9/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class UserViewModel: ObservableObject {
    
    private var user: MultipeerUser
    @Published var name = ""
    @Published var image : UIImage?
    @Published var isLoggedIn = false
    
    init(user: MultipeerUser) {
        self.user = user
        _ = attemptLogin()
    }
    
    func attemptLogin() -> Bool {
        setUser()
        isLoggedIn = isValidUser()
        return isLoggedIn
    }
    
    func setUser() {
        user.name = name
        user.image = image
        if isValidUser() {
            user.id = MCPeerID(displayName: name)
        }
    }
    
    func logOut() {
        user.name = ""
        user.image = nil
        user.id = nil
        isLoggedIn = false
    }
    
    private func isValidUser() -> Bool {
        return user.name.count >= 4 && !user.name.contains(" ")
    }
}
