//Created for Ebcom in 2024
// Using Swift 5.0

import SwiftUI

struct SelectionButtonsView: View {
    @ObservedObject var vm: ViewModel
    @Binding var selectedMessages: [Message]
    @Binding var showSelectionBox: Bool

    var body: some View {
        HStack(alignment: .center) {
            ActionButton(title: "حذف", type: .delete) {
                withAnimation {
                    vm.removeFromCache(items: selectedMessages)
                    showSelectionBox.toggle()
                }
            }
            ActionButton(title: "انصراف", type: .cancel) {
                withAnimation {
                    showSelectionBox.toggle()
                    selectedMessages.removeAll()
                }
            }
        }
        .frame(height: 40)
        .padding()
        .isHidden(!showSelectionBox, remove: true)
    }
}

#Preview {
    SelectionButtonsView(vm: ViewModel(apiCall: MessageLoader(
        url: URL(string: "https://run.mocky.io/v3/4f4aff79-37c5-4392-9820-878f0cf6f5d9")!,
        client: URLSessionHTTPClient(session: URLSession(configuration: .default))), cache: CacheLoader(client: MessageCache.shared)), selectedMessages: .constant([]), showSelectionBox: .constant(false))
}
