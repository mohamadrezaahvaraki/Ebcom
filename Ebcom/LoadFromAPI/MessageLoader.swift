//Created for Ebcom in 2024
// Using Swift 5.0

import Foundation

public final class MessageLoader {
    private let client: HTTPClient
    private let url : URL
    
    // Represents the result of loading Messages.
    // - success: Loading Messages was successful, providing an array of `Message` objects.
    // - failure: Loading Messages failed, providing a `MessageLoaderError`.
    public enum MessageResult : Equatable{
        case success([Message])
        case failure(MessageLoaderError)
    }
    
    // Represents the possible errors that can occur during Message loading.
    public enum MessageLoaderError : String, Swift.Error {
        case connectivity = "Connection Error"
        case invalidData = "Decoding Problem"
        case doesNotExistInCache = "Data does not exists in cache"
    }
    
    // Initializes a new instance of the `MessageLoader` class.
    public init(url: URL , client: HTTPClient){
        self.url = url
        self.client = client
    }
    
    // Loads Messages asynchronously and calls the completion handler with the result.
    public func load(completion: @escaping (MessageResult) -> Void) {
        
        Task {
            do {
                try await self.client.get(from: self.url) { result in
                    switch result{
                    case let .success(data, response):
                        completion(self.map(data, from: response))
                    case .failure:
                        completion(.failure(.connectivity))
                    }
                }
            }catch {
                print(error)
            }
        }
    }
    
    // Maps the response data to a `Result` type.
    private func map(_ data: Data, from response: HTTPURLResponse) -> MessageResult {
        do {
            let Messages = try MessagesMapper.map(data, response)
            return .success(Messages)
        }catch {
            print(error)
            return .failure(.invalidData)
        }
    }
}
