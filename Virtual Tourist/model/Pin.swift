//
//  Pin.swift
//  Virtual Tourist
//
//  Created by Rajeev Ranganathan on 01/12/18.
//  Copyright © 2018 Rajeev Kalkunte RANGANATHAN. All rights reserved.
//

import Foundation
import CoreData

public class Pin: NSManagedObject {
    convenience init(latitude:Double,longitude:Double,context:NSManagedObjectContext) {
        if let pin = NSEntityDescription.entity(forEntityName: "Pin", in: context){
            self.init(entity: pin, insertInto: context)
            self.latitude = latitude
            self.longitude = longitude
        }else{
            fatalError("Something went wrong!!")
        }
    }
}

