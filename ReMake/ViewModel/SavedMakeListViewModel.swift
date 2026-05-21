//
//  SavedMakeListViewModel.swift
//  ReMake
//
//  Created by maho hayashi on 2026/05/15.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
final class SavedMakeListViewModel: ObservableObject {
    @Published var cards: [MakeupRecord] = []
    @Published var isComparisonMode = false
    @Published var selectedCardIDs: Set<UUID> = []
    @Published var showAlert = false
    @Published var showComparisonView = false

    func updateCards(from records: [MakeupRecord]) {
        cards = records
    }

    func toggleComparisonMode() {
        isComparisonMode.toggle()
        if !isComparisonMode {
            selectedCardIDs.removeAll()
            showComparisonView = false
        }
    }

    func toggleSelection(for card: MakeupRecord) {
        if selectedCardIDs.contains(card.id) {
            selectedCardIDs.remove(card.id)
        } else if selectedCardIDs.count < 2 {
            selectedCardIDs.insert(card.id)
        } else {
            showAlert = true
        }
    }

    var selectedCards: [MakeupRecord] {
        cards.filter { selectedCardIDs.contains($0.id) }
    }

    func deleteCard(_ card: MakeupRecord, from context: ModelContext) {
        cards.removeAll { $0.id == card.id }
        selectedCardIDs.remove(card.id)
        context.delete(card)
        try? context.save()
    }
}
