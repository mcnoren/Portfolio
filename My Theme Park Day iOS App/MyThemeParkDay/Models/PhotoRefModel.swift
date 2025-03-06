//
//  PhotoRefModel.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/31/24.
//

import Foundation

struct PhotoRefModel: Identifiable, Codable, Hashable{
    let id: String
    let day_id: String
    let schedule_id: String
    var photos: [String]
    
    init(id: String = UUID().uuidString, day_id: String, schedule_id: String = "", photos: [String] = []) {
        self.id = id
        self.day_id = day_id
        self.schedule_id = schedule_id
        self.photos = photos
    }
}
