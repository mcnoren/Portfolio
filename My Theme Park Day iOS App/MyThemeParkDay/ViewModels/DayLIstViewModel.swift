//
//  DayLIstViewModel.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/5/24.
//

import Foundation

class DayListViewModel: ObservableObject {
    
    @Published var days: [DayModel] = [] {
        didSet {
            saveDays()
        }
    }
    @Published var day_ids: [String] = [] {
        didSet {
            saveDays()
        }
    }
    
    
    let daysKey: String = "days_list"
    let calendar = Calendar.current
    
    init() {
        getDays()
    }
    
    func getDays() {
//        let newItems = [
//            ItemModel(title: "This is the first title!", isCompleted: false),
//            ItemModel(title: "This is the second!", isCompleted: true),
//            ItemModel(title: "Third!", isCompleted: false)
//        ]
//        items.append(contentsOf: newItems)
        guard
            let data = UserDefaults.standard.data(forKey: daysKey),
            let savedDays = try? JSONDecoder().decode([DayModel].self, from: data)
        else { return }
        
        self.days = savedDays
    }
    
    func deleteDay(day_id: String) {
        if let index = days.firstIndex(where: { $0.id == day_id }) {
            days.remove(at: index)
        }
    }
    
    func moveDay(from: IndexSet, to: Int) {
        days.move(fromOffsets: from, toOffset: to)
    }
    
    func addDay(id: String, parks: [String], title: String, date: Date = Date()) {
        let newDay = DayModel(id: id, date: date, parks: parks, title: title)
        days.insert(newDay, at: 0)
    }
    
    func append_scheduleList(day_id: String, schedule: ScheduleModel) {
        
        //        if let index = items.firstIndex { (existingItem) -> Bool in
        //            return existingItem.id == item.id
        //        } {
        //            ///run this code
        //        }
                
        if let index = days.firstIndex(where: { $0.id == day_id }) {
            days[index].scheduleList.append(schedule)
            days[index].scheduleList = days[index].get_scheduleList_sorted_by_start_time()
        }
    }
    
    func change_day_title(day_id: String, title: String) {
        if let index = days.firstIndex(where: { $0.id == day_id }) {
            days[index].title = title
        }
    }
    
    func delete_schedule(day_id: String, schedule_id: String) {
        if let index = days.firstIndex(where: { $0.id == day_id }) {
            days[index].delete_schedule(schedule_id: schedule_id)
        }
    }
    
    func change_schedule(day_id: String, new_schedule: ScheduleModel) {
        if let index = days.firstIndex(where: { $0.id == day_id }) {
            days[index].changeSchedule(schedule: new_schedule)
        }
    }
    
    func change_schedule_notes(day_id: String, schedule_id: String, notes: String) {
        if let index = days.firstIndex(where: { $0.id == day_id }) {
            if let index_s = days[index].scheduleList.firstIndex(where: { $0.id == schedule_id }) {
                days[index].scheduleList[index_s].notes = notes
            }
        }
    }
    func change_schedule_LL(day_id: String, schedule_id: String, LL: Bool = false) {
        if let index = days.firstIndex(where: { $0.id == day_id }) {
            if let index_s = days[index].scheduleList.firstIndex(where: { $0.id == schedule_id }) {
                days[index].scheduleList[index_s].LL = LL
            }
        }
    }
    func change_schedule_startedWaiting(day_id: String, schedule_id: String, startedWaiting: Date? = nil) {
        if let index = days.firstIndex(where: { $0.id == day_id }) {
            if let index_s = days[index].scheduleList.firstIndex(where: { $0.id == schedule_id }) {
                days[index].scheduleList[index_s].startedWaiting = startedWaiting
            }
        }
    }
    func change_schedule_startedEvent(day_id: String, schedule_id: String, startedEvent: Date? = nil) {
        if let index = days.firstIndex(where: { $0.id == day_id }) {
            if let index_s = days[index].scheduleList.firstIndex(where: { $0.id == schedule_id }) {
                days[index].scheduleList[index_s].startedEvent = startedEvent
            }
        }
    }
    func change_schedule_endedEvent(day_id: String, schedule_id: String, endedEvent: Date? = nil) {
        if let index = days.firstIndex(where: { $0.id == day_id }) {
            if let index_s = days[index].scheduleList.firstIndex(where: { $0.id == schedule_id }) {
                days[index].scheduleList[index_s].endedEvent = endedEvent
            }
        }
    }
    
