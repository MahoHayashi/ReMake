//
//  InputMakeupView.swift
//  ReMake
//
//  Created by maho hayashi on 2025/06/06.
//

import SwiftUI
import Foundation
import SwiftData

@Model
class MakeupRecord {
    var id = UUID()
    var name: String
    var comment: String
    var url: String

    init(name: String, comment: String, url: String) {
        self.name = name
        self.comment = comment
        self.url = url
    }
}


class CameraLaunchViewModel: ObservableObject {
    @Published var isLaunchedCamera = false
    @Published var imageData = Data()
}

struct InputMakeupView: View {
    
    //カテゴリとか種別のものはenumの方が可読性が良い！
    enum SelectionType {
        case eye, lip, highlight, eyebrow, base, cheek, mascara, eyeshadow, eyeliner,colorlense
    }
    
    @State var makeName: String = ""
    @State var comment: String = ""
    @State var URLcomment: String = ""

    @State private var imageIndex: Int = 0

    @State private var showAlert: Bool = false

    @State private var showPickerSheet = false
    @State private var selectedEye = ""
    @State private var selectedLip = ""
    @State private var selectedHighlight = ""
    @State private var selectedEyebrow = ""
    @State private var selectedBase = ""
    @State private var selectedCheek = ""
    @State private var selectedMascara = ""
    @State private var selectedEyeshadow = ""
    @State private var selectedEyeliner = ""
    @State private var selectedColorlense = ""
    @State private var currentSelection: SelectionType? = nil
    @State private var sheetTitle: String = ""
    @State private var selectedItems: [SelectionType: String] = [:]

    @StateObject private var viewModel = CameraLaunchViewModel()

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool //NavigationStack使ってるからBinding
    @Query private var cosmetics: [Cosmetic]

var pickerOptions: [String] {
    let options = Array(Set(cosmetics.map { $0.listProduct }))
    //なにもコスメが登録されていない場合の処理
    return options.isEmpty ? ["（登録されたコスメがありません）"] : options
}
    
    func bindingForCurrentSelection() -> Binding<String> {
        //enumとswitch文は相性が良い！
        switch currentSelection {
        case .eye: return $selectedEye
        case .lip: return $selectedLip
        case .highlight: return $selectedHighlight
        case .eyebrow: return $selectedEyebrow
        case .base: return $selectedBase
        case .cheek: return $selectedCheek
        case .eyeliner: return $selectedEyeliner
        case .eyeshadow: return $selectedEyeshadow
        case .colorlense: return $selectedColorlense
        case .mascara: return $selectedMascara
        case .none: return .constant("")
        }
    }
    
