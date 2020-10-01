//
//  FoodPersistenceService.swift
//  Foods
//
//  Created by Riki on 9/29/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation
import CoreData

class FoodPersistenceService {
    
    static let shared = FoodPersistenceService()
    
    private init(){}
    
    private var viewContext = PersistenceService.shared.persistenceContainer.viewContext
    
    var listeners: [FoodPersistenceListener] = []
    var timer: Timer?
    
    func addToCart(food: FoodInfo) {
        
        let foodEntity = Food(context: viewContext)
        
//        foodEntity.id = food.id
        foodEntity.name = food.name
        foodEntity.imageUrl = food.imageUrl
        foodEntity.price = food.price ?? 0
        foodEntity.foodDescription = food.description
        save()
    }
    
    func fetchFoods() -> [Food] {
        
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        do {
            let result = try viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("Persistence fetch error...")
            return []
        }
    }
    
    func removeFromCart(name: String) {
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        let predicate = NSPredicate(format: "name = %@", name)
        fetchRequest.predicate = predicate
        do {
            let result = try viewContext.fetch(fetchRequest)
            if result.count > 0 {
                viewContext.delete(result.first!)
                save()
            }

        } catch {
            print("Remove item from cart error...")
        }
    }
    
    func save() {
        PersistenceService.shared.saveContext()
        
        timer?.invalidate()
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { _ in
                self.listeners.forEach{ $0.foodPersistenceDidUpdate() }
            })
        }

    }
    
    func listenOn(_ newListener: FoodPersistenceListener) {
        listeners.append(newListener)
    }
}
