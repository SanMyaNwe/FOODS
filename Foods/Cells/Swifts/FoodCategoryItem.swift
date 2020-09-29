//
//  FoodCategoryItem.swift
//  Foods
//
//  Created by Riki on 9/18/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit

class FoodCategoryItem: UICollectionViewCell {
    
    static let identifier = "FoodCategoryItem"

    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var ivCategory: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryView.layer.cornerRadius = 16
    }
    
    func bind(with food: Food) {
        ivCategory.setImage(with: food.icon ?? "")
        lblName.text = food.name ?? ""
    }

}
