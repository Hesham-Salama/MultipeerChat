//
//  MPMessage.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/26/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import MultipeerConnectivity
import CoreData

class MPMessage: Identifiable {
    
    private static let tableName = "UserMessageEntity"
    private static let timeKey = "time"
    private static let dataKey = "data"
    private static let idKey = "id"
    private static let senderPeerHashKey = "senderHashValue"
    private static let recipientPeerHashKey = "recipientHashValue"
    private static let coreDataHandler = CoreDataHandler(tableName: MPMessage.tableName)
    weak static var delegate: MessageAdded?
    let data: Data
    let unixTime: TimeInterval
    let senderPeerID: UUID
    let receiverPeerID: UUID
    internal let id: UUID
    
    init(data: Data, unixTime: TimeInterval, senderPeerID: UUID, receiverPeerID: UUID, id: UUID) {
        self.data = data
        self.unixTime = unixTime
        self.senderPeerID = senderPeerID
        self.receiverPeerID = receiverPeerID
        self.id = id
    }
    
    func saveLocally() {
        guard let managedObject = MPMessage.coreDataHandler.getNewManagedObject() else {
            fatalError("Couldn't save the user data!")
        }
        MPMessage.coreDataHandler.setData(in: managedObject, key: MPMessage.senderPeerHashKey, data: senderPeerID.uuidString)
        MPMessage.coreDataHandler.setData(in: managedObject, key: MPMessage.recipientPeerHashKey, data: receiverPeerID.uuidString)
        MPMessage.coreDataHandler.setData(in: managedObject, key: MPMessage.dataKey, data: data)
        MPMessage.coreDataHandler.setData(in: managedObject, key: MPMessage.timeKey, data: unixTime)
        MPMessage.coreDataHandler.setData(in: managedObject, key: MPMessage.idKey, data: id)
        MPMessage.delegate?.added(message: self)
    }
    
    static func getMutualMessages(between peer1ID: UUID, and peer2ID: UUID, paging: Int? = nil) -> [MPMessage] {
        var messages = [MPMessage]()
        let sortDescriptor = [CoreDataSortDescriptor(key: timeKey, isAscending: false)]
        let predicateStr = "(\(recipientPeerHashKey) == %@ AND \(senderPeerHashKey) == %@) OR (\(senderPeerHashKey) == %@ AND \(recipientPeerHashKey) == %@)"
        guard let managedObjects = coreDataHandler.getData(predicate: NSPredicate(format: predicateStr, peer1ID.uuidString, peer2ID.uuidString, peer1ID.uuidString, peer2ID.uuidString), sortDescriptors: sortDescriptor, paging: paging) else {
            return messages
        }
        managedObjects.forEach {
            if let messageData = $0.value(forKey: dataKey) as? Data, let unixTime = $0.value(forKey: timeKey) as? TimeInterval, let messageID = $0.value(forKey: idKey) as? UUID, let receiverHash = $0.value(forKey: recipientPeerHashKey) as? String, let receiverUUID = UUID(uuidString: receiverHash), let senderHash = $0.value(forKey: senderPeerHashKey) as? String, let senderUUID = UUID(uuidString: senderHash) {
                messages.append(MPMessage(data: messageData, unixTime: unixTime, senderPeerID: senderUUID, receiverPeerID: receiverUUID, id: messageID))
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
