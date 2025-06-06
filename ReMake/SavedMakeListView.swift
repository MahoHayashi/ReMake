//
//  SavedMakeListView.swift
//  ReMake
//
//  Created by maho hayashi on 2025/06/06.
//

import SwiftUI

struct SavedMakeListView: View {
    @State private var isShowingInputView = false
    var body: some View {
        NavigationView {
            ZStack {
                // NavigationLink for navigation
                NavigationLink(destination: InputMakeupView(), isActive: $isShowingInputView) {
                    EmptyView()
                }
                VStack {
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
                            isShowingInputView = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .padding()
                                .background(Circle().fill(Color(red: 0xA6/255.0, green: 0x80/255.0, blue: 0x76/255.0)))
                        }
                        .padding(.trailing, 20)
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    MainTabView()
}
