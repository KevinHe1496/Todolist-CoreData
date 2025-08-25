//
//  DataController.swift
//  Todolist-CoreData
//
//  Created by Kevin Heredia on 22/8/25.
//

import CoreData

class DataController: ObservableObject {
    
    let container: NSPersistentCloudKitContainer
    
    @Published var selectedFilter: Filter? = Filter.all
    
    // Vista previa de datos de ejemplo para SwiftUI (modo preview)
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
    }()
    
    // Inicializa el contenedor de Core Data (con opción en memoria)
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }
        // debe unir automáticamente los cambios que ocurran en otros contextos del mismo persistentContainer.
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // si hay un conflicto entre los datos locales y los del almacén persistente, los valores del objeto en memoria (en tu app) tienen prioridad sobre los que vienen de la base.
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        // Activa la opción para que Core Data emita notificaciones (.NSPersistentStoreRemoteChange) cada vez que haya cambios en el almacén (por ejemplo, si usas CloudKit o múltiples dispositivos).
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        // Cada vez que algo cambia remotamente en el almacén (otra app, otro dispositivo, otro contexto), se ejecutará tu función remoteStoreChanged.
        NotificationCenter.default
            .addObserver(
                forName: .NSPersistentStoreRemoteChange,
                object: container.persistentStoreCoordinator,
                queue: .main,
                using: remoteStoreChanged(
                    _:
                )
            )
        
        container.loadPersistentStores { storeDescription, error in
            if let error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    
    // Esta función notifica a SwiftUI que algo cambió en Core Data.
    func remoteStoreChanged(_ notification: Notification) {
        objectWillChange.send()
    }
    
    // Crea datos de ejemplo (categorías con tareas) para pruebas
    func createSampleData() {
        let viewContext = container.viewContext
        
        for i in 1...5 {
            let category = Category(context: viewContext)
            category.id = UUID()
            category.name = "Category \(i)"
            
            for j in 1...10 {
                let task = Task(context: viewContext)
                task.title = "Task \(i)-\(j)"
                task.creationDate = .now
                task.completed = Bool.random()
                task.priority = Int16.random(in: 0...2)
                category.addToTasks(task)
            }
        }
        
        try? viewContext.save()
    }
    
    // Guarda los cambios en Core Data si los hay
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    // Elimina un objeto específico de Core Data
    func delete(_ object: NSManagedObject) {
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
    }
    
    // Elimina en lote usando un fetch request (privado)
    // se actualicen automáticamente y reflejen que los objetos fueron eliminados.
    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }
    
    // Elimina todas las categorías y tareas
    func deleteAll() {
        let request1: NSFetchRequest<NSFetchRequestResult> = Category.fetchRequest()
        delete(request1)
        
        let request2: NSFetchRequest<NSFetchRequestResult> = Task.fetchRequest()
        delete(request2)
        
        save()
    }
}
