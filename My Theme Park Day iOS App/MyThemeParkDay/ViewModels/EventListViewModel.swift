//
//  AttractionsListViewModel.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/6/24.
//

import Foundation

class EventListViewModel: ObservableObject {
    
    @Published var events: [EventModel] = [] {
        didSet {
            saveEvents()
        }
    }
    @Published var parks: [String] = [] {
        didSet {
            saveParks()
        }
    }
    
    let eventsKey: String = "events_list"
    let parksKey: String = "parks_list"
    
    init() {
        getEvents()
        getParks()
    }
    
    func getEvents() {
        guard
            let data = UserDefaults.standard.data(forKey: eventsKey),
            let savedEvents = try? JSONDecoder().decode([EventModel].self, from: data)
        else { return }
        
        self.events = savedEvents
    }
    
    func addEvents(newEvents: [EventModel]) {
        events += newEvents
    }
    
    func deleteAttraction(indexSet: IndexSet) {
        events.remove(atOffsets: indexSet)
    }
    
    func moveAttraction(from: IndexSet, to: Int) {
        events.move(fromOffsets: from, toOffset: to)
    }
    
    func deleteEvent(park: String, name: String) {
        let index = events.firstIndex(where: { $0.park == park && $0.name == name })
        if index != nil {
            events.remove(at: index!)
        }
    }
    
    func getParks() {
        guard
            let data = UserDefaults.standard.data(forKey: parksKey),
            let savedParks = try? JSONDecoder().decode([String].self, from: data)
        else { return }
        
        self.parks = savedParks
    }
    
    func saveParks() {
        if let encodedData = try? JSONEncoder().encode(parks) {
            UserDefaults.standard.set(encodedData, forKey: parksKey)
        }
    }
    
    func addPark(parkName: String) {
        if parks.contains(parkName) {
            deletePark(parkName: parkName)
        }
        parks.append(parkName)
    }
    
    func deletePark(parkName: String) {
        parks.remove(at: parks.firstIndex(where: { $0 == parkName } )!)
        while events.firstIndex(where: { ($0.park == parkName) }) != nil {
            events.remove(at: events.firstIndex(where: { ($0.park == parkName) })!)
        }
    }
    
    func movePark(from: IndexSet, to: Int) {
        parks.move(fromOffsets: from, toOffset: to)
    }
    
    func eventsForPark(parkName: String) -> [EventModel] {
        var parkEvents: [EventModel] = []
        for event in events {
            if event.park == parkName {
                parkEvents.append(event)
            }
        }
        return parkEvents
    }
    
    func getEventTypes(parkName: String) -> [String] {
        var types: [String] = []
        for event in events {
            if event.park == parkName && !types.contains(event.type) {
                types.append(event.type)
            }
        }
        return types
    }
    
    func textToEvents(eventsCVS: String) -> [EventModel] {
        // turns an eventCSV into a events
        var newEvents: [EventModel] = []
        var lines = eventsCVS.split(whereSeparator: \.isNewline)
//        var test: [String] = []
//        test.append(eventsCVS)
//        print(test)
//        print(lines)
        lines.remove(at: 0)
        for line in lines {
            let values = line.split(separator: ",")
            if values.count >= 4 {
                var trimmed_values: [String] = []
                for value in values {
                    let trimmed_value = value.trimmingCharacters(in: .whitespaces)
                    trimmed_values.append(trimmed_value)
                }
                var newEvent: EventModel
                if trimmed_values.count >= 6 && Double(trimmed_values[4]) != nil && Double(trimmed_values[5]) != nil {
                    newEvent = EventModel(name: trimmed_values[0], park: "", land: "", LL: trimmed_values[2].lowercased() == "true" ? true : false, type: ["Attraction", "Food", "Entertainment", "Character Meet & Greet"].contains(trimmed_values[1]) ? trimmed_values[1] : "Other", singleRider: trimmed_values[3].lowercased() == "true" ? true : false, latitude: Double(trimmed_values[4]), longitude: Double(trimmed_values[5]))
                } else {
                    newEvent = EventModel(name: trimmed_values[0], park: "", land: "", LL: trimmed_values[2].lowercased() == "true" ? true : false, type: ["Attraction", "Food", "Entertainment", "Character Meet & Greet"].contains(trimmed_values[1]) ? trimmed_values[1] : "Other", singleRider: trimmed_values[3].lowercased() == "true" ? true : false)
                }
                newEvents.append(newEvent)
            }
        }
//        for event in newEvents {
//            if event.longitude != nil && event.latitude != nil {
//                print(event.longitude! + event.latitude!)
//            }
//        }
        return newEvents
    }
    func saveEvents() {
        if let encodedData = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encodedData, forKey: eventsKey)
        }
    }
    
    func hasLocationData(parkName: String) -> Bool {
        var hasLocation: Bool = false
        for event in eventsForPark(parkName: parkName) {
            if event.latitude != nil {
                hasLocation = true
            }
        }
        return hasLocation
    }
}
