
import SwiftUI

struct SearchBar: View {

    @State var isLoading: Bool
    @Binding var text: String
    @Binding var isEditing: Bool
    var didTapCancelSearch: (() -> Void)?
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
               Image("search")
                        .foregroundColor (Color.gray)
                        .frame(width: 40, height: 40)
                
                TextField("", text: $text)
                    .background(Color.clear)
                    .font(FontManager.body)
                    .placeHolder(Text(Constants.PlaceHolder.searchPosts).font(FontManager.headLine_2)
                        .foregroundColor(.white.opacity(0.3)), show: text.isEmpty)
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
                            Image(systemName: "xmark.circle")
                                .foregroundColor(Color.gray)
                                .frame(width: 40, height: 40)
                        }).frame(width: 35, height: 35)
                    }
            }.padding(.vertical)
             .frame(height: 40.0)
             .background(Color.white)
             .overlay(RoundedRectangle(cornerRadius: 8.0)
                 .strokeBorder(Color("lightGreyColor"), style: StrokeStyle(lineWidth: 1.5)))
        }
    }
}
