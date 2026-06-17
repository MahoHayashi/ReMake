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
    @StateObject private var searchViewModel = SearchCosmeticViewModel()
    var sections: [InputCosmeViewModel.CollapsibleSection]
    @State public var product: String = ""
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
                        onComplete(selectedCategory, "", product, "")
                        dismiss()
                    }
                }
                Text("マイコスメを追加")
                    .font(.headline)
            }
            .padding(.bottom)

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
                Text("商品名")
                    .bold()
                    .frame(width: 80, alignment: .leading)
                TextField("検索結果を選ぶか入力してください", text: $product)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            searchSection
        }
        .padding()
    }

    /// 楽天APIでコスメを検索し、結果をタップすると商品名欄に反映するセクション。
    private var searchSection: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("コスメを検索（楽天）", text: $searchViewModel.keyword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .submitLabel(.search)
                    .onSubmit {
                        Task { await searchViewModel.search() }
                    }
                if searchViewModel.isLoading {
                    ProgressView()
                }
            }

            if let message = searchViewModel.errorMessage {
                Text(message)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(searchViewModel.results) { result in
                        Button {
                            product = result.name
                        } label: {
                            HStack(alignment: .top, spacing: 12) {
                                AsyncImage(url: result.imageURL) { image in
                                    image.resizable().scaledToFill()
                                } placeholder: {
                                    Color(white: 0.92)
                                }
                                .frame(width: 64, height: 64)
                                .clipShape(RoundedRectangle(cornerRadius: 8))

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(result.name)
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                        .lineLimit(3)
                                        .multilineTextAlignment(.leading)
                                    Text("¥\(result.price)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 8)
                        }
                        Divider()
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    MainTabView()
}
