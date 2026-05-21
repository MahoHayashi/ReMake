//
//  MakeupDetailViewModel.swift
//  ReMake
//
//  Created by maho hayashi on 2026/05/15.
//

import Foundation

@MainActor
final class MakeupDetailViewModel: ObservableObject {
    enum SelectionType: String, CaseIterable {
        case eye
        case lip
        case highlight
        case eyebrow
        case base
        case cheek
        case mascara
        case eyeshadow
        case eyeliner
        case colorlense
    }

    @Published var imageIndex = 0
    @Published var selectedItems: [SelectionType: String] = [:]

    init(record: MakeupRecord) {
        selectedItems = record.selectedItems.reduce(into: [:]) { result, item in
            guard let selection = SelectionType(rawValue: item.key) else { return }
            result[selection] = item.value
        }
    }

    func values(for selection: SelectionType) -> [String] {
        guard let value = selectedItems[selection], !value.isEmpty else {
            return []
        }
        return value.components(separatedBy: ", ")
    }

    func title(for selection: SelectionType) -> String {
        switch selection {
        case .eye:
            return "アイ"
        case .lip:
            return "リップ"
        case .highlight:
            return "ハイライト"
        case .eyebrow:
            return "アイブロウ"
        case .base:
            return "ベース"
        case .cheek:
            return "チーク"
        case .mascara:
            return "マスカラ"
        case .eyeshadow:
            return "アイシャドウ"
        case .eyeliner:
            return "アイライナー"
        case .colorlense:
            return "カラコン"
        }
    }
}
