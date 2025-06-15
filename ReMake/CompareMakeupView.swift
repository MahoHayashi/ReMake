//
//  CompareMakeupView.swift
//  ReMake
//
//  Created by maho hayashi on 2025/06/15.
//

import SwiftUI

struct CompareMakeupView: View {
    @State private var imageIndices: [UUID: Int] = [:]
    
    let records: [MakeupRecord]

    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
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
                                .frame(width: 280, height: 30)
                        )
                    ZStack {
                        ImagePager(images: [
                            .named("MakeupFace"),
                            .named("EyeImage"),
                            .uiImage(record.faceImageData != nil ? UIImage(data: record.faceImageData!) ?? UIImage() : UIImage()),
                            .uiImage(record.eyeImageData != nil ? UIImage(data: record.eyeImageData!) ?? UIImage() : UIImage())
                        ], index: binding)
                        .frame(width: 280, height: 280)
                        // Overlays
                        if binding.wrappedValue == 0 {
                            // Face overlays
                            if let lip = record.selectedItems["lip"] {
                                Text(lip)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .background(Color.white.opacity(0.6))
                                    .cornerRadius(6)
                                    .offset(x: 0, y: 70)
                            }
                            if let highlight = record.selectedItems["highlight"] {
                                Text(highlight)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .background(Color.white.opacity(0.6))
                                    .cornerRadius(6)
                                    .offset(x: 60, y: -50)
                            }
                            if let eyebrow = record.selectedItems["eyebrow"] {
                                Text(eyebrow)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .background(Color.white.opacity(0.6))
                                    .cornerRadius(6)
                                    .offset(x: 0, y: -80)
                            }
                            if let base = record.selectedItems["base"] {
                                Text(base)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .background(Color.white.opacity(0.6))
                                    .cornerRadius(6)
                                    .offset(x: -60, y: 50)
                            }
                            if let cheek = record.selectedItems["cheek"] {
                                Text(cheek)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .background(Color.white.opacity(0.6))
                                    .cornerRadius(6)
                                    .offset(x: 60, y: 50)
                            }
                        } else if binding.wrappedValue == 1 {
                            // Eye overlays
                            if let eyeshadow = record.selectedItems["eyeshadow"] {
                                Text(eyeshadow)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .background(Color.white.opacity(0.6))
                                    .cornerRadius(6)
                                    .offset(x: 0, y: -70)
                            }
                            if let mascara = record.selectedItems["mascara"] {
                                Text(mascara)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .background(Color.white.opacity(0.6))
                                    .cornerRadius(6)
                                    .offset(x: -70, y: 0)
                            }
                            if let colorlense = record.selectedItems["colorlense"] {
                                Text(colorlense)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .background(Color.white.opacity(0.6))
                                    .cornerRadius(6)
                                    .offset(x: 0, y: 70)
                            }
                            if let eyeliner = record.selectedItems["eyeliner"] {
                                Text(eyeliner)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .background(Color.white.opacity(0.6))
                                    .cornerRadius(6)
                                    .offset(x: 70, y: 0)
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
