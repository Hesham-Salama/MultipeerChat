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
    
    init() {
        MultipeerUser.delegate = self
    }
    
    func updatePeers() {
        peers = MultipeerUser.getAll().filter { $0.mcPeerID != UserPeer.shared.peerID }
        print(peers)
    }
}

extension ChatsViewModel: PeerAdded {
    func added(peer: MultipeerUser) {
        DispatchQueue.main.async { [weak self] in
            self?.peers.append(peer)
        }
    }
}
