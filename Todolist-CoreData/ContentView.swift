//
//  ContentView.swift
//  Todolist-CoreData
//
//  Created by Kevin Heredia on 22/8/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        List(selection: $dataController.selectedTask) {
            ForEach(dataController.tasksForSelectedFilter()) { task in
                TaskRow(task: task)
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Tasks")
        .searchable(text: $dataController.filterText, prompt: "Filter task")
    }
    
    func delete(_ offsets: IndexSet) {
        let tasks = dataController.tasksForSelectedFilter()
        
        for offset in offsets {
            let item = tasks[offset]
            dataController.delete(item)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DataController())
}
