//
//  InputCosmeViewModel.swift
//  ReMake
//
//  Created by maho hayashi on 2026/05/15.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
final class InputCosmeViewModel: ObservableObject {
    struct CollapsibleSection: Identifiable {
        let id = UUID()
        let title: String
        var items: [String]
        var isExpanded: Bool = true
    }

    @Published var sections = [
        CollapsibleSection(title: "化粧下地", items: []),
        CollapsibleSection(title: "ファンデーション", items: []),
        CollapsibleSection(title: "コンシーラー", items: []),
        CollapsibleSection(title: "チーク", items: []),
        CollapsibleSection(title: "ハイライト・シェーディング", items: []),
        CollapsibleSection(title: "アイシャドウ", items: []),
        CollapsibleSection(title: "アイライナー", items: []),
        CollapsibleSection(title: "マスカラ", items: []),
        CollapsibleSection(title: "カラコン", items: []),
        CollapsibleSection(title: "アイブロウ", items: []),
        CollapsibleSection(title: "リップ", items: [])
    ]
    @Published var showsheet = false

    func updateSections(from cosmetics: [Cosmetic]) {
        for index in sections.indices {
            let title = sections[index].title
            sections[index].items = cosmetics
                .filter { $0.category == title }
                .map { $0.listProduct }
        }
    }

    func addCosmetic(
        brand: String,
        product: String,
        color: String,
        category: String,
        to context: ModelContext,
        existingCosmetics: [Cosmetic]
    ) {
        let cosmetic = Cosmetic(
            brand: brand,
            product: product,
            color: color,
            category: category
        )
        context.insert(cosmetic)
        try? context.save()
        updateSections(from: existingCosmetics + [cosmetic])
    }

    func deleteCosmetics(
        at offsets: IndexSet,
        in section: CollapsibleSection,
        from context: ModelContext,
        cosmetics: [Cosmetic]
    ) {
        for index in offsets {
            let itemToDelete = section.items[index]
            if let cosmeticToDelete = cosmetics.first(where: { $0.listProduct == itemToDelete }) {
                context.delete(cosmeticToDelete)
            }
        }
        try? context.save()
        updateSections(from: cosmetics.filter { cosmetic in
            !offsets.contains { section.items[$0] == cosmetic.listProduct }
        })
    }
}
