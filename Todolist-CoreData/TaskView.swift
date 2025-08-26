//
//  TaskView.swift
//  Todolist-CoreData
//
//  Created by Kevin Heredia on 26/8/25.
//

import SwiftUI

struct TaskView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var task: Task
    
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $task.taskTitle, prompt: Text("Enter the task title here"))
                    .font(.title)
                
                Text("**Modified:** \(task.taskModificationDate.formatted(date: .long, time: .shortened))")
                    .foregroundStyle(.secondary)
                
                Text("**Status:** \(task.taskStatus)")
                    .foregroundStyle(.secondary)
                
                
                Menu {
                    ForEach(task.taskCategory) { category in
                        Button {
                            task.removeFromCategories(category)
                        } label: {
                            Label(category.categoryName, systemImage: "checkmark")
                        }
                    }
                    
                    let otherCategories = dataController.missingCategories(from: task)
                    
                    if otherCategories.isEmpty == false {
                        Divider()
                        
                        Section("Add Tags") {
                            ForEach(otherCategories) { category in
                                Button(category.categoryName) {
                                    task.addToCategories(category)
                                }
                            }
                        }
                    }
                } label: {
                    Text(task.taskCategoriesList)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .animation(nil, value: task.taskCategoriesList)
                }
            }
            
            Picker("Priority", selection: $task.priority) {
                Text("Low").tag(Int16(0))
                Text("Medium").tag(Int16(1))
                Text("High").tag(Int16(2))
            }
        }
        .disabled(task.isDeleted)
    }
}

#Preview {
    TaskView(task: .example)
        .environmentObject(DataController())
}
