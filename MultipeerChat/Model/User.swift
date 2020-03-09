//
//  User.swift
//  MultipeerChat
//
//  Created by Hesham on 3/9/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import UIKit
import MultipeerConnectivity

struct User: Identifiable {
    var id = MCPeerID(displayName: UIDevice.current.name)
    var name: String
    var picture: UIImage?
    
    init() {
        name = ""
    }
}
