//
//  UserMessageSaver.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 6/5/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import MultipeerConnectivity

class UserMessageSaver {
    
    static func messageSent(from companionPeer: CompanionMP, decodedMessage: MultipeerFrameworkMessage) {
        guard let userID = UserMP.shared.id else {
            return
        }
        save(from: companionPeer.id, to: userID, decodedMessage: decodedMessage)
    }
    
    static func messageSent(to companionPeer: CompanionMP, decodedMessage: MultipeerFrameworkMessage) {
        guard let userID = UserMP.shared.id else {
            return
        }
        save(from: userID, to: companionPeer.id, decodedMessage: decodedMessage)
    }
    
    private static func save(from peer1ID: UUID, to peer2ID: UUID, decodedMessage: MultipeerFrameworkMessage) {
        guard let messageData = decodedMessage.data else {
            print("nil message data")
            return
        }
        let currentTime = Date().timeIntervalSince1970
        let userMessage = MPMessage(data: messageData, unixTime: currentTime, senderPeerID: peer1ID, receiverPeerID: peer2ID, id: UUID())
        DispatchQueue.main.async {
            userMessage.saveLocally()
        }
    }
}
