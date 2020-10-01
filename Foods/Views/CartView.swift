//
//  CartView.swift
//  Foods
//
//  Created by Riki on 9/19/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CartView: UIViewController {
    
    static let identifier = "CartView"
    
    @IBOutlet weak var checkOutView: UIView!
    @IBOutlet weak var foodCollectionView: UICollectionView!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var btnCheckOut: UIButton!
    
    private let mCartViewModel = CartViewModel()
    private let bag = DisposeBag()
    
    private var price: Double = 0
    private var totalAmount: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setUpFoodCollectionView()
        initDataObservations()
    }
    
    private func configure() {
        btnCheckOut.layer.cornerRadius = 12
        checkOutView.layer.cornerRadius = 46
        checkOutView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setUpFoodCollectionView() {
        
        let itemPadding: CGFloat = 36
        let collectionViewHeight: CGFloat = view.bounds.size.height * 0.6
        let itemHeight: CGFloat = collectionViewHeight - 2 * itemPadding
        let itemWidth: CGFloat = itemHeight * (3 / 4)
        let insetX: CGFloat = (view.bounds.width - itemWidth) / 2.0
        let insetY: CGFloat = ((view.bounds.height * 0.6) - itemHeight) / 2.0
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemPadding
        
        foodCollectionView.delegate = self
        foodCollectionView.setCollectionViewLayout(layout, animated: true)
        foodCollectionView.showsHorizontalScrollIndicator = false
        foodCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        foodCollectionView.register(with: CartItem.identifier)
    }
    
    private func initDataObservations() {
        
        mCartViewModel
            .mFoodList
            .observeOn(MainScheduler.instance)
            .bind(to: foodCollectionView.rx.items(cellIdentifier: CartItem.identifier, cellType: CartItem.self)) {(_, data, cell) in
                cell.mFood = data
                cell.bind(with: data)
                self.price += data.price
            }
        .disposed(by: bag)
        
        mCartViewModel.fetchFoodListFromCart()
        
        print(self.price)
        totalAmount += price
        lblTotalAmount.text = String("$\(totalAmount)")
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CartView: UIScrollViewDelegate, UICollectionViewDelegate {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.foodCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
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
