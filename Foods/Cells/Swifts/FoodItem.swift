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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ivFood.layer.cornerRadius = 16
    }
    
    func bind(with food: Food) {
        ivFood.setImage(with: food.imageUrl ?? "")
    }
}
