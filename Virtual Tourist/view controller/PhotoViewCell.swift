//
//  PhotoViewCell.swift
//  Virtual Tourist
//
//  Created by Rajeev Ranganathan on 02/12/18.
//  Copyright © 2018 Rajeev Kalkunte RANGANATHAN. All rights reserved.
//

import Foundation
import UIKit

class PhotoViewCell:UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.contentView.backgroundColor = UIColor.red
                self.contentView.alpha = 0.5
            }
            else
            {
                self.transform = CGAffineTransform.identity
                self.contentView.backgroundColor = UIColor.gray
                 self.contentView.alpha = 1.0
            }
        }
    }
}
