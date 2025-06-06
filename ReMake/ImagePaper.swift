//
//  ImagePaper.swift
//  ReMake
//
//  Created by maho hayashi on 2025/06/06.
//

import SwiftUI

struct ImagePager: View {

    var imageNames: [String]
    
    @State private var index: Int = 0
    @State private var offset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in // 1. offset(scroll位置)を操作するため、GeometryReaderを利用
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(0..<self.imageNames.count) {
                        Image(self.imageNames[$0])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width, height: geometry.size.width)
                    }
                }
            }
            .content.offset(x: self.offset) // 2. self.offsetとscrollViewのoffsetをバインディング
            .frame(width: geometry.size.width, height: nil, alignment: .leading)
            .gesture(DragGesture()
                .onChanged({ value in  // 3. Dragを監視。Dragに合わせて、スクロールする。
                    self.offset = value.translation.width - geometry.size.width * CGFloat(self.index)
                })
                .onEnded({ value in // 4. Dragが完了したら、Drag量に応じて、indexを更新
                    let scrollThreshold = geometry.size.width / 2
                    if value.predictedEndTranslation.width < -scrollThreshold {
                        self.index = min(self.index + 1, self.imageNames.endIndex - 1)
                    } else if value.predictedEndTranslation.width > scrollThreshold {
                        self.index = max(self.index - 1, 0)
                    }
                    
                    withAnimation { // 5. 更新したindexの画像をアニメーションしながら表示する。
                        self.offset = -geometry.size.width * CGFloat(self.index)
                    }
                })
            )
        }
    }
}
