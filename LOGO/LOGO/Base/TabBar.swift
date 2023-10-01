
import SwiftUI

struct TabBar: View {
    
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    
    var body: some View {
        ZStack{
            VStack {
                Spacer()
                HStack {
                    content
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom,35)
                .padding(.horizontal,20)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.white)
                            .shadow(color: Color.gray.opacity(0.1), radius: 1, x: 0, y: -2)
                            .frame(height: 90)
                    }
                )
            }
        }
        .ignoresSafeArea()

        
    }
    
    var content: some View {
        ForEach(tabItems) { item in
                Image(item.icon)
                    .renderingMode(.template)
                    .foregroundColor(selectedTab == item.tab ? Color.accentColor : Color("lightGreyColor"))
                    .frame(width: 36, height: 36)
                    .frame(maxWidth: .infinity)
                
                    .background(
                        VStack {
                            RoundedRectangle(cornerRadius: 2)
                                .frame(width: selectedTab == item.tab ? 20 : 0, height: 4)
                                .offset(y: -4)
                                .opacity(selectedTab == item.tab ? 1 : 0)
                            Spacer()
                        }
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            selectedTab = item.tab
                        }
                    }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}

struct TabItem: Identifiable {
    var id = UUID()
    var icon: String
    var tab: Tab
}

var tabItems = [
    TabItem(icon: "home", tab: .home),
    TabItem(icon: "shop", tab: .store),
    TabItem(icon: "promo", tab: .promo),
    TabItem(icon: "gallery", tab: .gallery),
    TabItem(icon: "profile", tab: .profile)
]

enum Tab: String {
    case home
    case store
    case promo
    case gallery
    case profile
}
