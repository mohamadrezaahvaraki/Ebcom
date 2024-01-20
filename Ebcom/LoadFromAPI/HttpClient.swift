//Created for Ebcom in 2024
// Using Swift 5.0

import Foundation

// Represents the result of an HTTP request.
public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

// A protocol for an HTTP client.
public protocol HTTPClient {
    func get (from url: URL, completion: @escaping (HTTPClientResult) -> Void) async throws
}

// Initializes a new instance of the `URLSessionHTTPClient` class.
public class URLSessionHTTPClient: HTTPClient {

    private let session: URLSession
    
    public init(session: URLSession){
        self.session = session
    }
    
    // Represents the possible errors that can occur during an asynchronous URLSession operation.
    public enum URLSessionAsyncErrors: Error {
        case invalidUrlResponse, missingResponseData
    }
    
    // Performs an asynchronous GET request using URLSession and calls the completion handler with the result.
    public func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) async throws {
        
        var req = URLRequest(url: url,timeoutInterval: 5)
        req.httpMethod = "GET"
       
        return try await withCheckedThrowingContinuation { continuation in
            session.dataTask(with: req ) { data , response , error in
                if error != nil {
                    continuation.resume(throwing: URLSessionAsyncErrors.missingResponseData)
                    return
                }
                
                guard let data = data else {
                    continuation.resume(throwing: URLSessionAsyncErrors.invalidUrlResponse)
                    return
                }
                continuation.resume(returning: completion(.success(data, response as! HTTPURLResponse)))
            }
            .resume()
        }
    }
}

