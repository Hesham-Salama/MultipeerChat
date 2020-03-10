//
//  CoreDataHandler.swift
//  MultipeerChat
//
//  Created by Hesham on 3/10/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import UIKit
import CoreData
import MultipeerConnectivity

class CoreDataHandler {
    
    private let tableName : String
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    init(tableName: String) {
        self.tableName = tableName
    }
    
    func getData(key: String) -> Any? {
        guard let managedObject = getFirstManagedObject() else {
            print("Nil first managed object")
            return nil
        }
        return managedObject.value(forKey: key)
    }
    
    func setData(key: String, data: Any?) {
        do {
            guard let entity = NSEntityDescription.entity(forEntityName: tableName, in: context) else {
                print("Failed to set data for non existing entity in that context")
                return
            }
            let managedObject: NSManagedObject
            if let tempManagedObject = getFirstManagedObject() {
                managedObject = tempManagedObject
            } else {
                managedObject = NSManagedObject(entity: entity, insertInto: context)
            }
            managedObject.setValue(data, forKeyPath: key)
            try context.save()
        } catch {
            print("Could not save \(key)'s value")
        }
    }
    
    private func getFirstManagedObject() -> NSManagedObject? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            return result.first as? NSManagedObject
        } catch {
            print("Failed to fetch new content")
        }
        return nil
    }
}
