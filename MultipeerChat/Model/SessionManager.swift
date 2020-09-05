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
        guard let peerID = UserMP.shared.peerID else {
            fatalError("No PeerID?")
        }
        if let session = sessions.first(where: {
            $0.connectedPeers.isEmpty || ($0.connectedPeers.count == 1 && $0.connectedPeers.first == peerID)
        }) {
            return session
        } else {
            let session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
            sessions.append(session)
            return session
        }
    }
    
    func getMutualSession(with peerID: MCPeerID) -> MCSession? {
        let session = sessions.first {
            $0.connectedPeers.contains(peerID)
        }
        return session
    }
    
    func removeAllSessions() {
        sessions.forEach { (session) in
            session.delegate = nil
        }
        sessions = []
    }
}
