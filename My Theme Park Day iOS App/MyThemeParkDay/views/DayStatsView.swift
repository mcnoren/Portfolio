//
//  DayStatsView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/16/24.
//

import SwiftUI
import Charts
import MapKit

struct DayStatsView: View {
    
    @EnvironmentObject var dayListViewModel: DayListViewModel
    @State var day: DayModel
    @State var camera: MapCameraPosition = .automatic
    @State var orderNumber: Int = 1
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Total ride wait: \(Int(dayListViewModel.get_day(day_id: day.id).total_attraction_wait_time)/60) min \(Int(dayListViewModel.get_day(day_id: day.id).total_attraction_wait_time)%60) sec")
                        .padding(.leading, 20)
                        .padding(.top, 10)
                    Spacer()
                }
                HStack {
                    Text("Total ride time: \(Int(dayListViewModel.get_day(day_id: day.id).total_attraction_ride_time)/60) min \(Int(dayListViewModel.get_day(day_id: day.id).total_attraction_ride_time)%60) sec")
                        .padding(.leading, 20)
                    Spacer()
                }
                HStack {
                    Text("Total actual - posted wait: ")
                        .padding(.leading, 20)
                    Text("\(Int(dayListViewModel.get_day(day_id: day.id).total_actual_minus_posted_wait)/60) min \(abs(Int(dayListViewModel.get_day(day_id: day.id).total_actual_minus_posted_wait)%60)) sec")
                        .foregroundStyle(dayListViewModel.get_day(day_id: day.id).total_actual_minus_posted_wait > 0 ? .red : .green)
                    Spacer()
                }
                if dayListViewModel.get_day(day_id: day.id).number_of_attractions > 0 {
                    HStack {
                        Text("Average actual - posted wait: ")
                            .padding(.leading, 20)
                        Text("\(Int(dayListViewModel.get_day(day_id: day.id).total_actual_minus_posted_wait)/dayListViewModel.get_day(day_id: day.id).number_of_attractions/60) min \(abs(Int(dayListViewModel.get_day(day_id: day.id).total_actual_minus_posted_wait)/dayListViewModel.get_day(day_id: day.id).number_of_attractions%60)) sec")
                            .foregroundStyle(dayListViewModel.get_day(day_id: day.id).total_actual_minus_posted_wait > 0 ? .red : .green)
                        Spacer()
                    }
                }
                if dayListViewModel.get_day(day_id: day.id).total_LL > 0 {
                    HStack {
                        Text("Total time saved with LL: ")
                            .padding(.leading, 20)
                        Text("\(Int(dayListViewModel.get_day(day_id: day.id).total_time_saved_with_LL)/60) min \(abs(Int(dayListViewModel.get_day(day_id: day.id).total_time_saved_with_LL)%60)) sec")
                            .foregroundStyle(dayListViewModel.get_day(day_id: day.id).total_time_saved_with_LL > 0 ? .red : .green)
                        Spacer()
                    }
                }
                if dayListViewModel.get_day(day_id: day.id).total_singleRider > 0 {
                    HStack {
                        Text("Total time saved with S: ")
                            .padding(.leading, 20)
                        Text("\(Int(dayListViewModel.get_day(day_id: day.id).total_time_saved_with_singleRider)/60) min \(abs(Int(dayListViewModel.get_day(day_id: day.id).total_time_saved_with_singleRider)%60)) sec")
                            .foregroundStyle(dayListViewModel.get_day(day_id: day.id).total_time_saved_with_singleRider > 0 ? .red : .green)
                        Spacer()
                    }
                }
                HStack {
                    Text("# of Attractions: \(dayListViewModel.get_day(day_id: day.id).number_of_attractions)")
                        .padding(.leading, 20)
                    Spacer()
                }
                HStack {
                    Text("# of LL: \(dayListViewModel.get_day(day_id: day.id).total_LL)")
                        .padding(.leading, 20)
                    Spacer()
                }
                HStack {
                    Text("# of Single Riders: \(dayListViewModel.get_day(day_id: day.id).total_singleRider)")
                        .padding(.leading, 20)
                    Spacer()
                }
                
                
