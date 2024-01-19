//Created for Ebcom in 2024
// Using Swift 5.0

import Foundation

class ViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var messagesError: MessageLoader.MessageLoaderError? = nil

    private let apiCall: MessageLoader
    private let cache: CacheLoader

    init(apiCall: MessageLoader, cache: CacheLoader) {
        self.apiCall = apiCall
        self.cache = cache
    }

    func load() {
                
        if cache.hasValue() {
            print("Data exists in cache")
            cache.readFromCache { [self] messages in
                self.messages = cache.sortMessages(messages)
            }
        } else {
            print("Data does not exist in cache")
            loadFromLoader()
        }
    }

    private func loadFromLoader() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.apiCall.load { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        self.messagesError = error
                    case .success(let messages):
                        self.messages = self.cache.sortMessages(messages)
                        self.cache.storeToCache(self.cache.sortMessages(messages))
                    }
                }
            }
        }
    }

    func setTagged(id: UUID, status: Bool) {
        cache.updateValue(messages: &messages, forKey: "isTagged", id: id, status: status)
    }

    func setRead(id: UUID, status: Bool) {
        cache.updateValue(messages: &messages,forKey: "isRead", id: id, status: status)
    }
    
    func updateCache() {
        cache.storeToCache(messages)
    }
    
    func removeFromCache(items: [Message]) {
        let toBeSaved = messages.filter { !items.contains($0) }
        cache.storeToCache(toBeSaved)
        cache.readFromCache(completion: { messages in self.messages = messages })
    }
}
