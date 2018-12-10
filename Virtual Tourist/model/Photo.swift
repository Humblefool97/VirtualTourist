//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Rajeev Ranganathan on 01/12/18.
//  Copyright © 2018 Rajeev Kalkunte RANGANATHAN. All rights reserved.
//

import Foundation
import CoreData

public class Photo: NSManagedObject {
    convenience init(imageUrl: String, forPin: Pin, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName:"Photo", in: context) {
            self.init(entity: ent, insertInto: context)
            self.image = nil
            self.url = imageUrl
            self.pin = forPin
        } else {
            fatalError("Something went wrong!!")
        }
    }
}