    func aborted(day_id: String, schedule_id: String, ride_broke_in_line: Bool = false, ride_broke_on_ride: Bool = false) {
        if let index = days.firstIndex(where: { $0.id == day_id }) {
            if let index_s = days[index].scheduleList.firstIndex(where: { $0.id == schedule_id }) {
                days[index].scheduleList[index_s].aborted = true
                days[index].scheduleList[index_s].ride_broke_in_line = ride_broke_in_line
                days[index].scheduleList[index_s].ride_broke_on_ride = ride_broke_on_ride
            }
        }
    }
    
    func add_schedule_photo(day_id: String, schedule_id: String, photo: Data?) {
        if let index = days.firstIndex(where: { $0.id == day_id }) {
            if let index_s = days[index].scheduleList.firstIndex(where: { $0.id == schedule_id }) {
                days[index].scheduleList[index_s].photos.append(photo)
            }
        }
    }
    
    
    func delete_schedule_photo(day_id: String, schedule_id: String, photo_index: Int) {
        if let index = days.firstIndex(where: { $0.id == day_id }) {
            days[index].deleteSchedulePhoto(schedule_id: schedule_id, photo_index: photo_index)
        }
    }
    
    func add_day_photo(day_id: String, photo: Data?) {
        if let index = days.firstIndex(where: { $0.id == day_id }) {
            days[index].photos.append(photo)
        }
    }
    
    func delete_day_photo(day_id: String, photo_index: Int) {
        if let index = days.firstIndex(where: { $0.id == day_id }) {
            days[index].deleteDayPhoto(photo_index: photo_index)
        }
    }
    
    func change_day_notes(day_id: String, notes: String) {
        if let index = days.firstIndex(where: { $0.id == day_id }) {
            days[index].notes = notes
        }
    }
    
    func get_day(day_id: String) -> DayModel {
        let index = days.firstIndex(where: { $0.id == day_id })
            return days[index!]
    }
    
    func get_schedule(day_id: String, schedule_id: String) -> ScheduleModel {
        let index = days.firstIndex(where: { $0.id == day_id })
            let schedule_index = days[index!].scheduleList.firstIndex(where: {$0.id == schedule_id })
                return days[index!].scheduleList[schedule_index!]
    }
    
    func saveDays() {
        if let encodedData = try? JSONEncoder().encode(days) {
            UserDefaults.standard.set(encodedData, forKey: daysKey)
//            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let url = documents.appendingPathComponent("day_ids")
//            
//            do {
//                // Write to Disk
//                let d = try PropertyListEncoder().encode(day_ids)
//                try d.write(to: url)
//                
//            } catch {
//                print("Unable to Write Data to Disk (\(error))")
//            }
//            
//            do {
//                // Write to Disk
//
//            }
        }
    }
    
    func containsCurrentDay() -> Bool{
        let current_month = String(calendar.component(.month, from: Date()))
        let current_day = String(calendar.component(.day, from: Date()))
        if days.firstIndex(where: { String(calendar.component(.month, from: $0.date)) == current_month && String(calendar.component(.day, from: $0.date)) == current_day}) != nil {
            return true
        }
        return false
    }
    
    func canEnterPark(day_id: String) -> Bool {
        if let index = days.firstIndex(where: { $0.id == day_id }) {
            for schedule in days[index].scheduleList {
                if schedule.endedEvent == nil {
                    return false
                }
            }
            return true
        }
        return false
    }
    
    func enterPark(day: DayModel, park: String) {
        if let index = days.firstIndex(where: { $0.id == day.id }) {
            days[index].scheduleList.append(ScheduleModel(event: EventModel(name: days[index].currentPark.isEmpty ? "Entered \(park)" : "Exited \(days[index].currentPark)", park: days[index].currentPark.isEmpty ? park : days[index].currentPark, land: "", type: "Entry"), type: "Entry", endedEvent: Date(), postedWait: 0))
            days[index].currentPark = park
            days[index].scheduleList = days[index].get_scheduleList_sorted_by_start_time()
        }
    }
    
    func calculateStats(day_id: String) {
        if let index = days.firstIndex(where: { $0.id == day_id }) {
            days[index].calculateStats()
        }
    }
}
