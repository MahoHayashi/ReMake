//
//  MainTabView.swift
//  ReMake
//
//  Created by maho hayashi on 2025/06/06.
//

import SwiftUI


struct MainTabView: View {
    var body: some View {
        TabView {
            SavedMakeListView()
                .tabItem {
                    Image(systemName: "person.crop.square.on.square.angled")
                    Text("メイク一覧")
                }

            InputCosmeView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("コスメ一覧")
                }
        }
        .accentColor(.pink)
    }
}

#Preview {
    MainTabView()
}