//                HStack {
//                    Text("Total meal wait: \(Int(day.total_food_wait_time)/60) min \(Int(dayListViewModel.get_day(day_id: day.id).total_food_wait_time)%60) sec")
//                        .padding(.leading, 20)
//                        .padding(.top, 10)
//                    Spacer()
//                }
//                HStack {
//                    Text("Total meal time: \(Int(day.total_food_enjoy_time)/60) min \(Int(dayListViewModel.get_day(day_id: day.id).total_food_enjoy_time)%60) sec")
//                        .padding(.leading, 20)
//                    Spacer()
//                }
                if dayListViewModel.get_day(day_id: day.id).total_attraction_wait_time > 0 || dayListViewModel.get_day(day_id: day.id).total_food_wait_time > 0 || dayListViewModel.get_day(day_id: day.id).total_show_wait_time > 0 || dayListViewModel.get_day(day_id: day.id).total_show_time > 0 || dayListViewModel.get_day(day_id: day.id).total_food_enjoy_time > 0 || dayListViewModel.get_day(day_id: day.id).total_attraction_ride_time > 0 {
                    Chart {
                        SectorMark(angle: .value("Time",
                                                 dayListViewModel.get_day(day_id: day.id).total_attraction_wait_time + dayListViewModel.get_day(day_id: day.id).total_food_wait_time + dayListViewModel.get_day(day_id: day.id).total_show_wait_time))
                        .foregroundStyle(Color(.lightGray))
                        //                    .annotation(position: .overlay) {
                        //                        if dayListViewModel.get_day(day_id: day.id).total_attraction_wait_time > 0 || dayListViewModel.get_day(day_id: day.id).total_food_wait_time > 0 || dayListViewModel.get_day(day_id: day.id).total_show_wait_time > 0 {
                        //                            Text("\((dayListViewModel.get_day(day_id: day.id).total_attraction_wait_time + dayListViewModel.get_day(day_id: day.id).total_food_wait_time) / (dayListViewModel.get_day(day_id: day.id).total_time) * 100, specifier: "%.1f")%")
                        //                        }
                        //                    }
                        SectorMark(angle: .value("Time",
                                                 dayListViewModel.get_day(day_id: day.id).total_show_time))
                        .foregroundStyle(Color(.red))
                        //                    .annotation(position: .overlay) {
                        //                        if dayListViewModel.get_day(day_id: day.id).total_show_time > 0 {
                        //                            Text("\((dayListViewModel.get_day(day_id: day.id).total_show_time) / (dayListViewModel.get_day(day_id: day.id).total_time) * 100, specifier: "%.1f")%")
                        //                        }
                        //                    }
                        SectorMark(angle: .value("Time",
                                                 dayListViewModel.get_day(day_id: day.id).total_food_enjoy_time))
                        .foregroundStyle(Color(.yellow))
                        //                    .annotation(position: .overlay) {
                        //                        if dayListViewModel.get_day(day_id: day.id).total_food_enjoy_time > 0 {
                        //                            Text("\((dayListViewModel.get_day(day_id: day.id).total_food_enjoy_time) / (dayListViewModel.get_day(day_id: day.id).total_time) * 100, specifier: "%.1f")%")
                        //                        }
                        //                    }
                        SectorMark(angle: .value("Time",
                                                 dayListViewModel.get_day(day_id: day.id).total_attraction_ride_time))
                        .foregroundStyle(Color(.blue))
                        //                    .annotation(position: .automatic) {
                        //                        if dayListViewModel.get_day(day_id: day.id).total_attraction_ride_time > 0 {
                        //                            Text("\((dayListViewModel.get_day(day_id: day.id).total_attraction_ride_time) / (dayListViewModel.get_day(day_id: day.id).total_time) * 100, specifier: "%.1f")%")
                        //                        }
                        //                    }
                    }
                    .frame(height: 200)
                    .padding()
                    .chartForegroundStyleScale([
                        "Attractions": Color(.blue),
                        "Meals": Color(.yellow),
                        "Entertainment": Color(.red),
                        "Waiting": Color(.lightGray)
                    ])
                }
                if dayListViewModel.get_day(day_id: day.id).number_of_attractions > 0 {
                    Text("Actual - Posted Wait Times")
                        .font(.title3)
                        .padding(.top, 20)
                    
                    ForEach(dayListViewModel.get_day(day_id: day.id).scheduleList, id: \.self) { event in
                        if event.startedWaiting != nil && event.startedEvent != nil && event.type == "Attraction" {
                            Chart() {
                                RuleMark(x: .value("0", 0))
                                    .foregroundStyle(.black)
                                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                                
                                let waited = event.startedEvent!.timeIntervalSince(event.startedWaiting!) / 60
                                BarMark (x: .value("Time Over", waited - Double(event.postedWait)),
                                         y: .value("Name", event.event.name + (event.LL ? " (LL)" : "") + (event.singleRider ? " (S)" : "")))
                                .foregroundStyle(event.ride_broke_in_line ? .gray : waited - Double(event.postedWait) > 0 ? .red : .green)
                            }
                            .frame(height: 70)
                            .chartXScale(domain: get_min_wait_diff()...get_max_wait_diff())
                            .padding([.leading, .trailing])
                        }
                    }
                    Chart {
                        
                    }
                    .frame(height: 0)
                    .chartForegroundStyleScale([
                        "Under Posted": Color(.green),
                        "Over Posted": Color(.red),
                        "Broke Down": Color(.gray)
                    ])
                    .padding([.leading, .bottom, .trailing])
                }
                
                if dayListViewModel.get_day(day_id: day.id).number_of_attractions > 0 {
                    Text("Events Sorted by Wait Time:")
                        .font(.title3)
                        .padding(.top, 40)
                        .padding(.bottom, 10)
                    ForEach(dayListViewModel.get_day(day_id: day.id).get_scheduleList_sorted_by_wait_time(), id: \.self) { schedule in
                        HStack {
                            if schedule.startedEvent != nil {
                                Text("\(Int(schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!))/60) min ")
                                    .font(.callout)
                                    .padding(.leading, 20)
                            } else {
                                Text("\(Int(schedule.endedEvent!.timeIntervalSince(schedule.startedWaiting!))/60) min ")
                                    .font(.callout)
                                    .padding(.leading, 20)
                            }
                            Text("\(schedule.event.name)")
                            if(schedule.LL) {
                                Text("LL")
                                    .font(.system(size: 24, weight: .heavy))
                                    .italic()
                                    .foregroundColor(.blue)
                                    .padding(.leading, 5)
                            }
                            if schedule.singleRider {
                                Text("S")
                                    .font(.system(size: 24, weight: .heavy))
                                    .italic()
                                    .foregroundColor(.blue)
                                    .padding(.leading, 5)
                            }
                            Spacer()
                        }
                        .padding(.bottom, 4)
                    }
                }
                Map(position: $camera) {
                    ForEach(0..<dayListViewModel.get_day(day_id: day.id).scheduleList.count) { i in
                        if dayListViewModel.get_day(day_id: day.id).scheduleList[i].event.latitude != nil && dayListViewModel.get_day(day_id: day.id).scheduleList[i].event.longitude != nil {
                            Annotation(dayListViewModel.get_day(day_id: day.id).scheduleList[i].event.name, coordinate: CLLocationCoordinate2D(latitude: dayListViewModel.get_day(day_id: day.id).scheduleList[i].event.latitude!, longitude: dayListViewModel.get_day(day_id: day.id).scheduleList[i].event.longitude!)) {
                                OrderMapAnnotationView(event: dayListViewModel.get_day(day_id: day.id).scheduleList[i].event, orderNumber: getOrderNumber(index: i))
                            }
                        }
                    }
                }
                .padding(20)
                .frame(height: 300)
                .mapStyle(.imagery)
                
                Spacer(minLength: 50)
            }
            .onAppear(perform: {
                self.day = dayListViewModel.get_day(day_id: day.id)
            })
        }
    }
    
    func get_min_wait_diff() -> Double{
        var min: Double = -10
        for schedule in dayListViewModel.get_day(day_id: day.id).scheduleList {
            if schedule.startedWaiting != nil && schedule.startedEvent != nil && schedule.type == "Attraction" {
                if schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!)/60 - Double(schedule.postedWait) < min {
                    min = schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!)/60 - Double(schedule.postedWait)
                }
            }
        }
        return min
    }
    
    func get_max_wait_diff() -> Double{
        var max: Double = 10
        for schedule in dayListViewModel.get_day(day_id: day.id).scheduleList {
            if schedule.startedWaiting != nil && schedule.startedEvent != nil && schedule.type == "Attraction" {
                if schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!)/60 - Double(schedule.postedWait) > max {
                    max = schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!)/60 - Double(schedule.postedWait)
                }
            }
        }
        return max
    }
    
    func getOrderNumber(index: Int) -> String {
        var num = 1
        var counts = ""
        var name = dayListViewModel.get_day(day_id: day.id).scheduleList[index].event.name
        var latitude = dayListViewModel.get_day(day_id: day.id).scheduleList[index].event.latitude
        var longitude = dayListViewModel.get_day(day_id: day.id).scheduleList[index].event.longitude
        for schedule in dayListViewModel.get_day(day_id: day.id).scheduleList {
            if schedule.event.name == name && schedule.event.latitude == latitude && schedule.event.longitude == longitude{
                if counts.isEmpty {
                    counts += String(num)
                } else {
                    counts += ", " + String(num)
                }
                num += 1
            } else if schedule.event.latitude != nil && schedule.event.longitude != nil {
                num += 1
            }
        }
        return counts
    }
    
    func getLocations() -> [ScheduleModel] {
        var scheduleNames: [String] = []
        var schedules: [ScheduleModel] = []
        for schedule in dayListViewModel.get_day(day_id: day.id).scheduleList {
            if !scheduleNames.contains(schedule.event.name) && schedule.event.latitude != nil && schedule.event.longitude != nil {
                scheduleNames.append(schedule.event.name)
                schedules.append(schedule)
            }
        }
        return schedules
    }
    
    func getOrderNumber(name: String) -> String {
        var num = 1
        var counts: String = ""
        for schedule in dayListViewModel.get_day(day_id: day.id).scheduleList {
            if schedule.event.name == name {
                if counts.isEmpty {
                    counts += String(num)
                } else {
                    counts += ", " + String(num)
                }
                num += 1
            } else if schedule.event.latitude != nil && schedule.event.longitude != nil {
                num += 1
            }
        }
        return counts
    }
}
