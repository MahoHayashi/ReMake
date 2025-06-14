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
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                // NavigationLink for navigation
                VStack(spacing: 0) {
                    HStack {
                        Button {
                            
                        } label: {
                            Text("比較")
                                .font(.system(size: 25))
                                .font(.headline)
                                .frame(width: 80, height: 55)
                                .foregroundColor(.white)
                                .background(.pink)
                                .cornerRadius(20)
                                .padding(.leading, 20)
                        }
                        Spacer()
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
                    .padding(.vertical, 8)

                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(cards, id: \.id) { card in
                                NavigationLink(destination: MakeupDetailView(record: card)) {
                                    //MakeupDetailViewに受け取らせたいものを引数に書く
                                    VStack {
                                        if let data = card.faceImageData, let uiImage = UIImage(data: data) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFit()
                                                .cornerRadius(10)
                                                .frame(width: 170, height: 170)
                                        } else {
                                            Image("Marichan")
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
                            }
                        }
                        .padding()
                    }
                }
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
