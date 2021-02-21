//
//  TaskRowViewModel.swift
//  TaskIt
//
//  Created by Kyle Dold on 16/02/2021.
//

import CoreData
import Foundation

class TaskRowViewModel: TaskRowViewModelProtocol {
    
    var id: UUID { return task.id ?? UUID() }
    var titleText: String { task.title ?? .empty }
    var priority: Priority { task.priority }
    
    @Published var isCompleted: Bool
    
    private(set) var task: Task
    private let managedObjectContext: NSManagedObjectContext
    
    init(task: Task, managedObjectContext: NSManagedObjectContext) {
        self.task = task
        self.managedObjectContext = managedObjectContext
        
        self.isCompleted = task.status == .completed
    }
    
    func completeButtonTapped() {
        task.status = task.status == .completed ? .todo : .completed
        try? managedObjectContext.save()
        
        isCompleted = task.status == .completed
    }
}
