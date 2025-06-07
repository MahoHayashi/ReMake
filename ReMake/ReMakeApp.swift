//
//  ReMakeApp.swift
//  ReMake
//
//  Created by maho hayashi on 2025/06/04.
//

import SwiftUI

@main
struct ReMakeApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        //複数のModelクラスを使うのでmodelContainerに使用する全てのモデルクラスを列挙して指定する必要がある
        .modelContainer(for: [Cosmetic.self,MakeupRecord.self])
    }
}
