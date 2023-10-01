

import SwiftUI

struct AuthTextView: View {
    //properties
    @Binding var textValue:String
    @Binding var isSecured: Bool
    var isPassword:Bool
    var title:String
    var authHeader:String
    var keyboardType: UIKeyboardType = .default
    
    //Functions
    func secureFieldType() -> some View{
       return SecureField(title, text: $textValue)
            .keyboardType(keyboardType)
        
    }
    
    func regularFieldType() -> some View{
       return TextField(title, text: $textValue)
            .keyboardType(keyboardType)
    }

    //body
    var body: some View {
        VStack(alignment: .leading){
            Text(authHeader)
                .font(.headline)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
            
            HStack{
                if isPassword{
                    if isSecured{
                        secureFieldType()
                    }else{
                        regularFieldType()
                    }
                    Button(action: {
                        self.isSecured.toggle()
                    }) {
                        Image (self.isSecured ? "view" : "hide" )
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                            .foregroundColor (Color.gray.opacity (0.75))
                    }
                }else{
                    regularFieldType()
                }
            }
            .padding(16)
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 8.0)
                .strokeBorder(Color("lightGreyColor"), style: StrokeStyle(lineWidth: 1.5)))
        }
        .padding(.vertical, 5)
    }
}

