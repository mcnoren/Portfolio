//
//  SearchBarView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/11/24.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    @FocusState.Binding var barIsFocussed: Bool
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                
                TextField("Search", text: $searchText)
                    .font(.body)
                    .autocorrectionDisabled(true)
                    .focused($barIsFocussed)
                    .overlay(
                        Image(systemName: "xmark.circle.fill")
                            .padding([.top, .leading, .bottom], 10)
                            .foregroundStyle(.gray)
                            .opacity(searchText.isEmpty ? 0.0 : 1.0)
                            .onTapGesture {
                                searchText = ""
                            }
                        
                        ,alignment: .trailing
                    )
                    .submitLabel(.done)
                
            }
            .font(.headline)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(Color(.systemGray6))
            )
            .padding(10)
            if barIsFocussed {
                Button {
                    barIsFocussed.toggle()
                } label: {
                    Text("Cancel")
                }
                .padding(.trailing, 5)
                .padding(-4)
                .offset(x: -10)
                .transition(.move(edge: .trailing))
                .animation(.easeInOut(duration: 0.15))
                
            }
            
        }
        .animation(.easeInOut(duration: 0.15), value: barIsFocussed)
    }
}
