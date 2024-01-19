//Created for Ebcom in 2024
// Using Swift 5.0

import Foundation

// Maps the response data to an array of `MessageBased on the provided code, here's an explanation of the comments/documentation:

internal final class MessagesMapper {
    
    private struct MessageItem: Decodable {
        let uuid: UUID
        let title: String
        var date: String?
        let description: String
        var expireDate: String?
        let image: String
        var unread: Bool
        let isTagged: Bool?
        
        
        var message: Message {
            return Message(id: uuid, title: title, message: description, imageURL: image, isRead: unread)
        }
    }
    
    internal static func map (_ data: Data,_ response: HTTPURLResponse) throws -> [Message] {
        guard response.statusCode == 200 else {
            throw MessageLoader.MessageLoaderError.invalidData
        }
        do {
            let root = try JSONDecoder().decode([MessageItem].self, from: data)
            return root.map{ $0.message }
        }catch {
            print("Error decoding \(error)")
            throw error
        }
    }
}
