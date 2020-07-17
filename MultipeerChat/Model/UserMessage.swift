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
    private static let senderPeerHashKey = "senderHashValue"
    private static let recipientPeerHashKey = "recipientHashValue"
    private static let coreDataHandler = CoreDataHandler(tableName: UserMessage.tableName)
    weak static var delegate: MessageAdded?
    let data: Data
    let unixTime: TimeInterval
    let senderPeerID: MCPeerID
    let receiverPeerID: MCPeerID
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
            try savePeerHash(peerID: senderPeerID, managedObject: managedObject, key: UserMessage.senderPeerHashKey)
            try savePeerHash(peerID: receiverPeerID, managedObject: managedObject, key: UserMessage.recipientPeerHashKey)
            UserMessage.delegate?.added(message: self)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func savePeerID(peerID: MCPeerID, managedObject: NSManagedObject, key: String) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: peerID, requiringSecureCoding: true)
        UserMessage.coreDataHandler.setData(in: managedObject, key: key, data: data)
    }
    
    private func savePeerHash(peerID: MCPeerID, managedObject: NSManagedObject, key: String) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: peerID, requiringSecureCoding: true)
        UserMessage.coreDataHandler.setData(in: managedObject, key: key, data: data)
    }
    
    static func getAll(from peer: MCPeerID, after time: TimeInterval? = nil, paging: Int? = nil) -> [UserMessage] {
        var messages = [UserMessage]()
        let sortDescriptor = [CoreDataSortDescriptor(key: timeKey, isAscending: false)]
        let predicateStr = "(\(timeKey) > %@) AND ((\(recipientPeerHashKey) == %@) OR (\(senderPeerHashKey) == %@))"
        guard let peerData = try? NSKeyedArchiver.archivedData(withRootObject: peer, requiringSecureCoding: true) else {
            return messages
        }
        let peerHash = peerData.hashValue
        guard let managedObjects = coreDataHandler.getData(predicate: NSPredicate(format: predicateStr, time ?? 0.0, peerHash, peerHash), sortDescriptors: sortDescriptor, paging: paging) else {
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
    
    static func removeAll() {
        guard let managedObjects = coreDataHandler.getData() else {
            return
        }
        coreDataHandler.remove(managedObjects: managedObjects)
    }
}
