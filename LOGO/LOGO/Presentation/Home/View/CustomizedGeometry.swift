
import SwiftUI

/// returns Geometry with an array of images
struct CustomizedGeometry: View {
    let imageNames: [String]
    
    var body: some View {
        
        if imageNames.count == 1{
            GeometryReader { geometry in
                Image(Assets.dish1)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .cornerRadius(8)
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
                    VStack{
                        let restOfImages = imageNames.dropFirst()
                        ForEach(restOfImages, id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width / 2, height: (geometry.size.height - 8) / 2)
                                .clipped()
                                .cornerRadius(8)
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
                        }
                    }
                }
            }
        }
    }
}

