import SwiftUI
import Foundation
import SwiftData

struct  MakeupDetailView: View {
    
    enum SelectionType: String {
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
    
    let record: MakeupRecord

    init(record: MakeupRecord) {
        self.record = record
        var mapped: [SelectionType: String] = [:]
        for (key, value) in record.selectedItems {
            if let selection = SelectionType(rawValue: key) {
                mapped[selection] = value
            }
        }
        _selectedItems = State(initialValue: mapped)
    }
    @Query private var cosmetics: [Cosmetic]
    
    func bindingForCurrentSelection() -> Binding<String> {
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
                ZStack {
                    VStack{
                        ImagePager(images: [
                            .named("MakeupFace"),
                            .named("ImageEye"),
                            .uiImage(record.faceImageData != nil ? UIImage(data: record.faceImageData!) ?? UIImage() : UIImage()),
                            .uiImage(record.eyeImageData != nil ? UIImage(data: record.eyeImageData!) ?? UIImage() : UIImage())
                        ], index: $imageIndex)
                        .frame(width: 370, height: 370)
                        
                        HStack(spacing: 8) {
                            ForEach(0..<4, id: \.self) { i in
                                Circle()
                                    .fill(i == imageIndex ? Color.primary : Color.secondary.opacity(0.4))
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .padding(.top, 16)
                    }
                    
                    if imageIndex == 0 {
                        VStack(spacing: 0) {
                            if let value = selectedItems[.lip], !value.isEmpty {
                                let values = value.components(separatedBy: ", ")
                                VStack(spacing: 2) {
                                    Text("リップ")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.black)
                                        .offset(y: -20)
                                    ForEach(values, id: \.self) { val in
                                        Text(val)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                            .offset(y: -20)
                                    }
                                }
                            }
                        }
                        .position(x: 218, y: 285)
                        VStack(spacing: 0) {
                            if let value = selectedItems[.highlight], !value.isEmpty {
                                let values = value.components(separatedBy: ", ")
                                VStack(spacing: 2) {
                                    Text("ハイライト")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.black)
                                        .offset(y: -20)
                                    ForEach(values, id: \.self) { val in
                                        Text(val)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                            .offset(y: -20)
                                    }
                                }
                            }
                        }
                        .position(x: 200, y: 208)
                        VStack(spacing: 0) {
                            if let value = selectedItems[.eyebrow], !value.isEmpty {
                                let values = value.components(separatedBy: ", ")
                                VStack(spacing: 2) {
                                    Text("アイブロウ")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.black)
                                        .offset(y: -20)
                                    ForEach(values, id: \.self) { val in
                                        Text(val)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                            .offset(y: -20)
                                    }
                                }
                            }
                        }
                        .position(x: 278, y: 152)
                        VStack(spacing: 0) {
                            if let value = selectedItems[.base], !value.isEmpty {
                                let values = value.components(separatedBy: ", ")
                                VStack(spacing: 2) {
                                    Text("ベース")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.black)
                                        .offset(y: -20)
                                    ForEach(values, id: \.self) { val in
                                        Text(val)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                            .offset(y: -20)
                                    }
                                }
                            }
                        }
                        .position(x: 135, y: 247)
                        VStack(spacing: 0) {
                            if let value = selectedItems[.cheek], !value.isEmpty {
                                let values = value.components(separatedBy: ", ")
                                VStack(spacing: 2) {
                                    Text("チーク")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.black)
                                        .offset(y: -20)
                                    ForEach(values, id: \.self) { val in
                                        Text(val)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(4)
                                            .background(Color.white.opacity(0.6))
                                            .cornerRadius(6)
                                            .offset(y: -20)
                                    }
                                }
                            }
                        }
                        .position(x: 270, y: 230)
                    } else if imageIndex == 1 {
                        ZStack {
                            VStack(spacing: 0) {
                                if let value = selectedItems[.eyeshadow], !value.isEmpty {
                                    let values = value.components(separatedBy: ", ")
                                    VStack(spacing: 2) {
                                        Text("アイシャドウ")
                                            .font(.caption)
                                            .bold()
                                            .foregroundColor(.black)
                                            .offset(y: -30)
                                        ForEach(values, id: \.self) { val in
                                            Text(val)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                                .padding(4)
                                                .background(Color.white.opacity(0.6))
                                                .cornerRadius(6)
                                                .offset(y: -30)
                                        }
                                    }
                                }
                            }
                            .position(x: 150, y: 90)
                            VStack(spacing: 0) {
                                if let value = selectedItems[.mascara], !value.isEmpty {
                                    let values = value.components(separatedBy: ", ")
                                    VStack(spacing: 2) {
                                        Text("マスカラ")
                                            .font(.caption)
                                            .bold()
                                            .foregroundColor(.black)
                                            .offset(y: -30)
                                        ForEach(values, id: \.self) { val in
                                            Text(val)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                                .padding(4)
                                                .background(Color.white.opacity(0.6))
                                                .cornerRadius(6)
                                                .offset(y: -30)
                                        }
                                    }
                                }
                            }
                            .position(x: 270, y: 100)
                            VStack(spacing: 0) {
                                if let value = selectedItems[.colorlense], !value.isEmpty {
                                    let values = value.components(separatedBy: ", ")
                                    VStack(spacing: 2) {
                                        Text("カラコン")
                                            .font(.caption)
                                            .bold()
                                            .foregroundColor(.black)
                                            .offset(y: -30)
                                        ForEach(values, id: \.self) { val in
                                            Text(val)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                                .padding(4)
                                                .background(Color.white.opacity(0.6))
                                                .cornerRadius(6)
                                                .offset(y: -30)
                                        }
                                    }
                                }
                            }
                            .position(x: 180, y: 205)
                            VStack(spacing: 0) {
                                if let value = selectedItems[.eyeliner], !value.isEmpty {
                                    let values = value.components(separatedBy: ", ")
                                    VStack(spacing: 2) {
                                        Text("アイライナー")
                                            .font(.caption)
                                            .bold()
                                            .foregroundColor(.black)
                                            .offset(y: -30)
                                        ForEach(values, id: \.self) { val in
                                            Text(val)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                                .padding(4)
                                                .background(Color.white.opacity(0.6))
                                                .cornerRadius(6)
                                                .offset(y: -30)
                                        }
                                    }
                                }
                            }
                            .position(x: 328, y: 170)
                        }
                    }
                }
                Spacer()
                Spacer()
                
                Text("メイクのタイトル")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 50)
                    .padding()
                Text("\(record.name)")
                    .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                                .frame(width: 300, height: 45)
                        )
                Text("コメント")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 50)
                    .padding()
                Text("\(record.comment)")
                    .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                                .frame(width: 300, height: 45)
                        )
                Text("参考にした記事・動画のURL")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 50)
                    .padding()
                Text("\(record.url)")
                    .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                                .frame(width: 300, height: 45)
                        )
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
               
            }
        }
    }
}

#Preview {
    let dummyData = MakeupRecord(
            name: "春のナチュラルメイク",
            comment: "ピンクを基調にしてナチュラルに仕上げました。",
            url: "https://example.com/spring-makeup",
            faceImageData: nil,
            eyeImageData: nil
        )
    
    dummyData.selectedItems = [
           "lip": "キャンメイク",
           "eyeshadow": "エチュード"
       ]

        return MakeupDetailView(record: dummyData)
}
