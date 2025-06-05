//
//  InputCosmeView.swift
//  ReMake
//
//  Created by maho hayashi on 2025/06/05.
//

import SwiftUI

struct InputCosmeView: View {
    struct CollapsibleSection: Identifiable {
        let id = UUID()
        let title: String
        var items: [String]
        var isExpanded: Bool = true
    }

    @State private var sections = [
        CollapsibleSection(title: "化粧下地", items: ["化粧下地"]),
        CollapsibleSection(title: "ファンデーション", items: ["リキッド", "パウダー"]),
        CollapsibleSection(title: "コンシーラー", items: ["スティック", "クリーム"]),
        CollapsibleSection(title: "チーク", items: ["パウダー", "クリーム"]),
        CollapsibleSection(title: "ハイライト・シェーディング", items: ["パウダー", "クリーム"]),
        CollapsibleSection(title: "アイシャドウ", items: ["単色", "パレット"]),
        CollapsibleSection(title: "アイライナー", items: ["単色", "パレット"]),
        CollapsibleSection(title: "マスカラ", items: ["ボリューム", "ロング"]),
        CollapsibleSection(title: "アイブロウ", items: ["ボリューム", "ロング"]),
        CollapsibleSection(title: "リップ", items: ["ティント", "グロス", "マット"]),
        CollapsibleSection(title: "アイブロウ", items: ["ボリューム", "ロング"]),
    ]

    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                Button(action: {
                    // Action here
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color(red: 0xA6/255.0, green: 0x80/255.0, blue: 0x76/255.0)))
                }
                .padding()
            }
            List {
                ForEach($sections) { $section in
                    DisclosureGroup(isExpanded: $section.isExpanded) {
                        ForEach(section.items, id: \.self) { item in
                            Text(item)
                                .foregroundColor(Color(white: 0.3))
                        }
                    } label: {
                        Text(section.title)
                            .font(.headline)
                    }
                }
            }
        }
    }
}

#Preview {
    InputCosmeView()
}
