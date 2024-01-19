//Created for Ebcom in 2024
// Using Swift 5.0

import Foundation

protocol UserDefaultsClient {
    func saveJson(_ json: String)
    func getJson() -> String?
    func clearCache()
    func hasValue() -> Bool
}

class MessageCache : UserDefaultsClient {
    
    static let shared = MessageCache()
    private let defaults = UserDefaults.standard
    private let cacheKey = "message_cache"
    private var cache : String? {
        return getJson()
    }


    func saveJson(_ json: String) {
        defaults.set(json, forKey: cacheKey)
    }

    func getJson() -> String? {
        return defaults.string(forKey: cacheKey)
    }

    func clearCache() {
        defaults.removeObject(forKey: cacheKey)
        URLCache().removeAllCachedResponses()
    }
    
    func hasValue() -> Bool {
        return cache != nil
    }
        
}
