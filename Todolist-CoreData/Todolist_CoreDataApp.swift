//
//  Todolist_CoreDataApp.swift
//  Todolist-CoreData
//
//  Created by Kevin Heredia on 22/8/25.
//

import SwiftUI

@main
struct Todolist_CoreDataApp: App {
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                SidebarView()
            } content: {
                ContentView()
            } detail: {
                DetailView()
            }
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
        }
    }
}
