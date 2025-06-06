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
                ImagePager(imageNames: [
                            "MakeupFace",
                            "blackLip",
                            "blackFace"
                        ])
                    //.resizable()
                    .frame(width: 370, height: 370)
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
