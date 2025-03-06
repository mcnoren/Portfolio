//
//  PDFexample.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/17/24.
//

import SwiftUI
import PDFKit
import Charts
import PhotosUI
import MapKit

@MainActor
struct PDFexample: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var dayListViewModel: DayListViewModel = DayListViewModel()
    @EnvironmentObject var photoGroupViewModel: PhotoGroupViewModel
    @State private var photopdfURL: URL?
    @State private var pdfURL: URL?
    @State var day: DayModel
    @Binding var notes: String
    @State var showToolbar: Bool = true
    @State var screen: String = "With Photos"
    let screenOptions: [String] = ["With Photos", "Without Photos"]
    
    var body: some View {
        VStack{
            if let photopdfURL = photopdfURL, let pdfURL = pdfURL{
                if showToolbar {
                    VStack {
                        ZStack {
                            HStack {
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }, label: {
                                    Image(systemName: "chevron.backward")
                                        .padding(.leading, 10)
                                        .bold()
                                    Text("Back")
                                })
                                Spacer()
                                ShareLink("", item: screen == "With Photos" ? photopdfURL : pdfURL)
                                    .font(.title3)
                                    .padding(5)
                            }
                            Text("pdf")
                                .bold()
                        }
                        Picker(selection: $screen) {
                            ForEach(screenOptions, id: \.self) { screen in
                                Text(screen)
                                    .tag(screen)
                            }
                        } label: {
                            Text("Screen Selector")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                }
                if screen == "With Photos" {
                    PDFKitView(url: photopdfURL)
                        .ignoresSafeArea(edges: [.bottom, .leading, .trailing])
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.1)) {
                                showToolbar.toggle()
                            }
                        }
                } else {
                    PDFKitView(url: pdfURL)
                        .ignoresSafeArea(edges: [.bottom, .leading, .trailing])
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.1)) {
                                showToolbar.toggle()
                            }
                        }
                }
            }
        }
        .onAppear {
            AppDelegate.orientationLock = .allButUpsideDown
        }
        .onDisappear {
            AppDelegate.orientationLock = .portrait
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear(perform: {
            photopdfURL = generatePhotoPDF(day: day)
            pdfURL = generateNonPhotoPDF(day: day)
            day = dayListViewModel.get_day(day_id: day.id)
        })
        
        
    }
    
    
    // PDF Viewer
    struct PDFKitView: UIViewRepresentable {
        
        let url: URL
        
        func makeUIView(context: Context) -> PDFView {
            let pdfView = PDFView()
            pdfView.document = PDFDocument(url: self.url)
            pdfView.autoScales = true
            return pdfView
        }
        
        func updateUIView(_ pdfView: PDFView, context: Context) {
            // Update pdf if needed
        }
    }
    
    
    // generate pdf from given view
    func generatePhotoPDF(day: DayModel) -> URL {
        //  Select UI View to render as pdf
        let renderer = ImageRenderer(content:PDFDataView(day: day, hasPhotos: true))
        let calandar = Calendar.current
        let day_string = String(calandar.component(.month, from: day.date)) + "-" + String(calandar.component(.day, from: day.date)) + "-" + String(calandar.component(.year, from: day.date)).suffix(2) + String(" \(day.title)")
        
        let url = URL.documentsDirectory.appending(path: "\(day_string) with photos.pdf")
       
        renderer.render { size, context in
            var pdfDimension = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            guard let pdf = CGContext(url as CFURL, mediaBox: &pdfDimension, nil) else {
                return
            }
            pdf.beginPDFPage(nil)
            context(pdf)
            pdf.endPDFPage()
            pdf.closePDF()
        }
        
        return url
    }
    
    // generate pdf from given view
    func generateNonPhotoPDF(day: DayModel) -> URL {
        //  Select UI View to render as pdf
        let renderer = ImageRenderer(content:PDFDataView(day: day, hasPhotos: false))
        let calandar = Calendar.current
        let day_string = String(calandar.component(.month, from: day.date)) + "-" + String(calandar.component(.day, from: day.date)) + "-" + String(calandar.component(.year, from: day.date)).suffix(2) + String(" \(day.title)")
        
        let url = URL.documentsDirectory.appending(path: "\(day_string) without photos.pdf")
       
        renderer.render { size, context in
            var pdfDimension = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            guard let pdf = CGContext(url as CFURL, mediaBox: &pdfDimension, nil) else {
                return
            }
            pdf.beginPDFPage(nil)
            context(pdf)
            pdf.endPDFPage()
            pdf.closePDF()
        }
        
        return url
    }
}

