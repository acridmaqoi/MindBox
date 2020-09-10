//
//  ContentView.swift
//  MindBox
//
//  Created by Sam Quinn on 25/08/2020.
//  Copyright © 2020 Sam Quinn. All rights reserved.
//
import SwiftUI
import CoreData

struct ContentView: View {
    // Core Data
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Task.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Task.completed, ascending: false),
        NSSortDescriptor(keyPath: \Task.name, ascending: true)
    ]) var tasks: FetchedResults<Task>
    
    // Add Button
    @Environment(\.presentationMode) var presentation
    @State var showingNewTaskView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(tasks, id: \.self) { task in
                        HStack {
                            TaskCell(task: task).environment(\.managedObjectContext, self.managedObjectContext)
                            NavigationLink(destination: TaskDetailView(task: task)) {
                                EmptyView()
                            }
                        }
                    }
                    .onDelete(perform: deleteTask)
                }
                .navigationBarTitle("Today")
                .navigationBarItems(trailing:
                    Button(action: {
                        withAnimation {
                            self.showingNewTaskView = true
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .imageScale(.large)
                            .frame(width: 40, height: 40, alignment: .trailing)
                    }
                )
                
                BottomSheetModal(display: $showingNewTaskView) {
                    NewTaskView(showingNewTaskView: self.$showingNewTaskView)
                        .font(Font.system(.headline))
                        .foregroundColor(Color.black)
                }
            }
            
            
        }
    }
    
    func deleteTask(at indexSet: IndexSet) {
        indexSet.forEach { TaskUtils.delete(task: tasks[$0], using: self.managedObjectContext)}
    }
}

struct TaskCell: View {
    @ObservedObject var task: Task
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        HStack {
            Button(action: {
                TaskUtils.toggleIsComplete(self.task, using: self.managedObjectContext)
                UIImpactFeedbackGenerator(style: .medium)
                    .impactOccurred()
            }) {
                Image(systemName: task.completed == true ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.blue)
                    .imageScale(.large)
            }
            .buttonStyle(BorderlessButtonStyle())
            .frame(width: 30, height: 30)
    
            VStack(alignment: .leading) {
                Text(task.name ?? "")
                    .font(.headline)
                Text(String(task.streak) + " days")
                    .font(.caption)
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
