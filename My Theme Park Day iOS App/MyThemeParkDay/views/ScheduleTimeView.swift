//
//  ScheduleTimeView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/10/24.
//

import SwiftUI

struct ScheduleTimeView: View {
    
    let schedule: ScheduleModel
    
    var body: some View {
        VStack {
            if schedule.type == "Attraction" {
                HStack {
                    Text("Posted Wait Time: ")
                        .padding(.leading, 20)
                        .padding(.top, 10)
                    Text("\(schedule.postedWait) min")
                        .padding(.top, 10)
                    Spacer()
                }
            }
            if schedule.startedWaiting != nil && (schedule.startedEvent != nil || schedule.aborted){
                HStack {
                    Text("Time Waited: ")
                        .padding(.leading, 20)
                        .padding(.top, schedule.type == "Attraction" ? 0 : 10)
                    if schedule.startedEvent != nil {
                        Text("\(Int(schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!))/60) min \(Int(schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!))%60) sec")
                            .padding(.top, schedule.type == "Attraction" ? 0 : 10)
                    } else {
                        Text("\(Int(schedule.endedEvent!.timeIntervalSince(schedule.startedWaiting!))/60) min \(Int(schedule.endedEvent!.timeIntervalSince(schedule.startedWaiting!))%60) sec")
                            .padding(.top, schedule.type == "Attraction" ? 0 : 10)
                    }
                    Spacer()
                }
            }
            HStack {
                Text("Time Enjoyed: ")
                    .padding(.leading, 20)
                    .padding(.top, schedule.startedWaiting == nil ? 10 : 0)
                if schedule.startedWaiting != nil && schedule.startedEvent != nil && schedule.endedEvent != nil {
                    Text("\(Int(schedule.endedEvent!.timeIntervalSince(schedule.startedEvent!))/60) min \(Int(schedule.endedEvent!.timeIntervalSince(schedule.startedEvent!))%60) sec")
                        .padding(.top, schedule.startedWaiting == nil ? 10 : 0)
                }
                Spacer()
            }
            if schedule.startedWaiting != nil && schedule.startedWaiting != nil{
                HStack {
                    Text("Total Time Spent: ")
                        .padding(.leading, 20)
                    if schedule.endedEvent != nil {
                        Text("\(Int(schedule.endedEvent!.timeIntervalSince(schedule.startedWaiting!))/60) min \(Int(schedule.endedEvent!.timeIntervalSince(schedule.startedWaiting!))%60) sec")
                    }
                    Spacer()
                }
                if schedule.type == "Attraction" {
                    HStack {
                        Text(schedule.LL ? "Time Saved with LL: " : "Acutal - Posted Wait: ")
                            .padding(.leading, 20)
                        if schedule.startedEvent != nil {
                            let waited = schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!)
                            Text("\(Int((waited - Double(schedule.postedWait*60)))/60) min \(abs(Int((waited - Double(schedule.postedWait*60)))%60)) sec")
                                .foregroundStyle(waited - Double(schedule.postedWait*60) > 0 ? .red : .green)
                        }
                        Spacer()
                    }
                }
                
                if schedule.startedWaiting != nil && schedule.startedEvent != nil && schedule.endedEvent != nil{
                    HStack {
                        Text("Percent enjoyed: ")
                            .padding(.leading, 20)
                        if schedule.endedEvent != nil {
                            Text("\(schedule.endedEvent!.timeIntervalSince(schedule.startedEvent!)/(schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!) + schedule.endedEvent!.timeIntervalSince(schedule.startedEvent!)) * 100, specifier: "%.2f")%")
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