//
struct PDFDataView: View {
    
    @State var dayListViewModel: DayListViewModel = DayListViewModel()
    @State var photoGroupViewModel: PhotoGroupViewModel = PhotoGroupViewModel()
    let day: DayModel
    @State var editing = false
    let hasPhotos: Bool
    
    var body: some View {
        VStack{
            HStack {
                DayListRowView(day_id: day.id, day_date: dayListViewModel.get_day(day_id: day.id).date, day_title: day.title, typing: .constant(false))
            }
            Divider()
            DayStatsViewPDF(day: dayListViewModel.get_day(day_id: day.id))
            if photoGroupViewModel.getPhotoRefModel(day_id: day.id) != nil {
                PhotoViewPDF(photos: photoGroupViewModel.getRefPhotos(day_id: day.id)!, hasPhotos: hasPhotos)
            }
            if !day.notes.isEmpty {
                HStack {
                    Text("Notes:")
                        .font(.title3)
                        .padding(5)
                    Spacer()
                }
                HStack{
                    Text("\(day.notes)")
                    Spacer()
                }
                .frame(maxWidth: 425)
                .fixedSize(horizontal: false, vertical: true)
            }
            Text("Schedule:")
                .font(.title)
                .padding(.top, 5)
            ForEach(dayListViewModel.get_day(day_id: day.id).scheduleList, id: \.self) {schedule in
                ScheduleViewPDF(day: day, schedule: schedule, hasPhotos: hasPhotos)
            }

        }
        .padding(.vertical, 40)
        .padding(.horizontal)
    }
}

struct ScheduleViewPDF: View {
    
    @State var photoGroupViewModel: PhotoGroupViewModel = PhotoGroupViewModel()
    
    let day: DayModel
    let schedule: ScheduleModel
    let hasPhotos: Bool
    
