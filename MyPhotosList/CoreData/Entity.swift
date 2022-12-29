//
//  Entity.swift
//  MyPhotosList
//
//  Created by Halil YAŞ on 29.12.2022.
//

import Foundation
import CoreData

@objc(Entity)

public class Entity : NSManagedObject {
    
}

extension Entity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        
        return NSFetchRequest<Entity>(entityName: "Entity")
    }
    
    @NSManaged public var titleText : String?
    @NSManaged public var descriptionText : String?
    @NSManaged public var image : NSData?
}
