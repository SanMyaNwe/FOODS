//
//  FoodModel.swift
//  Foods
//
//  Created by Riki on 9/28/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation
import RxSwift

protocol FoodModelProtocol {
    
    func fetchAllCategories(endpoint: Endpoint) -> Observable<FoodListResponse>
    
    func fetchMenu(endpoint: Endpoint, category: String) -> Observable<FoodListResponse>
    
    func fetchFoodList(endpoint: Endpoint, menu: String) -> Observable<FoodListResponse>
}

class FoodModel: FoodModelProtocol {
    
    func fetchAllCategories(endpoint: Endpoint) -> Observable<FoodListResponse> {
        return ApiService.shared.fetch(
            endpoint: endpoint,
            method: .GET,
            params: [:],
            value: FoodListResponse.self)
    }
    
    func fetchMenu(endpoint: Endpoint, category: String) -> Observable<FoodListResponse> {
        return ApiService.shared.fetch(
            endpoint: .getMenu,
            method: .GET,
            params: ["category" : category],
            value: FoodListResponse.self)
    }
    
    func fetchFoodList(endpoint: Endpoint, menu: String) -> Observable<FoodListResponse> {
        return ApiService.shared.fetch(
            endpoint: .getFoodList,
            method: .GET,
            params: ["menu": menu],
            value: FoodListResponse.self)
    }
    
}

