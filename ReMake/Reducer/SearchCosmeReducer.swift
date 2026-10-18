//
//  SearchCosmeReducer.swift
//  ReMake
//
//  コスメ検索（楽天市場 商品検索API）の Reducer。
//  SearchCosmeticViewModel を TCA に置き換えたもの。
//

import ComposableArchitecture
import Foundation

@Reducer
struct SearchCosmeReducer {
    @ObservableState
    struct State: Equatable {
        var keyword = ""
        var results: [CosmeticSearchResult] = []
        var isLoading = false
        var errorMessage: String?
    }

    enum Action {
        /// TextField に入力した
        case keywordChanged(String)
        /// キーボードの「検索」を押した
        case searchSubmitted
        /// 楽天APIの結果が返ってきた
        case searchResponse(Result<[CosmeticSearchResult], any Error>)
    }

    @Dependency(\.rakutenClient) var rakutenClient

    /// 前の検索が終わる前に次の検索をしたとき、前のものを止めるための ID
    private enum CancelID { case search }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .keywordChanged(keyword):
                // TODO: 1. state.keyword を書き換える
                state.keyword = keyword
                return .none

            case .searchSubmitted:
                // TODO: 2. 前後の空白を取り除いたキーワードが空なら、何もしないで .none を返す
                let trimmed = state.keyword.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { return .none}
                // TODO: 3. isLoading を true、errorMessage を nil にする
                state.isLoading = true
                state.errorMessage = nil
                
                // TODO: 4. .run の中で rakutenClient.search を呼び、結果を .searchResponse で送り返す
                
                // TODO: 5. .cancellable(id: CancelID.search, cancelInFlight: true) を付ける
                return .run { send in
                    await send(.searchResponse(Result { try await rakutenClient.search(keyword: trimmed) }))
                }
                .cancellable(id: CancelID.search, cancelInFlight: true)

            case let .searchResponse(.success(results)):
                // TODO: 6. isLoading を false にして、results を入れる
                state.isLoading = false
                state.results = results
                
                // TODO: 7. 0件なら errorMessage に「該当するコスメが見つかりませんでした。」を入れる
                if results.isEmpty {
                    state.errorMessage = "該当するコスメが見つかりませんでした。"
                }
                return .none

            case let .searchResponse(.failure(error)):
                // TODO: 8. isLoading を false、results を空にして、errorMessage にエラーの説明を入れる
                state.results = []
                state.isLoading = false
                state.errorMessage = (error as? LocalizedError)?.errorDescription
                ?? "検索に失敗しました。"
                return .none
            }
        }
    }
}
