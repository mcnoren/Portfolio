//
//  PhotoViewModel.swift
//  MyThemeParkDay
//
//  Created by Matthew Noren on 3/19/24.
//

import Foundation
import PhotosUI

class PhotoGroupViewModel: ObservableObject {
    
//    @Published var photo_groups: [PhotoModel] = [] {
//        didSet {
//            savePhotos()
//        }
//    }
    @Published var photo_ref_groups: [PhotoRefModel] = [] {
        didSet {
            savePhotoRefs()
        }
    }
    
//    let photosKey: String = "photo_groups"
    let photosRefKey: String = "photo_ref_groups"
    
    init() {
//        getPhotoGroups()
        getPhotoRefGroups()
    }
    
//    func getPhotoGroups() {
//        guard
//            let data = UserDefaults.standard.data(forKey: photosKey),
//            let savedPhotoGroups = try? JSONDecoder().decode([PhotoModel].self, from: data)
//        else { return }
//        
//        self.photo_groups = savedPhotoGroups
//    }
    
    func getPhotoRefGroups() {
        guard
            let data = UserDefaults.standard.data(forKey: photosRefKey),
            let savedPhotoRefGroups = try? JSONDecoder().decode([PhotoRefModel].self, from: data)
        else { return }
        
        self.photo_ref_groups = savedPhotoRefGroups
    }
    
    func getPhotoRefModel(day_id: String, schedule_id: String = "") -> PhotoRefModel? {
        if let index = photo_ref_groups.firstIndex(where: { $0.day_id == day_id && $0.schedule_id == schedule_id }) {
            return photo_ref_groups[index]
        }
        return nil
    }
    
//    func addPhotoGroup(photo_model: PhotoModel) {
//        self.photo_groups.append(photo_model)
//    }
    
    func addPhotoRefGroup(photo_ref_model: PhotoRefModel) {
        self.photo_ref_groups.append(photo_ref_model)
    }
    
//    func savePhotos() {
//        if let encodedData = try? JSONEncoder().encode(photo_groups) {
//            UserDefaults.standard.set(encodedData, forKey: photosKey)
//        }
//    }
    
    func savePhotoRefs() {
        if let encodedData = try? JSONEncoder().encode(photo_ref_groups) {
            UserDefaults.standard.set(encodedData, forKey: photosRefKey)
        }
    }
    
//    func getPhotos(day_id: String, schedule_id: String = "") -> [Data?]? {
//        let index = photo_groups.firstIndex(where: { $0.day_id == day_id && $0.schedule_id == schedule_id })
//        if index != nil {
//            return photo_groups[index!].photos
//        } else {
//            return nil
//        }
//    }
    
    func getRefPhoto(id: String) -> Data? {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documents.appendingPathComponent(id)
        do {
            let data = try Data(contentsOf: url)
                return data
        } catch {
            print("Error reading file")
        }
        return nil
    }
    
    func getRefPhotos(day_id: String, schedule_id: String = "") -> [Data?]? {
        if let index = photo_ref_groups.firstIndex(where: { $0.day_id == day_id && $0.schedule_id == schedule_id }) {
            let ids = photo_ref_groups[index].photos
            var photos: [Data?]? = []
            for id in ids {
                let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let url = documents.appendingPathComponent(id)
                do {
                    let data = try Data(contentsOf: url)
                        photos!.append(data)
                } catch {
                    print("Error reading file")
                }
            }
            return photos
        }
        return nil
    }
    
    func add_photo(day_id: String, schedule_id: String = "", photo: Data?) {
        if let index = photo_ref_groups.firstIndex(where: { $0.day_id == day_id && $0.schedule_id == schedule_id}) {
            if photo != nil {
                let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let id = UUID().uuidString
                let url = documents.appendingPathComponent(id)
                
                do {
                    // Write to Disk
                    try photo!.write(to: url)
                    
                    photo_ref_groups[index].photos.append(id)
                    
                } catch {
                    print("Unable to Write Data to Disk (\(error))")
                }
            }
        }
    }
    
//    func delete_photo(day_id: String, schedule_id: String = "", photo_index: Int) {
//        if let index = photo_groups.firstIndex(where: { $0.day_id == day_id && $0.schedule_id == schedule_id}) {
//            photo_groups[index].photos.remove(at: photo_index)
//        }
//    }
    
    func delete_ref_photo(day_id: String, schedule_id: String = "", photo_index: Int) {
        if let index = photo_ref_groups.firstIndex(where: { $0.day_id == day_id && $0.schedule_id == schedule_id}) {
            let id = photo_ref_groups[index].photos[photo_index]
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = documents.appendingPathComponent(id)
            do {
                try FileManager.default.removeItem(at: url)
                photo_ref_groups[index].photos.remove(at: photo_index)
                print("Successfully deleted file!")
            } catch {
                print("Error deleting file: \(error)")
            }
        }
    }
    
//    func delete_photo_group(day_id: String, schedule_id: String = "") {
//        if let index = photo_groups.firstIndex(where: { $0.day_id == day_id && $0.schedule_id == schedule_id}) {
//            photo_groups.remove(at: index)
//        }
//    }
    
    func delete_ref_photo_group(day_id: String, schedule_id: String = "") {
        if let index = photo_ref_groups.firstIndex(where: { $0.day_id == day_id && $0.schedule_id == schedule_id}) {
            let count = photo_ref_groups[index].photos.count
            for _ in 0..<count {
                delete_ref_photo(day_id: day_id, schedule_id: schedule_id, photo_index: 0)
            }
            photo_ref_groups.remove(at: index)
        }
    }
    
//    func delete_all_photos_for_day(day_id: String) {
//        var new_photo_groups: [PhotoModel] = []
//        for i in 0..<photo_groups.count {
//            if photo_groups[i].day_id != day_id {
//                new_photo_groups.append(photo_groups[i])
//            }
//        }
//        photo_groups = new_photo_groups
//    }
    
    func delete_all_photo_refs_for_day(day_id: String) {
        var new_photo_groups: [PhotoRefModel] = []
        let count = photo_ref_groups.count
        for _ in 0..<count {
            if photo_ref_groups[0].day_id != day_id {
                new_photo_groups.append(photo_ref_groups[0])
                delete_ref_photo_group(day_id: photo_ref_groups[0].day_id, schedule_id: photo_ref_groups[0].schedule_id)
            } else {
                delete_ref_photo_group(day_id: photo_ref_groups[0].day_id, schedule_id: photo_ref_groups[0].schedule_id)
            }
        }
        photo_ref_groups = new_photo_groups
    }
}
