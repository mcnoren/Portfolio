//
//  TimeView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/9/24.
//

import SwiftUI

struct TimeView: View {
    
    let date: Date
    let calendar = Calendar.current
    
    var body: some View {
        if(calendar.component(.hour, from: date) == 0) {
            if(calendar.component(.minute, from: date) < 10) {
                if(calendar.component(.hour, from: date) < 12) {
                    Text("12:0" + String(calendar.component(.minute, from: date)) + String(" AM"))
                }
            } else {
                if(calendar.component(.hour, from: date) < 12) {
                    Text("12:" + String(calendar.component(.minute, from: date)) + String(" AM"))
                }
            }
        } else if(calendar.component(.hour, from: date) < 13) {
            if(calendar.component(.minute, from: date) < 10) {
                if(calendar.component(.hour, from: date) < 12) {
                    Text(String(calendar.component(.hour, from: date) % 13) + ":0" + String(calendar.component(.minute, from: date)) + String(" AM"))
                } else {
                    Text(String(calendar.component(.hour, from: date) % 13) + ":0" + String(calendar.component(.minute, from: date)) + String(" PM"))
                }
            } else {
                if(calendar.component(.hour, from: date) < 12) {
                    Text(String(calendar.component(.hour, from: date) % 13) + ":" + String(calendar.component(.minute, from: date)) + String(" AM"))
                } else {
                    Text(String(calendar.component(.hour, from: date) % 13) + ":" + String(calendar.component(.minute, from: date)) + String(" PM"))
                }
            }
        } else {
            if(calendar.component(.minute, from: date) < 10) {
                if(calendar.component(.hour, from: date) < 12) {
                    Text(String(calendar.component(.hour, from: date) % 13 + 1) + ":0" + String(calendar.component(.minute, from: date)) + String(" AM"))
                } else {
                    Text(String(calendar.component(.hour, from: date) % 13 + 1) + ":0" + String(calendar.component(.minute, from: date)) + String(" PM"))
                }
            } else {
                if(calendar.component(.hour, from: date) < 12) {
                    Text(String(calendar.component(.hour, from: date) % 13 + 1) + ":" + String(calendar.component(.minute, from: date)) + String(" AM"))
                } else {
                    Text(String(calendar.component(.hour, from: date) % 13 + 1) + ":" + String(calendar.component(.minute, from: date)) + String(" PM"))
                }
            }
        }
    }
}


