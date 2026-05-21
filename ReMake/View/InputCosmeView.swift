//
//  InputCosmeView.swift
//  ReMake
//
//  Created by maho hayashi on 2025/06/05.
//

import SwiftUI
import Foundation
import SwiftData



struct InputCosmeView: View {
    @StateObject private var viewModel = InputCosmeViewModel()
    @Environment(\.modelContext) private var modelContext
    @Query  var cosmetics: [Cosmetic]

    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                Button(action: {
                    viewModel.showsheet.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color(red: 0xA6/255.0, green: 0x80/255.0, blue: 0x76/255.0)))
                }
                .sheet(isPresented: $viewModel.showsheet){
                    Mysheet(sections: viewModel.sections) { category, brand, product, color in
                        viewModel.addCosmetic(
                            brand: brand,
                            product: product,
                            color: color,
                            category: category,
                            to: modelContext,
                            existingCosmetics: cosmetics
                        )
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
                ForEach($viewModel.sections) { $section in
                    DisclosureGroup(isExpanded: $section.isExpanded) {
                        ForEach(section.items, id: \.self) { item in
                            Text(item)
                                .foregroundColor(Color(white: 0.3))
                        }
                        //削除機能
                        .onDelete { indexSet in
                            viewModel.deleteCosmetics(
                                at: indexSet,
                                in: section,
                                from: modelContext,
                                cosmetics: cosmetics
                            )
                        }
                    } label: {
                        Text(section.title)
                            .font(.headline)
                    }
                }
            }
        }
        .onAppear {
            viewModel.updateSections(from: cosmetics)
        }
        .onChange(of: cosmetics.map(\.id)) { _ in
            viewModel.updateSections(from: cosmetics)
        }
    }
}

struct Mysheet: View {
    @Environment(\.dismiss) var dismiss
    var sections: [InputCosmeViewModel.CollapsibleSection]
    @State public var brand: String = ""
    @State public var product: String = ""
    @State public var color: String = ""
    @State private var selectedCategory: String = "化粧下地"
    var onComplete: (String, String, String, String) -> Void

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
