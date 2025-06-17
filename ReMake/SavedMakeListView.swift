//
//  SavedMakeListView.swift
//  ReMake
//
//  Created by maho hayashi on 2025/06/06.
//

import SwiftUI
import Foundation
import SwiftData

struct SavedMakeListView: View {
    @Query private var savedRecords: [MakeupRecord]
    @State private var cards: [MakeupRecord] = []
    @State private var path = NavigationPath()
    @Environment(\.modelContext) private var modelContext
    
    //比較モードが有効かどうかのBool
    @State private var isComparisonMode = false
    @State private var selectedCardIDs: Set<UUID> = []
    @State private var showAlert = false
    @State private var compareBeforeWord: String = "比較"
    @State private var showComparisonView = false
    
//    private func deleteCard(_ card: MakeupRecord) {
//        if let index = cards.firstIndex(where: { $0.id == card.id }) {
//            cards.remove(at: index)
//            modelContext.delete(card)
//            try? modelContext.save()
//        }
//    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                // NavigationLink for navigation
                VStack(spacing: 0) {
                    HStack {
                        Button {
                            isComparisonMode.toggle()//toggle()でBoolを反転
                        } label: {
                            Text(isComparisonMode ? "戻る" : "比較")
                                .font(.system(size: 25))
                                .font(.headline)
                                .frame(width: 80, height: 55)
                                .foregroundColor(.white)
                                .background(.pink)
                                .cornerRadius(20)
                                .padding(.leading, 20)
                        }
                        Spacer()
                        ZStack(alignment: .topTrailing) {
                            
                            if isComparisonMode {
                                /*filter は **「条件を満たす要素だけを抽出する」**ときに使う*/
                                NavigationLink(destination: CompareMakeupView(records: cards.filter { selectedCardIDs.contains($0.id) }), isActive: $showComparisonView) {
                                    EmptyView()
                                }
                                .hidden()
                                
                                Button(action: {
                                    showComparisonView = true
                                }) {
                                    Text("決定")
                                        .font(.system(size: 25))
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .frame(width: 50, height: 40)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color.pink)
                                        .cornerRadius(20)
                                }
                                .zIndex(1)
                                .offset(x: -10, y: 0)
                            }

                            Button(action: {
                                path.append("input")
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Circle().fill(Color(red: 0xA6/255.0, green: 0x80/255.0, blue: 0x76/255.0)))
                            }
                            .padding(.trailing, 20)
                        }
                    }
                    .padding(.vertical, 8)

                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(cards, id: \.id) { card in
                                ZStack(alignment: .topTrailing) {
                                    NavigationLink(destination: MakeupDetailView(record: card)) {
                                        VStack {
                                            if let data = card.faceImageData, let uiImage = UIImage(data: data) {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .cornerRadius(10)
                                                    .frame(width: 170, height: 170)
                                            } else {
                                                Image("pinkPaper")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .cornerRadius(10)
                                                    .frame(width: 150, height: 150)
                                            }
                                            Text(card.name)
                                                .bold()
                                                .foregroundColor(.black)
//                                            Button(action: {
//                                                if let index = cards.firstIndex(where: { $0.id == card.id }) {
//                                                    cards.remove(at: index)
//                                                    modelContext.delete(card)
//                                                    try? modelContext.save()
//                                                }
//                                            }) {
//                                                Text("×")
//                                                    .font(.caption)
//                                                    .foregroundColor(.red)
//                                                    .padding(6)
//                                                    .background(Color.gray.opacity(0.1))
//                                                    .cornerRadius(8)
//                                            }
                                        }
                                        .frame(width: 130, height: 200)
                                        .padding()
                                        .background(.white)
                                        .cornerRadius(20)
                                        .clipped()
                                        .shadow(color: .gray.opacity(0.7), radius: 5)
                                    }
//                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//                                        if !isComparisonMode {
//                                            Button(role: .destructive) {
//                                                if let index = cards.firstIndex(where: { $0.id == card.id }) {
//                                                    cards.remove(at: index)
//                                                    modelContext.delete(card)
//                                                    try? modelContext.save()
//                                                }
//                                            } label: {
//                                                Label("削除", systemImage: "trash")
//                                            }
//                                        }
//                                    }

                                    if isComparisonMode {
                                        Button {
                                            if selectedCardIDs.contains(card.id) {
                                                selectedCardIDs.remove(card.id)
                                            } else if selectedCardIDs.count < 2 {
                                                selectedCardIDs.insert(card.id)
                                            } else {
                                                showAlert = true
                                            }
                                        } label: {
                                            Circle()
                                                .fill(Color.white)
                                                .frame(width: 50, height: 50)
                                                .overlay(
                                                    ZStack {
                                                        Circle()
                                                            .stroke(Color.gray, lineWidth: 2)
                                                        if selectedCardIDs.contains(card.id) {
                                                            Image(systemName: "checkmark")
                                                                .font(.system(size: 30))
                                                                .foregroundColor(.pink)
                                                        }
                                                    }
                                                )
                                                .offset(x: 10, y: -10)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .alert("選択できるメイクは二つまでです", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
            .onAppear {
                cards = savedRecords
            }
            .navigationDestination(for: String.self) { value in
                if value == "input" {
                    InputMakeupView(path: $path)
                }
            }
        }
    }
}

#Preview {
    MainTabView()
}
