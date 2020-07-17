//
//  MultipeerUser.swift
//  MultipeerChat
//
//  Created by Hesham on 3/17/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import MultipeerConnectivity
import UIKit
import CoreData

struct MultipeerUser {
    
    let mcPeerID: MCPeerID
    let picture: UIImage?
    private static let tableName = "Peer"
    private static let coreDataHandler = CoreDataHandler(tableName: tableName)
    
    init(mcPeerID: MCPeerID, picture: UIImage?) {
        self.mcPeerID = mcPeerID
        self.picture = picture
    }
}

extension MultipeerUser {
    
    private static var mcPeerKey : String {
        return "mcPeerID"
    }
    
    private static var pictureKey : String {
        return "profilePicture"
    }
    
    private var isPeerSaved : Bool {
        return MultipeerUser.getAll().filter{ $0.mcPeerID == self.mcPeerID }.first != nil
    }
    
    func saveLocally() {
        if !isPeerSaved {
            do {
                guard let managedObject = MultipeerUser.coreDataHandler.getNewManagedObject() else {
                    fatalError("Couldn't save the user data!")
                }
                try saveMCPeerID(mcPeerID: mcPeerID, newManagedObject: managedObject)
                savePeerImage(image: picture, newManagedObject: managedObject)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func saveMCPeerID(mcPeerID: MCPeerID, newManagedObject: NSManagedObject) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: mcPeerID, requiringSecureCoding: true)
        MultipeerUser.coreDataHandler.setData(in: newManagedObject, key: MultipeerUser.mcPeerKey, data: data)
    }
    
    private func savePeerImage(image: UIImage?, newManagedObject: NSManagedObject) {
        let data = image?.pngData()
        MultipeerUser.coreDataHandler.setData(in: newManagedObject, key: MultipeerUser.pictureKey, data: data)
    }
    
    static func getAll() -> [MultipeerUser] {
        var mUsers = [MultipeerUser]()
        guard let managedObjects = coreDataHandler.getData() else {
            return mUsers
        }
        managedObjects.forEach {
            if let data = $0.value(forKey: mcPeerKey) as? Data, let mcPeerID = try? NSKeyedUnarchiver.unarchivedObject(ofClass: MCPeerID.self, from: data) {
                let picture = $0.value(forKey: pictureKey) as? UIImage
                mUsers.append(MultipeerUser(mcPeerID: mcPeerID, picture: picture))
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

extension MultipeerUser: Identifiable {
    var id: Int {
        return mcPeerID.hashValue
    }
}
