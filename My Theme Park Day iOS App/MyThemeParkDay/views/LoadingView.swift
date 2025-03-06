//
//  LoadingView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/28/24.
//

import SwiftUI

struct LoadingView: View {
    
    @State var dayListViewModel: DayListViewModel?
    @State var photoGroupViewModel: PhotoGroupViewModel?
    @State var loaded: Bool = false
    
    var body: some View {
        ZStack {
            if loaded {
                NavigationStack {
                    DayListView()
                        .environmentObject(dayListViewModel!)
                        .environmentObject(photoGroupViewModel!)
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .onAppear(perform: {
                        DispatchQueue.main.async{
                            dayListViewModel = DayListViewModel()
                            photoGroupViewModel = PhotoGroupViewModel()
                            loaded = true
                        }
                    })
            }
        }
    }
}

#Preview {
    LoadingView()
}
