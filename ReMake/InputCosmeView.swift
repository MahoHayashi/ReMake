//
//  InputCosmeView.swift
//  ReMake
//
//  Created by maho hayashi on 2025/06/05.
//

import SwiftUI

struct InputCosmeView: View {
    struct CollapsibleSection: Identifiable {
        let id = UUID()
        let title: String
        var items: [String]
        var isExpanded: Bool = true
    }

    @State private var sections = [
        CollapsibleSection(title: "化粧下地", items: ["化粧下地"]),
        CollapsibleSection(title: "ファンデーション", items: ["リキッド", "パウダー"]),
        CollapsibleSection(title: "コンシーラー", items: ["スティック", "クリーム"]),
        CollapsibleSection(title: "チーク", items: ["パウダー", "クリーム"]),
        CollapsibleSection(title: "ハイライト・シェーディング", items: ["パウダー", "クリーム"]),
        CollapsibleSection(title: "アイシャドウ", items: ["単色", "パレット"]),
        CollapsibleSection(title: "アイライナー", items: ["単色", "パレット"]),
        CollapsibleSection(title: "マスカラ", items: ["ボリューム", "ロング"]),
        CollapsibleSection(title: "アイブロウ", items: ["ボリューム", "ロング"]),
        CollapsibleSection(title: "リップ", items: ["ティント", "グロス", "マット"]),
        CollapsibleSection(title: "アイブロウ", items: ["ボリューム", "ロング"]),
    ]
    
    @State private var showsheet = false

    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                Button(action: {
                    //アクションの内容をここに書く
                    //ボタンが押されたらshowsheetプロパティを反転する
                    self.showsheet.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color(red: 0xA6/255.0, green: 0x80/255.0, blue: 0x76/255.0)))
                }
                //showsheet
                .sheet(isPresented: $showsheet){
                    Mysheet()
                        .presentationDetents([
                            .medium,
                            .large,
                            // 高さ
                            .height(300),
                            // 画面に対する割合
                            .fraction(0.8)
                        ])
                    
                }
                .padding()
            }
            List {
                ForEach($sections) { $section in
                    DisclosureGroup(isExpanded: $section.isExpanded) {
                        ForEach(section.items, id: \.self) { item in
                            Text(item)
                                .foregroundColor(Color(white: 0.3))
                        }
                    } label: {
                        Text(section.title)
                            .font(.headline)
                    }
                }
            }
        }
    }
}

struct Mysheet: View {
    @Environment(\.dismiss) var dismiss
    @State public var brand: String = ""
    @State public var product: String = ""
    @State public var color: String = ""

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button("キャンセル") {
                        dismiss()
                    }
                    Spacer()
                    Button("完了") {
                    }
                }
                Text("マイコスメを追加")
                    .font(.headline)
            }
            .padding(.bottom)
            Spacer()
            HStack {
                Text("ブランド")
                    .bold()
                    .frame(width: 80, alignment: .leading)
                TextField("ブランド名を入力してください", text: $brand)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            HStack {
                Text("商品名")
                    .bold()
                    .frame(width: 80, alignment: .leading)
                TextField("商品名を入力してください", text: $product)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            HStack {
                Text("色番/色名")
                    .bold()
                    .frame(width: 80, alignment: .leading)
                TextField("色番/色名を入力してください", text: $color)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    InputCosmeView()
}
