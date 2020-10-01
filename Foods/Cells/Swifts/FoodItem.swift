//
//  FoodItem.swift
//  Foods
//
//  Created by Riki on 9/18/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit

class FoodItem: UICollectionViewCell {
    
    static let identifier = "FoodItem"

    @IBOutlet weak var ivFood: UIImageView!
    @IBOutlet weak var lblMenu: UILabel!
    
    override var isSelected: Bool {
            didSet {
                self.ivFood.alpha = isSelected ? 0.75 : 1.0
            }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ivFood.layer.cornerRadius = 16
    }
    
    func bind(with food: FoodInfo) {
        lblMenu.text = food.name
        ivFood.setImage(with: food.imageUrl ?? "")
    }
}
