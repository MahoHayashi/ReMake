//
//  RakutenClient.swift
//  ReMake
//
//  楽天市場 商品検索APIを TCA の Dependency として使うためのクライアント。
//  Reducer はこのクライアント経由で検索するので、テストでは通信せずに結果を差し替えられる。
//

import ComposableArchitecture
import Foundation

@DependencyClient
struct RakutenClient {
    /// キーワードでコスメを検索する
    var search: @Sendable (_ keyword: String) async throws -> [CosmeticSearchResult]
}

extension RakutenClient: DependencyKey {
    /// 本番用：今までの RakutenCosmeticAPI をそのまま呼ぶ
    static let liveValue = RakutenClient(
        search: { keyword in
            try await RakutenCosmeticAPI().search(keyword: keyword)
        }
    )

    /// プレビュー用：通信せずにサンプルを返す
    static let previewValue = RakutenClient(
        search: { _ in
            [
                CosmeticSearchResult(name: "サンプル リップ 01", imageURL: nil, price: 1650),
                CosmeticSearchResult(name: "サンプル アイシャドウ 02", imageURL: nil, price: 2200)
            ]
        }
    )

    /// テスト用：差し替えずに呼ばれたらテストが失敗する（@DependencyClient が自動で作る）
    static let testValue = RakutenClient()
}

extension DependencyValues {
    var rakutenClient: RakutenClient {
        get { self[RakutenClient.self] }
        set { self[RakutenClient.self] = newValue }
    }
}
