//
//  csvExplanationView.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 5/24/24.
//

import SwiftUI

struct csvExplanationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var eventListViewModel: EventListViewModel = EventListViewModel()
    @State var isImporting: Bool = false
    @Binding var incompatibleCSV: Bool
    @Binding var text: String
    @Binding var importedEvents: [EventModel]
    @Binding var events: [EventModel]
    @Binding var error: Error?
    @Binding var name: String
    
    var body: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Cancel")
            }
            .padding(10)
            Spacer()
        }
        Text("Import Park Data")
            .font(.largeTitle)
            .bold()
            .padding(.leading, 10)
            .padding(.vertical, 5)
        VStack {
            Text("My Theme Park Day allows users to import ride data to the app in the form of csv files. The link below takes you to a website that contains pre-made csv files with theme park data for your convienience.")
            Link("MyThemeParkDay.com", destination: URL(string: "https://mythemeparkday.wordpress.com/park-presets/")!)
                .padding()
            Button {
                isImporting = true
            } label: {
                Text("import csv")
            }
            .padding(.top, 20)
            Spacer()
        }
        .fileImporter(isPresented: $isImporting, allowedContentTypes: [.text]) {
            do {
                let fileUrl = try $0.get()
                self.name = fileUrl.lastPathComponent// <--- the file name you want
                self.name = self.name.replacingOccurrences(of: "." + fileUrl.pathExtension, with: "")
                self.name = self.name.replacingOccurrences(of: "Park Presets - ", with: "")
                let result = $0.flatMap { url in
                    read(from: url)
                }
                switch result {
                case .success(let text):
                    self.text = text
                    incompatibleCSV = false
                    changedText()
                case .failure(let error):
                    self.error = error
                }
            } catch{
                print ("error reading: \(error.localizedDescription)")
            }
        }
        
    }
    private func read(from url: URL) -> Result<String,Error> {
      let accessing = url.startAccessingSecurityScopedResource()
      defer {
        if accessing {
          url.stopAccessingSecurityScopedResource()
        }
      }

      return Result { try String(contentsOf: url) }
    }
    
    func save() {
        
    }
    
    func changedText() {
        importedEvents = eventListViewModel.textToEvents(eventsCVS: text)
        if importedEvents.count == 0 {
            incompatibleCSV = true
        }
        for event in importedEvents {
            print(event)
            let index = events.firstIndex(where: { $0.name == event.name })
            if index == nil {
                events.append(event)
            } else {
                events.remove(at: index!)
                events.append(event)
            }
        }
        presentationMode.wrappedValue.dismiss()
    }
}
