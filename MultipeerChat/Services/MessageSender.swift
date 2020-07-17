//
//  MessageSender.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/24/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import MultipeerConnectivity

class MessageSender {
    
    let session: MCSession
    
    init(session: MCSession) {
        self.session = session
    }
    
    func sendProfilePicture(image: UIImage?) {
        let message = MultipeerFrameworkMessage(data: image?.pngData(), contentType: .image, commuType: .system)
        sendMessage(message: message)
    }
    
    func sendMessage(text: String) {
        let message = MultipeerFrameworkMessage(data: Data(text.utf8), contentType: .text, commuType: .user)
        let isMessageSent = sendMessage(message: message)
        if isMessageSent, let sentPeer = session.connectedPeers.first {
            saveMessage(message: message, sentPeer: sentPeer)
        }
    }
    
    func sendMessage(image: UIImage) {
        let message = MultipeerFrameworkMessage(data: image.pngData(), contentType: .image, commuType: .user)
        let isMessageSent = sendMessage(message: message)
        if isMessageSent, let sentPeer = session.connectedPeers.first {
            saveMessage(message: message, sentPeer: sentPeer)
        }
    }
    
    private func saveMessage(message: MultipeerFrameworkMessage, sentPeer: MCPeerID) {
        guard let myPeerID = UserPeer.shared.peerID else {
            return
        }
        UserMessageSaver.save(decodedMessage: message, from: myPeerID, to: sentPeer)
    }
    
    @discardableResult
    private func sendMessage(message: MultipeerFrameworkMessage) -> Bool {
        do {
            guard let encodedMessage = encodeMessage(message: message) else {
                print("Message isn't convertible to binary data.")
                return false
            }
            try session.send(encodedMessage, toPeers: session.connectedPeers, with: .reliable)
            print("Message sent")
            return true
        } catch {
            print("Error in sending the message")
            print(error.localizedDescription)
            return false
        }
    }
    
    private func encodeMessage(message: MultipeerFrameworkMessage) -> Data? {
        return try? JSONEncoder().encode(message)
    }
}
