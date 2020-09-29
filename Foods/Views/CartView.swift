//
//  CartView.swift
//  Foods
//
//  Created by Riki on 9/19/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit

class CartView: UIViewController {
    
    static let identifier = "CartView"
    
    @IBOutlet weak var checkOutView: UIView!
    @IBOutlet weak var FoodCollectionView: UICollectionView!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var btnCheckOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setUpFoodCollectionView()
    }
    
    private func configure() {
        btnCheckOut.layer.cornerRadius = 12
        checkOutView.layer.cornerRadius = 46
        checkOutView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setUpFoodCollectionView() {
//        let screenSize: CGSize = UIScreen.main.bounds.size
//        FoodCollectionView.layer.borderColor = UIColor.blue.cgColor
//        FoodCollectionView.layer.borderWidth = 1
        let itemPadding: CGFloat = 24
        let collectionViewHeight: CGFloat = view.bounds.size.height * 0.6
//        let itemWidth: CGFloat = screenSize.width * 0.65
//        let itemHeight: CGFloat = itemWidth * 1.6
        let itemHeight: CGFloat = collectionViewHeight - 2 * itemPadding
        let itemWidth: CGFloat = itemHeight * (3 / 4)
        let insetX: CGFloat = (view.bounds.width - itemWidth) / 2.0
        let insetY: CGFloat = ((view.bounds.height * 0.6) - itemHeight) / 2.0
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemPadding
        
        FoodCollectionView.dataSource = self
        FoodCollectionView.delegate = self
        FoodCollectionView.setCollectionViewLayout(layout, animated: true)
        FoodCollectionView.showsHorizontalScrollIndicator = false
        FoodCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        FoodCollectionView.register(with: CartItem.identifier)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CartView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: CartItem.identifier, for: indexPath) as! CartItem
        return item
    }
}

extension CartView: UIScrollViewDelegate, UICollectionViewDelegate {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.FoodCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWithIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing

        var offset = targetContentOffset.pointee
        let index = ( offset.x + scrollView.contentInset.left) / cellWithIncludingSpacing
        let roundedIndex = round(index)

        offset = CGPoint(x: roundedIndex * cellWithIncludingSpacing -
            scrollView.contentInset.left
            , y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
