//
//  UserDataRemoval.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 7/17/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import Foundation

class UserDataRemoval {
    
    static func remove() {
        CompanionMP.removeAll()
        MPMessage.removeAll()
        UserMP.shared.peerID = nil
        SessionManager.shared.removeAllSessions()
    }
}
