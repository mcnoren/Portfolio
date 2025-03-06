//
//  ScheduleListViewModel.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/8/24.
//

import Foundation

class ScheduleListViewModel: ObservableObject {
    
    var day: DayModel
    @Published var schedules: [ScheduleModel]
    
    init(day: DayModel) {
        self.day = day
        self.schedules = day.scheduleList
    }
    
    func deleteSchedule(indexSet: IndexSet) {
        schedules.remove(atOffsets: indexSet)
    }
    
    func addSchedule(event: EventModel, notes: String = "", startedWaiting: Date? = nil, startedEvent: Date? = nil, endedEvent: Date? = nil, postedWait: Int) {
        let newAttraction = ScheduleModel(event: event, notes: notes, startedWaiting: startedWaiting, startedEvent: startedEvent, endedEvent: endedEvent, postedWait: postedWait)
        DayListViewModel().append_scheduleList(day_id: day.id, schedule: newAttraction)
        schedules.append(newAttraction)
    }
}
