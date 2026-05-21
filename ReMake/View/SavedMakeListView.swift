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
    @State private var path = NavigationPath()
    @StateObject private var viewModel = SavedMakeListViewModel()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                // NavigationLink for navigation
                VStack(spacing: 0) {
                    HStack {
                        Button {
                            viewModel.toggleComparisonMode()
                        } label: {
                            Text(viewModel.isComparisonMode ? "戻る" : "比較")
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
                            
                            if viewModel.isComparisonMode {
                                NavigationLink(destination: CompareMakeupView(records: viewModel.selectedCards), isActive: $viewModel.showComparisonView) {
                                    EmptyView()
                                }
                                .hidden()
                                
                                Button(action: {
                                    viewModel.showComparisonView = true
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
                            ForEach(viewModel.cards, id: \.id) { card in
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
                                        }
                                        .frame(width: 130, height: 200)
                                        .padding()
                                        .background(.white)
                                        .cornerRadius(20)
                                        .clipped()
                                        .shadow(color: .gray.opacity(0.7), radius: 5)
                                    }

                                    if viewModel.isComparisonMode {
                                        Button {
                                            viewModel.toggleSelection(for: card)
                                        } label: {
                                            Circle()
                                                .fill(Color.white)
                                                .frame(width: 50, height: 50)
                                                .overlay(
                                                    ZStack {
                                                        Circle()
                                                            .stroke(Color.gray, lineWidth: 2)
                                                        if viewModel.selectedCardIDs.contains(card.id) {
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
            .alert("選択できるメイクは二つまでです", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            }
            .onAppear {
                viewModel.updateCards(from: savedRecords)
            }
            .onChange(of: savedRecords.map(\.id)) { _ in
                viewModel.updateCards(from: savedRecords)
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
