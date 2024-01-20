//Created for Ebcom in 2024
// Using Swift 5.0

import SwiftUI

@main
struct EbcomApp: App {
//    let persistenceController = PersistenceController.shared

    let vm = ViewModel(apiCall: MessageLoader(
        url: URL(string: "https://run.mocky.io/v3/4f4aff79-37c5-4392-9820-878f0cf6f5d9")!,
        client: URLSessionHTTPClient(session: URLSession(configuration: .default))), cache: CacheLoader(client: MessageCache.shared))

    
    var body: some Scene {
        WindowGroup {
            
            MessagesView(vm: vm)
                .environmentObject(vm)
        }
    }
}
