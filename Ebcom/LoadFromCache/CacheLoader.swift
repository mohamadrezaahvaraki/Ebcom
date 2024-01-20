//Created for Ebcom in 2024
// Using Swift 5.0

import Foundation

public final class CacheLoader {
    
    private let client: UserDefaultsClient
    private let cacheKey = "message_cache"
    
    public init(client: UserDefaultsClient){
        self.client = client
    }
    
    public func storeToCache(_ messages: [Message]) {
        guard let (_ , jsonString) = try? encode(messages) else {
            return
        }
        client.saveJson(jsonString)
    }

    public func readFromCache(completion : @escaping ([Message]) -> Void) throws {
        guard let encodedMessages = client.getJson() else {
            throw MessageLoader.MessageLoaderError.invalidData
        }
        let res = map(encodedMessages.data(using: .utf8)!)
        switch res {
        case .success(let messages):
            completion(sortMessages(messages))
            
        case .failure(let error):
            throw error
        }
    }
    
    public func updateValue(messages: inout [Message], forKey: String, id: UUID, status: Bool) {
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
    
    public func sortMessages(_ messages: [Message]) -> [Message] {
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
    
    public func hasValue() -> Bool {
        return self.client.hasValue()
    }
    
    public func clearCache() {
        return self.client.clearCache()
    }
    
    private func map(_ data: Data) -> MessageLoader.MessageResult {
        do {
            let Messages = try MessagesMapper.map(data)
            return .success(Messages)
        }catch {
            print(error)
            return .failure(.invalidData)
        }
    }
    
    private func encode(_ messages: [Message]) throws -> (Data, String) {
        do {
            return try MessagesMapper.encoder(messages)
        }catch {
            print(error)
            throw error
        }
    }
}
