//
//  SessionManager.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/22/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import MultipeerConnectivity

class SessionManager: NSObject {
    
    static let shared = SessionManager()
    private var sessions = [MCSession]()
    
    private override init() {}
    
    var newSession: MCSession {
        guard let peerID = UserPeer.shared.peerID else {
            fatalError("No PeerID?")
        }
        let session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        sessions.append(session)
        return session
    }
    
    func getMutualSession(with peerID: MCPeerID) -> MCSession? {
        let session = sessions.filter { $0.connectedPeers.contains(peerID)}.first
        return session
    }
}
