//
//  TaskRow.swift
//  Todolist-CoreData
//
//  Created by Kevin Heredia on 25/8/25.
//

import SwiftUI

struct TaskRow: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var task: Task
    var body: some View {
        NavigationLink(value: task) {
            HStack {
                Image(systemName: "exclamationmark.circle")
                    .imageScale(.large)
                    .opacity(task.priority == 2 ? 1 : 0)
                
                VStack(alignment: .leading) {
                    Text(task.taskTitle)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text("No tasks")
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(task.taskCreationDate.formatted(date: .numeric, time: .omitted))
                        .font(.subheadline)
                    
                    if task.completed {
                        Text("CLOSED")
                            .font(.body.smallCaps())
                    }
                }
                .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    TaskRow(task: .example)
        .environmentObject(DataController())
}
