//
//  SwiftUIView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/14/24.
//

import SwiftUI
import Charts

struct ScheduleChartView: View {
    
    let schedule: ScheduleModel
    
    var body: some View {
        if schedule.startedEvent != nil && schedule.startedWaiting != nil && schedule.endedEvent != nil{
            
            Chart{
                SectorMark(angle: .value("Time", schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!))
                ).foregroundStyle(Color(.lightGray))
                if schedule.endedEvent != nil {
                    SectorMark(angle: .value("Time", schedule.endedEvent!.timeIntervalSince(schedule.startedEvent!))
                    ).foregroundStyle(Color(.blue))
                }
            }
            .frame(height: 150)
            .chartForegroundStyleScale([
                "Enjoyed": Color(.blue),
                "Waited": Color(.lightGray)
                ])
            .padding()
            
//            Chart {
//                RuleMark(x: .value("0", 0))
//                    .foregroundStyle(.black)
//                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
//                
//                let waited = schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!) / 60
//                BarMark (x: .value("Time Over", waited - Double(schedule.postedWait)),
//                         y: .value("Name", schedule.event.name + (schedule.LL ? " (LL)" : "") + (schedule.singleRider ? " (S)" : "")))
//                .foregroundStyle(schedule.ride_broke_in_line ? .gray : waited - Double(schedule.postedWait) > 0 ? .red : .green)
//            }
//            .frame(height: 90)
//            .chartXScale(domain: (schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!) / 60 - Double(schedule.postedWait) > -10 ? -10 : schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!) / 60 - Double(schedule.postedWait))...(schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!) / 60 - Double(schedule.postedWait) < 10 ? 10 : schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!) / 60 - Double(schedule.postedWait)))
//            .padding([.leading, .bottom, .trailing])
//            .chartForegroundStyleScale([
//                "Under Posted": Color(.green),
//                "Over Posted": Color(.red),
//                "Broke Down": Color(.gray)
//            ])
        }
    }
    
    
}


