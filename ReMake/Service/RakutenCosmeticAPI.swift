//
//  RakutenCosmeticAPI.swift
//  ReMake
//
//  楽天市場 商品検索API(Rakuten Ichiba Item Search API)で
//  コスメを検索するネットワーク層。
//

import Foundation

/// 検索画面が使う軽量モデル（楽天のレスポンスを必要な分だけ抽出したもの）
/// TCA の State に入れてテストで比べるため、Equatable と Sendable にしている。
struct CosmeticSearchResult: Identifiable, Equatable, Sendable {
    let id = UUID()
    let name: String
    let imageURL: URL?
    let price: Int
}

/// API呼び出しで起こりうるエラー
enum RakutenCosmeticAPIError: LocalizedError {
    case missingApplicationId
    case missingAccessKey
    case invalidURL
    case requestFailed
    case serverError(statusCode: Int, message: String?)
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .missingApplicationId:
            return "楽天アプリIDが設定されていません（APIConfig.swift）。"
        case .missingAccessKey:
            return "楽天アクセスキーが設定されていません（APIConfig.swift）。"
        case .invalidURL:
            return "検索URLの組み立てに失敗しました。"
        case .requestFailed:
            return "通信に失敗しました。電波状況を確認してください。"
        case let .serverError(statusCode, message):
            if let message {
                return "検索に失敗しました（\(statusCode)）: \(message)"
            }
            return "検索に失敗しました（\(statusCode)）。"
        case .decodingFailed:
            return "検索結果の読み込みに失敗しました。"
        }
    }
}

struct RakutenCosmeticAPI {
    // 2026年2月の仕様変更後のエンドポイント（旧 app.rakuten.co.jp は非推奨）。
    // 20220601 版は2026年8月に廃止され、呼ぶと 400 "API Configuration not found" になる。
    private let endpoint = "https://openapi.rakuten.co.jp/ichibams/api/IchibaItem/Search/20260701"

    /// キーワードでコスメを検索する
    func search(keyword: String) async throws -> [CosmeticSearchResult] {
        guard !APIConfig.rakutenApplicationId.isEmpty else {
            throw RakutenCosmeticAPIError.missingApplicationId
        }
        guard !APIConfig.rakutenAccessKey.isEmpty else {
            throw RakutenCosmeticAPIError.missingAccessKey
        }

        var components = URLComponents(string: endpoint)
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "applicationId", value: APIConfig.rakutenApplicationId),
            URLQueryItem(name: "accessKey", value: APIConfig.rakutenAccessKey),
            URLQueryItem(name: "keyword", value: keyword),
            URLQueryItem(name: "hits", value: "20"),
            URLQueryItem(name: "imageFlag", value: "1"),
            URLQueryItem(name: "format", value: "json")
        ]
        if APIConfig.rakutenCosmeticGenreId > 0 {
            queryItems.append(
                URLQueryItem(name: "genreId", value: String(APIConfig.rakutenCosmeticGenreId))
            )
        }
        components?.queryItems = queryItems

        guard let url = components?.url else {
            throw RakutenCosmeticAPIError.invalidURL
        }

        // 2026年仕様では Origin ヘッダーが無いと 403 になる。
        var request = URLRequest(url: url)
        request.setValue(APIConfig.rakutenOrigin, forHTTPHeaderField: "Origin")

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            // error をそのまま出すとURL（applicationId / accessKey 入り）までログに残るので、コードと説明だけ出す。
            let nsError = error as NSError
            print("楽天API 通信エラー: \(nsError.domain) \(nsError.code) \(nsError.localizedDescription)")
            throw RakutenCosmeticAPIError.requestFailed
        }

        // 400/403 などはボディに楽天のエラー内容が入っているので、それを表示に使う。
        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            let apiError = try? JSONDecoder().decode(RakutenErrorResponse.self, from: data)
            print("楽天API エラー: \(http.statusCode) \(apiError?.error ?? "") \(apiError?.errorDescription ?? "")")
            throw RakutenCosmeticAPIError.serverError(
                statusCode: http.statusCode,
                message: apiError?.errorDescription
            )
        }

        do {
            let searchResponse = try JSONDecoder().decode(RakutenSearchResponse.self, from: data)
            return searchResponse.items.map { wrapper in
                let item = wrapper.item
                return CosmeticSearchResult(
                    name: item.itemName,
                    imageURL: item.mediumImageUrls.first.flatMap { URL(string: $0.imageUrl) },
                    price: item.itemPrice
                )
            }
        } catch {
            print("楽天API デコードエラー: \(error)")
            throw RakutenCosmeticAPIError.decodingFailed
        }
    }
}

// MARK: - 楽天レスポンスのDTO

private struct RakutenErrorResponse: Decodable {
    let error: String?
    let errorDescription: String?

    enum CodingKeys: String, CodingKey {
        case error
        case errorDescription = "error_description"
    }
}

private struct RakutenSearchResponse: Decodable {
    let items: [RakutenItemWrapper]

    enum CodingKeys: String, CodingKey {
        case items = "Items"
    }
}

private struct RakutenItemWrapper: Decodable {
    let item: RakutenItem

    enum CodingKeys: String, CodingKey {
        case item = "Item"
    }
}

private struct RakutenItem: Decodable {
    let itemName: String
    let itemPrice: Int
    let mediumImageUrls: [RakutenImage]
}

private struct RakutenImage: Decodable {
    let imageUrl: String
}
