//
//  CompareMakeupView.swift
//  ReMake
//
//  Created by maho hayashi on 2025/06/15.
//
import Foundation
import SwiftUI
import SwiftData

struct CompareMakeupView: View {
    @State private var imageIndices: [UUID: Int] = [:]
    
    let records: [MakeupRecord]

    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 8) {
                ForEach(records, id: \.id) { record in
                    let binding = Binding<Int>(
                        get: { imageIndices[record.id] ?? 0 },
                        set: { imageIndices[record.id] = $0 }
                    )
                    Text(record.name)
                        .bold()
                        .font(.headline)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                                .frame(width: 270, height: 25)
                        )
                    ZStack {
                        VStack {
                            ImagePager(images: [
                                .named("MakeupFace"),
                                .named("ImageEye"),
                                .uiImage(record.faceImageData != nil ? UIImage(data: record.faceImageData!) ?? UIImage() : UIImage()),
                                .uiImage(record.eyeImageData != nil ? UIImage(data: record.eyeImageData!) ?? UIImage() : UIImage())
                            ], index: binding)
                        
                        .frame(width: 270, height: 250)
                        VStack {
                            HStack(spacing: 8) {
                                ForEach(0..<4, id: \.self) { i in
                                    Circle()
                                        .fill(i == binding.wrappedValue ? Color.primary : Color.secondary.opacity(0.4))
                                        .frame(width: 8, height: 8)
                                }
                            }
                            .padding(.top, 15)
                        }
                    }
                        .padding(.top, 4)
                        // Overlays
                        if binding.wrappedValue == 0 {
                            // Face overlays
                            if let lip = record.selectedItems["lip"] {
                                CosmeticOverlayLabel(title: "リップ", values: lip.components(separatedBy: ", "))
                                    .offset(x: 0, y: 90)
                            }
                            if let highlight = record.selectedItems["highlight"] {
                                CosmeticOverlayLabel(title: "ハイライト", values: highlight.components(separatedBy: ", "))
                                    .offset(x: 40, y: -50)
                            }
                            if let eyebrow = record.selectedItems["eyebrow"] {
                                CosmeticOverlayLabel(title: "アイブロウ", values: eyebrow.components(separatedBy: ", "))
                                    .offset(x: 70, y: -80)
                            }
                            if let base = record.selectedItems["base"] {
                                CosmeticOverlayLabel(title: "ベース", values: base.components(separatedBy: ", "))
                                    .offset(x: -70, y: 20)
                            }
                            if let cheek = record.selectedItems["cheek"] {
                                CosmeticOverlayLabel(title: "チーク", values: cheek.components(separatedBy: ", "))
                                    .offset(x: 70, y: 20)
                            }
                        } else if binding.wrappedValue == 1 {
                            // Eye overlays
                            if let eyeshadow = record.selectedItems["eyeshadow"] {
                                CosmeticOverlayLabel(title: "アイシャドウ", values: eyeshadow.components(separatedBy: ", "))
                                    .offset(x: 0, y: -70)
                            }
                            if let mascara = record.selectedItems["mascara"] {
                                CosmeticOverlayLabel(title: "マスカラ", values: mascara.components(separatedBy: ", "))
                                    .offset(x: -70, y: 0)
                            }
                            if let colorlense = record.selectedItems["colorlense"] {
                                CosmeticOverlayLabel(title: "カラコン", values: colorlense.components(separatedBy: ", "))
                                    .offset(x: 0, y: 70)
                            }
                            if let eyeliner = record.selectedItems["eyeliner"] {
                                CosmeticOverlayLabel(title: "アイライナー", values: eyeliner.components(separatedBy: ", "))
                                    .offset(x: 90, y: 0)
                            }
                        }
                    }
                    .frame(width: 280, height: 280)
                    
                    
                    Spacer().frame(height: 15)
                }
            }
        }
    }
}

#Preview {
    let dummyRecords = [
        MakeupRecord(name: "春メイク", comment: "ナチュラル仕上げ", url: "https://example.com", faceImageData: nil, eyeImageData: nil),
        MakeupRecord(name: "秋メイク", comment: "深みのあるカラー", url: "https://example.com", faceImageData: nil, eyeImageData: nil)
    ]
    return CompareMakeupView(records: dummyRecords)
}
