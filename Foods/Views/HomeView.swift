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
import AVFoundation

class HomeView: UIViewController {
    
    static let identifier = "HomeView"
    
    @IBOutlet weak var foodCollectionView: UICollectionView!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lblMenu: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var foodCategoryCollectionView: UICollectionView!
    
    private let mHomeViewModel = HomeViewModel()
    private let bag = DisposeBag()
    
    private var mMenu: [FoodInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setUpFoodCategoryCollectionView()
        setUpFoodCollectionView()
        initDataObservations()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        let indexPathForFirstRow = IndexPath(row: 0, section: 0)
//        foodCategoryCollectionView.selectItem(at: indexPathForFirstRow as IndexPath, animated: false, scrollPosition: .right)
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        mHomeViewModel.fetchMenu(category: "food")
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
        
//        let indexPathForFirstRow = IndexPath(row: 0, section: 0)
        foodCategoryCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        foodCategoryCollectionView.reloadData()
    }
    
    private func setUpFoodCollectionView() {
        
        let dynamicLayout = DynamicLayout()
        dynamicLayout.delegate = self
        
        foodCollectionView.setCollectionViewLayout(dynamicLayout, animated: true)
        foodCollectionView.showsVerticalScrollIndicator = false
        foodCollectionView.register(with: FoodItem.identifier)
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
            .modelSelected(FoodInfo.self)
            .subscribe(onNext: { (data) in
                self.lblMenu.text = String((data.name ?? "")+" Menu")
                self.mHomeViewModel.fetchMenu(category: data.id)
            })
            .disposed(by: bag)
        
        mHomeViewModel
            .mMenu
            .observeOn(MainScheduler.instance)
            .subscribe (onNext: {(data) in
                self.mMenu = data
                DispatchQueue.main.async {
                    self.foodCollectionView.reloadData()
                }
            })
            .disposed(by: bag)
        
        mHomeViewModel
            .mMenu
            .observeOn(MainScheduler.instance)
            .bind(to: foodCollectionView.rx.items(cellIdentifier: FoodItem.identifier, cellType: FoodItem.self)) { _, data, cell in
                cell.bind(with: data)
            }
            .disposed(by: bag)
        
        // PRESENT DETAILS VIEW
        foodCollectionView
            .rx
            .modelSelected(FoodInfo.self)
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

extension HomeView: DynamicLayoutDelegate {
    func collecionView(collecionView: UICollectionView, photoHeightForItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat {
        let imageUrlString = mMenu[indexPath.item].imageUrl ?? ""
        let imageUrl = URL(string: imageUrlString)!
        let imageData = try? Data(contentsOf: imageUrl)
        let image = UIImage(data: imageData ?? Data())
        
        return image?.height(width: width) ?? 150
    }
}
