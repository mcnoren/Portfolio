//
//  StatsView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/14/24.
//

import SwiftUI
import PhotosUI
import MapKit

struct StatsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dayListViewModel: DayListViewModel
    @EnvironmentObject var photoGroupViewModel: PhotoGroupViewModel
    @Binding var selectedTab: Tabs
    @State var day: DayModel
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
    @Binding var tab: Data?
    @State var showingPhotosPicker: Bool = false
    @State var showCamera: Bool = false
    @Binding var showPhotoView: Bool
    @State var loaded: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
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
                    if !NotesIsFocused && photoGroupViewModel.getRefPhotos(day_id: day.id) != nil && !photoGroupViewModel.getRefPhotos(day_id: day.id)!.isEmpty && !showTrash && screen == "Journal"{
                        Button {
                            NotesIsFocused = false
                            showTrash = true
                        } label: {
                            Text("Edit")
                                .padding(.trailing, 10)
                        }
                    }
                    if !showTrash && !NotesIsFocused{
                        NavigationLink {
                            PDFexample(day: dayListViewModel.get_day(day_id: day.id), notes: $notes)
                        } label: {
                            Text("PDF")
                                .padding(.trailing, 10)
                                .bold()
                        }
                        .environmentObject(dayListViewModel)
                        .environmentObject(photoGroupViewModel)
                    }
                    if NotesIsFocused || showTrash && screen == "Journal" {
                        Button {
                            NotesIsFocused = false
                            showTrash = false
                        } label: {
                            Text("Done")
                                .padding(.trailing, 10.0)
                        }
                    }
                }
                HStack {
                    Text("Overview")
                        .font(.largeTitle)
                        .bold()
                        .padding(.leading, 10)
                        .padding(.vertical, 5)
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
                Spacer()
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
                                    if photoGroupViewModel.getRefPhotos(day_id: day.id) == nil {
                                        DispatchQueue.main.async{
                                            photoGroupViewModel.addPhotoRefGroup(photo_ref_model: PhotoRefModel(day_id: day.id))
                                        }
                                    }
                                    showingPhotosPicker.toggle()
                                } label: {
                                    Label("Photos", systemImage: "photo")
                                }
                                Button {
                                    if photoGroupViewModel.getRefPhotos(day_id: day.id) == nil {
                                        DispatchQueue.main.async{
                                            photoGroupViewModel.addPhotoRefGroup(photo_ref_model: PhotoRefModel(day_id: day.id))
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
                        }
                        
                        if photoGroupViewModel.getRefPhotos(day_id: day.id) != nil && !photoGroupViewModel.getRefPhotos(day_id: day.id)!.isEmpty {
                            TabView(selection: $tab, content:  {
                                ForEach(photoGroupViewModel.getRefPhotos(day_id: day.id)!, id: \.self) {data in
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
                                    .frame(minHeight: 250, maxHeight: .infinity)
                                
                            }
                            TextEditor(text: $notes)
                                .font(.body)
                            //                                    .colorMultiply(Color(.yellow))
                                .cornerRadius(15)
                                .opacity(notes.isEmpty ? 0.25 : 1)
                                .padding(.horizontal, 20.0)
                                .focused($NotesIsFocused)
                                .frame(minHeight: 250, maxHeight: .infinity)
                            
                        }
                        
                    }
                    .onChange(of: selectedPhotos) { oldValue, newValue in
                        changed_photos()
                    }
                    .onChange(of: selectedImage) {
                        if let data = selectedImage!.pngData() {
                            DispatchQueue.main.async{
                                photoGroupViewModel.add_photo(day_id: day.id, photo: data)
                            }
                            let imageSaver = ImageSaver()
                            imageSaver.writeToPhotoAlbum(image: selectedImage!)
                        }
                        else {
                            print("Data is nil")
                        }
                    }
                    .onChange(of: NotesIsFocused) {
                        if !NotesIsFocused {
                            dayListViewModel.change_day_notes(day_id: day.id, notes: notes)
                        }
                    }
                } else {
                    DayStatsView(day: day)
                    
                }
            }
        }
        .onChange(of: selectedTab, {
            if selectedTab == .stats {
                dayListViewModel.calculateStats(day_id: day.id)
                loaded = false
            }
        })
        .onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            AppDelegate.orientationLock = .portrait
        }
        .confirmationDialog("Delete", isPresented: $showConfirmation, titleVisibility: .hidden) {
            Button("Delete", role: .destructive) {
                photoGroupViewModel.delete_ref_photo(day_id: day.id, photo_index: photoGroupViewModel.getRefPhotos(day_id: day.id)!.firstIndex(where: {$0 == tab}) ?? 0)
                
                if photoGroupViewModel.getRefPhotos(day_id: day.id)!.isEmpty {
                    showTrash = false
                }
            }
        } message: {
            Text("Are you sure you want to delete this photo?")
        }
        .overlay(
            ZStack {
                if showPhotoView {
                    StatsPhotoView(showPhotoView: $showPhotoView, selectedPhoto: $tab, day_id: day.id, loaded: $loaded)
                        .toolbar(.hidden, for: .tabBar)
                }
            }
        )
    }
    func changed_photos() {
        DispatchQueue.main.async {
            for item in selectedPhotos {
                
                item.loadTransferable(type: Data.self) {result in
                    switch result {
                    case .success(let data):
                        if let data = data {
                            if !photoGroupViewModel.getRefPhotos(day_id: day.id)!.contains(data) {
                                DispatchQueue.main.async{
                                    photoGroupViewModel.add_photo(day_id: day.id, photo: data)
                                }
                            }
                        } else {
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
}

//#Preview {
//    NavigationStack {
//        StatsView(selectedTab: .constant(.stats), day: DayModel(parks: ["Disneyland"], title: "Disneyland"), notes: "We had a fun day!")
//    }
//    .environmentObject(DayListViewModel())
//}
