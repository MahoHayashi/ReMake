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

    @State public var sections = [
        CollapsibleSection(title: "化粧下地", items: []),
        CollapsibleSection(title: "ファンデーション", items: []),
        CollapsibleSection(title: "コンシーラー", items: []),
        CollapsibleSection(title: "チーク", items: []),
        CollapsibleSection(title: "ハイライト・シェーディング", items: []),
        CollapsibleSection(title: "アイシャドウ", items: []),
        CollapsibleSection(title: "アイライナー", items: []),
        CollapsibleSection(title: "マスカラ", items: []),
        CollapsibleSection(title: "アイブロウ", items: []),
        CollapsibleSection(title: "リップ", items: []),
        CollapsibleSection(title: "アイブロウ", items: []),
    ]
    
    @State private var showsheet = false

    func addProductToSection(title: String, product: String) {
        if let index = sections.firstIndex(where: { $0.title == title }) {
            sections[index].items.append(product)
        }
    }

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
                    Mysheet(sections: sections) { title, product in
                        addProductToSection(title: title, product: product)
                    }
                    .presentationDetents([
                        .medium,
                        .large,
                        .height(300),
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
    var sections: [InputCosmeView.CollapsibleSection]
    @State public var brand: String = ""
    @State public var product: String = ""
    @State public var color: String = ""
    @State private var category = 1
    @State private var selectedCategory: String = "化粧下地"
    var onComplete: (String, String) -> Void
    
    var listProduct: String {
        brand + " " + product + " " + color
       }

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button("キャンセル") {
                        dismiss()
                    }
                    Spacer()
                    Button("完了") {
                        onComplete(selectedCategory, listProduct)
                        dismiss()
                    }
                }
                Text("マイコスメを追加")
                    .font(.headline)
            }
            .padding(.bottom)
            Spacer()
            HStack {
                Text("カテゴリ")
                    .bold()
                    .frame(width: 80, alignment: .leading)
                Picker("カテゴリ", selection: $selectedCategory) {
                    ForEach(sections, id: \.title) { section in
                        Text(section.title).tag(section.title)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity, alignment: .leading)
            }
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
    MainTabView()
}
