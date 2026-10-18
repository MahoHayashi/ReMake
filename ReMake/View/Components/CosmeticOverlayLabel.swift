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
///
/// `imageURLByName` に「コスメ名(listProduct) → 画像URL」を渡すと、
/// その名前のコスメは楽天画像のサムネイルで表示する（画像が無い名前は従来どおりテキスト）。
/// `showsBackground` を true にすると、イラストの上でも読みやすいよう全体の後ろに白背景を敷く。
struct CosmeticOverlayLabel: View {
    let title: String
    let values: [String]
    var imageURLByName: [String: URL] = [:]
    var showsBackground = false
    /// 白背景の不透明度（1 で真っ白、小さくするほど後ろのイラストが透ける）
    var backgroundOpacity: Double = 1
    /// true にすると、画像で表示するコスメの下に商品名も表示する
    var showsNameUnderImage = false

    var body: some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.caption)
                .bold()
                .foregroundColor(.black)
            ForEach(values, id: \.self) { value in
                if let url = imageURLByName[value] {
                    VStack(spacing: 2) {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Color(white: 0.92)
                        }
                        .frame(width: 56, height: 56)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        if showsNameUnderImage {
                            Text(value)
                                .font(.caption2)
                                .foregroundColor(Color(white: 0.3))
                                .multilineTextAlignment(.center)
                                .frame(width: 80)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                } else {
                    Text(value)
                        .cosmeticPillStyle()
                }
            }
        }
        .padding(showsBackground ? 6 : 0)
        .background(showsBackground ? Color.white.opacity(backgroundOpacity) : Color.clear, in: RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    CosmeticOverlayLabel(title: "リップ", values: ["キャンメイク 01", "ロムアンド 12"])
}
