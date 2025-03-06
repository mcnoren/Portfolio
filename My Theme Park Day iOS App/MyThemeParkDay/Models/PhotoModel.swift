//
//  PhotoModel.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/19/24.
//

import Foundation

struct PhotoModel: Identifiable, Codable, Hashable{
    let id: String
    let day_id: String
    let schedule_id: String
    var photos: [Data?]
    
    init(id: String = UUID().uuidString, day_id: String, schedule_id: String = "", photos: [Data?] = []) {
        self.id = id
        self.day_id = day_id
        self.schedule_id = schedule_id
        self.photos = photos
    }
}