    var body: some View {
        ZStack{
            Spacer()
            VStack {
                HStack {
                    Spacer()
                    Button {
                        let record = MakeupRecord(name: makeName, comment: comment, url: URLcomment)
                        modelContext.insert(record)
                        try? modelContext.save()
                    isPresented = false
                        //dismiss() NavigationLinkを使っている場合はむり
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
                            "EyeImage",
                            "pinkPaper",
                            "morepinkPaper"
                        ], index: $imageIndex)
                        .frame(width: 370, height: 370)
                        
                        if imageIndex == 0 {
                            // Add six plus buttons over the image with selected value display
                            // Example for .lip
                            VStack(spacing: 0) {
                                if let value = selectedItems[.lip], !value.isEmpty {
                                    Text(value)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .padding(4)
                                        .background(Color.white.opacity(0.6))
                                        .cornerRadius(6)
                                        .offset(y: -20)
                                }
                                Button(action: {
                                    sheetTitle = "リップを選択"
                                    currentSelection = .lip
                                    showPickerSheet = true
                                }) {
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .position(x: 218, y: 285) //リップ

                            VStack(spacing: 0) {
                                if let value = selectedItems[.highlight], !value.isEmpty {
                                    Text(value)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .padding(4)
                                        .background(Color.white.opacity(0.6))
                                        .cornerRadius(6)
                                        .offset(y: -20)
                                }
                                Button(action: {
                                    sheetTitle = "ハイライト・シェーディングを選択"
                                    currentSelection = .highlight
                                    showPickerSheet = true
                                }) {
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .position(x: 204, y: 205) //ハイライト・シェーディング

                            VStack(spacing: 0) {
                                if let value = selectedItems[.eyebrow], !value.isEmpty {
                                    Text(value)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .padding(4)
                                        .background(Color.white.opacity(0.6))
                                        .cornerRadius(6)
                                        .offset(y: -20)
                                }
                                Button(action: {
                                    sheetTitle = "アイブロウを選択"
                                    currentSelection = .eyebrow
                                    showPickerSheet = true
                                }) {
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .position(x: 278, y: 152) //アイブロウ
                            .sheet(isPresented: $showPickerSheet) {
                                VStack {
                                    Text(sheetTitle)
                                        .font(.headline)
                                        .padding()
                                    Picker("選択", selection: bindingForCurrentSelection()) {
                                        ForEach(pickerOptions, id: \.self) { option in
                                            Text(option)
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                    .padding()
                                    HStack {
                                        
                                        Button("キャンセル") {
                                            showPickerSheet = false
                                        }
                                        .padding(.leading, 16)
                                        Spacer()
                                        Button("完了") {
                                            if let selection = currentSelection {
                                                selectedItems[selection] = bindingForCurrentSelection().wrappedValue
                                            }
                                            showPickerSheet = false
                                        }
                                    }
                                    .padding(.leading, 16)
                                    .padding(.trailing, 40)
                                }
                                .presentationDetents([
                                    .medium,
                                    .large,
                                    .height(300),
                                    .fraction(0.8)
                                ])
                            }

                            VStack(spacing: 0) {
                                if let value = selectedItems[.base], !value.isEmpty {
                                    Text(value)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .padding(4)
                                        .background(Color.white.opacity(0.6))
                                        .cornerRadius(6)
                                        .offset(y: -20)
                                }
                                Button(action: {
                                    sheetTitle = "ベースメイクを選択"
                                    currentSelection = .base
                                    showPickerSheet = true
                                }) {
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .position(x: 135, y: 247) //ベースメイク

                            VStack(spacing: 0) {
                                if let value = selectedItems[.cheek], !value.isEmpty {
                                    Text(value)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .padding(4)
                                        .background(Color.white.opacity(0.6))
                                        .cornerRadius(6)
                                        .offset(y: -20)
                                }
                                Button(action: {
                                    sheetTitle = "チークを選択"
                                    currentSelection = .cheek
                                    showPickerSheet = true
                                }) {
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .position(x: 270, y: 230) //チーク
                        }else if imageIndex == 1 {
                            ZStack {
                                VStack(spacing: 0) {
                                    if let value = selectedItems[.eyeshadow], !value.isEmpty {
                                        Text(value)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                            .offset(y: -30)
                                    }
                                    Button(action: {
                                        currentSelection = .eyeshadow
                                        sheetTitle = "アイシャドウを選択"
                                        showPickerSheet = true
                                    }) {
                                        Image(systemName: "plus.circle")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.pink)
                                    }
                                }
                                .position(x: 150, y: 90)
                                .sheet(isPresented: $showPickerSheet) {
                                    VStack {
                                        Text(sheetTitle)
                                            .font(.headline)
                                            .padding()
                                        Picker("選択", selection: bindingForCurrentSelection()) {
                                            ForEach(pickerOptions, id: \.self) { option in
                                                Text(option)
                                            }
                                        }
                                        .pickerStyle(.wheel)
                                        .padding()
                                        HStack {
                                            
                                            Button("キャンセル") {
                                                showPickerSheet = false
                                            }
                                            .padding(.leading, 16)
                                            Spacer()
                                            Button("完了") {
                                                if let selection = currentSelection {
                                                    selectedItems[selection] = bindingForCurrentSelection().wrappedValue
                                                }
                                                showPickerSheet = false
                                            }
                                        }
                                        .padding(.leading, 16)
                                        .padding(.trailing, 40)
                                    }
                                    .presentationDetents([
                                        .medium,
                                        .large,
                                        .height(300),
                                        .fraction(0.8)
                                    ])
                                }//アイシャドウ

                                VStack(spacing: 0) {
                                    if let value = selectedItems[.mascara], !value.isEmpty {
                                        Text(value)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                            .offset(y: -30)
                                    }
                                    Button(action: {
                                        currentSelection = .mascara
                                        sheetTitle = "マスカラを選択"
                                        showPickerSheet = true
                                    }) {
                                        Image(systemName: "plus.circle")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.pink)
                                    }
                                }
                                .position(x: 273, y: 90) // マスカラ

                                VStack(spacing: 0) {
                                    if let value = selectedItems[.colorlense], !value.isEmpty {
                                        Text(value)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                            .offset(y: -30)
                                    }
                                    Button(action: {
                                        currentSelection = .colorlense
                                        sheetTitle = "カラコンを選択"
                                        showPickerSheet = true
                                    }) {
                                        Image(systemName: "plus.circle")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.pink)
                                    }
                                }
                                .position(x: 196, y: 190) // カラコン

                                VStack(spacing: 0) {
                                    if let value = selectedItems[.eyeliner], !value.isEmpty {
                                        Text(value)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                            .offset(y: -30)
                                    }
                                    Button(action: {
                                        currentSelection = .eyeliner
                                        sheetTitle = "アイラインを選択"
                                        showPickerSheet = true
                                    }) {
                                        Image(systemName: "plus.circle")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.pink)
                                    }
                                }
                                .position(x: 340, y: 170) // アイライン
                            }
                        }else if imageIndex == 2 {
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
                                    Button("はい") {
                                        showAlert = false
                                        viewModel.isLaunchedCamera = true
                                    }
                                    //ダイアログ内で行う処理
                                } message: {
                                    Text("フラッシュをたこう！")
                                }
                            }
                            .fullScreenCover(isPresented: $viewModel.isLaunchedCamera) {
                                Imagepicker(show: $viewModel.isLaunchedCamera, image: $viewModel.imageData)
                            }
                        }else if imageIndex == 3 {
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
                                    Button("はい") {
                                        showAlert = false
                                        viewModel.isLaunchedCamera = true
                                    }
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
    InputMakeupView(isPresented: .constant(true))
}
