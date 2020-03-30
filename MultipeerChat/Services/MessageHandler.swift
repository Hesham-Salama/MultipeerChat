//
//  MessageHandler.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/24/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import MultipeerConnectivity
import UIKit

class MessageHandler {
    
    @discardableResult
    static func handleReceivedSystemImage(data: Data, from peerID: MCPeerID) -> Bool {
        guard let decodedMessage = try? JSONDecoder().decode(Message.self, from: data) else {
            print("Couldn't decode the message")
            return false
        }
        guard decodedMessage.commuType == .system else {
            print("Message communication type is not system, discarding message")
            return false
        }
        guard decodedMessage.contentType == .image else {
            print("Only profile picture is allowed at this time here.")
            return false
        }
        saveUserLocally(decodedMessage, peerID)
        return true
    }
    
    private static func saveUserLocally(_ decodedMessage: Message, _ peerID: MCPeerID) {
        var image: UIImage?
        if let data = decodedMessage.data {
            image = UIImage(data: data)
        }
        let multipeerFriendUser = MultipeerUser(mcPeerID: peerID, picture: image)
        multipeerFriendUser.saveLocally()
        print("The new connected peer \"\(peerID.displayName)\" has been saved locally")
    }
    
    static func handleReceivedUserMessage(data: Data, from peerID: MCPeerID) -> UserMessage? {
        guard let userPeerID = UserPeer.shared.peerID else {
            return nil
        }
        return saveMessageLocally(data: data, from: peerID, to: userPeerID)
    }
    
    static func handleSentUserMessage(data: Data, to peerID: MCPeerID) {
        guard let userPeerID = UserPeer.shared.peerID else {
            return
        }
        saveMessageLocally(data: data, from: userPeerID, to: peerID)
    }
    
    @discardableResult
    private static func saveMessageLocally(data: Data, from peerID: MCPeerID, to peerID2: MCPeerID) -> UserMessage? {
        guard let decodedMessage = try? JSONDecoder().decode(Message.self, from: data) else {
            print("Couldn't decode the message")
            return nil
        }
        guard decodedMessage.commuType == .user else {
            print("This is not a user type message")
            return nil
        }
        guard let messageData = decodedMessage.data else {
            print("nil message data")
            return nil
        }
        let currentTime = Date().timeIntervalSince1970
        let userMessage = UserMessage(data: messageData, unixTime: currentTime, senderPeerID: peerID, receiverPeerID: peerID2, id: UUID())
        userMessage.saveLocally()
        return userMessage
    }
}
