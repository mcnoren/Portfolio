//
//  ScheduleLLView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/10/24.
//

import SwiftUI

struct ScheduleLLView: View {
    
    let schedule: ScheduleModel
    
    var body: some View {
        
        if(schedule.LL) {
            HStack {
                let postedWaitSeconds = schedule.postedWait*60
                Text("Time Saved: ")
                    .padding(.leading, 20)
                if schedule.endedEvent != nil {
                    Text("\((postedWaitSeconds-Int(schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!)))/60) min \((postedWaitSeconds-Int(schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!)))%60) sec")
                }
                Spacer()
            }
        }
    }
}

