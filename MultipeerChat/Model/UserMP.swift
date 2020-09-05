//
//  UserMP.swift
//  MultipeerChat
//
//  Created by Hesham on 3/17/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import MultipeerConnectivity

class UserMP {
    static let shared = UserMP()
    private let coreDataHandler : CoreDataHandler
    private let tableName = "User"
    private let mcPeerIDKey = "mcPeerID"
    private let profilePictureKey = "profilePicture"
    private let idKey = "id"
    
    private init() {
        coreDataHandler = CoreDataHandler(tableName: tableName)
    }
    
    var peerID: MCPeerID? {
        get {
            guard let data = coreDataHandler.getData()?.first?.value(forKey: mcPeerIDKey) as? Data else {
                return nil
            }
            return try? NSKeyedUnarchiver.unarchivedObject(ofClass: MCPeerID.self, from: data)
        }
        set {
            guard let newValue = newValue else {
                coreDataHandler.setDataOnlyObject(key: mcPeerIDKey, data: nil)
                return
            }
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: true)
                coreDataHandler.setDataOnlyObject(key: mcPeerIDKey, data: data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    var profilePicture: UIImage? {
        get {
            guard let data = coreDataHandler.getData()?.first?.value(forKey: profilePictureKey) as? Data else {
                return nil
            }
            return UIImage(data: data)
        }
        set {
            let data = newValue?.pngData()
            coreDataHandler.setDataOnlyObject(key: profilePictureKey, data: data)
        }
    }
    
    var id: UUID? {
        get {
            guard let uuidStr = coreDataHandler.getData()?.first?.value(forKey: idKey) as? String else { return nil }
            return UUID(uuidString: uuidStr)
        }
        set {
            let uuidStr = newValue?.uuidString
            coreDataHandler.setDataOnlyObject(key: idKey, data: uuidStr)
        }
    }
}
