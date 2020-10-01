//
//  UIImage++.swift
//  Foods
//
//  Created by Riki on 10/1/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit
import AVFoundation

extension UIImage {
    func height(width: CGFloat) -> CGFloat {
        let boundingRect = CGRect(x: CGFloat(0), y: CGFloat(0), width: width, height: CGFloat(MAXFLOAT))
        let rect = AVMakeRect(aspectRatio: self.size, insideRect: boundingRect)
        return rect.size.height
    }
}
