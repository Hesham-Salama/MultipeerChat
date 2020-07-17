//
//  MoreViewModel.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 7/12/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

class MoreViewModel {
    var logoutMessage = "Do you want to logout? This will clear all your data."
    let options = ["Logout", "About"]
    
    func removeDataRequested(loginVM: LoginViewModel) {
        UserDataRemoval.remove()
        loginVM.isLoggedIn = false
    }
}
