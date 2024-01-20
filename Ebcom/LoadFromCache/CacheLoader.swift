//Created for Ebcom in 2024
// Using Swift 5.0

import Foundation

public final class CacheLoader {
    
    private let client: UserDefaultsClient
    private let cacheKey = "message_cache"
    
    // Initializes a new instance of the `CacheLoader` class.
    public init(client: UserDefaultsClient){
        self.client = client
    }
    
    // Stores Messages in cache
    public func storeToCache(_ messages: [Message]) {
        guard let (_ , jsonString) = try? encode(messages) else {
            return
        }
        client.saveJson(jsonString)
    }

    // Loads Messages using the completion handler with the result.
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
    
    // Updates Messages values in cache
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
    
    // Sorts Messages using the completion handler with the result.
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
    
    // Checks for exisance of Messages in cache
    public func hasValue() -> Bool {
        return self.client.hasValue()
    }
    
    // Clears the Messages cache
    public func clearCache() {
        return self.client.clearCache()
    }
    
    // Maps retrieved Messages to the Message model
    private func map(_ data: Data) -> MessageLoader.MessageResult {
        do {
            let Messages = try MessagesMapper.map(data)
            return .success(Messages)
        }catch {
            print(error)
            return .failure(.invalidData)
        }
    }
    
    // Maps messages from model to Data in order to store them.
    private func encode(_ messages: [Message]) throws -> (Data, String) {
        do {
            return try MessagesMapper.encoder(messages)
        }catch {
            print(error)
            throw error
        }
    }
}
