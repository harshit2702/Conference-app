//
//  prospect.swift
//  Conference app
//
//  Created by Harshit Agarwal on 23/04/23.
//

import SwiftUI

class prospect: Identifiable, Codable{
    var id = UUID()
    var name = ""
    var emailId = ""
    fileprivate(set) var isContacted = false
}

@MainActor class Prospects : ObservableObject{
   @Published private(set) var people: [prospect]
    let savedKey = "SavedData"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: savedKey){
            if let decode = try? JSONDecoder().decode([prospect].self,from: data){
                people = decode
                return
            }
        }
        
        people = []
    }
    
    func save(){
        if let encoded = try? JSONEncoder().encode(people){
            UserDefaults.standard.set(encoded, forKey: savedKey)
            
        }
    }
    
    func add(_ prospects: prospect){
        people.append(prospects)
        save()
    }
    
    func toggle(_ prospects: prospect){
        objectWillChange.send()
        prospects.isContacted.toggle()
        save()
    }
}
