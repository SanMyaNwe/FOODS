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
import FacebookCore
import FacebookLogin

class CartView: UIViewController {
    
    static let identifier = "CartView"
    
    @IBOutlet weak var checkOutView: UIView!
    @IBOutlet weak var foodCollectionView: UICollectionView!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var btnCheckOut: UIButton!
    
    private let mCartViewModel = CartViewModel()
    private let bag = DisposeBag()
    
    private var totalAmount: Double = 0
    private var userProfile: Profile!
    
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
                cell.bind(with: data, mCartViewModel: self.mCartViewModel)
            }
        .disposed(by: bag)
        
        mCartViewModel.fetchFoodListFromCart()
        
        mCartViewModel
            .mTotalAmountObs
            .subscribe(onNext: { (data) in
                self.lblTotalAmount.text = String("$"+String(format: "%.2f", data))
        })
        .disposed(by: bag)
        
    }
    
    private func loginWithFacebook() {
        
        if let _ = AccessToken.current {
            
            self.showOrderConfirmMessage()
        } else {
            Constants.loginManager.logIn(permissions: ["public_profile","email"], viewController: self) { (result) in
                switch result {
                case .success(_, _, _):
                    self.showOrderConfirmMessage()
                case .failed(let error):
                    print(error.localizedDescription)
                case .cancelled:
                    break
                }
            }
        }
    }
    
    private func showOrderConfirmMessage() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: CustomAlertView.identifier)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func onClickCheckOut(_ sender: Any) {
        
        let alert = UIAlertController(title: "Do you want to allow?",
                                      message: "This app need to access your basic profile to complete your order.",
                                      preferredStyle: .alert)
        
        let btnAllow = UIAlertAction(title: "Allow", style: .default) { _ in
            self.loginWithFacebook()
        }
        
        let btnNotAllow = UIAlertAction(title: "Don't Allow",
                                        style: .cancel,
                                        handler: nil)
        
        alert.addAction(btnAllow)
        alert.addAction(btnNotAllow)
        self.present(alert, animated: true)
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
