//
//  MultipeerUser.swift
//  MultipeerChat
//
//  Created by Hesham on 3/9/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import UIKit
import MultipeerConnectivity

struct MultipeerUser: Identifiable {
    
    private let coreDataHandler: CoreDataHandler

    private let nameKey = "name"
    private let imageKey = "profilePicture"
    private let idKey = "mcpeerID"
    private let tableName = "User"
    private let uuidKey = "uuid"
    
    var name : String {
        get {
            return coreDataHandler.getData(key: nameKey) as? String ?? ""
        }
        set {
            coreDataHandler.setData(key: nameKey, data: newValue)
        }
    }
    
    var image : UIImage? {
        get {
            guard let imageData = coreDataHandler.getData(key: imageKey) as? Data else {
                return nil
            }
            return UIImage(data: imageData)
        }
        set {
            let imageData = newValue?.pngData()
            coreDataHandler.setData(key: imageKey, data: imageData)
        }
    }
    
    var mcPeerID : MCPeerID? {
        get {
            guard let data = coreDataHandler.getData(key: idKey) as? Data, let id = try? NSKeyedUnarchiver.unarchivedObject(ofClass: MCPeerID.self, from: data) else {
                print("Error in getting MCPeerID value from CoreData.")
                return nil
            }
            return id
        }
        set {
            setMCPeerID(mcPeerID: newValue)
        }
    }
    
    var id: UUID {
        get {
            guard let uuid = coreDataHandler.getData(key: uuidKey) as? UUID else {
                let uuid = UUID()
                coreDataHandler.setData(key: uuidKey, data: uuid)
                return uuid
            }
            return uuid
        }
    }
    
    init() {
        coreDataHandler = CoreDataHandler(tableName: tableName)
    }
    
    private func setMCPeerID(mcPeerID: MCPeerID?) {
        guard let mcPeerID = mcPeerID else {
            coreDataHandler.setData(key: idKey, data: nil)
            return
        }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: mcPeerID, requiringSecureCoding: true)
            coreDataHandler.setData(key: idKey, data: data)
        } catch {
            print("Error in setting the MCPeerID value in CoreData.")
            print(error.localizedDescription)
            coreDataHandler.setData(key: idKey, data: nil)
        }
    }
}
