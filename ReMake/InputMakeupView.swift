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
    var faceImageData: Data?
    var eyeImageData: Data?
    var selectedItems: [String: String] = [:]

    init(name: String, comment: String, url: String, faceImageData: Data? = nil, eyeImageData: Data? = nil) {
        self.name = name
        self.comment = comment
        self.url = url
        self.faceImageData = faceImageData
        self.eyeImageData = eyeImageData
    }
}



class CameraLaunchViewModel: ObservableObject {
    @Published var isLaunchedCamera = false
    @Published var imageData = Data()
    @Published var capturedType: String? = nil
}

struct InputMakeupView: View {
    
    //カテゴリとか種別のものはenumの方が可読性が良い！
    enum SelectionType {
        case eye, lip, highlight, eyebrow, base, cheek, mascara, eyeshadow, eyeliner, colorlense
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
    @State private var selectedItemLists: [SelectionType: [String]] = [:]

    @StateObject private var viewModel = CameraLaunchViewModel()

    // 追加: 撮影後のデータ一時保存
    @State private var tempFaceImageData: Data? = nil
    @State private var tempEyeImageData: Data? = nil

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Binding var path: NavigationPath
    @Query private var cosmetics: [Cosmetic]

var pickerOptions: [String] {
    guard let current = currentSelection else { return [] }
    switch current {
    case .base:
        let baseCategories = ["化粧下地", "ファンデーション", "コンシーラー"]
        let filtered = cosmetics
            .filter { baseCategories.contains($0.category) }
            .map { $0.listProduct }
        return filtered.isEmpty ? ["（登録されたコスメがありません）"] : filtered
    default:
        let categoryTitle: String = {
            switch current {
            case .eye: return "アイ"
            case .lip: return "リップ"
            case .highlight: return "ハイライト・シェーディング"
            case .eyebrow: return "アイブロウ"
            case .cheek: return "チーク"
            case .mascara: return "マスカラ"
            case .eyeshadow: return "アイシャドウ"
            case .eyeliner: return "アイライナー"
            case .colorlense: return "カラコン"
            case .base: return "" // handled above
            }
        }()
        let filtered = cosmetics.filter { $0.category == categoryTitle }.map { $0.listProduct }
        return filtered.isEmpty ? ["（登録されたコスメがありません）"] : filtered
    }
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
                        let record = MakeupRecord(
                            name: makeName,
                            comment: comment,
                            url: URLcomment,
                            faceImageData: tempFaceImageData,
                            eyeImageData: tempEyeImageData
                        )
                        // Save as: [String: String] with joined values
                        record.selectedItems = selectedItemLists.reduce(into: [:]) { result, pair in
                            result[String(describing: pair.key)] = pair.value.joined(separator: ", ")
                        }
                        modelContext.insert(record)
                        do {
                            try modelContext.save()
                        } catch {
                            print("保存に失敗しました: \(error)")
                        }
                        viewModel.imageData = Data()
                        viewModel.capturedType = nil
                        tempFaceImageData = nil
                        tempEyeImageData = nil
                        path.removeLast()
                    } label: {
                        Text("完了")
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(.pink)
                            .cornerRadius(20)
                    }
                    .padding(.trailing, 20)
                }
                    //イニシャライザに渡す
                    ZStack {
                        VStack{
                            ImagePager(images: [
                                .named("MakeupFace"),
                                .named("ImageEye"),
                                .named("pinkPaper"),
                                .named("morepinkPaper")
                            ], index: $imageIndex)
                            .frame(width: 370, height: 370)
                            
                            HStack(spacing: 8) {
                                ForEach(0..<4, id: \.self) { i in
                                    Circle()
                                        .fill(i == imageIndex ? Color.primary : Color.secondary.opacity(0.4))
                                        .frame(width: 8, height: 8)
                                }
                            }
                        }
                        .padding(.top, 8)
                        
                        if imageIndex == 0 {
                            // Add six plus buttons over the image with selected value display
                            // Example for .lip
                            VStack(spacing: 0) {
                                if let values = selectedItemLists[.lip] {
                                    Text(sectionTitle(for: .lip))
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.black)
                                        .offset(y: -20)
                                    ForEach(values, id: \.self) { value in
                                        Text(value)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                            .offset(y: -20)
                                    }
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
                                if let values = selectedItemLists[.highlight] {
                                    Text(sectionTitle(for: .highlight))
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.black)
                                        .offset(y: -20)
                                    ForEach(values, id: \.self) { value in
                                        Text(value)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                            .offset(y: -20)
                                    }
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
                            .position(x: 200, y: 208) //ハイライト・シェーディング

                            VStack(spacing: 0) {
                                if let values = selectedItemLists[.eyebrow] {
                                    Text(sectionTitle(for: .eyebrow))
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.black)
                                        .offset(y: -20)
                                    ForEach(values, id: \.self) { value in
                                        Text(value)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                            .offset(y: -20)
                                    }
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

                                    if pickerOptions.first != "（登録されたコスメがありません）" {
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
                                                    let newValue = bindingForCurrentSelection().wrappedValue
                                                    if !newValue.isEmpty {
                                                        if var list = selectedItemLists[selection] {
                                                            if !list.contains(newValue) {
                                                                list.append(newValue)
                                                                selectedItemLists[selection] = list
                                                            }
                                                        } else {
                                                            selectedItemLists[selection] = [newValue]
                                                        }
                                                    }
                                                }
                                                showPickerSheet = false
                                            }
                                        }
                                        .padding(.leading, 16)
                                        .padding(.trailing, 40)
                                    } else {
                                        Text("登録されたコスメがありません")
                                            .foregroundColor(.gray)
                                            .padding()
                                        Button("閉じる") {
                                            showPickerSheet = false
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
                                if let values = selectedItemLists[.base] {
                                    Text(sectionTitle(for: .base))
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.black)
                                        .offset(y: -20)
                                    ForEach(values, id: \.self) { value in
                                        Text(value)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                            .offset(y: -20)
                                    }
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
                                if let values = selectedItemLists[.cheek] {
                                    Text(sectionTitle(for: .cheek))
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.black)
                                        .offset(y: -20)
                                    ForEach(values, id: \.self) { value in
                                        Text(value)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                            .offset(y: -20)
                                    }
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
                                    if let values = selectedItemLists[.eyeshadow] {
                                        Text(sectionTitle(for: .eyeshadow))
                                            .font(.caption)
                                            .bold()
                                            .foregroundColor(.black)
                                            .offset(y: -30)
                                        ForEach(values, id: \.self) { value in
                                            Text(value)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                                .padding(4)
                                                .background(Color.white.opacity(0.6))
                                                .cornerRadius(6)
                                                .offset(y: -30)
                                        }
                                    }
                                    Button(action: {
                                        currentSelection = .eyeshadow
                                        sheetTitle = "アイシャドウを選択"
                                        showPickerSheet = true
                                    }) {
                                        Image(systemName: "plus.circle")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .position(x: 140, y: 110)
                                .sheet(isPresented: $showPickerSheet) {
                                    VStack {
                                        Text(sheetTitle)
                                            .font(.headline)
                                            .padding()

                                        if pickerOptions.first != "（登録されたコスメがありません）" {
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
                                                        let newValue = bindingForCurrentSelection().wrappedValue
                                                        if !newValue.isEmpty {
                                                            if var list = selectedItemLists[selection] {
                                                                if !list.contains(newValue) {
                                                                    list.append(newValue)
                                                                    selectedItemLists[selection] = list
                                                                }
                                                            } else {
                                                                selectedItemLists[selection] = [newValue]
                                                            }
                                                        }
                                                    }
                                                    showPickerSheet = false
                                                }
                                            }
                                            .padding(.leading, 16)
                                            .padding(.trailing, 40)
                                        } else {
                                            Text("登録されたコスメがありません")
                                                .foregroundColor(.gray)
                                                .padding()
                                            Button("閉じる") {
                                                showPickerSheet = false
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
                                    if let values = selectedItemLists[.mascara] {
                                        Text(sectionTitle(for: .mascara))
                                            .font(.caption)
                                            .bold()
                                            .foregroundColor(.black)
                                            .offset(y: -30)
                                        ForEach(values, id: \.self) { value in
                                            Text(value)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                                .padding(4)
                                                .background(Color.white.opacity(0.6))
                                                .cornerRadius(6)
                                                .offset(y: -30)
                                        }
                                    }
                                    Button(action: {
                                        currentSelection = .mascara
                                        sheetTitle = "マスカラを選択"
                                        showPickerSheet = true
                                    }) {
                                        Image(systemName: "plus.circle")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .position(x: 270, y: 100) // マスカラ

                                VStack(spacing: 0) {
                                    if let values = selectedItemLists[.colorlense] {
                                        Text(sectionTitle(for: .colorlense))
                                            .font(.caption)
                                            .bold()
                                            .foregroundColor(.black)
                                            .offset(y: -30)
                                        ForEach(values, id: \.self) { value in
                                            Text(value)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                                .padding(4)
                                                .background(Color.white.opacity(0.6))
                                                .cornerRadius(6)
                                                .offset(y: -30)
                                        }
                                    }
                                    Button(action: {
                                        currentSelection = .colorlense
                                        sheetTitle = "カラコンを選択"
                                        showPickerSheet = true
                                    }) {
                                        Image(systemName: "plus.circle")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .position(x: 180, y: 205) // カラコン

                                VStack(spacing: 0) {
                                    if let values = selectedItemLists[.eyeliner] {
                                        Text(sectionTitle(for: .eyeliner))
                                            .font(.caption)
                                            .bold()
                                            .foregroundColor(.black)
                                            .offset(y: -30)
                                        ForEach(values, id: \.self) { value in
                                            Text(value)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                                .padding(4)
                                                .background(Color.white.opacity(0.6))
                                                .cornerRadius(6)
                                                .offset(y: -30)
                                        }
                                    }
                                    Button(action: {
                                        currentSelection = .eyeliner
                                        sheetTitle = "アイラインを選択"
                                        showPickerSheet = true
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
                        }else if imageIndex == 2 {
                            // tempFaceImageData の画像表示
                            if let data = tempFaceImageData, let uiImage = UIImage(data: data) {
                                Button {
                                    tempFaceImageData = nil
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
                                        viewModel.capturedType = "face"
                                    }
                                } message: {
                                    Text("フラッシュをたこう！")
                                }
                            }
                            .fullScreenCover(isPresented: $viewModel.isLaunchedCamera) {
                                Imagepicker(show: $viewModel.isLaunchedCamera, image: $viewModel.imageData)
                            }
                        }else if imageIndex == 3 {
                            // tempEyeImageData の画像表示
                            if let data = tempEyeImageData, let uiImage = UIImage(data: data) {
                                Button {
                                    tempEyeImageData = nil
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
                                        viewModel.capturedType = "eye"
                                    }
                                } message: {
                                    Text("フラッシュをたこう！")
                                }
                            }
                            .fullScreenCover(isPresented: $viewModel.isLaunchedCamera) {
                                Imagepicker(show: $viewModel.isLaunchedCamera, image: $viewModel.imageData)
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
        // .onChangeで撮影後のデータを一時保存
        .onChange(of: viewModel.imageData) { newData in
            if let type = viewModel.capturedType {
                if type == "face" {
                    tempFaceImageData = newData
                } else if type == "eye" {
                    tempEyeImageData = newData
                }
            }
        }
    }
}

#Preview {
    InputMakeupView(path: .constant(NavigationPath()))
}

extension InputMakeupView {
    func sectionTitle(for selection: SelectionType) -> String {
        switch selection {
        case .eye: return "アイ"
        case .lip: return "リップ"
        case .highlight: return "ハイライト・シェーディング"
        case .eyebrow: return "アイブロウ"
        case .base: return "ベースメイク"
        case .cheek: return "チーク"
        case .mascara: return "マスカラ"
        case .eyeshadow: return "アイシャドウ"
        case .eyeliner: return "アイライン"
        case .colorlense: return "カラコン"
        }
    }
}
