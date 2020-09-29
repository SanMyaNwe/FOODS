//
//  EndPoint.swift
//  Foods
//
//  Created by Riki on 9/23/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation

enum Endpoint {
    
    case getAllCategories
    case getMenu
    case getFoodList
    
    var route: String {
        switch self {
        case .getAllCategories:
            return Api.BASE_URL + "/getAllCategories"
        case .getMenu:
            return Api.BASE_URL + "/getMenu"
        case .getFoodList:
            return Api.BASE_URL + "/getFoodList"
        }
    }
}
