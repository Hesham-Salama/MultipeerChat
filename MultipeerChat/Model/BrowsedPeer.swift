//
//  BrowsedPeer.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/22/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import MultipeerConnectivity

struct BrowsedPeer: Identifiable {
    let peerID: MCPeerID
    var status: PeerStatus
    
    var id: Int {
        return peerID.hashValue + status.rawValue
    }
}
