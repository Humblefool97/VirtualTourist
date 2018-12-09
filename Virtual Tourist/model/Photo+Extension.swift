//
//  Photo+Extension.swift
//  Virtual Tourist
//
//  Created by Rajeev Ranganathan on 01/12/18.
//  Copyright © 2018 Rajeev Kalkunte RANGANATHAN. All rights reserved.
//


import Foundation
import CoreData

extension Photo {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }
    
    @NSManaged public var image: Data?
    @NSManaged public var url: String?
    @NSManaged public var pin: Pin?
    
}

