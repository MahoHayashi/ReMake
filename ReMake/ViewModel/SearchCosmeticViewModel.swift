//
//  SearchCosmeticViewModel.swift
//  ReMake
//
//  楽天市場 商品検索APIを使ってコスメを検索する画面用のViewModel。
//  RakutenCosmeticAPI（Service層）を呼び出し、結果・読み込み状態・
//  エラーメッセージを @Published で公開する。
//

import Foundation
import SwiftUI

@MainActor
final class SearchCosmeticViewModel: ObservableObject {
    @Published var keyword: String = ""
    @Published var results: [CosmeticSearchResult] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let api = RakutenCosmeticAPI()

    /// 現在のキーワードでコスメを検索する。
    func search() async {
        let trimmed = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        isLoading = true
        errorMessage = nil
        do {
            results = try await api.search(keyword: trimmed)
            if results.isEmpty {
                errorMessage = "該当するコスメが見つかりませんでした。"
            }
        } catch {
            results = []
            errorMessage = (error as? LocalizedError)?.errorDescription
                ?? "検索に失敗しました。"
        }
        isLoading = false
    }
}
