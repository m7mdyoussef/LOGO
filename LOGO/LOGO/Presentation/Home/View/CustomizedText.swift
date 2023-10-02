
import SwiftUI

/// returns a Text with hilighted search keyword 
struct CustomizedText: View {
    let apiResponse: String
    let keyword: String
    
    var body: some View {
        let textComponents = apiResponse.components(separatedBy: " ")
        
        var modifiedText = Text("")
        
        for component in textComponents {
            if component.lowercased().contains(keyword.lowercased())  {
                modifiedText = modifiedText + Text("\(component) ")
                    .bold()
                    .foregroundColor(Color.black) // Change the color to your desired color
            } else {
                modifiedText = modifiedText + Text("\(component) ")
                    .foregroundColor(Color.darkGrey) // Change the color to your desired color
            }
        }
        
        return modifiedText
    }
}
