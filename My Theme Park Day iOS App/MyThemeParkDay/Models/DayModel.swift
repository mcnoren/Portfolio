//
//  DayModel.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/5/24.
//

import Foundation
import SwiftUI

//Immutable Struct
struct DayModel: Identifiable, Codable, Hashable{
    static func == (lhs: DayModel, rhs: DayModel) -> Bool {
        lhs.id == rhs.id
    }
    static func != (lhs: DayModel, rhs: DayModel) -> Bool {
        lhs.id != rhs.id
    }

    
    let id: String
    var title: String
    let parks: [String]
    let date: Date
    var scheduleList: [ScheduleModel]
    var currentPark: String
    var notes: String
    var photos: [Data?]
    var total_attraction_wait_time: Double
    var total_attraction_ride_time: Double
    var total_food_wait_time: Double
    var total_food_enjoy_time: Double
    var total_LL: Int
    var total_singleRider: Int
    var total_aborted_in_line: Int
    var total_show_time: Double
    var total_show_wait_time: Double
    var total_time: Double
    var number_of_attractions: Int
    var total_actual_minus_posted_wait: Double
    var total_time_saved_with_LL: Double
    var total_time_saved_with_singleRider: Double
    
    init(id: String = UUID().uuidString, date: Date = Date(), scheduleList: [ScheduleModel] = [], parks: [String], title: String, currentPark: String = "", notes: String = "", photos: [Data?] = [], total_attraction_wait_time: Double = 0, total_attraction_ride_time: Double = 0, total_food_wait_time: Double = 0, total_food_enjoy_time: Double = 0, total_LL: Int = 0, total_show_time: Double = 0, total_show_wait_time: Double = 0, total_time: Double = 0) {
        self.id = id
        self.parks = parks
        self.title = title
        self.date = date
        self.scheduleList = scheduleList
        self.currentPark = currentPark
        self.notes = notes
        self.photos = photos
        self.total_attraction_wait_time = total_attraction_wait_time
        self.total_attraction_ride_time = total_attraction_wait_time
        self.total_food_wait_time = total_food_wait_time
        self.total_food_enjoy_time = total_food_enjoy_time
        self.total_LL = total_LL
        self.total_singleRider = 0
        self.total_aborted_in_line = 0
        self.total_show_time = total_show_time
        self.total_show_wait_time = total_show_wait_time
        self.total_time = total_time
        self.number_of_attractions = 0
        self.total_actual_minus_posted_wait = 0
        self.total_time_saved_with_LL = 0
        self.total_time_saved_with_singleRider = 0
        
        self.calculateStats()
        self.scheduleList = get_scheduleList_sorted_by_start_time()
    }

    func append_scheduleList(schedule: ScheduleModel) -> DayModel {
        return DayModel(id: id, date: date, scheduleList: scheduleList + [schedule], parks: parks, title: title, currentPark: currentPark, notes: notes, photos: photos)
    }
    
    mutating func delete_schedule(schedule_id: String) {
        let index = scheduleList.firstIndex(where: { $0.id == schedule_id })
            self.scheduleList.remove(at: index!)
        
    }
    
    mutating func changeSchedule(schedule: ScheduleModel) {
        let index = scheduleList.firstIndex(where: { $0.id == schedule.id })
            self.scheduleList[index!] = schedule
        scheduleList = get_scheduleList_sorted_by_start_time()
        
    }
    
//    func enter_park(park: String, enter: Bool) -> DayModel {
//        var times = parkTimes
//        if enter {
//            times.append([park, enter, Date()])
//        }
//    }
    
    mutating func changeSchedulePhotos(schedule_id: String, photos: [Data?]) {
        let index = scheduleList.firstIndex(where: { $0.id == schedule_id })
        self.scheduleList[index!] = ScheduleModel(id: scheduleList[index!].id, event: scheduleList[index!].event, notes: scheduleList[index!].notes, LL: scheduleList[index!].LL, type: scheduleList[index!].type, startedWaiting: scheduleList[index!].startedWaiting, startedEvent: scheduleList[index!].startedEvent, endedEvent: scheduleList[index!].endedEvent, postedWait: scheduleList[index!].postedWait, photos: photos)
    }
    
    mutating func deleteSchedulePhoto(schedule_id: String, photo_index: Int) {
        let index = scheduleList.firstIndex(where: { $0.id == schedule_id })
            if photo_index >= 0 && photo_index < scheduleList[index!].photos.count {
                self.scheduleList[index!].photos.remove(at: photo_index)
            }
    }
    
