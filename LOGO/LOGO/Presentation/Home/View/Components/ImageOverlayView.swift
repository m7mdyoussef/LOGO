
import SwiftUI

struct ImageOverlayView: View {
    var imageName: String
    var isImageTapped: Bool
    
    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
        }
    }
}
