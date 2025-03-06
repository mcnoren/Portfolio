//
//  AttractionModel.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/6/24.
//

import Foundation

//Immutable Struct

    struct EventModel:Identifiable, Codable, Hashable {
        let id: String
        let name: String
        let park: String
        let land: String
        let LL: Bool
        let type: String
        let singleRider: Bool
        let latitude: Double?
        let longitude: Double?
        
        init(id: String = UUID().uuidString, name: String, park: String, land: String, LL: Bool = false,
             type: String, singleRider: Bool = false, latitude: Double? = nil, longitude: Double? = nil) {
            
            self.id = id
            self.name = name
            self.park = park
            self.land = land
            self.LL = LL
            self.type = type
            self.singleRider = singleRider
            self.latitude = latitude
            self.longitude = longitude
        }
    }
