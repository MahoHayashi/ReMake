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
                                let values = lip.components(separatedBy: ", ")
                                VStack(spacing: 2) {
                                    Text("リップ")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.black)
                                    ForEach(values, id: \.self) { val in
                                        Text(val)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                    }
                                }
                                .offset(x: 0, y: 70)
                            }
                            if let highlight = record.selectedItems["highlight"] {
                                let values = highlight.components(separatedBy: ", ")
                                VStack(spacing: 2) {
                                    Text("ハイライト")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.black)
                                    ForEach(values, id: \.self) { val in
                                        Text(val)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                    }
                                }
                                .offset(x: 60, y: -50)
                            }
                            if let eyebrow = record.selectedItems["eyebrow"] {
                                let values = eyebrow.components(separatedBy: ", ")
                                VStack(spacing: 2) {
                                    Text("アイブロウ")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.black)
                                    ForEach(values, id: \.self) { val in
                                        Text(val)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                    }
                                }
                                .offset(x: 0, y: -80)
                            }
                            if let base = record.selectedItems["base"] {
                                let values = base.components(separatedBy: ", ")
                                VStack(spacing: 2) {
                                    Text("ベース")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.black)
                                    ForEach(values, id: \.self) { val in
                                        Text(val)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                    }
                                }
                                .offset(x: -60, y: 50)
                            }
                            if let cheek = record.selectedItems["cheek"] {
                                let values = cheek.components(separatedBy: ", ")
                                VStack(spacing: 2) {
                                    Text("チーク")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.black)
                                    ForEach(values, id: \.self) { val in
                                        Text(val)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                    }
                                }
                                .offset(x: 60, y: 50)
                            }
                        } else if binding.wrappedValue == 1 {
                            // Eye overlays
                            if let eyeshadow = record.selectedItems["eyeshadow"] {
                                let values = eyeshadow.components(separatedBy: ", ")
                                VStack(spacing: 2) {
                                    Text("アイシャドウ")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.black)
                                    ForEach(values, id: \.self) { val in
                                        Text(val)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                    }
                                }
                                .offset(x: 0, y: -70)
                            }
                            if let mascara = record.selectedItems["mascara"] {
                                let values = mascara.components(separatedBy: ", ")
                                VStack(spacing: 2) {
                                    Text("マスカラ")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.black)
                                    ForEach(values, id: \.self) { val in
                                        Text(val)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                    }
                                }
                                .offset(x: -70, y: 0)
                            }
                            if let colorlense = record.selectedItems["colorlense"] {
                                let values = colorlense.components(separatedBy: ", ")
                                VStack(spacing: 2) {
                                    Text("カラコン")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.black)
                                    ForEach(values, id: \.self) { val in
                                        Text(val)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                    }
                                }
                                .offset(x: 0, y: 70)
                            }
                            if let eyeliner = record.selectedItems["eyeliner"] {
                                let values = eyeliner.components(separatedBy: ", ")
                                VStack(spacing: 2) {
                                    Text("アイライナー")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.black)
                                    ForEach(values, id: \.self) { val in
                                        Text(val)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                    }
                                }
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
