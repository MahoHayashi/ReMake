//
//  InputMakeupView.swift
//  ReMake
//
//  Created by maho hayashi on 2025/06/06.
//

import SwiftUI
import Foundation
import _SwiftData_SwiftUI


struct InputMakeupView: View {
    @StateObject private var viewModel = InputMakeupViewModel()
    @StateObject private var cameraViewModel = CameraLaunchViewModel()

    @Environment(\.modelContext) private var modelContext
    @Binding var path: NavigationPath
    @Query private var cosmetics: [Cosmetic]

    var pickerOptions: [String] {
        viewModel.pickerOptions(from: cosmetics)
    }
    
    var body: some View {
        ZStack{
            Spacer()
            VStack {
                HStack {
                    Spacer()
//                    Button {
//                        save()
//                    } label: {
//                        Text("完了")
//                            .foregroundColor(.white)
//                            .padding(.horizontal, 20)
//                            .padding(.vertical, 10)
//                            .background(.pink)
//                            .cornerRadius(20)
//                    }
//                    .padding(.trailing, 20)
                }
                    //イニシャライザに渡す
                    ZStack {
                        VStack{
                            ImagePager(images: [
                                .named("MakeupFace"),
                                .named("ImageEye"),
                                .named("pinkPaper"),
                                .named("morepinkPaper")
                            ], index: $viewModel.imageIndex)
                            .frame(width: 370, height: 370)
                            
                            HStack(spacing: 8) {
                                ForEach(0..<4, id: \.self) { i in
                                    Circle()
                                        .fill(i == viewModel.imageIndex ? Color.primary : Color.secondary.opacity(0.4))
                                        .frame(width: 8, height: 8)
                                }
                            }
                        }
                        .padding(.top, 8)
                        
                        if viewModel.imageIndex == 0 {
                            // Add six plus buttons over the image with selected value display
                            // Example for .lip
                            VStack(spacing: 0) {
                                if let values = viewModel.selectedItemLists[.lip] {
                                    CosmeticOverlayLabel(title: viewModel.sectionTitle(for: .lip), values: values)
                                        .offset(y: -20)
                                }
                                Button(action: {
                                    viewModel.setPicker(selection: .lip, title: "リップを選択", cosmetics: cosmetics)
                                }) {
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .position(x: 218, y: 285) //リップ

                            VStack(spacing: 0) {
                                if let values = viewModel.selectedItemLists[.highlight] {
                                    CosmeticOverlayLabel(title: viewModel.sectionTitle(for: .highlight), values: values)
                                        .offset(y: -20)
                                }
                                Button(action: {
                                    viewModel.setPicker(selection: .highlight, title: "ハイライト・シェーディングを選択", cosmetics: cosmetics)
                                }) {
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .position(x: 200, y: 208) //ハイライト・シェーディング

                            VStack(spacing: 0) {
                                if let values = viewModel.selectedItemLists[.eyebrow] {
                                    CosmeticOverlayLabel(title: viewModel.sectionTitle(for: .eyebrow), values: values)
                                        .offset(y: -20)
                                }
                                Button(action: {
                                    viewModel.setPicker(selection: .eyebrow, title: "アイブロウを選択", cosmetics: cosmetics)
                                }) {
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .position(x: 278, y: 152) //アイブロウ
                            .sheet(isPresented: $viewModel.showPickerSheet) {
                                VStack {
                                    Text(viewModel.sheetTitle)
                                        .font(.headline)
                                        .padding()

                                    if pickerOptions.first != "（登録されたコスメがありません）" {
                                        Picker("選択", selection: viewModel.currentSelectionBinding()) {
                                            ForEach(pickerOptions, id: \.self) { option in
                                                Text(option)
                                            }
                                        }
                                        .pickerStyle(.wheel)
                                        .padding()

                                        HStack {
                                            Button("キャンセル") {
                                                viewModel.showPickerSheet = false
                                            }
                                            .padding(.leading, 16)
                                            Spacer()
                                            Button("完了") {
                                                viewModel.addSelectedValue()
                                                viewModel.showPickerSheet = false
                                            }
                                        }
                                        .padding(.leading, 16)
                                        .padding(.trailing, 40)
                                    } else {
                                        Text("登録されたコスメがありません")
                                            .foregroundColor(.gray)
                                            .padding()
                                        Button("閉じる") {
                                            viewModel.showPickerSheet = false
                                        }
                                    }
                                }
                                .presentationDetents([
                                    .medium,
                                    .large,
                                    .height(300),
                                    .fraction(0.8)
                                ])
                            }

                            VStack(spacing: 0) {
                                if let values = viewModel.selectedItemLists[.base] {
                                    CosmeticOverlayLabel(title: viewModel.sectionTitle(for: .base), values: values)
                                        .offset(y: -20)
                                }
                                Button(action: {
                                    viewModel.setPicker(selection: .base, title: "ベースメイクを選択", cosmetics: cosmetics)
                                }) {
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .position(x: 135, y: 247) //ベースメイク

                            VStack(spacing: 0) {
                                if let values = viewModel.selectedItemLists[.cheek] {
                                    CosmeticOverlayLabel(title: viewModel.sectionTitle(for: .cheek), values: values)
                                        .offset(y: -20)
                                }
                                Button(action: {
                                    viewModel.setPicker(selection: .cheek, title: "チークを選択", cosmetics: cosmetics)
                                }) {
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .position(x: 270, y: 230) //チーク
                        }else if viewModel.imageIndex == 1 {
                            ZStack {
                                VStack(spacing: 0) {
                                    if let values = viewModel.selectedItemLists[.eyeshadow] {
                                        CosmeticOverlayLabel(title: viewModel.sectionTitle(for: .eyeshadow), values: values)
                                            .offset(y: -30)
                                    }
                                    Button(action: {
                                        viewModel.setPicker(selection: .eyeshadow, title: "アイシャドウを選択", cosmetics: cosmetics)
                                    }) {
                                        Image(systemName: "plus.circle")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .position(x: 140, y: 110)
                                .sheet(isPresented: $viewModel.showPickerSheet) {
                                    VStack {
                                        Text(viewModel.sheetTitle)
                                            .font(.headline)
                                            .padding()

                                        if pickerOptions.first != "（登録されたコスメがありません）" {
                                            Picker("選択", selection: viewModel.currentSelectionBinding()) {
                                                ForEach(pickerOptions, id: \.self) { option in
                                                    Text(option)
                                                }
                                            }
                                            .pickerStyle(.wheel)
                                            .padding()

                                            HStack {
                                                Button("キャンセル") {
                                                    viewModel.showPickerSheet = false
                                                }
                                                .padding(.leading, 16)
                                                Spacer()
                                                Button("完了") {
                                                    viewModel.addSelectedValue()
                                                    viewModel.showPickerSheet = false
                                                }
                                            }
                                            .padding(.leading, 16)
                                            .padding(.trailing, 40)
                                        } else {
                                            Text("登録されたコスメがありません")
                                                .foregroundColor(.gray)
                                                .padding()
                                            Button("閉じる") {
                                                viewModel.showPickerSheet = false
                                            }
                                        }
                                    }
                                    .presentationDetents([
                                        .medium,
                                        .large,
                                        .height(300),
                                        .fraction(0.8)
                                    ])
                                }//アイシャドウ

                                VStack(spacing: 0) {
                                    if let values = viewModel.selectedItemLists[.mascara] {
                                        CosmeticOverlayLabel(title: viewModel.sectionTitle(for: .mascara), values: values)
                                            .offset(y: -30)
                                    }
                                    Button(action: {
                                        viewModel.setPicker(selection: .mascara, title: "マスカラを選択", cosmetics: cosmetics)
                                    }) {
                                        Image(systemName: "plus.circle")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .position(x: 270, y: 100) // マスカラ

                                VStack(spacing: 0) {
                                    if let values = viewModel.selectedItemLists[.colorlense] {
                                        CosmeticOverlayLabel(title: viewModel.sectionTitle(for: .colorlense), values: values)
                                            .offset(y: -30)
                                    }
                                    Button(action: {
                                        viewModel.setPicker(selection: .colorlense, title: "カラコンを選択", cosmetics: cosmetics)
                                    }) {
                                        Image(systemName: "plus.circle")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .position(x: 180, y: 205) // カラコン

                                VStack(spacing: 0) {
                                    if let values = viewModel.selectedItemLists[.eyeliner] {
                                        CosmeticOverlayLabel(title: viewModel.sectionTitle(for: .eyeliner), values: values)
                                            .offset(y: -30)
                                    }
                                    Button(action: {
                                        viewModel.setPicker(selection: .eyeliner, title: "アイラインを選択", cosmetics: cosmetics)
                                    }) {
                                        Image(systemName: "plus.circle")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .position(x: 328, y: 170) // アイライン
                                // 目
                            }
                        }else if viewModel.imageIndex == 2 {
                            // viewModel.tempFaceImageData の画像表示
                            if let data = viewModel.tempFaceImageData, let uiImage = UIImage(data: data) {
                                Button {
                                    viewModel.tempFaceImageData = nil
                                } label: {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 300, height: 300)
                                        .cornerRadius(10)
                                }
                            }
                            VStack {
                                Spacer()
                                Button("顔全体の写真") {
                                    viewModel.showAlert.toggle()
                                }
                                .bold()
                                .font(.system(size: 50))
                                .foregroundColor(.black)
                                .padding(.top, 20)
                                Spacer()
                                .alert("顔全体の写真を撮る",isPresented: $viewModel.showAlert) {
                                    Button("キャンセル") {}
                                    Button("はい") {
                                        viewModel.showAlert = false
                                        cameraViewModel.isLaunchedCamera = true
                                        cameraViewModel.capturedType = "face"
                                    }
                                } message: {
                                    Text("フラッシュをたこう！")
                                }
                            }
                            .fullScreenCover(isPresented: $cameraViewModel.isLaunchedCamera) {
                                Imagepicker(show: $cameraViewModel.isLaunchedCamera, image: $cameraViewModel.imageData)
                            }
                        }else if viewModel.imageIndex == 3 {
                            // viewModel.tempEyeImageData の画像表示
                            if let data = viewModel.tempEyeImageData, let uiImage = UIImage(data: data) {
                                Button {
                                    viewModel.tempEyeImageData = nil
                                } label: {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 400, height: 350)
                                        .cornerRadius(10)
                                }
                            }
                            VStack {
                                Spacer()
                                Button("目元の写真") {
                                    viewModel.showAlert.toggle()
                                }
                                .bold()
                                .font(.system(size: 50))
                                .foregroundColor(.black)
                                .padding(.top, 20)
                                Spacer()
                                .alert("目元の写真を撮る",isPresented: $viewModel.showAlert) {
                                    Button("キャンセル") {}
                                    Button("はい") {
                                        viewModel.showAlert = false
                                        cameraViewModel.isLaunchedCamera = true
                                        cameraViewModel.capturedType = "eye"
                                    }
                                } message: {
                                    Text("フラッシュをたこう！")
                                }
                            }
                            .fullScreenCover(isPresented: $cameraViewModel.isLaunchedCamera) {
                                Imagepicker(show: $cameraViewModel.isLaunchedCamera, image: $cameraViewModel.imageData)
                            }
                        }
                    }
                Spacer()
                Spacer()
                
                Text("メイクのタイトル")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 50)
                TextField("メイクのタイトルを入力してください", text: $viewModel.makeName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 45)
                Text("コメント")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 50)
                TextField("コメントを入力してください", text: $viewModel.comment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 45)
                Text("参考にした記事・動画のURL")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 50)
                TextField("URLを入力してください", text: $viewModel.urlComment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 45)
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
        }
        // .onChangeで撮影後のデータを一時保存
        .onChange(of: cameraViewModel.imageData) { newData in
            viewModel.updateCapturedImage(newData, type: cameraViewModel.capturedType)
        }
        // キーボード表示中も保存できるように、キーボード上部に完了ボタンを出す
        // （上部の完了ボタンはキーボードで画面外に押し出されてタップできなくなるため）
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("完了") {
                    save()
                }
            }
        }
    }

    private func save() {
        viewModel.saveMakeup(to: modelContext)
        cameraViewModel.imageData = Data()
        cameraViewModel.capturedType = nil
        path.removeLast()
    }
}

#Preview {
    InputMakeupView(path: .constant(NavigationPath()))
}
