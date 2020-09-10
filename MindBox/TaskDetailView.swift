//
//  TaskViewDetail.swift
//  MindBox
//
//  Created by Sam Quinn on 31/08/2020.
//  Copyright © 2020 Sam Quinn. All rights reserved.
//

import SwiftUI

struct TaskDetailView: View {
    var task: Task
    
    var body: some View {
        NavigationView {
            VStack {
                Text(self.task.name!)
            }
        }
        .navigationBarTitle(Text(self.task.name!), displayMode: .inline)
        .navigationBarItems(trailing: EditButton())
    }
}

struct TaskViewDetail_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let task = Task.init(context: context)
        task.name = "Washing up"
        task.desc = "Wash the dishes"
        task.completed = false
        task.streak = 2
        
        return TaskDetailView(task: task)
            .environment(\.managedObjectContext, context)
    }
}
