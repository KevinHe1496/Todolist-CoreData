//
//  ContentView.swift
//  Todolist-CoreData
//
//  Created by Kevin Heredia on 22/8/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    
    var tasks: [Task] {
        let filter = dataController.selectedFilter ?? .all
        var allTasks: [Task]
        
        if let category = filter.category {
            allTasks = category.tasks?.allObjects as? [Task] ?? []
        } else {
            let request = Task.fetchRequest()
            request.predicate = NSPredicate(format: "modificationDate > %@", filter.minModificationDate as NSDate)
            allTasks = (try? dataController.container.viewContext.fetch(request)) ?? []
        }
        return allTasks.sorted()
    }
    var body: some View {
        List(selection: $dataController.selectedTask) {
            ForEach(tasks) { task in
                TaskRow(task: task)
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Tasks")
    }
    
    func delete(_ offsets: IndexSet) {
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
