//
//  InputMakeupViewModel.swift
//  ReMake
//
//  Created by maho hayashi on 2026/05/15.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
final class InputMakeupViewModel: ObservableObject {
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

    @Published var makeName = ""
    @Published var comment = ""
    @Published var urlComment = ""
    @Published var imageIndex = 0
    @Published var showAlert = false
    @Published var showPickerSheet = false
    @Published var sheetTitle = ""
    @Published var currentSelection: SelectionType?
    @Published var selectedItemLists: [SelectionType: [String]] = [:]
    @Published var tempFaceImageData: Data?
    @Published var tempEyeImageData: Data?

    private var selectedValues: [SelectionType: String] = [:]

    func pickerOptions(from cosmetics: [Cosmetic]) -> [String] {
        guard let currentSelection else { return [] }

        let categories: [String]
        switch currentSelection {
        case .base:
            categories = ["化粧下地", "ファンデーション", "コンシーラー"]
        default:
            categories = [categoryTitle(for: currentSelection)]
        }

        let filtered = cosmetics
            .filter { categories.contains($0.category) }
            .map { $0.listProduct }

        return filtered.isEmpty ? ["（登録されたコスメがありません）"] : filtered
    }

    func selectedValue(for selection: SelectionType) -> String {
        selectedValues[selection] ?? ""
    }

    func setSelectedValue(_ value: String, for selection: SelectionType) {
        selectedValues[selection] = value
    }

    func selectedValueBinding(for selection: SelectionType) -> Binding<String> {
        Binding(
            get: { self.selectedValue(for: selection) },
            set: { self.setSelectedValue($0, for: selection) }
        )
    }

    func currentSelectionBinding() -> Binding<String> {
        guard let currentSelection else {
            return .constant("")
        }
        return selectedValueBinding(for: currentSelection)
    }

    func addSelectedValue() {
        guard let currentSelection else { return }
        let newValue = selectedValue(for: currentSelection)
        guard !newValue.isEmpty else { return }

        var values = selectedItemLists[currentSelection] ?? []
        if !values.contains(newValue) {
            values.append(newValue)
            selectedItemLists[currentSelection] = values
        }
    }

    func setPicker(selection: SelectionType, title: String) {
        currentSelection = selection
        sheetTitle = title
        showPickerSheet = true
    }

    func saveMakeup(to context: ModelContext) {
        let record = MakeupRecord(
            name: makeName,
            comment: comment,
            url: urlComment,
            faceImageData: tempFaceImageData,
            eyeImageData: tempEyeImageData
        )
        record.selectedItems = selectedItemLists.reduce(into: [:]) { result, item in
            result[item.key.rawValue] = item.value.joined(separator: ", ")
        }

        context.insert(record)
        try? context.save()
        resetAfterSave()
    }

    func updateCapturedImage(_ imageData: Data, type: String?) {
        switch type {
        case "face":
            tempFaceImageData = imageData
        case "eye":
            tempEyeImageData = imageData
        default:
            break
        }
    }

    func resetAfterSave() {
        makeName = ""
        comment = ""
        urlComment = ""
        imageIndex = 0
        currentSelection = nil
        selectedValues.removeAll()
        selectedItemLists.removeAll()
        tempFaceImageData = nil
        tempEyeImageData = nil
    }

    func sectionTitle(for selection: SelectionType) -> String {
        switch selection {
        case .eye:
            return "アイ"
        case .lip:
            return "リップ"
        case .highlight:
            return "ハイライト・シェーディング"
        case .eyebrow:
            return "アイブロウ"
        case .base:
            return "ベースメイク"
        case .cheek:
            return "チーク"
        case .mascara:
            return "マスカラ"
        case .eyeshadow:
            return "アイシャドウ"
        case .eyeliner:
            return "アイライン"
        case .colorlense:
            return "カラコン"
        }
    }

    private func categoryTitle(for selection: SelectionType) -> String {
        switch selection {
        case .eye:
            return "アイ"
        case .lip:
            return "リップ"
        case .highlight:
            return "ハイライト・シェーディング"
        case .eyebrow:
            return "アイブロウ"
        case .base:
            return ""
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
