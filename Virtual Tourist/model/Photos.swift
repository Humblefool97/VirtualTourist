//
//  Photos.swift
//  Virtual Tourist
//
//  Created by Rajeev Ranganathan on 11/12/18.
//  Copyright © 2018 Rajeev Kalkunte RANGANATHAN. All rights reserved.
//

import Foundation

public class Photos{
    var urlList:[String]? = nil
    var numOfPages = 0

    init(urlList:[String]?,pages:Int) {
        self.urlList = urlList
        self.numOfPages = pages
    }
}
