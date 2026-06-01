//
//  Cosmetic.swift
//  ReMake
//
//  Created by maho hayashi on 2026/05/15.
//

import Foundation
import SwiftData

@Model
class Cosmetic {
    var id: UUID
    var brand: String
    var product: String
    var color: String
    var category: String

    init(brand: String, product: String, color: String, category: String) {
        self.id = UUID()
        self.brand = brand
        self.product = product
        self.color = color
        self.category = category
    }

    var listProduct: String {
        "\(brand) \(product) \(color)"
    }
}
