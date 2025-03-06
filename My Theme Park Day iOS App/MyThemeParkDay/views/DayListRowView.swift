//
//  DayListRowView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/5/24.
//

import SwiftUI

struct DayListRowView: View {
    
    @EnvironmentObject var dayListViewModel: DayListViewModel
    @EnvironmentObject var photoGroupViewModel: PhotoGroupViewModel
    let day_id: String
    let day_date: Date
    @State var day_title: String
    let calandar = Calendar.current
    @Binding var typing: Bool
    @FocusState var TitleIsFocused: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text(getDateString())
                    .padding(.horizontal, 5)
//                if !typing {
//                    Text(day_title)
//                } else {
//                    TextField("Enter Day Name",text: $day_title)
//                        .submitLabel(.done)
//                        .focused($TitleIsFocused)
//                    if !TitleIsFocused {
//                        Button {
//                            typing = true
//                            TitleIsFocused = true
//                        } label: {
//                            Image(systemName: "pencil")
//                        }
//                    }
//                }
                Spacer()
            }
            .font(.title2)
            .padding(.top, 4)
            .padding(.bottom, 1)
            HStack {
                Text(day_title)
                Spacer()
            }
            .padding(.leading, 5)
        }
        .onChange(of: day_title) {
            dayListViewModel.change_day_title(day_id: day_id, title: day_title)
        }
    }
    func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy" // OR "dd-MM-yyyy"

        let currentDateString: String = dateFormatter.string(from: day_date)
        return currentDateString
    }
}
