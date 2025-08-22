//
//  Filter.swift
//  Todolist-CoreData
//
//  Created by Kevin Heredia on 22/8/25.
//

import Foundation

struct Filter: Identifiable, Hashable {
    var id: UUID
    var name: String
    var icon: String
    var minModificationDate = Date.distantPast
    var category: Category?
    
    static var all = Filter(id: UUID(), name: "All Tasks", icon: "tray")
    static var recent = Filter(id: UUID(), name: "Recent Tasks", icon: "clock", minModificationDate: .now.addingTimeInterval(86400 * -7)) // que muestre los tasks de los ultimos 7 dias
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
}
