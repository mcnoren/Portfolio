//
//  ScheduleView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/10/24.
//

import SwiftUI
import PhotosUI

struct ScheduleView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dayListViewModel: DayListViewModel
    @EnvironmentObject var photoGroupViewModel: PhotoGroupViewModel
    let day_id: String
    @State var schedule: ScheduleModel
    @State var screen: String = "Stats"
    @State var notes: String
    @State var placeholderText = "Type Here..."
    @State var selectedPhotos: [PhotosPickerItem] = []
    @State var selectedImage: UIImage?
    let screenOptions: [String] = ["Stats", "Journal"]
    @FocusState var NotesIsFocused: Bool
    @State var imageDisapear: Bool = false
    @State var editing: Bool = false
    @State var showTrash: Bool = false
    @State var showConfirmation: Bool = false
    @State var showAbortConfirmation: Bool = false
    @State var selectedTab: Data?
    @State var showingPhotosPicker: Bool = false
    @State var showCamera: Bool = false
    @State var loading: Bool = false
    @State var showPhotoView: Bool = false
    
    var body: some View {
        ZStack {
            VStack{
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
                        .padding(.top, 20)
                        Spacer()
                    }
                    if schedule.endedEvent == nil && schedule.type == "Attraction" {
                        Button {
                            showAbortConfirmation = true
                        } label: {
                            Text("Abort")
                                .tint(.white)
                        }
                        .padding()
                        .frame(width: 130.0, height: 40)
                        .background(.red)
                        .clipShape(Capsule())
                        .padding(.top, 10)
                    }
                    HStack {
                        Spacer()
                        if !NotesIsFocused && photoGroupViewModel.getRefPhotos(day_id: day_id, schedule_id: schedule.id) != nil && !photoGroupViewModel.getRefPhotos(day_id: day_id, schedule_id: schedule.id)!.isEmpty && !showTrash && screen == "Journal"{
                            Button {
                                NotesIsFocused = false
                                showTrash = true
                            } label: {
                                Text("Edit")
                                    .padding(.trailing, 10.0)
                            }
                            .padding(.top, 20)
                        }
                        if NotesIsFocused || showTrash && screen == "Journal"{
                            Button {
                                NotesIsFocused = false
                                showTrash = false
                            } label: {
                                Text("Done")
                                    .padding(.trailing, 10.0)
                            }
                            .padding(.top, 20)
                        }
                        
                        
                    }
                }
                
                HStack {
                    Text("\(schedule.event.name)")
                        .font(.largeTitle)
                        .bold()
                        .padding(10)
                    Spacer()
                }
                Picker(selection: $screen) {
                    ForEach(screenOptions, id: \.self) { schedule in
                        Text(schedule)
                            .tag(schedule)
                    }
                } label: {
                    Text("Screen Selector")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                if screen == "Journal" {
                    ScrollView {
                        
                        HStack {
                            if showTrash {
                                Button(action: {
                                    showConfirmation = true
                                }, label: {
                                    Image(systemName: "minus.circle.fill")
                                        .padding(.leading, 10)
                                        .foregroundColor(.red)
                                })
                            }
                            Spacer()
                            Menu {
                                Button {
                                    loading = true
                                    if photoGroupViewModel.getRefPhotos(day_id: day_id, schedule_id: schedule.id)  == nil {
                                        DispatchQueue.main.async{
                                            photoGroupViewModel.addPhotoRefGroup(photo_ref_model: PhotoRefModel(day_id: day_id, schedule_id: schedule.id))
                                        }
                                    }
                                    showingPhotosPicker.toggle()
                                } label: {
                                    Label("Photos", systemImage: "photo")
                                }
                                Button {
                                    loading = true
                                    if photoGroupViewModel.getRefPhotos(day_id: day_id, schedule_id: schedule.id) == nil {
                                        DispatchQueue.main.async{
                                            photoGroupViewModel.addPhotoRefGroup(photo_ref_model: PhotoRefModel(day_id: day_id, schedule_id: schedule.id))
                                        }
                                    }
                                    showCamera.toggle()
                                } label: {
                                    Label("Camera", systemImage: "camera")
                                }
                            } label: {
                                Image(systemName: "plus")
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 5)
                            }
                        }
                        .photosPicker(isPresented: $showingPhotosPicker, selection: $selectedPhotos, matching: .images)
                        .fullScreenCover(isPresented: self.$showCamera) {
                                        accessCameraView(selectedImage: self.$selectedImage)
                                .ignoresSafeArea()
                                .onAppear(perform: {
                                    loading = false
                                })
                                    }
                        
                        if photoGroupViewModel.getRefPhotos(day_id: day_id, schedule_id: schedule.id) != nil && !photoGroupViewModel.getRefPhotos(day_id: day_id, schedule_id: schedule.id)!.isEmpty{
                            TabView(selection: $selectedTab, content:  {
                                ForEach(photoGroupViewModel.getRefPhotos(day_id: day_id, schedule_id: schedule.id)!, id: \.self) {data in
                                    if let data = data, let uiimage = UIImage(data: data) {
                                        ZStack {
                                            Button {
                                                    showPhotoView = true
                                            } label: {
                                                Image(uiImage: uiimage)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .cornerRadius(15)
                                            }
                                            
                                        }
                                        .tag(data)
                                    }
                                }
                                
                            })
                            .tabViewStyle(PageTabViewStyle())
                            .frame(height: 380)
                            .padding([.leading, .bottom, .trailing], 10)
                        }
                        HStack {
                            Text("Notes:")
                                .padding(.horizontal, 20)
                                .font(.title3)
                                .bold()
                            Spacer()
                            
                        }
                        ZStack {
                            if notes.isEmpty {
                                TextEditor(text:$placeholderText)
                                    .font(.body)
                                //                                        .colorMultiply(Color(.yellow))
                                    .cornerRadius(15)
                                    .foregroundColor(Color(.gray))
                                    .disabled(true)
                                    .padding(.horizontal, 20)
                                    .focused($NotesIsFocused)
                                    .frame(minHeight: 150, maxHeight: .infinity)
                                
                            }
                            TextEditor(text: $notes)
                                .font(.body)
                            //                                    .colorMultiply(Color(.yellow))
                                .cornerRadius(15)
                                .opacity(notes.isEmpty ? 0.25 : 1)
                                .padding(.horizontal, 20.0)
                                .focused($NotesIsFocused)
                                .frame(minHeight: 150, maxHeight: .infinity)
                            
                        }
                        
                    }
                    .onChange(of: selectedPhotos) {
                        DispatchQueue.main.async {
                            if !selectedPhotos.isEmpty {
                                for item in selectedPhotos {
                                    item.loadTransferable(type: Data.self) { result in
                                        switch result {
                                        case .success(let data):
                                            if let data = data {
                                                if !photoGroupViewModel.getRefPhotos(day_id: day_id, schedule_id: schedule.id)!.contains(data) {
                                                    DispatchQueue.main.async{
                                                        photoGroupViewModel.add_photo(day_id: day_id, schedule_id: schedule.id, photo: data)
                                                    }
                                                }
                                            }
                                            else {
                                                print("Data is nil")
                                            }
                                        case .failure(let failure):
                                            fatalError("\(failure)")
                                        }
                                    }
                                    
                                }
                                self.selectedPhotos = []
                            }
                        }
                        self.loading = false
                    }
                    .onChange(of: selectedImage) {
                        if let data = selectedImage!.pngData() {
                            DispatchQueue.main.async{
                                DispatchQueue.main.async{
                                    photoGroupViewModel.add_photo(day_id: day_id, schedule_id: schedule.id, photo: data)
                                }
                                let imageSaver = ImageSaver()
                                imageSaver.writeToPhotoAlbum(image: selectedImage!)
                            }
                            loading = false
                        }
                        else {
                            print("Data is nil")
                        }
                    }
                    .onChange(of: NotesIsFocused) {
                        if !NotesIsFocused {
                            dayListViewModel.change_schedule_notes(day_id: day_id, schedule_id: schedule.id, notes: notes)
                        }
                    }
                }
                
                if screen == "Stats" && !editing {
                    HStack {
                        Spacer()
                        Button {
                            editing.toggle()
                        } label: {
                            Text("Edit")
                                .padding(.horizontal, 20)
                        }
                        .padding(.top, 20)
                    }
                    ScrollView {
                        ScheduleInfoView(schedule: schedule)
                        ScheduleTimeView(schedule: schedule)
//                        if schedule.type == "Attraction" {
//                            ScheduleLLView(schedule: schedule)
//                        }
                        ScheduleChartView(schedule: schedule)
                    }
                }
                if screen == "Stats" && editing {
                    EditScheduleView(day: dayListViewModel.get_day(day_id: day_id), schedule: $schedule, LL: schedule.LL, singleRider: schedule.singleRider, name: schedule.event.name, park: schedule.event.park, land: schedule.event.land, type: schedule.type, postedWait: schedule.postedWait, startedWaiting: schedule.startedWaiting!, startedEventTemp: schedule.startedEvent, endedEventTemp: schedule.endedEvent, editing: $editing, ride_broke_in_line: schedule.ride_broke_in_line, ride_broke_on_ride: schedule.ride_broke_on_ride, latitude: schedule.event.latitude, longitude: schedule.event.longitude)
                }
                Spacer()
            }
            if loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .confirmationDialog("Delete", isPresented: $showConfirmation, titleVisibility: .hidden) {
            Button("Delete", role: .destructive) {
                photoGroupViewModel.delete_ref_photo(day_id: day_id, schedule_id: schedule.id, photo_index: photoGroupViewModel.getRefPhotos(day_id: day_id, schedule_id: schedule.id)!.firstIndex(where: {$0 == selectedTab}) ?? 0)
                
                if photoGroupViewModel.getRefPhotos(day_id: day_id, schedule_id: schedule.id)!.isEmpty {
                    showTrash = false
                }
            }
        } message: {
            Text("Are you sure you want to delete this photo?")
        }
        .confirmationDialog("Abort", isPresented: $showAbortConfirmation, titleVisibility: .hidden) {
            Button("Stopped Waiting") {
                dayListViewModel.aborted(day_id: day_id, schedule_id: schedule.id)
                dayListViewModel.change_schedule_endedEvent(day_id: day_id, schedule_id: schedule.id, endedEvent: Date())
                presentationMode.wrappedValue.dismiss()
            }
            Button("Broke Down in Line", role: .destructive) {
                dayListViewModel.aborted(day_id: day_id, schedule_id: schedule.id, ride_broke_in_line: true)
                dayListViewModel.change_schedule_endedEvent(day_id: day_id, schedule_id: schedule.id, endedEvent: Date())
                presentationMode.wrappedValue.dismiss()
            }
            Button("Broke Down on Ride", role: .destructive) {
                dayListViewModel.aborted(day_id: day_id, schedule_id: schedule.id, ride_broke_on_ride: true)
                dayListViewModel.change_schedule_endedEvent(day_id: day_id, schedule_id: schedule.id, endedEvent: Date())
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("What happened?")
        }
        .overlay(
            ZStack {
                if showPhotoView {
                    SchedulePhotoView(showPhotoView: $showPhotoView, selectedPhoto: $selectedTab, day_id: day_id, schedule_id: schedule.id)
                }
            }
        )
    }

}
