//Created for Ebcom in 2024
// Using Swift 5.0

import SwiftUI

struct Tabbar: View {
    
    @Binding var selectedTab : String
    var messageCount : Int

    var body: some View {
        HStack(spacing: 0) {
            TabButton(title: "ذخیره شده", tag: "bookmarks", messageCount: messageCount, selectedTab: $selectedTab)
                .onTapGesture {
                    selectedTab = "bookmarks"
                }
            
            TabButton(title: "عمومی", tag: "general", messageCount: messageCount, selectedTab: $selectedTab)
                .onTapGesture {
                    selectedTab = "general"
                }
        }
    }
}


#Preview {
    Tabbar(selectedTab: .constant("general"), messageCount: (10))
}
