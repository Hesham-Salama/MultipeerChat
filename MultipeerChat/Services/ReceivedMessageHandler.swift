//
//  ReceivedMessageHandler.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/24/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import MultipeerConnectivity
import UIKit

class ReceivedMessageHandler {
    
    static func handle(data: Data, from peerID: MCPeerID) {
        guard let decodedMessage = try? JSONDecoder().decode(MultipeerFrameworkMessage.self, from: data) else {
            print("Couldn't decode the message")
            return
        }
        if decodedMessage.commuType == .system, decodedMessage.contentType == .image {
            handleReceivedSystemImage(decodedMessage: decodedMessage, from: peerID)
        }
        else if decodedMessage.commuType == .user {
            handleReceivedUserMessage(decodedMessage: decodedMessage, from: peerID)
        }
    }
    
    private static func handleReceivedSystemImage(decodedMessage: MultipeerFrameworkMessage, from peerID: MCPeerID) {
        saveUserInfo(decodedMessage, peerID)
    }
    
    private static func saveUserInfo(_ decodedMessage: MultipeerFrameworkMessage, _ peerID: MCPeerID) {
        var image: UIImage?
        if let data = decodedMessage.data {
            image = UIImage(data: data)
        }
        let multipeerFriendUser = MultipeerUser(mcPeerID: peerID, picture: image)
        multipeerFriendUser.saveLocally()
        print("The new connected peer \"\(peerID.displayName)\" has been saved locally")
    }
    
    private static func handleReceivedUserMessage(decodedMessage: MultipeerFrameworkMessage, from peerID: MCPeerID) {
        guard let userPeerID = UserPeer.shared.peerID else {
            print("No user peer ID")
            return
        }
        UserMessageSaver.save(decodedMessage: decodedMessage, from: peerID, to: userPeerID)
    }
}
