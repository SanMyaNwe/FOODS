//
//  HomeView.swift
//  Foods
//
//  Created by Riki on 9/18/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeView: UIViewController {
    
    static let identifier = "HomeView"
    
    @IBOutlet weak var FoodCollectionView: UICollectionView!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lblMenu: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var foodCategoryCollectionView: UICollectionView!
    
    private let mHomeViewModel = HomeViewModel()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setUpFoodCategoryCollectionView()
        setUpFoodCollectionView()
        initDataObservations()
        mHomeViewModel.isLoadingObs.value
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.mHomeViewModel.fetchMenu(category: "food")
    }
    
    private func configure() {
        btnCart.layer.cornerRadius = 16
        searchBar.layer.cornerRadius = 16
        searchBar.backgroundImage = UIImage()
    }
    
    private func setUpFoodCategoryCollectionView() {
        let screenSize: CGSize = self.view.bounds.size
        let noOfitems: CGFloat = 4
        let itemPadding: CGFloat = 24
        let totalPadding: CGFloat = itemPadding * ( noOfitems + 1 )
        let itemWidth: CGFloat = ( screenSize.width - totalPadding ) / noOfitems
        let itemHeight: CGFloat = itemWidth * ( 4 / 3 )
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemPadding
        
        foodCategoryCollectionView.setCollectionViewLayout(layout, animated: true)
        foodCategoryCollectionView.showsHorizontalScrollIndicator = false
        foodCategoryCollectionView.register(with: FoodCategoryItem.identifier)
        foodCategoryCollectionView.contentInset = UIEdgeInsets(top: 0, left: itemPadding, bottom: 0, right: itemPadding)
    }
    
    private func setUpFoodCollectionView() {
        let screenSize: CGSize = self.view.bounds.size
        let noOfItems: CGFloat = 2
        let itemPadding: CGFloat = 24
        let totalPadding: CGFloat = ( noOfItems + 1 ) * itemPadding
        let itemWidth: CGFloat = ( screenSize.width - totalPadding ) / noOfItems
        let itemHeight: CGFloat = 200
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = itemPadding
        
        FoodCollectionView.setCollectionViewLayout(layout, animated: true)
        FoodCollectionView.showsVerticalScrollIndicator = false
        FoodCollectionView.contentInset = UIEdgeInsets(top: 0, left: itemPadding, bottom: 0, right: itemPadding)
        FoodCollectionView.register(with: FoodItem.identifier)
    }
    
    private func initDataObservations() {
        
        // DISPLAY FOOD CATEGORIES
        mHomeViewModel.fetchAllCategories()
        mHomeViewModel
            .mCategories
            .observeOn(MainScheduler.instance)
            .bind(to: foodCategoryCollectionView.rx.items(cellIdentifier: FoodCategoryItem.identifier, cellType: FoodCategoryItem.self)) { _, data, cell in
                cell.bind(with: data)
            }
            .disposed(by: bag)
        
        // DISPLAY MENU BY CATEGORY
        foodCategoryCollectionView
            .rx
            .modelSelected(Food.self)
            .subscribe(onNext: { (data) in
                self.lblMenu.text = String((data.name ?? "")+" Menu")
                self.mHomeViewModel.fetchMenu(category: data.id)
            })
            .disposed(by: bag)
        
        mHomeViewModel
            .mMenu
            .observeOn(MainScheduler.instance)
            .bind(to: FoodCollectionView.rx.items(cellIdentifier: FoodItem.identifier, cellType: FoodItem.self)) { _, data, cell in
                cell.bind(with: data)
            }
            .disposed(by: bag)
        
        // PRESENT DETAILS VIEW
        FoodCollectionView
            .rx
            .modelSelected(Food.self)
            .subscribe(onNext: { (data) in
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: FoodDetailsView.identifier) as! FoodDetailsView
                vc.modalPresentationStyle = .fullScreen
                vc.mFood = data
                self.present(vc, animated: true, completion: nil)
            })
            .disposed(by: bag)
        
        // LOADING
        mHomeViewModel
            .isLoadingObs
            .observeOn(MainScheduler.instance)
            .map { !$0 }
            .bind(to: loadingIndicator.rx.isHidden)
            .disposed(by: bag)
        
        // ERROR
        mHomeViewModel
            .errorObs
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { error in
                print(error ?? "")
        })
        .disposed(by: bag)
    }
    
    @IBAction func onClickCart(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: CartView.identifier)
        vc.modalPresentationStyle = .overCurrentContext
        self.show(vc, sender: self)
    }
    
}
