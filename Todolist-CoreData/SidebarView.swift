//
//  SidebarView.swift
//  Todolist-CoreData
//
//  Created by Kevin Heredia on 22/8/25.
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var dataController: DataController
    let smartFilters: [Filter] = [.all, .recent]
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var categories: FetchedResults<Category>
    
    var categoryFilters: [Filter] {
        categories.map { category in
            Filter(id: category.id ?? UUID(), name: category.name ?? "No name", icon: "tag", category: category)
        }
    }
    
    var body: some View {
        List(selection: $dataController.selectedFilter) {
            Section("Smart Filters") {
                ForEach(smartFilters) { filter in
                    NavigationLink(value: filter.name) {
                        Label(filter.name, systemImage: filter.icon)
                    }
                }
            }
            
            Section("Categories") {
                ForEach(categoryFilters) { filter in
                    NavigationLink(value: filter) {
                        Label(filter.name, systemImage: filter.icon)
                    }
                }
            }
        }
        .toolbar {
            Button {
                dataController.deleteAll()
                dataController.createSampleData()
            } label: {
                Label("ADD SAMPLES", systemImage: "flame")
            }
        }
    }
}

#Preview {
    SidebarView()
        .environmentObject(DataController.preview)
}
