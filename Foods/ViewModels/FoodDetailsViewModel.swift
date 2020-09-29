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
    
    public var mFoodList = PublishSubject<[Food]>()
    public var errorObs: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    
    private let bag = DisposeBag()
    
    private let foodModel = FoodModel()
    
    func fetchFoodList(menu: String) {
    foodModel
        .fetchFoodList(endpoint: .getFoodList, menu: menu)
        .subscribeOn(ConcurrentDispatchQueueScheduler(queue: .global()))
        .subscribe(onNext: { (data) in
            self.mFoodList.onNext(data.result ?? [])
        }, onError: { (error) in
            self.errorObs.accept(error.localizedDescription)
            
        })
    .disposed(by: bag)
    }
}
