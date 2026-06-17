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
    /// 楽天APIの商品画像URL（検索結果から登録した場合に保持。手入力時は nil）
    var imageURL: String?

    init(brand: String, product: String, color: String, category: String, imageURL: String? = nil) {
        self.id = UUID()
        self.brand = brand
        self.product = product
        self.color = color
        self.category = category
        self.imageURL = imageURL
    }

    var listProduct: String {
        [brand, product, color]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}
