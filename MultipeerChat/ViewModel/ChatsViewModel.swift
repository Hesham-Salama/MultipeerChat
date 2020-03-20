//
//  ChatsViewModel.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/14/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI
import MultipeerConnectivity

class ChatsViewModel: ObservableObject {
    @Published var peers = [MultipeerUser]()
    let session : Session
    
    init() {
        guard let peerID = UserPeer.shared.peerID else {
            fatalError("User must have been logged in!")
        }
        session = Session(peerID: peerID, serviceType: MultipeerConstants.serviceType)
    }
}
