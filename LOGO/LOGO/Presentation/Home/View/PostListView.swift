
import SwiftUI

/// returns a view of Post component
struct PostListView: View {
    //properties
    @StateObject var viewModel: HomeViewModel
    var postType:PostType
    @Binding var isLoading: Bool
    @Binding var cashedDataPresented: Bool
    
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
                            VStack(alignment: .leading, spacing: 4) {
                                Text(Constants.PlaceHolder.PostUserName).font(.headline)
                                    .fontWeight(.medium)
                                Text(Constants.PlaceHolder.PostTime).font(.subheadline).foregroundColor(.gray)
                            }//: VStack
                        }//: HStack

                        Text(post.body ?? "")
                            .foregroundColor(Color.darkGrey)
                            .lineLimit(nil)
                        
//                        if let attributedString = attributedText(for: post.body ?? "", rangeText:viewModel.searchText) {
//                            Text(attributedString)
//                                .lineLimit(nil)
//                        } else {
//                            Text(post.body ?? "")
//                        }
//
                        GeometryReader { geometry in
                            Image(Assets.dish1)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .clipped()
                                .cornerRadius(8)
                        }//: GeometryReader
                        .frame(minHeight: 150, idealHeight: 250)
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
        }//: ScrollView
    }
    
    
}


//extension PostListView{
//    func attributedText(for body: String , rangeText:String) -> NSAttributedString? {
//        let attributedString = NSMutableAttributedString(string: body)
//        let range = (body as NSString).range(of: rangeText)
//
//        if range.location != NSNotFound {
//            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: range)
//            attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range) // Change the color to your desired color
//
//            return attributedString
//        } else {
//            return nil
//        }
//    }
//}
//



//
//
//
//extension NSMutableAttributedString {
//    func bold(_ text: String) -> NSMutableAttributedString{
//        let fullRange = NSRange(location: 0, length: self.length)
//        
//        if let range = self.string.range(of: text) {
//            let nsRange = NSRange(range, in: self.string)
//            
//            // Create two attributed strings, one for the text inside the range and one for the text outside
//            let attributedStringInsideRange = NSMutableAttributedString(string: self.string)
//            attributedStringInsideRange.addAttribute(.foregroundColor, value: UIColor.red, range: nsRange)
//            attributedStringInsideRange.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: nsRange)
//            
//            let attributedStringOutsideRange = NSMutableAttributedString(attributedString: self)
//            attributedStringOutsideRange.addAttribute(.foregroundColor, value: UIColor.blue, range: NSRange(location: 0, length: self.length))
//            attributedStringOutsideRange.removeAttribute(.font, range: fullRange)
//            
//            // Combine the two attributed strings into one
//            attributedStringOutsideRange.replaceCharacters(in: nsRange, with: attributedStringInsideRange)
//            
//            // Update the current attributed string
//            self.setAttributedString(attributedStringOutsideRange)
//            
//        }
//        return self
//    }
//
//}


