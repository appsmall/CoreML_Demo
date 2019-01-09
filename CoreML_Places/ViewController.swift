//
//  ViewController.swift
//  CoreML_Places
//
//  Created by apple on 08/01/19.
//  Copyright © 2019 appsmall. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    let model = GenderNet()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func alertWithSingleAction(message : String){
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let actions = [okAction]
        Utility.alert(on: self, title: "Alert", message: message, withActions: actions, style: .alert)
    }

    @IBAction func chooseImagePressed(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        let alertController = UIAlertController(title: "Upload Picture", message: "Please select a picture method.", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Open Camera", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                // Camera available
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
                
            } else {
                // Camera not available
                self.alertWithSingleAction(message: "Camera not available on your device.")
            }
        }
        let photoLibraryAction = UIAlertAction(title: "Open Photo Library", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                // Photo Library available
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                // Photo Library not available
                self.alertWithSingleAction(message: "Photo library not available on your device.")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func identifyingObjectWithinImage(image: UIImage) {
        if let pixelBuffer = ImageProcessor.pixelBuffer(forImage: image.cgImage!) {
            
            do {
                //let scene = try model.prediction(image: pixelBuffer)
                let scene = try model.prediction(data: pixelBuffer)
                label.text = scene.classLabel
            }
            catch {
                print("Error")
            }
        }
        
    }
    
    // Set image height and width to (224, 224)
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newWidth))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newWidth))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

// MARK:- UIIMAGE PICKER CONTROLLER DELEGATE METHODS
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage = UIImage()
        
        if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        }
        
        imageView.image = selectedImage
        self.identifyingObjectWithinImage(image: resizeImage(image: selectedImage, newWidth: 227))
        picker.dismiss(animated: true, completion: nil)
    }
}

