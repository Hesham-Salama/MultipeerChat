//
//  UserMessageSaver.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 6/5/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import MultipeerConnectivity

class UserMessageSaver {
    
    static func save(decodedMessage: MultipeerFrameworkMessage, from peerID: MCPeerID, to peerID2: MCPeerID) {
        guard let messageData = decodedMessage.data else {
            print("nil message data")
            return
        }
        let currentTime = Date().timeIntervalSince1970
        let userMessage = UserMessage(data: messageData, unixTime: currentTime, senderPeerID: peerID, receiverPeerID: peerID2, id: UUID())
        DispatchQueue.main.async {
            userMessage.saveLocally()
        }
//        print("The message has been saved locally")
    }
}
