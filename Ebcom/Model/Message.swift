//Created for Ebcom in 2024
// Using Swift 5.0

import Foundation

public struct Message: Codable , Identifiable,Hashable, Equatable {
    
    public var id : UUID
    public let title: String
    public var date: String = "۱۴۰۰/۱۰/۲۴ - ۱۰:۵۰"
    public let message: String
    public var expireDate: String = "۱۴۰۰/۱۱/۳۰ - ۱۳:۰۰"
    public let imageURL: String
    public var isRead: Bool
    public var isTagged: Bool = false
    
}