    var body: some View {
        VStack {
            Divider()
            if schedule.startedWaiting != nil {
                TimeView(date: schedule.startedWaiting!)
            } else if schedule.startedEvent != nil {
                TimeView(date: schedule.startedEvent!)
            } else if schedule.endedEvent != nil {
                TimeView(date: schedule.endedEvent!)
            }
            HStack {
                Text("\(schedule.event.name)")
                    .font(schedule.type == "Entry" ? .body : .title2)
                    .frame(maxWidth: 400)
                    .fixedSize(horizontal: false, vertical: true)
            }
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
            
            if schedule.ride_broke_in_line {
                HStack {
                    Text("*Broke Down in line")
                        .foregroundStyle(.red)
                        .font(.caption)
                }
            }
            if schedule.ride_broke_on_ride {
                HStack {
                    Text("*Broke Down on ride")
                        .foregroundStyle(.red)
                        .font(.caption)
                }
            }
            if schedule.aborted {
                HStack {
                    Text("*Left")
                        .foregroundStyle(.red)
                        .font(.caption)
                }
            }
            
            ScheduleStatsViewPDF(schedule: schedule)
                .padding(.bottom, 4)
            
            if photoGroupViewModel.getRefPhotos(day_id: day.id, schedule_id: schedule.id) != nil {
                PhotoViewPDF(photos: photoGroupViewModel.getRefPhotos(day_id: day.id, schedule_id: schedule.id)!, hasPhotos: hasPhotos)
            }
            
            if !schedule.notes.isEmpty {
                HStack {
                    Text("Notes:")
                        .font(.title3)
                        .padding(5)
                    Spacer()
                }
                HStack{
                    Text("\(schedule.notes)")
                    Spacer()
                }
                .frame(maxWidth: 425)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct DayStatsViewPDF: View {
    
    let day: DayModel
    @State var camera: MapCameraPosition = .automatic
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    HStack {
                        Text("Total ride wait: \(Int(day.total_attraction_wait_time)/60) min \(Int(day.total_attraction_wait_time)%60) sec")
                            .padding(.top, 10)
                        Spacer()
                    }
                    HStack {
                        Text("Total ride time: \(Int(day.total_attraction_ride_time)/60) min \(Int(day.total_attraction_ride_time)%60) sec")
                        Spacer()
                    }
                    HStack {
                        Text("Total actual - posted wait: ")
                        Text("\(Int(day.total_actual_minus_posted_wait)/60) min \(abs(Int(day.total_actual_minus_posted_wait)%60)) sec")
                            .foregroundStyle(day.total_actual_minus_posted_wait > 0 ? .red : .green)
                        Spacer()
                    }
                    if day.total_LL > 0 {
                        HStack {
                            Text("Total time saved with LL: ")
                            Text("\(Int(day.total_time_saved_with_LL)/60) min \(abs(Int(day.total_time_saved_with_LL)%60)) sec")
                                .foregroundStyle(day.total_time_saved_with_LL > 0 ? .red : .green)
                            Spacer()
                        }
                    }
                    if day.total_singleRider > 0 {
                        HStack {
                            Text("Total time saved with Single Rider: ")
                            Text("\(Int(day.total_time_saved_with_singleRider)/60) min \(abs(Int(day.total_time_saved_with_singleRider)%60)) sec")
                                .foregroundStyle(day.total_time_saved_with_singleRider > 0 ? .red : .green)
                            Spacer()
                        }
                    }
                    HStack {
                        Text("# of Attractions: \(day.number_of_attractions)")
                        Spacer()
                    }
                    HStack {
                        Text("# of LL: \(day.total_LL)")
                        Spacer()
                    }
                    HStack {
                        Text("# of single riders: \(day.total_singleRider)")
                        Spacer()
                    }
                    
                    
//                    HStack {
//                        Text("Total meal wait: \(Int(day.total_food_wait_time)/60) min \(Int(day.total_food_wait_time)%60) sec")
//                            .padding(.top, 10)
//                        Spacer()
//                    }
//                    HStack {
//                        Text("Total meal time: \(Int(day.total_food_enjoy_time)/60) min \(Int(day.total_food_enjoy_time)%60) sec")
//                        Spacer()
//                    }
                }
                if day.total_attraction_wait_time > 0 || day.total_food_wait_time > 0 || day.total_show_wait_time > 0 || day.total_show_time > 0 || day.total_food_enjoy_time > 0 || day.total_attraction_ride_time > 0 {
                    Chart {
                        SectorMark(angle: .value("Time",
                                                 day.total_attraction_wait_time + day.total_food_wait_time + day.total_show_wait_time))
                        .foregroundStyle(Color(.lightGray))
                        SectorMark(angle: .value("Time",
                                                 day.total_show_time))
                        .foregroundStyle(Color(.red))
                        SectorMark(angle: .value("Time",
                                                 day.total_food_enjoy_time))
                        .foregroundStyle(Color(.yellow))
                        SectorMark(angle: .value("Time",
                                                 day.total_attraction_ride_time))
                        .foregroundStyle(Color(.blue))
                    }
                    .frame(width: 150, height: 150)
                    .chartForegroundStyleScale([
                        "Attractions": Color(.blue),
                        "Meals": Color(.yellow),
                        "Entertainment": Color(.red),
                        "Waiting": Color(.lightGray)
                    ])
                } else {
                    HStack {
                        
                    }
                    .frame(width: 150, height: 150)
                }
            }
            
            if day.number_of_attractions > 0 {
                WaitChartView(day: day)
            }
            
            if day.number_of_attractions > 0 {
                Text("Events Sorted by Wait Time:")
                    .font(.title3)
                    .padding(.top, 20)
                    .padding(.bottom, 5)
                ForEach(day.get_scheduleList_sorted_by_wait_time(), id: \.self) { schedule in
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
                    .padding(.bottom, 7)
                }
            }
//            Map(position: $camera) {
//                ForEach(0..<day.scheduleList.count) { i in
//                    if day.scheduleList[i].event.latitude != nil && day.scheduleList[i].event.longitude != nil {
//                        Annotation("", coordinate: CLLocationCoordinate2D(latitude: day.scheduleList[i].event.latitude!, longitude: day.scheduleList[i].event.longitude!)) {
//                            OrderMapAnnotationView(event: day.scheduleList[i].event, orderNumber: getOrderNumber(index: i))
//                        }
//                    }
//                }
//            }
//            .padding(20)
//            .disabled(true)
//            .frame(height: 300)
//            .mapStyle(.imagery)
        }
    }
    func getOrderNumber(index: Int) -> Int {
        var num = 1
        for i in 0..<day.scheduleList.count {
            if i == index {
                return num
            }
            if day.scheduleList[i].event.latitude != nil && day.scheduleList[i].event.longitude != nil {
                num += 1
            }
        }
        return -1
    }
}

