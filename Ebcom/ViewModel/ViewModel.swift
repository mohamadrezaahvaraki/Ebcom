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
            do {
                try cache.readFromCache { [weak self] messages in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.messages = self.cache.sortMessages(messages)
                    }
                }
            }catch {
                print("Data decode error from cache")
                loadFromLoader()
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
                        let sortedMessages = self.cache.sortMessages(messages)
                        self.messages = sortedMessages
                        self.cache.storeToCache(sortedMessages)
                    }
                }
            }
        }
    }

    func setTagged(id: UUID, status: Bool) {
        cache.updateValue(messages: &messages, forKey: "isTagged", id: id, status: status)
        cache.storeToCache(messages)
    }

    func setRead(id: UUID, status: Bool) {
        cache.updateValue(messages: &messages, forKey: "isRead", id: id, status: status)
        cache.storeToCache(messages)
    }

    func updateCache() {
        cache.storeToCache(messages)
    }

    func removeFromCache(items: [Message]) {
        let toBeSaved = messages.filter { !items.contains($0) }
        cache.storeToCache(toBeSaved)
        try! cache.readFromCache { [weak self] messages in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.messages = messages
            }
        }
    }
}
