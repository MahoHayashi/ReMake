//
//  SearchCosmeReducerTests.swift
//  ReMakeTests
//
//  SearchCosmeReducer のテスト。
//  rakutenClient を差し替えるので、本物の楽天APIには通信しない。
//

import ComposableArchitecture
import Testing
@testable import ReMake

@MainActor
struct SearchCosmeReducerTests {

    /// 見本：検索に成功すると結果が入る
    @Test
    func 検索すると結果が入る() async {
        let results = [CosmeticSearchResult(name: "サンプル リップ", imageURL: nil, price: 1650)]

        let store = TestStore(initialState: SearchCosmeReducer.State(keyword: "リップ")) {
            SearchCosmeReducer()
        } withDependencies: {
            // 通信せずに、上の results を返すようにする
            $0.rakutenClient.search = { _ in results }
        }

        // 送った Action で State がどう変わるかを、クロージャの中に書く
        await store.send(.searchSubmitted) {
            $0.isLoading = true
        }

        // Effect から返ってくる Action を受け取る
        await store.receive(\.searchResponse.success) {
            $0.isLoading = false
            $0.results = results
        }
    }

    @Test
    func 結果が0件ならメッセージが出る() async {
        // TODO: A. rakutenClient.search が空の配列 [] を返すようにする
        let results: [CosmeticSearchResult] = []
        
        let store = TestStore(initialState: SearchCosmeReducer.State(keyword: "リップ")) {
            SearchCosmeReducer()
        } withDependencies: {
            $0.rakutenClient.search = { _ in results }
        }
        // TODO: B. .searchSubmitted を送ったときの State の変化を書く
        await store.send(.searchSubmitted) {
            $0.isLoading = true
        }
        // TODO: C. .searchResponse.success を受け取ったときの State の変化を書く
        //          （results は [] のままなので書かなくてよい。errorMessage はどうなる？）
        await store.receive(\.searchResponse.success) {
            $0.isLoading = false
            $0.errorMessage = "該当するコスメが見つかりませんでした。"
        }
    }

    @Test
    func 検索に失敗したらエラーメッセージが出る() async {
        // TODO: D. rakutenClient.search がエラーを投げるようにする
        //          ヒント：struct DummyError: Error {} を作って throw DummyError()
        struct DummyError: Error { }
        
        let store = TestStore(initialState: SearchCosmeReducer.State(keyword: "リップ")) {
            SearchCosmeReducer()
        } withDependencies: {
            // ② ここで投げる
            $0.rakutenClient.search = { _ in throw DummyError() }
        }
        
        
        // TODO: E. .searchSubmitted を送ったときの State の変化を書く
        await store.send(.searchSubmitted) {
            $0.isLoading = true
        }
        
        
        // TODO: F. .searchResponse.failure を受け取ったときの State の変化を書く
        //          （DummyError は LocalizedError ではないので、どのメッセージになる？）
        await store.receive(\.searchResponse.failure) {
            $0.isLoading = false
            $0.errorMessage = "検索に失敗しました。"
        }
    }
}
