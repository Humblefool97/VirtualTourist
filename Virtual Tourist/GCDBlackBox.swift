//
//  GCDBlackBox.swift
//  Virtual Tourist
//
//  Created by Rajeev Ranganathan on 02/12/18.
//  Copyright © 2018 Rajeev Kalkunte RANGANATHAN. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
