//
//  UserViewModel.swift
//  MultipeerChat
//
//  Created by Hesham on 3/9/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import UIKit

class UserViewModel: ObservableObject {
    
    private var user: User
    @Published var name = ""
    @Published var image : UIImage?
    @Published var isLoggedIn = false
    
    init(user: User) {
        self.user = user
    }
    
    func setUser() -> Bool {
        guard name.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            return false
        }
        user.name = name
        user.picture = image
        isLoggedIn = true
        return true
    }
    
    func logOut() {
        isLoggedIn = false
        user.name = ""
        user.picture = nil
    }
}
