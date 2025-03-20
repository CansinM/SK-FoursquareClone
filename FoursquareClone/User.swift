import Foundation
import ParseSwift

struct User: ParseUser {
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    
    var username: String?
    var password: String?
    var email: String?
    
    var emailVerified: Bool?
    var authData: [String: [String: String]?]?
    
    // Varsayılan init fonksiyonu
    init() {}
}

