//
//  ScheduleModel.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/8/24.
//

import Foundation

struct ScheduleModel: Identifiable, Codable, Hashable{
    let id: String
    var event: EventModel
    var type: String
    var notes: String
    var LL: Bool
    var startedWaiting: Date?
    var startedEvent: Date?
    var endedEvent: Date?
    var postedWait: Int //minutes
    var photos: [Data?]
    var singleRider: Bool
    var ride_broke_in_line: Bool
    var ride_broke_on_ride: Bool
    var aborted: Bool
    
    
    init(id: String = UUID().uuidString, event: EventModel, notes: String = "", LL: Bool = false, type: String = "Attraction", startedWaiting: Date? = nil, startedEvent: Date? = nil, endedEvent: Date? = nil, postedWait: Int, photos: [Data?] = [], singleRider: Bool = false, ride_broke_in_line: Bool = false, ride_broke_on_ride: Bool = false, aborted: Bool = false)
    {
        self.id = id
        self.event = event
        self.notes = notes
        self.LL = LL
        self.type = type
        self.startedWaiting = startedWaiting
        self.startedEvent = startedEvent
        self.endedEvent = endedEvent
        self.postedWait = postedWait
        self.photos = photos
        self.singleRider = singleRider
        self.ride_broke_in_line = ride_broke_in_line
        self.ride_broke_on_ride = ride_broke_on_ride
        self.aborted = aborted
    }
    
}
