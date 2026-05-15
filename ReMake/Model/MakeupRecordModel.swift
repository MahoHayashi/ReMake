//
//  MakeupRecordModel.swift
//  ReMake
//
//  Created by maho hayashi on 2026/05/15.
//

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
