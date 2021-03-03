//
//  TaskDetailsViewModelProtocol.swift
//  TaskIt
//
//  Created by Kyle Dold on 15/02/2021.
//

import Foundation

protocol TaskDetailsViewModelProtocol: ObservableObject {
    
    var taskName: String { get set }
    var priority: Priority { get set }
    var dueDate: Date { get set }
    var isComplete: Bool { get set }
    var taskNotes: String { get set }
    var taskNamePlaceholderText: String { get }
    var taskNotesPlaceholderText: String { get }
    var taskDateText: String { get }
    var submitButtonText: String { get }
    var subTaskListViewModel: SubTaskListViewModel { get }
    var isSubmitButtonDisabled: Bool { get }
    
    func onAppear()
    func onDisappear()
    func addNewTaskTapped(_ completion: @escaping EmptyClosure)
}
