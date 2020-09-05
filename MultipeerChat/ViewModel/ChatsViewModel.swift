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
    @Published var peers = [CompanionMP]()
    
    init() {
        CompanionMP.delegate = self
    }
    
    func updatePeers() {
        peers = CompanionMP.getAll().filter { $0.mcPeerID != UserMP.shared.peerID }
        print(peers)
    }
}

extension ChatsViewModel: PeerAdded {
    func added(peer: CompanionMP) {
        DispatchQueue.main.async { [weak self] in
            self?.peers.append(peer)
        }
    }
}
