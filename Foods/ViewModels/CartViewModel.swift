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
    
    private let bag = DisposeBag()
    
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
            })
        .disposed(by: bag)
    }
}

extension CartViewModel: FoodPersistenceListener {
    func foodPersistenceDidUpdate() {
        self.fetchFoodListFromCart()
    }
}
