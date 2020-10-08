//
//  CartViewModel.swift
//  Foods
//
//  Created by Riki on 9/29/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class CartViewModel {
    
    public var isLoadingObs: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    public var mFoodList = PublishSubject<[Food]>()
    public var mTotalAmountObs: BehaviorRelay<Double> = BehaviorRelay(value: 0)
    
    private let bag = DisposeBag()
    private var totalAmount: Double = 0
    
    init() {
        FoodPersistenceService.shared.listenOn(self)
    }
    
    func fetchFoodListFromCart() {
        isLoadingObs.accept(true)
        Observable
            .just(FoodPersistenceService.shared.fetchFoods())
            .subscribe(onNext: { (data) in
                self.isLoadingObs.accept(false)
                self.mFoodList.onNext(data)
                data.forEach { (food) in
                    self.totalAmount += food.price
                }
            })
        .disposed(by: bag)
        
        mTotalAmountObs.accept(totalAmount)
        
    }
}

extension CartViewModel: FoodPersistenceListener {
    func foodPersistenceDidUpdate() {
        self.fetchFoodListFromCart()
    }
}
