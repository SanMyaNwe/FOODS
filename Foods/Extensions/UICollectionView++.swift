//
//  UICollectionView++.swift
//  Foods
//
//  Created by Riki on 9/18/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func register(with id: String) {
        let nib = UINib(nibName: id, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: id)
    }
}
