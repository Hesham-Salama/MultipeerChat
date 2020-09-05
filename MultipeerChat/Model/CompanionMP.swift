//
//  CompanionMP.swift
//  MultipeerChat
//
//  Created by Hesham on 3/17/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import MultipeerConnectivity
import UIKit
import CoreData

struct CompanionMP {
    
    let mcPeerID: MCPeerID
    let picture: UIImage?
    private(set) var uuid: UUID
    private static let tableName = "Companion"
    private static let coreDataHandler = CoreDataHandler(tableName: tableName)
    weak static var delegate: PeerAdded?
    
    init(mcPeerID: MCPeerID, picture: UIImage?, id: UUID) {
        self.mcPeerID = mcPeerID
        self.picture = picture
        self.uuid = id
    }
}

extension CompanionMP {
    
    private static var mcPeerKey: String {
        return "mcPeerID"
    }
    
    private static var pictureKey: String {
        return "profilePicture"
    }
    
    private static var idKey: String {
        return "id"
    }
    
    private var isPeerSaved : Bool {
        return CompanionMP.getAll().first(where: {
            $0.id == self.id
        }) != nil
    }
    
    func saveLocally() {
        isPeerSaved ? setNewDataForCompanion() : saveNewCompanion()
    }
    
    private func setNewDataForCompanion() {
        let predicateStr = "\(CompanionMP.idKey) == %@"
        let predicate = NSPredicate(format: predicateStr, self.id.uuidString)
        guard let managedObject = CompanionMP.coreDataHandler.getData(predicate: predicate)?.first else {
            fatalError("It should exist?")
        }
        do {
            try saveMCPeerID(mcPeerID: mcPeerID, newManagedObject: managedObject)
            savePeerImage(image: picture, newManagedObject: managedObject)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func saveNewCompanion() {
        do {
            guard let managedObject = CompanionMP.coreDataHandler.getNewManagedObject() else {
                fatalError("Couldn't save the user data!")
            }
            try saveMCPeerID(mcPeerID: mcPeerID, newManagedObject: managedObject)
            savePeerImage(image: picture, newManagedObject: managedObject)
            saveUniqueID(managedObject)
            CompanionMP.delegate?.added(peer: self)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func saveUniqueID(_ managedObject: NSManagedObject) {
        let uuidStr = uuid.uuidString
        CompanionMP.coreDataHandler.setData(in: managedObject, key: CompanionMP.idKey, data: uuidStr)
    }
    
    private func saveMCPeerID(mcPeerID: MCPeerID, newManagedObject: NSManagedObject) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: mcPeerID, requiringSecureCoding: true)
        CompanionMP.coreDataHandler.setData(in: newManagedObject, key: CompanionMP.mcPeerKey, data: data)
    }
    
    private func savePeerImage(image: UIImage?, newManagedObject: NSManagedObject) {
        let data = image?.pngData()
        CompanionMP.coreDataHandler.setData(in: newManagedObject, key: CompanionMP.pictureKey, data: data)
    }
    
    static func getAll() -> [CompanionMP] {
        var mUsers = [CompanionMP]()
        guard let managedObjects = coreDataHandler.getData() else {
            return mUsers
        }
        managedObjects.forEach {
            if let data = $0.value(forKey: mcPeerKey) as? Data, let mcPeerID = try? NSKeyedUnarchiver.unarchivedObject(ofClass: MCPeerID.self, from: data), let uuidStr = $0.value(forKey: idKey) as? String, let uuid = UUID(uuidString: uuidStr) {
                var picture : UIImage?
                if let data = $0.value(forKey: pictureKey) as? Data {
                    picture = UIImage(data: data)
                }
                mUsers.append(CompanionMP(mcPeerID: mcPeerID, picture: picture, id: uuid))
            }
        }
        return mUsers
    }
    
    static func removeAll() {
        guard let managedObjects = coreDataHandler.getData() else {
            return
        }
        coreDataHandler.remove(managedObjects: managedObjects)
    }
}

extension CompanionMP: Identifiable {
    var id: UUID {
        return uuid
    }
}

extension CompanionMP: Codable {
    
    enum CodingKeys: String, CodingKey {
        case mcPeerID
        case picture
        case uuid
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let mcPeerData = try values.decode(Data.self, forKey: .mcPeerID)
        mcPeerID = try NSKeyedUnarchiver.unarchivedObject(ofClass: MCPeerID.self, from: mcPeerData)!
        let pictureData : Data? = try values.decode(Data.self, forKey: .picture)
        picture = pictureData != nil ? UIImage(data: pictureData!) : nil
        uuid = try values.decode(UUID.self, forKey: .uuid)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(picture?.pngData(), forKey: .picture)
        let uuidData = try NSKeyedArchiver.archivedData(withRootObject: mcPeerID, requiringSecureCoding: true)
        try container.encode(uuidData, forKey: .mcPeerID)
    }
}
