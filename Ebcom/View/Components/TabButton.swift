//Created for Ebcom in 2024
// Using Swift 5.0

import SwiftUI

struct TabButton: View {
    let title: String
    let tag: String
    var messageCount : Int
    @Binding var selectedTab: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(selectedTab == tag ? .primary : .secondary)
            Text("\(messageCount)")
                .padding(2)
                .isHidden(tag != "general", remove: true)
                .background(Circle()
                    .foregroundColor(selectedTab == tag ? .red : .secondary)
                    .scaledToFill()
                )
                .foregroundColor(.white)

        }
        .font(Font.get(.body))
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .environment(\.layoutDirection, .rightToLeft)
        .border(width: selectedTab == tag ? 5 : 0, edges: [.bottom], color: Color.init(hex: "#1FBEDC"))

    }
}

#Preview {
    TabButton(title: "عمومی", tag: "general", messageCount: (6), selectedTab: .constant("general"))
}
