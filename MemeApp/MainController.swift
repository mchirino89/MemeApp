//
//  MainController.swift
//  MemeApp
//
//  Created by Mauricio Chirino on 2/7/17.
//  Copyright © 2017 Mauricio Chirino. All rights reserved.
//

import UIKit

class MainController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var bottomTextField: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var photoButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var placeholderTextView: UITextView!
    let photoPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImage.autoresizingMask = UIViewAutoresizing.flexibleHeight
        photoPicker.delegate = self
        photoButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Low memory in device")
    }
    
    private func getImageFromSource(isCameraImage: Bool) {
        photoPicker.sourceType = isCameraImage ? .camera : .photoLibrary
        present(photoPicker, animated: true, completion: nil)
    }
    
    private func enableActions(enable: Bool) {
        shareButton.isEnabled = enable
        deleteButton.isEnabled = enable
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            memeImage.alpha = 1
            placeholderTextView.alpha = 0
            memeImage.image = image
            enableActions(enable: true)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func shareMemeAction(_ sender: Any) {
        print("Sharing image")
    }
    
    @IBAction func deleteMemeAction(_ sender: Any) {
        UIView.animate(withDuration: 0.35, animations: {
            self.enableActions(enable: false)
            self.memeImage.alpha = 0
            self.placeholderTextView.alpha = 1
        }, completion: { _ in
            self.memeImage.image = nil
        })
    }
    
    @IBAction func takePhotoAction(_ sender: Any) {
        getImageFromSource(isCameraImage: true)
    }
    
    @IBAction func pickPhotoAction(_ sender: Any) {
        getImageFromSource(isCameraImage: false)
    }
}
