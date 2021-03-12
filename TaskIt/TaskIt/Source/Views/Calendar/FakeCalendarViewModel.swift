//
//  FakeCalendarViewModel.swift
//  TaskIt
//
//  Created by Kyle Dold on 07/03/2021.
//

import Foundation

class FakeCalendarViewModel: CalendarViewModelProtocol {
    
    var selectedDate = Date()
    var onDateSelected: ValueClosure<Date>? = { _ in }
}

