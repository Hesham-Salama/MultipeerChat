//
//  MessageSender.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/24/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import MultipeerConnectivity

class MessageSender {
    
    private let companionPeer: MCPeerID
    weak var sessionDelegate: MCSessionDelegate?
    
    init(companionPeer: MCPeerID, sessionDelegate: MCSessionDelegate? = nil) {
        self.companionPeer = companionPeer
        self.sessionDelegate = sessionDelegate
    }
    
    private lazy var userAsCompanion: CompanionMP? = {
        guard let userPeer = UserMP.shared.peerID, let userID = UserMP.shared.id else { return nil }
        let userAsCompanion = CompanionMP(mcPeerID: userPeer, picture: UserMP.shared.profilePicture, id: userID)
        return userAsCompanion
    }()
    
    private var session: MCSession? {
        let session = SessionManager.shared.getMutualSession(with: companionPeer)
        session?.delegate = sessionDelegate
        return session
    }
    
    @discardableResult
    func sendSelfInfo() -> Bool {
        guard let encodedVal = try? JSONEncoder().encode(userAsCompanion) else {
            print("Error in encoding companion object")
            return false
        }
        guard let session = session else {
            print("nil session")
            return false
        }
        do {
            try session.send(encodedVal, toPeers: [companionPeer], with: .reliable)
            print("Self info has been sent")
            return true
        } catch {
            print("Error in sending message to the peer")
            print(error)
            return false
        }
    }
    
//    @discardableResult
//    func sendMessage(text: String) -> Bool {
//        let message = MultipeerFrameworkMessage(data: Data(text.utf8), contentType: .text, commuType: .user)
//        return sendMessage(message: message)
//    }
//
//    @discardableResult
//    func sendMessage(image: UIImage) -> Bool {
//        let message = MultipeerFrameworkMessage(data: image.pngData(), contentType: .image, commuType: .user)
//        return sendMessage(message: message)
//    }

    @discardableResult
    func sendMessage(message: MultipeerFrameworkMessage) -> Bool {
        do {
            guard let encodedMessage = encodeMessage(message: message) else {
                return false
            }
            guard let session = session else {
                print("nil session")
                return false
            }
            try session.send(encodedMessage, toPeers: [companionPeer], with: .reliable)
            print("Message sent")
        } catch {
            print("Error in sending the message")
            print(error)
            return false
        }
        return true
    }
    
    private func encodeMessage(message: MultipeerFrameworkMessage) -> Data? {
        return try? JSONEncoder().encode(message)
    }
}
