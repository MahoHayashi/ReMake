//
//  InputCosmeView.swift
//  ReMake
//
//  Created by maho hayashi on 2025/06/05.
//

import SwiftUI
import Foundation
import SwiftData

@Model
class Cosmetic {
    var id: UUID
    var brand: String
    var product: String
    var color: String
    var category: String

    init(brand: String, product: String, color: String, category: String) {
        self.id = UUID()
        self.brand = brand
        self.product = product
        self.color = color
        self.category = category
    }

    var listProduct: String {
        "\(brand) \(product) \(color)"
    }
}

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
        CollapsibleSection(title: "カラコン", items: []),
        CollapsibleSection(title: "アイブロウ", items: []),
        CollapsibleSection(title: "リップ", items: []),
    ]
    
    @State private var showsheet = false
    @Environment(\.modelContext) private var modelContext
    @Query  var cosmetics: [Cosmetic]

    //titleにあったitemに追加する関数
    func addProductToSection(title: String, product: String) {
        let updatedProducts = cosmetics
            .filter { $0.category == title }
            .map { $0.listProduct }

        if let index = sections.firstIndex(where: { $0.title == title }) {
            sections[index].items = updatedProducts
        }
    }
    
    func updateSections() {
        for index in sections.indices {
            let title = sections[index].title
            let products = cosmetics
                .filter { $0.category == title }
                .map { $0.listProduct }
            sections[index].items = products
        }
    }
    
    //コスメを追加する関数(関数作らずに.insertだけでよかったかも)
    private func addCosmetic(brand: String, product: String, color: String, category: String) {
        let newCosmetic = Cosmetic(brand: brand, product: product, color: color, category: category)
        modelContext.insert(newCosmetic)
        try? modelContext.save()
        updateSections()
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
                    Mysheet(sections: sections) { category, brand, product, color in
                        addCosmetic(brand: brand, product: product, color: color, category: category)
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
                        //削除機能
                        .onDelete { indexSet in
                            for index in indexSet {
                                let itemToDelete = section.items[index]
                                if let cosmeticToDelete = cosmetics.first(where: { $0.listProduct == itemToDelete }) {
                                    modelContext.delete(cosmeticToDelete)
                                }
                            }
                            try? modelContext.save()
                            updateSections()
                        }
                    } label: {
                        Text(section.title)
                            .font(.headline)
                    }
                }
            }
        }
        //画面が開かれたとき、初期設定をしている
        .onAppear {
            for index in sections.indices {
                let title = sections[index].title
                let products = cosmetics
                    .filter { $0.category == title }
                    .map { $0.listProduct }
                sections[index].items = products
            }
        }
    }
}

struct Mysheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    var sections: [InputCosmeView.CollapsibleSection]
    @State public var brand: String = ""
    @State public var product: String = ""
    @State public var color: String = ""
    @State private var category = 1
    @State private var selectedCategory: String = "化粧下地"
    @Query var cosmetics: [Cosmetic]
    var onComplete: (String, String, String, String) -> Void
    
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
                        onComplete(selectedCategory, brand, product, color)
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
