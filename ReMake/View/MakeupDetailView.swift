import SwiftUI
import Foundation
import SwiftData

struct  MakeupDetailView: View {
    let record: MakeupRecord
    @StateObject private var viewModel: MakeupDetailViewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteAlert = false
    @Query private var cosmetics: [Cosmetic]

    init(record: MakeupRecord) {
        self.record = record
        _viewModel = StateObject(wrappedValue: MakeupDetailViewModel(record: record))
    }

    /// コスメ名(listProduct) → 楽天の画像URL の対応表。
    /// 保存メイクが持つコスメ名から、登録済みコスメの画像を引いて表示するために使う。
    var imageURLByName: [String: URL] {
        Dictionary(
            cosmetics.compactMap { cosmetic -> (String, URL)? in
                guard let urlString = cosmetic.imageURL,
                      let url = URL(string: urlString) else { return nil }
                return (cosmetic.listProduct, url)
            },
            uniquingKeysWith: { first, _ in first }
        )
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
                        ], index: $viewModel.imageIndex)
                        .frame(width: 370, height: 370)
                        
                        HStack(spacing: 8) {
                            ForEach(0..<4, id: \.self) { i in
                                Circle()
                                    .fill(i == viewModel.imageIndex ? Color.primary : Color.secondary.opacity(0.4))
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .padding(.top, 16)
                    }
                    
                    if viewModel.imageIndex == 0 {
                        VStack(spacing: 0) {
                            let values = viewModel.values(for: .lip)
                            if !values.isEmpty {
                                CosmeticOverlayLabel(title: viewModel.title(for: .lip), values: values, imageURLByName: imageURLByName)
                                    .offset(y: -20)
                            }
                        }
                        .position(x: 218, y: 285)
                        VStack(spacing: 0) {
                            let values = viewModel.values(for: .highlight)
                            if !values.isEmpty {
                                CosmeticOverlayLabel(title: viewModel.title(for: .highlight), values: values, imageURLByName: imageURLByName)
                                    .offset(y: -20)
                            }
                        }
                        .position(x: 200, y: 208)
                        VStack(spacing: 0) {
                            let values = viewModel.values(for: .eyebrow)
                            if !values.isEmpty {
                                CosmeticOverlayLabel(title: viewModel.title(for: .eyebrow), values: values, imageURLByName: imageURLByName)
                                    .offset(y: -20)
                            }
                        }
                        .position(x: 278, y: 152)
                        VStack(spacing: 0) {
                            let values = viewModel.values(for: .base)
                            if !values.isEmpty {
                                CosmeticOverlayLabel(title: viewModel.title(for: .base), values: values, imageURLByName: imageURLByName)
                                    .offset(y: -20)
                            }
                        }
                        .position(x: 135, y: 247)
                        VStack(spacing: 0) {
                            let values = viewModel.values(for: .cheek)
                            if !values.isEmpty {
                                CosmeticOverlayLabel(title: viewModel.title(for: .cheek), values: values, imageURLByName: imageURLByName)
                                    .offset(y: -20)
                            }
                        }
                        .position(x: 270, y: 230)
                    } else if viewModel.imageIndex == 1 {
                        ZStack {
                            VStack(spacing: 0) {
                                let values = viewModel.values(for: .eyeshadow)
                                if !values.isEmpty {
                                    CosmeticOverlayLabel(title: viewModel.title(for: .eyeshadow), values: values, imageURLByName: imageURLByName)
                                        .offset(y: -30)
                                }
                            }
                            .position(x: 150, y: 90)
                            VStack(spacing: 0) {
                                let values = viewModel.values(for: .mascara)
                                if !values.isEmpty {
                                    CosmeticOverlayLabel(title: viewModel.title(for: .mascara), values: values, imageURLByName: imageURLByName)
                                        .offset(y: -30)
                                }
                            }
                            .position(x: 270, y: 100)
                            VStack(spacing: 0) {
                                let values = viewModel.values(for: .colorlense)
                                if !values.isEmpty {
                                    CosmeticOverlayLabel(title: viewModel.title(for: .colorlense), values: values, imageURLByName: imageURLByName)
                                        .offset(y: -30)
                                }
                            }
                            .position(x: 180, y: 205)
                            VStack(spacing: 0) {
                                let values = viewModel.values(for: .eyeliner)
                                if !values.isEmpty {
                                    CosmeticOverlayLabel(title: viewModel.title(for: .eyeliner), values: values, imageURLByName: imageURLByName)
                                        .offset(y: -30)
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .alert("このメイクを削除しますか？", isPresented: $showDeleteAlert) {
            Button("キャンセル", role: .cancel) {}
            Button("削除", role: .destructive) {
                modelContext.delete(record)
                try? modelContext.save()
                dismiss()
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
