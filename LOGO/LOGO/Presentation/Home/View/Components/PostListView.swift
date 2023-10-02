
import SwiftUI

/// returns a view of Post component
struct PostListView: View {
    //properties
    @StateObject var viewModel: HomeViewModel
    var postType:PostType
    @Binding var isLoading: Bool
    @Binding var cashedDataPresented: Bool
    
    @State private var isUserImageTapped = false
    
    let imageNames: [String] = [Assets.dish1, Assets.dish2, Assets.dish3, Assets.dish4]
    
    //body
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center){
                let postList = (postType == .posts) ? viewModel.posts : viewModel.searchData
                ForEach(postList, id: \.id) { post  in
                    VStack(alignment: .leading, spacing: 15){
                        HStack{
                            Image(Assets.profileImg)
                                .resizable()
                                .clipShape (Circle())
                                .frame(width: 40, height: 40)
                                .clipped()
                                .onTapGesture {
                                    isUserImageTapped = true
                                }
                            VStack(alignment: .leading, spacing: 4) {
                                Text(Constants.PlaceHolder.PostUserName).font(.headline)
                                    .fontWeight(.medium)
                                Text(Constants.PlaceHolder.PostTime).font(.subheadline).foregroundColor(.gray)
                            }//: VStack
                        }//: HStack
                        
                        if let body = post.body, postType == .search {
                            CustomizedText(apiResponse: body, keyword: viewModel.searchText)
                        } else {
                            Text(post.body ?? "").foregroundColor(Color.darkGrey)
                        }
                        
                        let randomImageCount = getRandomCountInRange(min: 1, max: imageNames.count)
                        let randomImages = getRandomImages(count: randomImageCount)
                        CustomizedGeometry(imageNames: randomImages, viewMode: viewModel)
                    }//: VStack
                    .padding()
                    
                    Divider().frame(height: 3.0)
                }
                
                if isLoading {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.white.opacity(0.8))
                            .frame(width: 40.0, height: 40.0)
                        ActivityIndicator(style: .medium, animate: .constant(true))
                    }
                } else {
                    Color.clear
                        .onAppear {
                            if !isLoading, !self.viewModel.posts.isEmpty, (postType == .posts), !cashedDataPresented {
                                self.viewModel.loadMore()
                            }
                        }
                }
            }//: LazyVStack
            .sheet(isPresented: $isUserImageTapped) {
                Image(Assets.profileImg)
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        isUserImageTapped = false
                    }
            }
        }//: ScrollView
    }
    
    //functions
    
    /// returns a random count number within min - max range
    /// - Parameters:
    ///   - min: min range value
    ///   - max: max range value
    /// - Returns: returns a random number within min - max range
    func getRandomCountInRange(min: Int, max: Int) -> Int {
        return Int.random(in: min...max)
    }
    
    /// returns an array of images with random count
    /// - Parameter count: random count needed for sizing the array
    /// - Returns: random Images array
    func getRandomImages(count: Int) -> [String] {
        var randomImages: [String] = []
        
        while randomImages.count < count {
            let randomIndex = Int.random(in: 0..<imageNames.count)
            let randomImage = imageNames[randomIndex]
            
            // Check if the randomImage is not already in the array
            if !randomImages.contains(randomImage) {
                randomImages.append(randomImage)
            }
        }
        return randomImages
    }
}



