//Created for Ebcom in 2024
// Using Swift 5.0

import XCTest
@testable import Ebcom

final class MessageLoaderTests : XCTestCase {
    
    func test_init_doesNotRequestURLFromServer(){
        
        let (_,client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_RequestDataFromURL(){
        
        let url = URL(string: "http://a-given-url.com")!
        let (sut,client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs,[url])
    }
    
    func test_load_TwiceRequestDataFromURL(){
        
        let url = URL(string: "http://a-given-url.com")!
        let (sut,client) = makeSUT(url: url)
        
        sut.load { _ in }
        sleep(4)
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs,[url,url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut,client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200Response() {
        let (sut,client) = makeSUT()
        
        let samples = [199,201,300,400,500]
        samples.enumerated().forEach { index, code in
            
            expect(sut, toCompleteWithResult: .failure(.invalidData)) {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: code, data: json,at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200ResponseInvalidJSON() {
        let (sut,client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .failure(.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200,data: invalidJSON)
        }
    }
    
    func test_load_deliversNoItemsOn200ResponseWithEmptyJSONList() {
        let (sut,client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .success([])) {
            let emptyListJson = makeItemsJSON([])
            client.complete(withStatusCode: 200,data: emptyListJson)
        }
    }
    
    func test_load_deliversItemsOn200ResponseWithJSONItems() {
        let (sut,client) = makeSUT()
        
        let (message1, message1JSON) = makeItems(id: UUID(), title: "title1", messageBody: "body1", image: "http://a-image-url1.com", unread: false)
        let (message2, message2JSON) = makeItems(id: UUID(), title: "title2", messageBody: "body2", image: "http://a-image-url2.com", unread: false)

        
        let messages = [message1, message2]
        
        expect(sut, toCompleteWithResult: .success(messages)) {
            
            let json = makeItemsJSON([message1JSON,message2JSON])
            client.complete(withStatusCode: 200,data: json)
            
        }
    }
    
    //Tests Helper Funcitons
    private func makeSUT(url: URL =  URL(string: "http://a-given-url.com")!) -> (sut: MessageLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = MessageLoader(url: url, client: client)
        return (sut,client)
    }
    
    private func expect(_ sut: MessageLoader , toCompleteWithResult result: MessageLoader.MessageResult,when action: () -> Void, file: StaticString  = #file, line: UInt = #line ) {
        var capturedResults = [MessageLoader.MessageResult]()
        sut.load { capturedResults.append($0) }
        sleep(2)
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private func makeItems(id: UUID, title: String, messageBody: String, image: String,unread: Bool) -> (model: Message, jsonModel: [String:Any]) {
        
        let message = Message(id: id, title: title,message: messageBody, imageURL: image, isRead: unread)
        
        let messageJSON = ["uuid": id.uuidString ,"title": title,"description": messageBody, "unread": false, "image": image] as [String : Any]
        return (message, messageJSON)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = items
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs : [URL] {
            return messages.map { $0.url }
        }
        
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        func get (from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url,completion))
        }
        
        func complete(with error: Error, at index: Int = 0){
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0){
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)
            messages[index].completion(.success(data, response!))
        }
    }
}

