//
//  Food.swift
//  Foods
//
//  Created by Riki on 9/28/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation

struct FoodInfo: Codable {
    
    var id: String!
    var name: String?
    var icon: String?
    var imageUrl: String?
    var price: Double?
    var description: String?
}
