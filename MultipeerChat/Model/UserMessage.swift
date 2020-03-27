//
//  UserMessage.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/26/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import MultipeerConnectivity
import CoreData

class UserMessage: Identifiable {
    
    private static let tableName = "UserMessageEntity"
    private static let timeKey = "time"
    private static let recipientPeerIDKey = "recipientPeerID"
    private static let senderPeerIDKey = "senderPeerID"
    private static let dataKey = "data"
    private static let idKey = "id"
    private static let coreDataHandler = CoreDataHandler(tableName: UserMessage.tableName)
    private let data: Data
    private let unixTime: TimeInterval
    private let senderPeerID: MCPeerID
    private let receiverPeerID: MCPeerID
    internal let id: UUID
    
    init(data: Data, unixTime: TimeInterval, senderPeerID: MCPeerID, receiverPeerID: MCPeerID, id: UUID) {
        self.data = data
        self.unixTime = unixTime
        self.senderPeerID = senderPeerID
        self.receiverPeerID = receiverPeerID
        self.id = id
    }
    
    func saveLocally() {
        do {
            guard let managedObject = UserMessage.coreDataHandler.getNewManagedObject() else {
                fatalError("Couldn't save the user data!")
            }
            try savePeerID(peerID: senderPeerID, managedObject: managedObject, key: UserMessage.senderPeerIDKey)
            try savePeerID(peerID: receiverPeerID, managedObject: managedObject, key: UserMessage.recipientPeerIDKey)
            UserMessage.coreDataHandler.setData(in: managedObject, key: UserMessage.dataKey, data: data)
            UserMessage.coreDataHandler.setData(in: managedObject, key: UserMessage.timeKey, data: unixTime)
            UserMessage.coreDataHandler.setData(in: managedObject, key: UserMessage.idKey, data: id)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func savePeerID(peerID: MCPeerID, managedObject: NSManagedObject, key: String) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: peerID, requiringSecureCoding: true)
        UserMessage.coreDataHandler.setData(in: managedObject, key: key, data: data)
    }
    
    static func getAll(after time: TimeInterval?) -> [UserMessage] {
        var messages = [UserMessage]()
        guard let managedObjects = coreDataHandler.getData(predicate: NSPredicate(format: "\(timeKey) > %@", time ?? 0.0)) else {
            return messages
        }
        managedObjects.forEach {
            if let recipientData = $0.value(forKey: recipientPeerIDKey) as? Data, let recipientPeerID = try? NSKeyedUnarchiver.unarchivedObject(ofClass: MCPeerID.self, from: recipientData),
                let senderData = $0.value(forKey: senderPeerIDKey) as? Data, let senderPeerID = try? NSKeyedUnarchiver.unarchivedObject(ofClass: MCPeerID.self, from: senderData), let messageData = $0.value(forKey: dataKey) as? Data, let unixTime = $0.value(forKey: timeKey) as? TimeInterval, let messageID = $0.value(forKey: idKey) as? UUID {
                messages.append(UserMessage(data: messageData, unixTime: unixTime, senderPeerID: senderPeerID, receiverPeerID: recipientPeerID, id: messageID))
            }
        }
        return messages
    }
}
