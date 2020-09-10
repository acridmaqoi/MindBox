//
//  NewTaskView.swift
//  MindBox
//
//  Created by Sam Quinn on 30/08/2020.
//  Copyright © 2020 Sam Quinn. All rights reserved.
//

import SwiftUI

struct NewTaskView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentation
    
    @State private var taskName: String = ""
    @State private var taskDesc: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Task Name", text: $taskName)
                TextField("Task Description", text: $taskDesc)
            }
            .navigationBarTitle(Text("New Task"), displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    TaskUtils.create(self.taskName, description: self.taskDesc, using: self.managedObjectContext)
                    self.presentation.wrappedValue.dismiss()
                }) {
                    Text("Done")
                }
            )
        }
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView()
    }
}
