//
//  Product.swift
//  ShoppingCart
//
//  Created by Mac on 19/10/24.
//

import Foundation

struct Product: Codable {
    var id: Int
    var productID: Int
    var productName: String
    var price: Double
    var qty: Int
    var segmentPrice: Double
    var maxQty: Int
    var image: String
    
    
    init(id: Int, productID: Int, productName: String, price: Double, qty: Int, segmentPrice: Double, maxQty: Int, image: String) {
        self.id = id
        self.productID = productID
        self.productName = productName
        self.price = price
        self.qty = qty
        self.segmentPrice = segmentPrice
        self.maxQty = maxQty
        self.image = image
    }
}
