import ParseSwift
import Foundation

struct Place: ParseObject {
    var originalData: Data?
    
    // ParseObject gereksinimleri
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    // Kendi verilerimiz
    var name: String?
    var type: String?
    var atmosphere: String?
    var latitude: String?
    var longitude: String?
    var image: ParseFile?
}
