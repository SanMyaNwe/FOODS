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
    
    override var isSelected: Bool {
        didSet {
            self.categoryView.backgroundColor = isSelected ? UIColor.black : UIColor.lightGray
            self.ivCategory.backgroundColor = isSelected ? UIColor.black : UIColor.lightGray
            ivCategory.image = ivCategory.image?.withRenderingMode(.alwaysTemplate)
            self.ivCategory.tintColor = isSelected ? UIColor.white : UIColor.black
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryView.layer.cornerRadius = 16
    }
    
    func bind(with food: FoodInfo) {
        ivCategory.setImage(with: food.icon ?? "")
        lblName.text = food.name ?? ""
    }

}
