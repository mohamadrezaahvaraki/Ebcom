//Created for Ebcom in 2024
// Using Swift 5.0

import SwiftUI

struct MessagesView: View {
    @ObservedObject var vm: ViewModel
    @State var messages: [Message] = []
    @State var selectedMessages: [Message] = []
    @State var selectedMessage: Message?
    @State private var selectedTab = "general"
    @State private var showSelectionBox = false
    @State private var messageCollapse = false
    
    var body: some View {
        VStack(spacing: 1) {
            Tabbar(selectedTab: $selectedTab, messageCount: vm.messages.filter{ return $0.isRead }.count)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.05, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.init(hex: "#CFF5FF"))
                )
            
            MessagesListView(vm: vm, selectedTab: $selectedTab, selectedMessages: $selectedMessages, showSelectionBox: $showSelectionBox)
            
            SelectionButtonsView(vm: vm,selectedMessages: $selectedMessages, showSelectionBox: $showSelectionBox)
        }
        .background(Color.init(hex: "#F4F9FA"))
        .onAppear {
            vm.load()
        }
    }
}

#Preview {
    MessagesView(vm: ViewModel(apiCall: MessageLoader(
        url: URL(string: "https://run.mocky.io/v3/4f4aff79-37c5-4392-9820-878f0cf6f5d9")!,
        client: URLSessionHTTPClient(session: URLSession(configuration: .default))), cache: CacheLoader(client: MessageCache.shared)) ,
                 messages: [
        Message(id: UUID(), title: "تیتر پیام",
                date: "۱۴۰۰/۱۰/۲۴ - ۱۰:۵۰",
                message: "لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ، و با استفاده از طراحان گرافیک است، چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است، و برای شرایط فعلی تکنولوژی مورد نیاز، و کاربردهای متنوع با هدف بهبود ابزارهای کاربردی می باشد، کتابهای زیادی در شصت و سه درصد گذشته حال و آینده، شناخت فراوان جامعه و متخصصان را می طلبد،",
                expireDate: "۱۴۰۰/۱۱/۳۰ - ۱۳:۰۰",
                imageURL: "bigImage",
                isRead: true,
                isTagged: true),
        Message(id: UUID(), title: "تیتر پیام ۲",
                date: "۱۴۰۰/۱۰/۲۴ - ۱۰:۵۰",
                message: "لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ، و با استفاده از طراحان گرافیک است، چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است، و برای شرایط فعلی تکنولوژی مورد نیاز، و کاربردهای متنوع با هدف بهبود ابزارهای کاربردی می باشد، کتابهای زیادی در شصت و سه درصد گذشته حال و آینده، شناخت فراوان جامعه و متخصصان را می طلبد،",
                expireDate: "۱۴۰۰/۱۱/۳۰ - ۱۳:۰۰",
                imageURL: "",
                isRead: false,
                isTagged: true)
    ])
}
