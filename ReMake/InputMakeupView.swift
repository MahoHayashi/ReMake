//
//  InputMakeupView.swift
//  ReMake
//
//  Created by maho hayashi on 2025/06/06.
//

import SwiftUI
import SwiftData

struct InputMakeupView: View {
    @State var makeName: String = ""
    @State var comment: String = ""
    @State var URLcomment: String = ""
    
    @State private var imageIndex: Int = 0
    
    @State private var showAlert: Bool = false
    
    @State private var showPickerSheet = false
    @State private var selectedOption = "（登録されたコスメがありません）"
    @State private var sheetTitle: String = ""

    @Environment(\.modelContext) private var modelContext
    @Query private var cosmetics: [Cosmetic]

var pickerOptions: [String] {
    let options = Array(Set(cosmetics.map { $0.listProduct }))
    //なにもコスメが登録されていない場合の処理
    return options.isEmpty ? ["（登録されたコスメがありません）"] : options
}
    
    var body: some View {
        ZStack{
            Spacer()
            VStack {
                HStack {
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("完了")
                        //                        .font(.system(size: 25))
                        //                        .font(.headline)
                        //                        .frame(width: 100, height: 50)
                        //                        .foregroundColor(.white)
                        //                        .background(.pink)
                        //                        .cornerRadius(20)
                            .padding(.trailing, 20)
                    }
                }
                    //イニシャライザに渡す
                    ZStack {
                        ImagePager(imageNames: [
                            "MakeupFace",
                            "pinkPaper",
                            "morepinkPaper"
                        ], index: $imageIndex)
                        .frame(width: 370, height: 370)
                        
                        if imageIndex == 0 {
                            // Add six plus buttons over the image
                            Button(action: {
                                sheetTitle = "目元のコスメを選択"
                                showPickerSheet = true
                            }) {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.secondary)
                            }//目元のコスメ
                            .position(x: 123, y: 185)
                            .sheet(isPresented: $showPickerSheet) {
                                VStack {
                                    Text(sheetTitle)
                                        .font(.headline)
                                        .padding()
                                    Picker("選択", selection: $selectedOption) {
                                        ForEach(pickerOptions, id: \.self) { option in
                                            Text(option)
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                    .padding()

                                    Button("完了") {
                                        showPickerSheet = false
                                    }
                                    .padding()
                                }
                                .presentationDetents([
                                    .medium,
                                    .large,
                                    .height(300),
                                    .fraction(0.8)
                                ])
                            }

                            Button(action: {
                                sheetTitle = "リップを選択"
                                showPickerSheet = true
                            }) {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.secondary)
                            }.position(x: 218, y: 285) //リップ

                            Button(action: {
                                sheetTitle = "ハイライト・シェーディングを選択"
                                showPickerSheet = true
                            }) {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.secondary)
                            }.position(x: 204, y: 227) //ハイライト・シェーディング

                            Button(action: {
                                sheetTitle = "アイブロウを選択"
                                showPickerSheet = true
                            }) {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.secondary)
                            }.position(x: 278, y: 152) //アイブロウ

                            Button(action: {
                                sheetTitle = "ベースメイクを選択"
                                showPickerSheet = true
                            }) {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.secondary)
                            }.position(x: 135, y: 247) //ベースメイク

                            Button(action: {
                                sheetTitle = "チークを選択"
                                showPickerSheet = true
                            }) {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.secondary)
                            }.position(x: 270, y: 230) //チーク
                            
                        }else if imageIndex == 1 {
                            VStack {
                                Spacer()
                                Button("顔全体の写真") {
                                    showAlert.toggle()
                                }
                                .bold()
                                .font(.system(size: 50))
                                .foregroundColor(.black)
                                .padding(.top, 20)
                                Spacer()
                                .alert("顔全体の写真を撮る",isPresented: $showAlert) {
                                    Button("キャンセル") {}
                                    Button("はい") {}
                                    //ダイアログ内で行う処理
                                } message: {
                                    Text("フラッシュをたこう！")
                                }
                            }
                        }else if imageIndex == 2 {
                            VStack {
                                Spacer()
                                Button("目元の写真") {
                                    showAlert.toggle()
                                }
                                .bold()
                                .font(.system(size: 50))
                                .foregroundColor(.black)
                                .padding(.top, 20)
                                Spacer()
                                .alert("目元の写真を撮る",isPresented: $showAlert) {
                                    Button("キャンセル") {}
                                    Button("はい") {}
                                    //ダイアログ内で行う処理
                                } message: {
                                    Text("フラッシュをたこう！")
                                }
                            }
                            
                        }
                    }
                Spacer()
                Spacer()
                
                Text("メイクのタイトル")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 50)
                TextField("メイクのタイトルを入力してください", text: $makeName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 45)
                Text("コメント")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 50)
                TextField("コメントを入力してください", text: $comment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 45)
                Text("参考にした記事・動画のURL")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 50)
                TextField("URLを入力してください", text: $URLcomment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 45)
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
            }
        }
    }
}

#Preview {
    InputMakeupView()
}
