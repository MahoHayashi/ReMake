//
//  ImagePaper.swift
//  ReMake
//
//  Created by maho hayashi on 2025/06/06.
//

import SwiftUI

//enumで管理することでUIImageとStringの両方を扱えるようにした
enum ImageSource {
    case uiImage(UIImage)
    case named(String)
}

struct ImagePager: View {
    var images: [ImageSource]
    
    @Binding var index: Int
    @State public var offset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(0..<self.images.count, id: \.self) { i in
                        Group {
                            switch self.images[i] {
                            case .uiImage(let img):
                                Image(uiImage: img)
                                    .resizable()
                            case .named(let name):
                                Image(name)
                                    .resizable()
                            }
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width, height: geometry.size.width)
                    }
                }
            }
            .content.offset(x: self.offset)
            .frame(width: geometry.size.width, alignment: .leading)
            .gesture(DragGesture()
                .onChanged { value in
                    self.offset = value.translation.width - geometry.size.width * CGFloat(self.index)
                }
                .onEnded { value in
                    let scrollThreshold = geometry.size.width / 2
                    if value.predictedEndTranslation.width < -scrollThreshold {
                        self.index = min(self.index + 1, self.images.count - 1)
                    } else if value.predictedEndTranslation.width > scrollThreshold {
                        self.index = max(self.index - 1, 0)
                    }
                    
                    withAnimation {
                        self.offset = -geometry.size.width * CGFloat(self.index)
                    }
                }
            )
        }
    }
}
