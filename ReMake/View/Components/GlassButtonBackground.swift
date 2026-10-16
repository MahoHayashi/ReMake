//
//  GlassButtonBackground.swift
//  ReMake
//
//  ボタン背景の共通部品。iOS 26 以降は Liquid Glass（色付き・タップに反応）、
//  それより前は従来どおりの単色背景で表示する。
//

import SwiftUI

extension View {
    /// ボタンの背景を iOS 26 以降は Liquid Glass、それ以前は単色で塗る
    @ViewBuilder
    func glassButtonBackground<S: Shape>(_ color: Color, in shape: S) -> some View {
        if #available(iOS 26, *) {
            self.glassEffect(.regular.tint(color).interactive(), in: shape)
        } else {
            self.background(color, in: shape)
        }
    }
}
