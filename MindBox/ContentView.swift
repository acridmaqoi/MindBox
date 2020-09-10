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
    ])
    var tasks: FetchedResults<Task>
    
    // Add Button
    @Environment(\.presentationMode) var presentation
    @State var showingNewTaskView = false
    
    var body: some View {
        NavigationView {
            List(tasks, id: \.self) { task in
                
                    
                HStack {
                    NavigationLink(destination: TaskDetailView(task: task)) {
                        TaskCell(task: task).environment(\.managedObjectContext, self.managedObjectContext)
//                        .onDelete(perform: deleteTask)
                    }//.buttonStyle(BorderlessButtonStyle())
                    

                }
                    
                
            }
            .navigationBarTitle("Today")
            .navigationBarItems(trailing:
                Button(action: {
//                    TaskUtils.create("self.taskName", description: "self.taskDesc", using: self.managedObjectContext)
                    self.showingNewTaskView = true // sheet view causes buttons to no longer work
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                        .frame(width: 40, height: 40, alignment: .trailing)
                }.sheet(isPresented: $showingNewTaskView) {
                    NewTaskView().environment(\.managedObjectContext, self.managedObjectContext)
                }
            )
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
            .buttonStyle(HighPriorityButtonStyle())
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

struct HighPriorityButtonStyle: PrimitiveButtonStyle {
    func makeBody(configuration: PrimitiveButtonStyle.Configuration) -> some View {
        MyButton(configuration: configuration)
    }
    
    private struct MyButton: View {
        @State var pressed = false
        let configuration: PrimitiveButtonStyle.Configuration
        
        var body: some View {
            let gesture = DragGesture(minimumDistance: 0)
                .onChanged { _ in self.pressed = true }
                .onEnded { value in
                    self.pressed = false
                    if value.translation.width < 10 && value.translation.height < 10 {
                        self.configuration.trigger()
                    }
                }
            
            return configuration.label
                .opacity(pressed ? 0.5 : 1.0)
                .highPriorityGesture(gesture)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
