//
//  TaskDetailsViewModelProtocol.swift
//  TaskIt
//
//  Created by Kyle Dold on 15/02/2021.
//

import Foundation

protocol TaskDetailsViewModelProtocol: ObservableObject {
    
    var taskName: String { get set }
    var dueDate: Date { get set }
    var isComplete: Bool { get set }
    var taskNotes: String { get set }
    var formattedDueDate: String { get }
    var taskNamePlaceholderText: String { get }
    var taskNotesPlaceholderText: String { get }
    var taskDateText: String { get }
    var deleteAlertTitleText: String { get }
    var deleteAlertMessageText: String { get }
    var deleteButtonText: String { get }
    var showCalendarView: Bool { get set }
    var subTaskListViewModel: SubTaskListViewModel { get }
    var calendarViewModel: CalendarViewModel { get }
    
    func deleteButtonTapped(_ completion: @escaping EmptyClosure)
    func calendarButtonTapped()
}
