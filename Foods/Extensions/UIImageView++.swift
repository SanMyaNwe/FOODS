//
//  UIImageView++.swift
//  Foods
//
//  Created by Riki on 9/28/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    func setImage(with path: String) {
        self.sd_setImage(with: URL(string: path), completed: nil)
    }
}
