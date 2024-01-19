//Created for Ebcom in 2024
// Using Swift 5.0

import Foundation

class CacheLoader {
    
    private let client: UserDefaultsClient
    private let cacheKey = "message_cache"

    public enum Result : Equatable{
        case success([Message])
        case failure(MessageLoaderError)
    }
    
    // Represents the possible errors that can occur during Message loading.
    public enum MessageLoaderError : Swift.Error {
        case connectivity
        case invalidData
    }
    
    
    public init(client: UserDefaultsClient){
        self.client = client
    }
    
    func storeToCache(_ messages: [Message]) {
        guard let jsonData = try? JSONEncoder().encode(messages),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return
        }
        client.saveJson(jsonString)
    }

    func readFromCache(completion : @escaping ([Message]) -> Void) {
        guard let encodedMessages = client.getJson(),
              let messages = try? JSONDecoder().decode([Message].self, from: encodedMessages.data(using: .utf8)!) else {
            return
        }
        completion(sortMessages(messages))
    }
    
    func updateValue(messages: inout [Message], forKey: String, id: UUID, status: Bool) {
        if let index = messages.firstIndex(where: { $0.id == id }) {
            var updatedMessage = messages[index]
            switch forKey {
            case "isTagged":
                updatedMessage.isTagged = status
            case "isRead":
                updatedMessage.isRead = status
            default:
                break;
            }
            messages[index] = updatedMessage
        }
        storeToCache(messages)
    }
    
    func sortMessages(_ messages: [Message]) -> [Message] {
        return messages.sorted { lhs, rhs in
            if lhs.isRead && !rhs.isRead {
                return true
            } else if !lhs.isRead && rhs.isRead {
                return false
            } else {
                return lhs.id > rhs.id
            }
        }
    }
    
    func hasValue() -> Bool {
        return self.client.hasValue()
    }
    
}
