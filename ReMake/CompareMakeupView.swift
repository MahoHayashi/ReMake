//
//  CompareMakeupView.swift
//  ReMake
//
//  Created by maho hayashi on 2025/06/15.
//

import SwiftUI

struct CompareMakeupView: View {
    @State private var imageIndex: Int = 0
    
    let records: [MakeupRecord]

    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                ForEach(records, id: \.id) { record in
                    Text(record.name)
                        .bold()
                        .font(.headline)
                        .background(Color.white) // 背景色
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                                    .frame(width: 280, height: 30)//枠線の色と太さ
                            )
                    ImagePager(images: [
                        .named("MakeupFace"),
                        .named("EyeImage"),
                        .uiImage(record.faceImageData != nil ? UIImage(data: record.faceImageData!) ?? UIImage() : UIImage()),
                        .uiImage(record.eyeImageData != nil ? UIImage(data: record.eyeImageData!) ?? UIImage() : UIImage())
                    ], index: $imageIndex)
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