struct WaitChartView: View {
    
    let day: DayModel
    @State var count: Int = 0
    
    var body: some View {
        if day.number_of_attractions > 0 {
                Text("Actual - Posted Wait Times")
                    .font(.title3)
                    .padding(.top, 20)
            ForEach(day.scheduleList, id: \.self) { event in
                if event.startedWaiting != nil && event.startedEvent != nil && event.type == "Attraction" {
                    Chart() {
                        RuleMark(x: .value("0", 0))
                            .foregroundStyle(.black)
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                        
                        let waited = event.startedEvent!.timeIntervalSince(event.startedWaiting!) / 60
                        BarMark (x: .value("Time Over", waited - Double(event.postedWait)),
                                 y: .value("Name", event.event.name + (event.LL ? " LL" : "") + (event.singleRider ? " S" : "")))
                        .foregroundStyle(event.ride_broke_in_line ? .gray : waited - Double(event.postedWait) > 0 ? .red : .green)
                    }
                    .frame(height: 70)
                    .chartXScale(domain: get_min_wait_diff()...get_max_wait_diff())
                    .padding([.leading, .bottom, .trailing])
                    
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
    }
    
    func get_min_wait_diff() -> Double{
        var min: Double = -10
        for schedule in day.scheduleList {
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
        for schedule in day.scheduleList {
            if schedule.startedWaiting != nil && schedule.startedEvent != nil && schedule.type == "Attraction" {
                if schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!)/60 - Double(schedule.postedWait) > max {
                    max = schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!)/60 - Double(schedule.postedWait)
                }
            }
        }
        return max
    }
}

struct ScheduleStatsViewPDF: View {
    
    let schedule: ScheduleModel
    
    var body: some View {
        if schedule.type != "Entry" {
            VStack {
                ScheduleInfoView(schedule: schedule)
                HStack {
                    ScheduleTimeView(schedule: schedule)
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
                        .padding(.leading)
                    }
                }
//                Chart {
//                    RuleMark(x: .value("0", 0))
//                        .foregroundStyle(.black)
//                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
//                    
//                    let waited = schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!) / 60
//                    BarMark (x: .value("Time Over", waited - Double(schedule.postedWait)),
//                             y: .value("Name", schedule.event.name + (schedule.LL ? " (LL)" : "") + (schedule.singleRider ? " (S)" : "")))
//                    .foregroundStyle(schedule.ride_broke_in_line ? .gray : waited - Double(schedule.postedWait) > 0 ? .red : .green)
//                }
//                .frame(height: 90)
//                .chartXScale(domain: (schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!) / 60 - Double(schedule.postedWait) > -10 ? -10 : schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!) / 60 - Double(schedule.postedWait))...(schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!) / 60 - Double(schedule.postedWait) < 10 ? 10 : schedule.startedEvent!.timeIntervalSince(schedule.startedWaiting!) / 60 - Double(schedule.postedWait)))
//                .padding([.leading, .bottom, .trailing])
//                .chartForegroundStyleScale([
//                    "Under Posted": Color(.green),
//                    "Over Posted": Color(.red),
//                    "Broke Down": Color(.gray)
//                ])
            }
        }
    }
}

struct PhotoViewPDF: View {
    
    let photos: [Data?]
    let hasPhotos: Bool
    
    var body: some View {
        if hasPhotos {
            VStack {
                ForEach(0..<photos.count, id: \.self) {int in
                    if int % 2 == 0 {
                        HStack {
                            if let data = photos[int], let uiimage = UIImage(data: data) {
                                Image(uiImage: uiimage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(15)
                                    .frame(width: 250, height: 250)
                            }
                            if int + 1 < photos.count {
                                if let data = photos[int+1], let uiimage = UIImage(data: data) {
                                    Image(uiImage: uiimage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(15)
                                        .frame(width: 250, height: 250)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}



