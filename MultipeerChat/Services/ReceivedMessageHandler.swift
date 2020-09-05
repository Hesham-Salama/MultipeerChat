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
    
    static func handleReceivedUserMessage(messageData: Data, from companion: CompanionMP) {
        guard let decodedMessage = try? JSONDecoder().decode(MultipeerFrameworkMessage.self, from: messageData) else {
            return
        }
        UserMessageSaver.messageSent(from: companion, decodedMessage: decodedMessage)
    }
    
    static func handleCompanionInfo(data: Data) -> CompanionMP? {
        guard let decodedCompanionMP = try? JSONDecoder().decode(CompanionMP.self, from: data) else {
            return nil
        }
        return decodedCompanionMP
    }
}
