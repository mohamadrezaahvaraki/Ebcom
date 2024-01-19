//Created for Ebcom in 2024
// Using Swift 5.0

import SwiftUI

@main
struct EbcomApp: App {
    let persistenceController = PersistenceController.shared

    let vm = MessageLoader(
        url: URL(string: "https://run.mocky.io/v3/729e846c-80db-4c52-8765-9a762078bc82")!,
                           client: URLSessionHTTPClient(session: URLSession(configuration: .default)))
    
    var body: some Scene {
        WindowGroup {
            
            MessagesView()
            
            
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
