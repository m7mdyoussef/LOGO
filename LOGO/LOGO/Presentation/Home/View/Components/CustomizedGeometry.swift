
import SwiftUI

/// returns Geometry with an array of images
struct CustomizedGeometry: View {
    let imageNames: [String]
    
    @State private var isImageTapped = false
    @State var selectedImage: String = ""
    @State var viewMode:HomeViewModel
    
    var body: some View {
        VStack{
            if imageNames.count == 1{
                GeometryReader { geometry in
                    Image(imageNames[0])
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .cornerRadius(8)
                        .onTapGesture {
                            isImageTapped = true
                            selectedImage = imageNames[0]

                        }
                }//: GeometryReader
                .frame(minHeight: 150, idealHeight: 250)
                
            }else if imageNames.count == 2{
                GeometryReader { geometry in
                    HStack {
                        ForEach(imageNames, id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width / 2, height: geometry.size.height)
                                .clipped()
                                .cornerRadius(8)
                                .onTapGesture {
                                    isImageTapped = true
                                    selectedImage = imageName
                                }
                        }
                    }
                }
                .frame(minHeight: 150, idealHeight: 250)
            }else if imageNames.count == 3{
                GeometryReader { geometry in
                    HStack{
                        Image(imageNames[0])
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width / 2, height: geometry.size.height)
                            .clipped()
                            .cornerRadius(8)
                            .onTapGesture {
                                isImageTapped = true
                                selectedImage = imageNames[0]
                            }
                        VStack{
                            let restOfImages = imageNames.dropFirst()
                            ForEach(restOfImages, id: \.self) { imageName in
                                Image(imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width / 2, height: (geometry.size.height - 8) / 2)
                                    .clipped()
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        isImageTapped = true
                                        selectedImage = imageName
                                    }
                            }
                        }
                    }
                }
                .frame(minHeight: 150, idealHeight: 250)
                
            }else if imageNames.count == 4{
                let imagesPairs: [[String]] = [[imageNames[0], imageNames[1]], [imageNames[2], imageNames[3]]]
                HStack{
                    ForEach(imagesPairs, id: \.self) { imagePair in
                        VStack {
                            ForEach(imagePair, id: \.self){ imageName in
                                Image(imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .clipped()
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        isImageTapped = true
                                        selectedImage = imageName
                                    }
                            }
                        }
                    }
                }
            }
            
        }
        .onChange(of: isImageTapped) { newValue in
            // Handle the change of isImageTapped here
            if newValue {
                // Do something when isImageTapped becomes true
                viewMode.showImageWith(imageName: selectedImage, isImageTapped: isImageTapped)
                isImageTapped = false
            }
            
        }
    }
}


