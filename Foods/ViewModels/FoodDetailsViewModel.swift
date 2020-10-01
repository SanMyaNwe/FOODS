//
//  FoodDetailsViewModel.swift
//  Foods
//
//  Created by Riki on 9/29/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class FoodDetailsViewModel {
    
    public var isLoadingObs: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    public var mFoodList = PublishSubject<[FoodInfo]>()
    public var errorObs: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    
    private let bag = DisposeBag()
    
    private let foodModel = FoodModel()
    
    func fetchFoodList(menu: String) {
        isLoadingObs.accept(true)
        foodModel
            .fetchFoodList(endpoint: .getFoodList, menu: menu)
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: .global()))
            .subscribe(onNext: { (data) in
                self.isLoadingObs.accept(false)
                self.mFoodList.onNext(data.result ?? [])
            }, onError: { (error) in
                self.isLoadingObs.accept(false)
                self.errorObs.accept(error.localizedDescription)
                
            })
        .disposed(by: bag)
        }
    
    func addToCart(food: FoodInfo) {
        FoodPersistenceService.shared.addToCart(food: food)
    }
    
    func removeFromCart(name: String) {
        FoodPersistenceService.shared.removeFromCart(name: name)
    }
}
