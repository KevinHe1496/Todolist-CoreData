//
//  NoTaskView.swift
//  Todolist-CoreData
//
//  Created by Kevin Heredia on 26/8/25.
//

import SwiftUI

struct NoTaskView: View {
    @EnvironmentObject var dataController: DataController
    var body: some View {
        Text("No Issue Selected")
            .font(.title)
            .foregroundStyle(.secondary)
        
        Button("New Issue") {
            
        }
    }
}

#Preview {
    NoTaskView()
}
