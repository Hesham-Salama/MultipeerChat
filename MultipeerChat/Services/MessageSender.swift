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
        let message = Message(data: image?.pngData(), contentType: .image, commuType: .system)
        sendMessage(message: message)
    }
    
    func sendMessage(text: String) {
        let message = Message(data: Data(text.utf8), contentType: .text, commuType: .user)
        sendMessage(message: message)
        if let encodedMessage = encodeMessage(message: message), let sentPeer = session.connectedPeers.first {
            MessageHandler.handleSentUserMessage(data: encodedMessage, to: sentPeer)
        }
    }
    
    func sendMessage(image: UIImage) {
        let message = Message(data: image.pngData(), contentType: .image, commuType: .user)
        sendMessage(message: message)
        if let encodedMessage = encodeMessage(message: message), let sentPeer = session.connectedPeers.first {
            MessageHandler.handleSentUserMessage(data: encodedMessage, to: sentPeer)
        }
    }
    
    private func sendMessage(message: Message) {
        do {
            guard let encodedMessage = encodeMessage(message: message) else {
                print("Message isn't convertible to binary data.")
                return
            }
            try session.send(encodedMessage, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("Error in sending the message")
            print(error.localizedDescription)
        }
    }
    
    private func encodeMessage(message: Message) -> Data? {
        return try? JSONEncoder().encode(message)
    }
}
