//
//  InputCosmeView.swift
//  ReMake
//
//  Created by maho hayashi on 2025/06/05.
//

import SwiftUI

struct InputCosmeView: View {
    let array = ["化粧下地", "ファンデーション", "コンシーラー","チーク","ハイライト・シェーディング","アイシャドウ","アイライナー","マスカラ","アイブロウ","リップ","カラコン"]
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
                ForEach(array, id: \.self) { item in
                    Text(item)
                    .bold()
                }
            }
        }
    }
}

#Preview {
    InputCosmeView()
}
