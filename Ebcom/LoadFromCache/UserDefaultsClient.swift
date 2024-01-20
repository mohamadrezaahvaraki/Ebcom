//Created for Ebcom in 2024
// Using Swift 5.0

import Foundation

public protocol UserDefaultsClient {
    func saveJson(_ json: String)
    func getJson() -> String?
    func clearCache()
    func hasValue() -> Bool
}

public class MessageCache : UserDefaultsClient {
    
    static let shared = MessageCache()
    private let defaults = UserDefaults.standard
    private let cacheKey = "message_cache"
    private var cache : String? {
        return getJson()
    }


    public func saveJson(_ json: String) {
        defaults.set(json, forKey: cacheKey)
    }

    public func getJson() -> String? {
        return defaults.string(forKey: cacheKey)
    }

    public func clearCache() {
        defaults.removeObject(forKey: cacheKey)
        URLCache().removeAllCachedResponses()
    }
    
    public func hasValue() -> Bool {
        return cache != nil
    }
        
}
