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
    
    var mFood: Food? = nil
    
    private let foodDetailsViewModel = FoodDetailsViewModel()
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setUpFoodCollectionView()
        initDataObservations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        foodDetailsViewModel
            .mFoodList
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (data) in
                self.ivFood.setImage(with: data.first?.imageUrl ?? "")
                self.lblFoodName.text = data.first?.name ?? ""
                self.lblPrice.text = "$"+String((data.first?.price ?? 0))
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
    }
    
    private func initDataObservations() {
        lblFoodCategory.text = mFood?.name ?? ""
        foodDetailsViewModel.fetchFoodList(menu: mFood?.id ?? "")
        
        foodDetailsViewModel
            .mFoodList
            .observeOn(MainScheduler.instance)
            .bind(to: foodCollectionView.rx.items(cellIdentifier: FoodItem.identifier, cellType: FoodItem.self)) {(_, data, cell) in
                cell.bind(with: data)
            }
        .disposed(by: bag)
        
        foodCollectionView
            .rx
            .modelSelected(Food.self)
            .subscribe(onNext: { (data) in
                self.ivFood.setImage(with: data.imageUrl ?? "")
                self.lblFoodName.text = data.name ?? ""
                self.lblPrice.text = "$"+String((data.price ?? 0))
                self.lblDescription.text = data.description ?? ""
            })
        .disposed(by: bag)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
