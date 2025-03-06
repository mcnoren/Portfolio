//
//  ScheduleInfoView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/10/24.
//

import SwiftUI

struct ScheduleInfoView: View {
    
    let schedule: ScheduleModel
    
    var body: some View {
        
        HStack {
            Text("Park: \(schedule.event.park)")
                .padding(.horizontal, 20)
            Spacer()
        }
        HStack {
            Text("Type: \(schedule.type)")
                .padding(.horizontal, 20)
            Spacer()
        }
        
    }
}