    mutating func deleteDayPhoto(photo_index: Int) {
        photos.remove(at: photo_index)
    }
    
    func get_scheduleList() -> [ScheduleModel] {
        scheduleList
    }
    
    func get_scheduleList_sorted_by_wait_time() -> [ScheduleModel] {
        var list = scheduleList
        var sorted: [ScheduleModel] = []
        while list.count > 0 {
            var max_value: Double = 0
            var max_index: Int = 0
            for i in 0..<list.count {
                var wait: Double = 0
                if list[i].startedWaiting != nil {
                    if list[i].startedEvent != nil {
                        wait = list[i].startedEvent!.timeIntervalSince(list[i].startedWaiting!)
                    }
                    else if list[i].endedEvent != nil {
                        wait = list[i].endedEvent!.timeIntervalSince(list[i].startedWaiting!)
                    }
                }
                if wait > max_value {
                    max_value = wait
                    max_index = i
                }
            }
            if max_value == 0 {
                break
            }
            sorted.append(list[max_index])
            list.remove(at: max_index)
        }
        return sorted
    }
    
    func get_scheduleList_sorted_by_start_time() -> [ScheduleModel] {
        var list = scheduleList
        var sorted: [ScheduleModel] = []
        while list.count > 0 {
            var min_date: Date = Date()
            var min_index: Int = 0
            for i in 0..<list.count {
                var date: Date = Date()
                date = list[i].startedWaiting ?? list[i].startedEvent ?? list[i].endedEvent!
                if date < min_date {
                    min_date = date
                    min_index = i
                }
            }
            sorted.append(list[min_index])
            list.remove(at: min_index)
        }
        return sorted
    }
    
    func get_schedule(schedule_id: String) -> ScheduleModel {
        let schedule_index = scheduleList.firstIndex(where: {$0.id == schedule_id })
        return scheduleList[schedule_index!]
    }
    
    mutating func calculateStats() {
        self.total_attraction_wait_time = 0
        self.total_attraction_ride_time = 0
        self.total_food_wait_time = 0
        self.total_food_enjoy_time = 0
        self.total_LL = 0
        self.total_singleRider = 0
        self.total_aborted_in_line = 0
        self.total_show_time = 0
        self.total_show_wait_time = 0
        self.total_time = 0
        self.number_of_attractions = 0
        self.total_actual_minus_posted_wait = 0
        self.total_time_saved_with_LL = 0
        self.total_time_saved_with_singleRider = 0
        
        for schedule in scheduleList {
            if schedule.type == "Attraction" {
                self.number_of_attractions += 1
                if schedule.startedWaiting != nil && schedule.startedEvent != nil{
                    self.total_attraction_wait_time += schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!)
                    if !schedule.LL && !schedule.singleRider{
                        self.total_actual_minus_posted_wait += schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!) - Double(schedule.postedWait*60)
                    } else if !schedule.singleRider{
                        self.total_time_saved_with_LL += schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!) - Double(schedule.postedWait*60)
                    } else {
                        self.total_time_saved_with_singleRider += schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!) - Double(schedule.postedWait*60)
                    }
                }
                if schedule.startedEvent != nil && schedule.endedEvent != nil {
                    self.total_attraction_ride_time += schedule.endedEvent!.timeIntervalSince(schedule.startedEvent!)
                }
                if schedule.aborted && schedule.startedEvent == nil {
                    self.total_aborted_in_line += 1
                }
            }
            if schedule.type == "Food" {
                if schedule.startedWaiting != nil && schedule.startedEvent != nil{
                    self.total_food_wait_time += schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!)
                }
                if schedule.startedEvent != nil && schedule.endedEvent != nil {
                    self.total_food_enjoy_time += schedule.endedEvent!.timeIntervalSince(schedule.startedEvent!)
                }
            }
            if schedule.LL {
                self.total_LL += 1
            }
            if schedule.singleRider {
                self.total_singleRider += 1
            }
            if schedule.type == "Entertainment" {
                if schedule.startedWaiting != nil && schedule.startedEvent != nil {
                    self.total_show_wait_time += schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!)
                }
                if schedule.startedEvent != nil && schedule.endedEvent != nil {
                    self.total_show_time += schedule.endedEvent!.timeIntervalSince(schedule.startedEvent!)
                }
            }
        }
        self.total_time = self.total_attraction_wait_time + self.total_attraction_ride_time + self.total_food_wait_time
        self.total_time += self.total_food_enjoy_time + self.total_show_time + self.total_show_wait_time
    }
}
