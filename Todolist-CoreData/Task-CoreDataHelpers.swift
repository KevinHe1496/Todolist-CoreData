//
//  Task-CoreDataHelpers.swift
//  Todolist-CoreData
//
//  Created by Kevin Heredia on 25/8/25.
//

import Foundation
// Esta es mi Entidad Task de Core Data
extension Task {
    //Aca sus atributos como title, creationdate, moficationdate
    var taskTitle: String {
        get { title ?? "" } // mira si el title tiene algo, si no tiene es nil ""
        set { title = newValue } // si tiene un valor lo asigna con newvalue ejm: title = Kevin
    }
    
    var taskCreationDate: Date {
        creationDate ?? .now
    }
    
    var taskModificationDate: Date {
        modificationDate ?? .now
    }
    
//    Convierte el conjunto de categorias (NSSet) en un array Category
//    si no hay categorias devuelve []
    var taskCategory: [Category] {
        let result = categories?.allObjects as? [Category] ?? []
        return result.sorted()
    }
    
    static var example: Task {
        // 1. Creamos un "cuaderno de tareas" (no se guarda de verdad, solo sirve para practicar).
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        // 2. Creamos una nueva tarea en ese cuaderno.
        let task = Task(context: viewContext)
        
        // 3. Le ponemos datos de ejemplo a esa tarea:
        task.title = "Example Issue"   // como si escribieras "Hacer la compra"
        task.priority = 2              // prioridad (ej: 2 = importante)
        task.creationDate = .now       // fecha actual (ej: "hoy")
        
        // 4. Devolvemos esta tarea de ejemplo para usarla en pruebas o en el preview.
        return task
    }

}

// Hacemos que Task pueda compararse y ordenarse (Comparable)
extension Task: Comparable {
    
    // 1. Primero ordena por título (ignorando mayúsculas/minúsculas)
    public static func <(lhs: Task, rhs: Task) -> Bool {
        let left = lhs.taskTitle.localizedLowercase
        let right = rhs.taskTitle.localizedLowercase
        
        // 2. Si los títulos son iguales, ordena por fecha de creación
        if left == right {
            return lhs.taskCreationDate < rhs.taskCreationDate
        } else {
            return left < right
        }
    }
}
