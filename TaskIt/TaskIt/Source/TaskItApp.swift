//
//  TaskItApp.swift
//  TaskIt
//
//  Created by Kyle Dold on 31/01/2021.
//

import SwiftUI

@main
struct TaskItApp: App {
    
    let coordinator =  TaskItCoordinator(managedObjectContext: PersistenceController.shared.container.viewContext)
    
    var body: some Scene {
        WindowGroup {
            TaskItCoordinatorView(coordinator: coordinator)
        }
    }
}
