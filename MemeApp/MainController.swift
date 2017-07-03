//
//  MainController.swift
//  MemeApp
//
//  Created by Mauricio Chirino on 2/7/17.
//  Copyright © 2017 Mauricio Chirino. All rights reserved.
//

import UIKit

class MainController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var photoButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var memeImage: UIImageView!
    let photoPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoPicker.delegate = self
        photoButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Low memory in device")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            memeImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func getImageFromSource(isCameraImage: Bool) {
        photoPicker.sourceType = isCameraImage ? .camera : .photoLibrary
        present(photoPicker, animated: true, completion: nil)
    }

    @IBAction func shareMemeAction(_ sender: Any) {
    }
    
    @IBAction func deleteMemeAction(_ sender: Any) {
    }
    
    @IBAction func takePhotoAction(_ sender: Any) {
        getImageFromSource(isCameraImage: true)
    }
    
    @IBAction func pickPhotoAction(_ sender: Any) {
        getImageFromSource(isCameraImage: false)
    }
}
