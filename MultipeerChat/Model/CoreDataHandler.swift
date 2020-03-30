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
    var maxPageLimit = 25
    
    init(tableName: String) {
        self.tableName = tableName
    }
    
    func getData(predicate: NSPredicate? = nil, sortDescriptors: [CoreDataSortDescriptor]? = nil, paging: Int? = nil) -> [NSManagedObject]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        request.predicate = predicate
        applySortDescriptors(sortDescriptors, request)
        applyPaging(paging, request)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            guard let managedObjects = result as? [NSManagedObject] else {
                return nil
            }
            return managedObjects
        } catch {
            print("Failed to get data: Table: \(tableName)")
        }
        return nil
    }
    
    func setDataOnlyObject(key: String, data: Any?) {
        let managedObject: NSManagedObject
        if let tempManagedObject = getFirstManagedObject() {
            managedObject = tempManagedObject
        } else if let tempManagedObject = getNewManagedObject() {
            managedObject = tempManagedObject
        } else {
            fatalError("Couldn't get a managed object!")
        }
        setData(in: managedObject, key: key, data: data)
    }
    
    func setData(in managedObject: NSManagedObject, key: String, data: Any?) {
        do {
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
    
    func getNewManagedObject() -> NSManagedObject? {
        guard let entity = NSEntityDescription.entity(forEntityName: tableName, in: context) else {
            print("Failed to set data for non existing entity in that context")
            return nil
        }
        return NSManagedObject(entity: entity, insertInto: context)
    }
    
    fileprivate func applySortDescriptors(_ sortDescriptors: [CoreDataSortDescriptor]?, _ request: NSFetchRequest<NSFetchRequestResult>) {
        if let descriptors = sortDescriptors {
            var descArr = [NSSortDescriptor]()
            for descriptor in descriptors {
                descArr.append(NSSortDescriptor(key: descriptor.key, ascending: descriptor.isAscending))
            }
            request.sortDescriptors = descArr
        }
    }
    
    fileprivate func applyPaging(_ paging: Int?, _ request: NSFetchRequest<NSFetchRequestResult>) {
        if let paging = paging {
            request.fetchLimit = maxPageLimit
            request.fetchOffset = paging
        }
    }
}
