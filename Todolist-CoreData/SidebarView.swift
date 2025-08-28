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
    
    @State private var categoryToRename: Category?
    @State private var renamingCategory = false
    @State private var categoryName = ""
    
    var categoryFilters: [Filter] {
        categories.map { category in
            Filter(id: category.categoryID, name: category.categoryName, icon: "tag", category: category)
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
                            .badge(filter.category?.categoryActiveTasks.count ?? 0)
                            .contextMenu {
                                Button {
                                    rename(filter)
                                } label: {
                                    Label("Rename", systemImage: "pencil")
                                }
                            }
                    }
                }
                .onDelete(perform: delete)
                
            }
        }
        .toolbar {
            
            
            Button(action: dataController.newCategory) {
                Label("Add category", systemImage: "plus")
            }
            
#if DEBUG
            Button {
                dataController.deleteAll()
                dataController.createSampleData()
            } label: {
                Label("ADD SAMPLES", systemImage: "flame")
            }
#endif
        }
        .alert("Rename category", isPresented: $renamingCategory) {
            Button("OK", action: completeRename)
            Button("Cancel", role: .cancel) { }
            TextField("New name", text: $categoryName)
        }
    }
    
    func delete(_ offsets: IndexSet) {
        for offset in offsets {
            let item = categories[offset]
            dataController.delete(item)
        }
    }
    
    func rename(_ filter: Filter) {
        categoryToRename = filter.category
        categoryName = filter.name
        renamingCategory = true
    }
    
    func completeRename() {
        categoryToRename?.name = categoryName
        dataController.save()
    }
}

#Preview {
    SidebarView()
        .environmentObject(DataController.preview)
}
