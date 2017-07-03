//
//  MainController.swift
//  MemeApp
//
//  Created by Mauricio Chirino on 2/7/17.
//  Copyright © 2017 Mauricio Chirino. All rights reserved.
//

import UIKit

class MainController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var bottomTextField: UITextField!
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
        let attributes = [NSStrokeWidthAttributeName: -4.0,
                          NSStrokeColorAttributeName: UIColor.black,
                          NSForegroundColorAttributeName: UIColor.white] as [String : Any];
        topTextField.attributedText = NSAttributedString(string: "TOP", attributes: attributes)
        topTextField.attributedPlaceholder = NSAttributedString(string: "Type clever joke", attributes: attributes)
        bottomTextField.attributedText = NSAttributedString(string: "BOTTOM", attributes: attributes)
        bottomTextField.attributedPlaceholder = NSAttributedString(string: "And punch line", attributes: attributes)
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
        UIView.animate(withDuration: 0.35, animations: {
            self.shareButton.isEnabled = enable
            self.deleteButton.isEnabled = enable
            self.placeholderTextView.alpha = enable ? 0 : 1
            self.memeImage.alpha = enable ? 1 : 0
            self.topTextField.alpha = enable ? 1 : 0
            self.bottomTextField.alpha = enable ? 1 : 0
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
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
        enableActions(enable: false)
    }
    
    @IBAction func takePhotoAction(_ sender: Any) {
        getImageFromSource(isCameraImage: true)
    }
    
    @IBAction func pickPhotoAction(_ sender: Any) {
        getImageFromSource(isCameraImage: false)
    }
}

extension MainController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.isEqual(topTextField) && textField.text == "TOP") || (textField.isEqual(bottomTextField) && textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.isEqual(topTextField) && textField.text == "") {
            textField.text = "TOP"
        } else if textField.isEqual(bottomTextField) && textField.text == "" {
            textField.text = "BOTTOM"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
}
