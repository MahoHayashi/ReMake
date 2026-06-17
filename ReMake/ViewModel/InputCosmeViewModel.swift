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
    /// リスト1行分のコスメ表示データ（名前と楽天の画像URL）
    struct CosmeticItem: Identifiable, Hashable {
        let id: UUID
        let name: String
        let imageURL: URL?
    }

    struct CollapsibleSection: Identifiable {
        let id = UUID()
        let title: String
        var items: [CosmeticItem]
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
                .map { cosmetic in
                    CosmeticItem(
                        id: cosmetic.id,
                        name: cosmetic.listProduct,
                        imageURL: cosmetic.imageURL.flatMap { URL(string: $0) }
                    )
                }
        }
    }

    func addCosmetic(
        brand: String,
        product: String,
        color: String,
        category: String,
        imageURL: String?,
        to context: ModelContext,
        existingCosmetics: [Cosmetic]
    ) {
        let cosmetic = Cosmetic(
            brand: brand,
            product: product,
            color: color,
            category: category,
            imageURL: imageURL
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
        let idsToDelete = Set(offsets.map { section.items[$0].id })
        for cosmetic in cosmetics where idsToDelete.contains(cosmetic.id) {
            context.delete(cosmetic)
        }
        try? context.save()
        updateSections(from: cosmetics.filter { !idsToDelete.contains($0.id) })
    }
}
