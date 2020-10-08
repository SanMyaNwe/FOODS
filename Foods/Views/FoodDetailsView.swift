//
//  FoodDetailsView.swift
//  Foods
//
//  Created by Riki on 9/20/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FoodDetailsView: UIViewController {
    
    static let identifier = "FoodDetailsView"
    
    @IBOutlet weak var lblFoodCategory: UILabel!
    @IBOutlet weak var ivFood: UIImageView!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var foodCollectionView: UICollectionView!
    
    var mFood: FoodInfo? = nil
    var foodInfo: FoodInfo? = nil
    
    private let mFoodDetailsViewModel = FoodDetailsViewModel()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setUpFoodCollectionView()
        initDataObservations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        mFoodDetailsViewModel
            .mFoodList
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (data) in
                self.foodInfo = data.first
                self.ivFood.setImage(with: data.first?.imageUrl ?? "")
                self.lblFoodName.text = data.first?.name ?? ""
                self.lblPrice.text = String("$\(data.first?.price ?? 0)")
                self.lblDescription.text = data.first?.description ?? ""
            })
        .disposed(by: bag)
    }
    
    private func configure() {
        ivFood.layer.cornerRadius = 32
        btnCart.layer.cornerRadius = 12
    }
    
    private func setUpFoodCollectionView() {
        let screenWidth: CGFloat = self.view.bounds.size.width
        let itemPadding: CGFloat = 24
        let noOfItems: CGFloat = 2
        let totalPadding: CGFloat = itemPadding * ( noOfItems + 1)
        let itemWidth:CGFloat = ( screenWidth - totalPadding ) / noOfItems
        let itemHeight:CGFloat = itemWidth * ( 4 / 3 )
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        
        foodCollectionView.setCollectionViewLayout(layout, animated: true)
        foodCollectionView.contentInset = UIEdgeInsets(top: 0, left: itemPadding, bottom: 0, right: itemPadding)
        foodCollectionView.showsHorizontalScrollIndicator = false
        foodCollectionView.register(with: FoodItem.identifier)
        
        foodCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        foodCollectionView.reloadData()
    }
    
    private func initDataObservations() {
        lblFoodCategory.text = mFood?.name ?? ""
        mFoodDetailsViewModel.fetchFoodList(menu: mFood?.id ?? "")
        
        mFoodDetailsViewModel
            .mFoodList
            .observeOn(MainScheduler.instance)
            .bind(to: foodCollectionView.rx.items(cellIdentifier: FoodItem.identifier, cellType: FoodItem.self)) {(_, data, cell) in
                cell.bind(with: data)
            }
        .disposed(by: bag)
        
        foodCollectionView
            .rx
            .modelSelected(FoodInfo.self)
            .subscribe(onNext: { (data) in
                self.foodInfo = data
                self.ivFood.setImage(with: data.imageUrl ?? "")
                self.lblFoodName.text = data.name ?? ""
                self.lblPrice.text = String("$\(data.price ?? 0)")
                self.lblDescription.text = data.description ?? ""
            })
        .disposed(by: bag)
        
        // LOADING
        mFoodDetailsViewModel
            .isLoadingObs
            .observeOn(MainScheduler.instance)
            .map { !$0 }
            .bind(to: loadingIndicator.rx.isHidden)
            .disposed(by: bag)
        
        // ERROR
        mFoodDetailsViewModel
            .errorObs
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { error in
                print(error ?? "")
        })
        .disposed(by: bag)
    }
    
    @IBAction func addToCart(_ sender: Any) {
        self.btnCart.alpha = 0.75
        mFoodDetailsViewModel.addToCart(food: foodInfo!)
        self.btnCart.alpha = 1
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
