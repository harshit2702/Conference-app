//
//  ProspectView.swift
//  Conference app
//
//  Created by Harshit Agarwal on 23/04/23.
//

import SwiftUI
import CodeScanner

struct ProspectView: View {
    enum filterType {
        case none,contacted,uncontacted
    }
    
    let filter: filterType
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    var body: some View {
        NavigationView{
            List{
                ForEach(filterProspect){ prospect in
                    VStack(alignment: .leading){
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailId)
                            .foregroundColor(.secondary)
                    }
                    .swipeActions{
                        if prospect.isContacted{
                            Button{
                                prospects.toggle(prospect)
                            }label: {
                                Label("Mark Uncontacted",systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        }
                        else{
                            Button{
                                prospects.toggle(prospect)
                            }label: {
                                Label("Mark Contacted",systemImage: "person.crop.circle.badge.checkmark")
                            }
                            .tint(.green)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar{
                Button{
                   isShowingScanner = true
                }label: {
                    Label("Scan",systemImage: "qrcode.viewfinder")
                }
            }
            .sheet(isPresented: $isShowingScanner){
                CodeScannerView(codeTypes: [.qr], simulatedData:"harshit\nharshitagarawal27@gmail.com",completion: handelScan)
            }
        }
    }
    
    var title: String{
        switch filter{
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted"
        case .uncontacted:
            return "Uncontacted"
        }
    }
    
    var filterProspect: [prospect]{
        switch filter{
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter{ $0.isContacted}
        case .uncontacted:
            return prospects.people.filter{ !$0.isContacted}
        }
    }
    
    func handelScan(result: Result<ScanResult, ScanError>){
        isShowingScanner = false
        switch result{
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else {return}
            
            let person = prospect()
            person.name = details[0]
            person.emailId = details[1]
            prospects.add(person)
        
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

struct ProspectView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectView(filter: .none)
            .environmentObject(Prospects())
    }
}
