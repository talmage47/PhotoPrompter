import Foundation
import CoreData

@objc(PhotoPair)
public class PhotoPair: NSManagedObject {
    
    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var prompt: String?
    @NSManaged public var frontImage: Data?
    @NSManaged public var backImage: Data?
}

extension PhotoPair {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoPair> {
        return NSFetchRequest<PhotoPair>(entityName: "PhotoPair")
    }
}
