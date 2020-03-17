//
//  UserPeer.swift
//  MultipeerChat
//
//  Created by Hesham on 3/17/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import MultipeerConnectivity

class UserPeer {
    static let shared = UserPeer()
    private let coreDataHandler : CoreDataHandler
    private let tableName = "User"
    private let mcPeerIDKey = "mcPeerID"
    
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
}
