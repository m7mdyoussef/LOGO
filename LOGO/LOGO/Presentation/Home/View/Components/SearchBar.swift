
import SwiftUI

struct SearchBar: View {

    //properties
    @State var isLoading: Bool
    @Binding var text: String
    @Binding var isEditing: Bool
    var didTapCancelSearch: (() -> Void)?
    
    //body
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                Image(Assets.search)
                        .foregroundColor (Color.gray)
                        .frame(width: 40, height: 40)
                
                TextField("", text: $text)
                    .background(Color.clear)
                    .font(.headline)
                    .placeHolder(Text(Constants.PlaceHolder.searchPosts).font(.headline)
                        .foregroundColor(Color.lightGreyColor), show: text.isEmpty)
                    .onTapGesture(perform: {
                        isEditing = true
                    })
                    if isLoading {
                        Button(action: {
                            text = .empty
                        }, label: {
                            ActivityIndicator(style: .medium, animate: .constant(true))
                                .configure {
                                    $0.color = .black
                                }
                        })
                        .frame(width: 35, height: 35)
                    } else {
                        Button(action: {
                            text = .empty
                            isEditing = false
                            dismissKeyboard()
                            if let didTapCancelSearch = self.didTapCancelSearch {
                                didTapCancelSearch()
                            }
                        }, label: {
                            Image(Assets.close)
                                .foregroundColor(Color.gray)
                                .frame(width: 40, height: 40)
                        }).frame(width: 35, height: 35)
                    }
            }.padding(.vertical, 5)
             .padding(.horizontal, 8)
             .frame(height: 40.0)
             .background(Color.white)
             .overlay(RoundedRectangle(cornerRadius: 8.0)
                .strokeBorder(Color.lightGreyColor, style: StrokeStyle(lineWidth: 1.5)))
        }
    }
}
