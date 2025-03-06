//
//  SchedulePhotoView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 4/3/24.
//

import SwiftUI

struct SchedulePhotoView: View {
    @EnvironmentObject var photoGroupViewModel: PhotoGroupViewModel
    @Environment(\.colorScheme) var colorScheme
    @Binding var showPhotoView: Bool
    @Binding var selectedPhoto: Data?
    let day_id: String
    let schedule_id: String
    @State var imageScale: CGFloat = 1
    @State var showUIElements: Bool = true
    @State var loaded: Bool = false
    @State var timer = Timer.publish(every: 0.00001, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack {
            
            if !showUIElements {
                Color.black
                    .ignoresSafeArea()
            } else {
                if colorScheme == .light {
                    Color.white
                        .ignoresSafeArea()
                }
                if colorScheme == .dark {
                    Color.black
                        .ignoresSafeArea()
                }
            }
            
            
            
            TabView(selection: $selectedPhoto) {
                ForEach(photoGroupViewModel.getRefPhotos(day_id: day_id, schedule_id: schedule_id)!, id: \.self) {data in
                    if let data = data, let uiimage = UIImage(data: data) {
                        ZStack {
                            Image(uiImage: uiimage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(imageScale > 1 ? imageScale : 1)
                            //                                .gesture(
                            //                                    MagnificationGesture().onChanged({ (value) in
                            //                                        imageScale = value
                            //                                    })
                            //                                )
                        }
                        .tag(data)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: showUIElements ? .automatic : .never))
            
            if showUIElements {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation(.easeInOut) {
                                showPhotoView = false
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(colorScheme == .light ? .black : .white)
                                .padding()
                        }
                    }
                    Spacer()
                }
            }
            
            if loaded == false {
                ZStack {
                    
                }
                .toolbar(.visible, for: .navigationBar)
            } else {
                ZStack {
                    
                }
                .toolbar(.hidden, for: .navigationBar)
            }
            
        }
        .onAppear {
            AppDelegate.orientationLock = .allButUpsideDown
        }
        .onDisappear {
            AppDelegate.orientationLock = .portrait
        }
        .onTapGesture {
            showUIElements.toggle()
        }
        .onReceive(timer) { _ in
            withAnimation(.smooth) {
                loaded = true
            }
            timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
        }
    }
}

//#Preview {
//    SchedulePhotoView()
//}
