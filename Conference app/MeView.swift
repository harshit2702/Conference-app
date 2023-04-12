//
//  MeView.swift
//  Conference app
//
//  Created by Harshit Agarwal on 23/04/23.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct MeView: View {
    @State private var name = "Anonymous"
    @State private var emailId = "you@yoursite.com"
    @State private var qrCode = UIImage()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    func generateQRCode(from string: String)-> UIImage{
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage{
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent){
                qrCode =  UIImage(cgImage: cgimg)
                return  qrCode
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    func updateCode(){
        qrCode = generateQRCode(from: "\(name)\n\(emailId)")
    }
    
    var body: some View {
        NavigationView{
            Form{
                TextField("Name",text: $name)
                    .textContentType(.name)
                    .font(.title)
                TextField("EmailID",text:$emailId)
                    .textContentType(.emailAddress)
                    .font(.title)
                Image(uiImage: qrCode)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width:200,height: 200)
                    .contextMenu{
                        Button{
                            let imageSaver = ImageSaver()
                            imageSaver.writeToPhotoAlbum(image: qrCode)
                        }label: {
                            Label("Save to photos",systemImage: "square.and.arrow.down")
                        }
                    }
            }
            .navigationTitle("Your Code")
            .onAppear(perform: updateCode)
            .onChange(of: name){_ in updateCode()}
            .onChange(of: emailId){_ in updateCode()}
        }
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
