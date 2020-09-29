//
//  HomeViewModel.swift
//  Foods
//
//  Created by Riki on 9/28/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class HomeViewModel {
    
    public var isLoadingObs: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    public var mCategories = PublishSubject<[Food]>()
    public var mMenu = PublishSubject<[Food]>()
    public var errorObs: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    
    private let bag = DisposeBag()
    
    private let foodModel = FoodModel()
    
    func fetchAllCategories() {
        isLoadingObs.accept(true)
        foodModel
            .fetchAllCategories(endpoint: .getAllCategories)
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: .global()))
            .subscribe(onNext: { (data) in
                self.isLoadingObs.accept(false)
                self.mCategories.onNext(data.result ?? [])
            }, onError: { (error) in
                self.isLoadingObs.accept(false)
                self.errorObs.accept(error.localizedDescription)
            })
            .disposed(by: bag)
    }
    
    func fetchMenu(category: String) {
        isLoadingObs.accept(true)
        foodModel
            .fetchMenu(endpoint: .getMenu, category: category)
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: .global()))
            .subscribe(onNext: { (data) in
                self.isLoadingObs.accept(false)
                self.mMenu.onNext(data.result ?? [])
            }, onError: { (error) in
                self.isLoadingObs.accept(false)
                self.errorObs.accept(error.localizedDescription)
            })
            .disposed(by: bag)
    }
}
