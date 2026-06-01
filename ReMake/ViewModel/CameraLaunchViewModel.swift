//
//  CameraLaunchViewModel.swift
//  ReMake
//
//  Created by maho hayashi on 2026/05/15.
//

import Foundation

class CameraLaunchViewModel: ObservableObject {
    @Published var isLaunchedCamera = false
    @Published var imageData = Data()
    @Published var capturedType: String? = nil
}
