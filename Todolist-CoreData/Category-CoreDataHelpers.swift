//
//  Category-CoreDataHelpers.swift
//  Todolist-CoreData
//
//  Created by Kevin Heredia on 25/8/25.
//

import Foundation

extension Category {
    var categoryID: UUID {
        id ?? UUID()
    }
    
    var categoryName: String {
        name ?? ""
    }
    // convierte la relación "tasks" en un array y filtra solo las que tienen completed == false
    var categoryActiveTasks: [Task] {
        let result = tasks?.allObjects as? [Task] ?? []
        return result.filter({ $0.completed == false }) // Devuelve solo las no completadas
    }
    
    static var example: Category {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let category = Category(context: viewContext)
        category.id = UUID()
        category.name = "Example Category"
        return category
    }
}

extension Category: Comparable {
    
    // 1. Primero ordena por nombre (ignora mayúsculas)
    public static func <(lhs: Category, rhs: Category) -> Bool {
        let left = lhs.categoryName.localizedLowercase
        let right = rhs.categoryName.localizedLowercase
        
        // 2. Si los nombres son iguales, ordena por id (UUID)
        if left == right {
            return lhs.categoryID.uuidString < rhs.categoryID.uuidString
        } else {
            return left < right
        }
    }
}
