//
//  CartManager.swift
//  PennyMead
//
//  Created by siddappa tambakad on 23/02/24.
//

import Foundation
import UIKit

class CartManager {
    static let shared = CartManager()
    var cartItems: [CollectibleItem] = []
    
    func addToCart(item: CollectibleItem) {
        cartItems.append(item)
        print(item)
    }
    func cartContainsItem(withSysid sysid: String) -> Bool {
        // Check if any item in the cart has the same sysid
        return cartItems.contains { $0.sysid == sysid }
    }
    
    func removeFromCart(at index: Int) {
        cartItems.remove(at: index)
        // You can also perform any additional logic here, such as updating UI
    }
    
    func cartCount() -> Int {
        return cartItems.count
    }
}
