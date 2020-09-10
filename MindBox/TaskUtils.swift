//
//  TaskUtils.swift
//  MindBox
//
//  Created by Sam Quinn on 25/08/2020.
//  Copyright © 2020 Sam Quinn. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

struct TaskUtils {
    public static func create(_ name: String, description: String, using managedObjectContext: NSManagedObjectContext) {
        let task = Task(context: managedObjectContext)
        task.id = UUID()
        task.name = name
        task.desc = description
        task.completed = false
        
        saveChanges(using: managedObjectContext)
    }
    
    public static func toggleIsComplete(_ task: Task, using managedObjectContext: NSManagedObjectContext) {
        if task.completed {
            task.completed = false
            task.streak -= 1
        } else {
            task.completed = true
            task.streak += 1
        }
        
        saveChanges(using: managedObjectContext)
    }
    
    public static func delete(task: Task, using managedObjectContext: NSManagedObjectContext) {
        managedObjectContext.delete(task)
        saveChanges(using: managedObjectContext)
    }
    
    fileprivate static func saveChanges(using managedObjectContext: NSManagedObjectContext) {
        guard managedObjectContext.hasChanges else { return }
        do {
            try managedObjectContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
