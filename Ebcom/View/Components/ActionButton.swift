//Created for Ebcom in 2024
// Using Swift 5.0

import SwiftUI

public enum ButtonType {
    case delete
    case cancel
}

struct ActionButton: View {
    
    var title: String
    var type: ButtonType = .delete
    var action : () -> Void = { }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40)
                .foregroundColor(type == .delete ? Color.init(hex: "#FF8800") : Color.white)
                .padding()
            
        }
        .border(Color.init(hex: "#FF8800"),width: 1,cornerRadius: 8)
        .background(type == .delete ? Color.clear : Color.init(hex: "#FF8800"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.font, Font.get(.buttonTitle))
        
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(title: "حذف")
    }
}
