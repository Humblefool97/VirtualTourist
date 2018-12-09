//
//  AppDelegate.swift
//  Virtual Tourist
//
//  Created by Rajeev Kalkunte RANGANATHAN on 20/11/18.
//  Copyright © 2018 Rajeev Kalkunte RANGANATHAN. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       //Configure coredata stack
        DataController.shared.load()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        DataController.shared.saveContext()
    }
}

