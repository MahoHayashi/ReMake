//
//  InputMakeupView.swift
//  ReMake
//
//  Created by maho hayashi on 2025/06/06.
//

import SwiftUI

struct InputMakeupView: View {
    @State var makeName: String = ""
    @State var comment: String = ""
    @State var URLcomment: String = ""
    
    @State private var imageIndex: Int = 0
    
    @State private var showAlert: Bool = false
    
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
                            Button(action: {}) {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }.position(x: 125, y: 220)//目元

                            Button(action: {}) {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }.position(x: 220, y: 320) //リップ

                            Button(action: {}) {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }.position(x: 204, y: 265)

                            Button(action: {}) {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }.position(x: 280, y: 200) //眉毛

                            Button(action: {}) {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }.position(x: 135, y: 285) //化粧下地とか

                            Button(action: {}) {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }.position(x: 270, y: 270) //チーク
                            
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
