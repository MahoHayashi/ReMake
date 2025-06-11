//
//  Camera.swift
//  ReMake
//
//  Created by maho hayashi on 2025/06/11.
//

import Foundation
import UIKit
import SwiftUI

struct Imagepicker : UIViewControllerRepresentable {
    @Binding var show: Bool
    @Binding var image: Data
    
    func makeCoordinator() -> Imagepicker.Coodinator {
        return Imagepicker.Coordinator(parent: self)
    }
      
    func makeUIViewController(context: UIViewControllerRepresentableContext<Imagepicker>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<Imagepicker>) {
    }
    
    class Coodinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent : Imagepicker
        
        init(parent : Imagepicker){
            self.parent = parent
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.parent.show.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            guard let image = info[.originalImage] as? UIImage else {
                return
            }
            guard let data = getCorrectOrientationUIImage(uiImage: image).jpegData(compressionQuality: 1.0) else {
                return
            }
            self.parent.image = data
            self.parent.show.toggle()
        }
        
        private func getCorrectOrientationUIImage(uiImage:UIImage) -> UIImage {
            var editedImage = UIImage()
            let ciContext = CIContext(options: nil)
            
            switch uiImage.imageOrientation {
            case .left:
                guard let orientedCIImage = CIImage(image: uiImage)?.oriented(.left),
                      let cgImage = ciContext.createCGImage(orientedCIImage, from: orientedCIImage.extent) else {
                    return uiImage
                }
                editedImage = UIImage(cgImage: cgImage)
            case .down:
                guard let orientedCIImage = CIImage(image: uiImage)?.oriented(.down),
                      let cgImage = ciContext.createCGImage(orientedCIImage, from: orientedCIImage.extent) else {
                    return uiImage
                }
                editedImage = UIImage(cgImage: cgImage)
            case .right:
                guard let orientedCIImage = CIImage(image: uiImage)?.oriented(.right),
                      let cgImage = ciContext.createCGImage(orientedCIImage, from: orientedCIImage.extent) else {
                    return uiImage
                }
                editedImage = UIImage(cgImage: cgImage)
            default:
                editedImage = uiImage
            }
            
            return editedImage
        }
    }
}
