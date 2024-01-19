//Created for Ebcom in 2024
// Using Swift 5.0

import XCTest
@testable import Ebcom

final class Ebcom_Cache_Tests: XCTestCase {

    class MessageCacheTests: XCTestCase {
        
        func test_Save_Message() {
            let json = """
            {
                "id": "cc959d44-976e-4757-b43c-62043261dbf6",
                "title": "test title",
                "date": "test date 1",
                "message": "test message 1",
                "expireDate": "test expire date 1",
                "imageURL": "https://a-test-url.com",
                "isRead": true,
                "isTagged": false
            }
            """
            MessageCache.shared.saveJson(json)
            XCTAssertEqual(MessageCache.shared.getJson(), json)
        }

        func test_Get_Message() {
            let json = """
            {
                "id": "cc959d44-976e-4757-b43c-62043261dbf6",
                "title": "test title",
                "date": "test date 1",
                "message": "test message 1",
                "expireDate": "test expire date 1",
                "imageURL": "https://a-test-url.com",
                "isRead": true,
                "isTagged": false
            }
            """
            MessageCache.shared.saveJson(json)
            XCTAssertEqual(MessageCache.shared.getJson(), json)
        }

        func test_Clear_Cache() {
            let json = """
            {
                "id": "cc959d44-976e-4757-b43c-62043261dbf6",
                "title": "test title",
                "date": "test date 1",
                "message": "test message 1",
                "expireDate": "test expire date 1",
                "imageURL": "https://a-test-url.com",
                "isRead": true,
                "isTagged": false
            }
            """
            MessageCache.shared.saveJson(json)
            MessageCache.shared.clearCache()
            XCTAssertNil(MessageCache.shared.getJson())
        }
    }
}
