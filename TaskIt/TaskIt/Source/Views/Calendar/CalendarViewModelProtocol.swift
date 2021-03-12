//
//  CalendarViewModelProtocol.swift
//  TaskIt
//
//  Created by Kyle Dold on 07/03/2021.
//

import Foundation

protocol CalendarViewModelProtocol: ObservableObject {
    
    var selectedDate: Date { get set }
    var onDateSelected: ValueClosure<Date>? { get set }
}
