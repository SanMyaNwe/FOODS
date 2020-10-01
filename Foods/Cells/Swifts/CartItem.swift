//
//  CartItem.swift
//  Foods
//
//  Created by Riki on 9/19/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit

class CartItem: UICollectionViewCell {
    
    static let identifier = "CartItem"
    
    @IBOutlet weak var foodView: UIView!
    @IBOutlet weak var lblFood: UILabel!
    @IBOutlet weak var ivFood: UIImageView!
    @IBOutlet weak var btnReduceQty: UIButton!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var btnAddQty: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    
    var mFood: Food? = nil
    
    private var price: Double = 0
    private var quantities: Double = 0
    var totalAmount: Double = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    func bind(with food: Food) {
        lblFood.text = food.name
        ivFood.setImage(with: food.imageUrl ?? "")
        lblPrice.text = String("$ \(food.price)")
    }
    
    private func configure() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.masksToBounds = false
        foodView.layer.cornerRadius = 32
        ivFood.layer.cornerRadius = ivFood.frame.height / 2
        ivFood.clipsToBounds = true
        btnReduceQty.layer.cornerRadius = 8
        btnAddQty.layer.cornerRadius = 8
        btnRemove.layer.cornerRadius = 32
        btnRemove.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    @IBAction func reduceQuantity(_ sender: Any) {
        
        var qty = Int(quantity.text!) ?? 0
        if qty > 1 {
            qty -= 1
            
            quantities = Double(qty)
            price = quantities * (mFood?.price ?? 0)
            totalAmount += price
            
            quantity.text = String(qty)
            lblPrice.text = String("$ \(price)")
            totalAmount = 0
        }
    }
    
    @IBAction func addQuantity(_ sender: Any) {
        
        var qty = Int(quantity.text!) ?? 0
        // TODO limit NoOfQuantity instead of 10
        if qty < 10 {
            qty += 1
            
            quantities = Double(qty)
            price = quantities * (mFood?.price ?? 0)
            totalAmount += price
            
            quantity.text = String(qty)
            lblPrice.text = String("$ \(price)")
            totalAmount = 0
        }
    }
    
    @IBAction func removeItemFromCart(_ sender: Any) {
        FoodPersistenceService.shared.removeFromCart(name: mFood?.name ?? "")
    }
}
