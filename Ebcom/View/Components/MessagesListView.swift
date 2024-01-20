//Created for Ebcom in 2024
// Using Swift 5.0

import SwiftUI

struct MessagesListView: View {
    @ObservedObject var vm: ViewModel
    @Binding var selectedTab: String
    @Binding var selectedMessages: [Message]
    @Binding var showSelectionBox: Bool

    var body: some View {
        List {
            ForEach(selectedTab == "general" ? vm.messages : vm.messages.filter{ return $0.isTagged }, id: \.id) { message in
                MessageView(messageBody: message, showSelection: $showSelectionBox , selectedToRemove: $selectedMessages)
                    .buttonStyle(.plain)
                    .onTapGesture {}.onLongPressGesture(perform: {
                        withAnimation {
                            self.showSelectionBox.toggle()
                            self.selectedMessages.append(message)
                        }
                    })
                    .environmentObject(vm)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.init(hex: "#F4F9FA"))
        }
        .overlay(Group {
            if vm.messages.isEmpty {
                VStack(spacing: 25) {
                    Image("emptyView")
                    Text("هیچ پیامی جهت نمایش موجود نیست")
                        .environment(\.layoutDirection, .rightToLeft)
                        .font(Font.get(.body))
                }
            }
        })
        .listStyle(.plain)
        .environment(\.layoutDirection, .rightToLeft)
    }
}

#Preview {
    MessagesListView(vm: ViewModel(apiCall: MessageLoader(
        url: URL(string: "https://run.mocky.io/v3/4f4aff79-37c5-4392-9820-878f0cf6f5d9")!,
        client: URLSessionHTTPClient(session: URLSession(configuration: .default))), cache: CacheLoader(client: MessageCache.shared)), selectedTab: .constant("general"), selectedMessages: .constant([
            Message(id: UUID(), title: "تیتر پیام",
                    date: "۱۴۰۰/۱۰/۲۴ - ۱۰:۵۰",
                    message: "لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ، و با استفاده از طراحان گرافیک است، چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است، و برای شرایط فعلی تکنولوژی مورد نیاز، و کاربردهای متنوع با هدف بهبود ابزارهای کاربردی می باشد، کتابهای زیادی در شصت و سه درصد گذشته حال و آینده، شناخت فراوان جامعه و متخصصان را می طلبد،",
                    expireDate: "۱۴۰۰/۱۱/۳۰ - ۱۳:۰۰",
                    imageURL: "bigImage",
                    isRead: true,
                    isTagged: true)
        ]), showSelectionBox: .constant(false))
}
