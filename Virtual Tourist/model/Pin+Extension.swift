//
//  Pin+Extension.swift
//  Virtual Tourist
//
//  Created by Rajeev Ranganathan on 01/12/18.
//  Copyright © 2018 Rajeev Kalkunte RANGANATHAN. All rights reserved.
//

import Foundation
import Foundation
import CoreData


extension Pin {
    
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var photo: NSSet?
    
}

// MARK: Generated accessors for photo
extension Pin {
    
    @objc(addPhotoObject:)
    @NSManaged public func addToPhoto(_ value: Photo)
    
    @objc(removePhotoObject:)
    @NSManaged public func removeFromPhoto(_ value: Photo)
    
    @objc(addPhoto:)
    @NSManaged public func addToPhoto(_ values: NSSet)
    
    @objc(removePhoto:)
    @NSManaged public func removeFromPhoto(_ values: NSSet)
    
}
