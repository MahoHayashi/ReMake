//
//  CosmeticOverlayLabel.swift
//  ReMake
//
//  顔・目元イラストに重ねる「部位ラベル＋選択コスメ一覧」の共通ビュー部品。
//  InputMakeupView / MakeupDetailView / CompareMakeupView の3画面で重複していた
//  表示ブロックをここに切り出している。
//

import SwiftUI

extension View {
    /// 選択コスメ1件分のピル装飾（3画面共通）
    func cosmeticPillStyle() -> some View {
        self
            .font(.caption)
            .foregroundColor(.gray)
            .padding(4)
            .background(Color.white.opacity(0.6))
            .cornerRadius(6)
    }
}

/// 部位名のラベルと、その部位で選択されたコスメ一覧をまとめて表示する。
/// 表示位置（`.position` / `.offset`）は呼び出し側で指定する。
struct CosmeticOverlayLabel: View {
    let title: String
    let values: [String]

    var body: some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.caption)
                .bold()
                .foregroundColor(.black)
            ForEach(values, id: \.self) { value in
                Text(value)
                    .cosmeticPillStyle()
            }
        }
    }
}

#Preview {
    CosmeticOverlayLabel(title: "リップ", values: ["キャンメイク 01", "ロムアンド 12"])
}
